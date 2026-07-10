#!/usr/bin/env python3
"""Validate Postgres migration against SQL Server source (Layers 1–3).

Usage:
    export MSSQL_HOST=... MSSQL_USER=... MSSQL_PASSWORD=...
    uv run python validate_migration.py
    uv run python validate_migration.py --pg-dsn postgresql://...
    uv run python validate_migration.py --write-manifest tools/fixtures/sample/manifest.json
"""

from __future__ import annotations

import argparse
import json
import os
from collections import defaultdict
from datetime import date, datetime
from decimal import Decimal
from pathlib import Path

from migration_lib import (
    DEFAULT_PG_DSN,
    LEGACY_TABLE_COUNTS,
    PAYEE_EXPR,
    STATUS_APPROVED,
    STATUS_NEEDS_CATEGORIZATION,
    CheckResult,
    connect_mssql,
    connect_pg,
    decimal_str,
    env,
    legacy_count,
    pg_count,
)

CATEGORY_LABEL_SQL = """
    CASE
        WHEN g.id IN (-1, 2) THEN c.category_name
        ELSE g.group_name || ' - ' || c.category_name
    END
"""


def month_key(value: date | datetime | None) -> str | None:
    if value is None:
        return None
    if isinstance(value, datetime):
        value = value.date()
    return f"{value.year:04d}-{value.month:02d}"


def run_layer1(mssql_cur, pg_cur) -> list[CheckResult]:
    results: list[CheckResult] = []

    for target_table, (legacy_table, _) in LEGACY_TABLE_COUNTS.items():
        source = legacy_count(mssql_cur, legacy_table)
        target = pg_count(pg_cur, target_table)
        status = "PASS" if source == target else "FAIL"
        results.append(
            CheckResult(1, f"{target_table} row count", status, "", source, target, target - source)
        )

    mssql_cur.execute("SELECT COUNT(*) FROM [dbo].[bankTransaction]")
    source_txn = mssql_cur.fetchone()[0]
    pg_cur.execute("SELECT COUNT(DISTINCT external_id), COUNT(*) FROM bank_transactions")
    distinct_external, total_rows = pg_cur.fetchone()
    coverage_ok = source_txn == distinct_external == total_rows
    results.append(
        CheckResult(
            1,
            "external_id coverage",
            "PASS" if coverage_ok else "FAIL",
            "legacy transactionIds must map 1:1 to external_id",
            source_txn,
            distinct_external,
            total_rows - source_txn,
        )
    )

    fk_checks = [
        ("bank_transactions", "account_id", "accounts"),
        ("bank_transactions", "spending_category_id", "spending_categories"),
        ("bank_transactions", "payee_id", "payees"),
        ("category_split_details", "bank_transaction_id", "bank_transactions"),
        ("category_split_details", "spending_category_id", "spending_categories"),
        ("transaction_tagged_events", "bank_transaction_id", "bank_transactions"),
        ("transaction_tagged_events", "tagged_event_id", "tagged_events"),
        ("transaction_tagged_events", "category_split_detail_id", "category_split_details"),
        ("category_rules", "payee_id", "payees"),
        ("category_rules", "spending_category_id", "spending_categories"),
    ]
    orphan_total = 0
    for table, fk_col, ref_table in fk_checks:
        pg_cur.execute(
            f"""
            SELECT COUNT(*) FROM {table} t
            WHERE t.{fk_col} IS NOT NULL
              AND NOT EXISTS (SELECT 1 FROM {ref_table} r WHERE r.id = t.{fk_col})
            """
        )
        orphans = pg_cur.fetchone()[0]
        orphan_total += orphans
        if orphans:
            results.append(
                CheckResult(1, f"FK orphans {table}.{fk_col}", "FAIL", "", 0, orphans, orphans)
            )
    if orphan_total == 0:
        results.append(CheckResult(1, "FK orphans", "PASS", "all FK columns resolve", 0, 0, 0))

    pg_cur.execute(
        """
        SELECT COUNT(*) FROM category_split_details sd
        WHERE NOT EXISTS (
            SELECT 1 FROM bank_transactions bt WHERE bt.id = sd.bank_transaction_id
        )
        """
    )
    bad_splits = pg_cur.fetchone()[0]
    results.append(
        CheckResult(
            1,
            "split parent linkage",
            "PASS" if bad_splits == 0 else "FAIL",
            "",
            0,
            bad_splits,
            bad_splits,
        )
    )

    pg_cur.execute(
        """
        SELECT COUNT(*) FROM transaction_tagged_events tte
        WHERE NOT EXISTS (SELECT 1 FROM bank_transactions bt WHERE bt.id = tte.bank_transaction_id)
           OR NOT EXISTS (SELECT 1 FROM tagged_events te WHERE te.id = tte.tagged_event_id)
           OR (
                tte.category_split_detail_id IS NOT NULL
                AND NOT EXISTS (
                    SELECT 1 FROM category_split_details sd WHERE sd.id = tte.category_split_detail_id
                )
           )
        """
    )
    bad_tags = pg_cur.fetchone()[0]
    results.append(
        CheckResult(
            1,
            "tag linkage",
            "PASS" if bad_tags == 0 else "FAIL",
            "",
            0,
            bad_tags,
            bad_tags,
        )
    )

    sequence_tables = [
        "accounts",
        "spending_categories",
        "category_split_details",
        "tagged_events",
        "transaction_tagged_events",
        "payees",
    ]
    seq_failures = 0
    for table in sequence_tables:
        pg_cur.execute(
            f"""
            SELECT COALESCE(
                (SELECT last_value FROM {table}_id_seq),
                0
            ),
            COALESCE((SELECT MAX(id) FROM {table}), 0)
            """
        )
        last_value, max_id = pg_cur.fetchone()
        if max_id and last_value < max_id:
            seq_failures += 1
            results.append(
                CheckResult(
                    1,
                    f"sequence {table}",
                    "FAIL",
                    f"last_value={last_value} max_id={max_id}",
                    max_id,
                    last_value,
                    max_id - last_value,
                )
            )
    if seq_failures == 0:
        results.append(CheckResult(1, "sequence sanity", "PASS", "", None, None, None))

    return results


def legacy_monthly_metrics(mssql_cur) -> tuple[dict[str, int], dict[str, Decimal]]:
    mssql_cur.execute(
        """
        SELECT CONVERT(char(7), accountingDate, 120) AS ym, COUNT(*), SUM(CAST(amount AS decimal(19,4)))
        FROM [dbo].[bankTransaction]
        WHERE accountingDate IS NOT NULL
        GROUP BY CONVERT(char(7), accountingDate, 120)
        """
    )
    counts: dict[str, int] = {}
    amounts: dict[str, Decimal] = {}
    for ym, cnt, total in mssql_cur.fetchall():
        counts[ym] = cnt
        amounts[ym] = Decimal(total or 0)
    return counts, amounts


def pg_monthly_metrics(pg_cur) -> tuple[dict[str, int], dict[str, Decimal]]:
    pg_cur.execute(
        """
        SELECT to_char(accounting_date, 'YYYY-MM') AS ym, COUNT(*), SUM(amount)
        FROM bank_transactions
        WHERE accounting_date IS NOT NULL
        GROUP BY 1
        ORDER BY 1
        """
    )
    counts: dict[str, int] = {}
    amounts: dict[str, Decimal] = {}
    for ym, cnt, total in pg_cur.fetchall():
        counts[ym] = cnt
        amounts[ym] = Decimal(total or 0)
    return counts, amounts


def run_layer2(mssql_cur, pg_cur) -> list[CheckResult]:
    results: list[CheckResult] = []

    source_total = legacy_count(mssql_cur, "bankTransaction")
    target_total = pg_count(pg_cur, "bank_transactions")
    results.append(
        CheckResult(
            2,
            "total transaction count",
            "PASS" if source_total == target_total else "FAIL",
            "",
            source_total,
            target_total,
            target_total - source_total,
        )
    )

    source_counts, source_amounts = legacy_monthly_metrics(mssql_cur)
    target_counts, target_amounts = pg_monthly_metrics(pg_cur)

    month_count_failures = [
        ym for ym in sorted(set(source_counts) | set(target_counts)) if source_counts.get(ym, 0) != target_counts.get(ym, 0)
    ]
    results.append(
        CheckResult(
            2,
            "monthly transaction count",
            "PASS" if not month_count_failures else "FAIL",
            ", ".join(month_count_failures[:5]) + ("..." if len(month_count_failures) > 5 else ""),
            len(source_counts),
            len(target_counts),
            len(month_count_failures),
        )
    )

    amount_failures = []
    for ym in sorted(set(source_amounts) | set(target_amounts)):
        diff = (target_amounts.get(ym, Decimal(0)) - source_amounts.get(ym, Decimal(0))).copy_abs()
        if diff > Decimal("0.01"):
            amount_failures.append(ym)
    results.append(
        CheckResult(
            2,
            "monthly sum of amounts",
            "PASS" if not amount_failures else "FAIL",
            ", ".join(amount_failures[:5]) + ("..." if len(amount_failures) > 5 else ""),
            len(source_amounts),
            len(target_amounts),
            len(amount_failures),
        )
    )

    mssql_cur.execute(
        """
        SELECT accountId, CONVERT(char(7), accountingDate, 120), COUNT(*), SUM(CAST(amount AS decimal(19,4)))
        FROM [dbo].[bankTransaction]
        WHERE accountingDate IS NOT NULL
        GROUP BY accountId, CONVERT(char(7), accountingDate, 120)
        """
    )
    source_account = {(row[0], row[1]): (row[2], Decimal(row[3] or 0)) for row in mssql_cur.fetchall()}
    pg_cur.execute(
        """
        SELECT account_id, to_char(accounting_date, 'YYYY-MM'), COUNT(*), SUM(amount)
        FROM bank_transactions
        WHERE accounting_date IS NOT NULL
        GROUP BY 1, 2
        """
    )
    target_account = {(row[0], row[1]): (row[2], Decimal(row[3] or 0)) for row in pg_cur.fetchall()}
    account_failures = [
        key
        for key in sorted(set(source_account) | set(target_account))
        if source_account.get(key, (0, Decimal(0))) != target_account.get(key, (0, Decimal(0)))
    ]
    results.append(
        CheckResult(
            2,
            "per-account monthly totals",
            "PASS" if not account_failures else "FAIL",
            f"{len(account_failures)} mismatched account-month buckets",
            len(source_account),
            len(target_account),
            len(account_failures),
        )
    )

    mssql_cur.execute(
        """
        SELECT CASE
                 WHEN gp.groupID IN (-1, 2) THEN sc.categoryName
                 ELSE gp.groupName + ' - ' + sc.categoryName
               END AS category_label,
               COUNT(*),
               SUM(CAST(bt.amount AS decimal(19,4)))
        FROM [dbo].[bankTransaction] bt
        LEFT JOIN [dbo].[spendingCategories] sc ON bt.categoryId = sc.categoryId
        LEFT JOIN [dbo].[spendingCategoryGroup] gp ON sc.groupID = gp.groupID
        WHERE bt.categoryStatus = %s
        GROUP BY CASE
                   WHEN gp.groupID IN (-1, 2) THEN sc.categoryName
                   ELSE gp.groupName + ' - ' + sc.categoryName
                 END
        """,
        (STATUS_APPROVED,),
    )
    source_category = {(row[0] or "(null)",): (row[1], Decimal(row[2] or 0)) for row in mssql_cur.fetchall()}

    pg_cur.execute(
        f"""
        SELECT {CATEGORY_LABEL_SQL}, COUNT(*), SUM(bt.amount)
        FROM bank_transactions bt
        LEFT JOIN spending_categories c ON bt.spending_category_id = c.id
        LEFT JOIN spending_category_groups g ON c.spending_category_group_id = g.id
        WHERE bt.category_status = %s
        GROUP BY 1
        """,
        (STATUS_APPROVED,),
    )
    target_category = {(row[0] or "(null)",): (row[1], Decimal(row[2] or 0)) for row in pg_cur.fetchall()}
    category_failures = [
        key
        for key in sorted(set(source_category) | set(target_category))
        if source_category.get(key, (0, Decimal(0))) != target_category.get(key, (0, Decimal(0)))
    ]
    results.append(
        CheckResult(
            2,
            "per-category approved totals",
            "PASS" if not category_failures else "FAIL",
            f"{len(category_failures)} mismatched categories",
            len(source_category),
            len(target_category),
            len(category_failures),
        )
    )

    mssql_cur.execute(
        "SELECT COUNT(*) FROM [dbo].[bankTransaction] WHERE categoryStatus = %s",
        (STATUS_NEEDS_CATEGORIZATION,),
    )
    source_uncat = mssql_cur.fetchone()[0]
    pg_cur.execute(
        "SELECT COUNT(*) FROM bank_transactions WHERE category_status = %s",
        (STATUS_NEEDS_CATEGORIZATION,),
    )
    target_uncat = pg_cur.fetchone()[0]
    results.append(
        CheckResult(
            2,
            "uncategorized backlog",
            "PASS" if source_uncat == target_uncat else "FAIL",
            "",
            source_uncat,
            target_uncat,
            target_uncat - source_uncat,
        )
    )

    def sign_metrics(cur, is_mssql: bool) -> tuple[tuple[int, Decimal], tuple[int, Decimal]]:
        if is_mssql:
            cur.execute(
                """
                SELECT
                    SUM(CASE WHEN amount < 0 THEN 1 ELSE 0 END),
                    SUM(CASE WHEN amount < 0 THEN CAST(amount AS decimal(19,4)) ELSE 0 END),
                    SUM(CASE WHEN amount > 0 THEN 1 ELSE 0 END),
                    SUM(CASE WHEN amount > 0 THEN CAST(amount AS decimal(19,4)) ELSE 0 END)
                FROM [dbo].[bankTransaction]
                """
            )
        else:
            cur.execute(
                """
                SELECT
                    COUNT(*) FILTER (WHERE amount < 0),
                    COALESCE(SUM(amount) FILTER (WHERE amount < 0), 0),
                    COUNT(*) FILTER (WHERE amount > 0),
                    COALESCE(SUM(amount) FILTER (WHERE amount > 0), 0)
                FROM bank_transactions
                """
            )
        neg_count, neg_sum, pos_count, pos_sum = cur.fetchone()
        return (neg_count or 0, Decimal(neg_sum or 0)), (pos_count or 0, Decimal(pos_sum or 0))

    source_signs = sign_metrics(mssql_cur, True)
    target_signs = sign_metrics(pg_cur, False)
    results.append(
        CheckResult(
            2,
            "income vs expense split",
            "PASS" if source_signs == target_signs else "FAIL",
            "",
            source_signs,
            target_signs,
            None,
        )
    )

    return results


def dedupe_duplicate_groups(cur, is_mssql: bool) -> int:
    if is_mssql:
        cur.execute(
            """
            SELECT COUNT(*) FROM (
                SELECT accountId, transactionDate, amount, bankOrigDescription, COUNT(*) AS n
                FROM [dbo].[bankTransaction]
                GROUP BY accountId, transactionDate, amount, bankOrigDescription
                HAVING COUNT(*) > 1
            ) d
            """
        )
    else:
        cur.execute(
            """
            SELECT COUNT(*) FROM (
                SELECT account_id, transaction_date, amount, bank_orig_description, COUNT(*) AS n
                FROM bank_transactions
                GROUP BY 1, 2, 3, 4
                HAVING COUNT(*) > 1
            ) d
            """
        )
    return cur.fetchone()[0]


def run_layer3(mssql_cur, pg_cur) -> list[CheckResult]:
    results: list[CheckResult] = []

    pg_cur.execute(
        """
        SELECT bt.external_id, bt.amount, COALESCE(SUM(sd.split_amount), 0)
        FROM bank_transactions bt
        INNER JOIN category_split_details sd ON sd.bank_transaction_id = bt.id
        GROUP BY bt.external_id, bt.amount
        HAVING ABS(bt.amount - COALESCE(SUM(sd.split_amount), 0)) >= 0.01
        """
    )
    imbalanced = pg_cur.fetchall()
    results.append(
        CheckResult(
            3,
            "split balance",
            "PASS" if not imbalanced else "FAIL",
            f"{len(imbalanced)} imbalanced parents",
            0,
            len(imbalanced),
            len(imbalanced),
        )
    )

    mssql_cur.execute(
        """
        SELECT COUNT(*) FROM [dbo].[categorySplitDetails] sd
        INNER JOIN [dbo].[bankTransaction] bt ON sd.parentTransactionId = bt.transactionId
        WHERE bt.categoryStatus <> %s
        """,
        (STATUS_APPROVED,),
    )
    source_orphan_splits = mssql_cur.fetchone()[0]
    pg_cur.execute(
        """
        SELECT COUNT(*) FROM category_split_details sd
        INNER JOIN bank_transactions bt ON bt.id = sd.bank_transaction_id
        WHERE bt.category_status <> %s
        """,
        (STATUS_APPROVED,),
    )
    orphan_splits = pg_cur.fetchone()[0]
    results.append(
        CheckResult(
            3,
            "splits on non-approved parents",
            "PASS" if orphan_splits == source_orphan_splits else "FAIL",
            "legacy allows splits before approval",
            source_orphan_splits,
            orphan_splits,
            orphan_splits - source_orphan_splits,
        )
    )

    pg_cur.execute(
        """
        SELECT
            COUNT(*) FILTER (WHERE category_status = %s) AS approved,
            COUNT(*) FILTER (WHERE category_status = %s AND payee_id IS NOT NULL) AS approved_with_payee
        FROM bank_transactions
        """,
        (STATUS_APPROVED, STATUS_APPROVED),
    )
    approved, approved_with_payee = pg_cur.fetchone()
    coverage = (approved_with_payee / approved * 100) if approved else 100.0
    results.append(
        CheckResult(
            3,
            "payee backfill coverage",
            "PASS" if coverage >= 95 else "FAIL",
            f"{coverage:.1f}% of approved txns have payee_id",
            95.0,
            round(coverage, 1),
            round(coverage - 95.0, 1),
        )
    )

    pg_cur.execute(
        f"""
        SELECT COUNT(*) FROM (
            SELECT DISTINCT {PAYEE_EXPR} AS payee_text
            FROM bank_transactions
            WHERE {PAYEE_EXPR} IS NOT NULL
        ) d
        WHERE NOT EXISTS (
            SELECT 1 FROM payee_aliases pa WHERE pa.raw_text = d.payee_text
        )
        """
    )
    missing_aliases = pg_cur.fetchone()[0]
    results.append(
        CheckResult(
            3,
            "payee alias coverage",
            "PASS" if missing_aliases == 0 else "FAIL",
            "",
            0,
            missing_aliases,
            missing_aliases,
        )
    )

    pg_cur.execute(
        """
        SELECT COUNT(*) FROM bank_transactions bt
        INNER JOIN category_suggestions cs ON cs.bank_transaction_id = bt.id
        WHERE bt.category_status = %s
        """,
        (STATUS_APPROVED,),
    )
    stale_suggestions = pg_cur.fetchone()[0]
    results.append(
        CheckResult(
            3,
            "category suggestion cleanup",
            "PASS" if stale_suggestions == 0 else "FAIL",
            "",
            0,
            stale_suggestions,
            stale_suggestions,
        )
    )

    pg_cur.execute(
        """
        SELECT te.tag,
               COUNT(*) AS obs_count,
               SUM(COALESCE(sd.split_amount, bt.amount)) AS obs_amount
        FROM transaction_tagged_events tte
        INNER JOIN tagged_events te ON te.id = tte.tagged_event_id
        INNER JOIN bank_transactions bt ON bt.id = tte.bank_transaction_id
        LEFT JOIN category_split_details sd ON sd.id = tte.category_split_detail_id
        GROUP BY te.tag
        ORDER BY te.tag
        """
    )
    pg_events = {row[0]: (row[1], Decimal(row[2] or 0)) for row in pg_cur.fetchall()}
    results.append(
        CheckResult(
            3,
            "event totals computed",
            "PASS" if pg_events else "WARN",
            f"{len(pg_events)} tagged event buckets",
            None,
            len(pg_events),
            None,
        )
    )

    pg_cur.execute("SELECT COUNT(*) FROM transfer_links")
    transfer_count = pg_cur.fetchone()[0]
    if transfer_count == 0:
        results.append(
            CheckResult(3, "transfer pairs", "WARN", "no transfer_links populated yet", 0, 0, None)
        )
    else:
        pg_cur.execute(
            """
            SELECT COUNT(*) FROM transfer_links tl
            INNER JOIN bank_transactions out_txn ON out_txn.id = tl.outbound_bank_transaction_id
            INNER JOIN bank_transactions in_txn ON in_txn.id = tl.inbound_bank_transaction_id
            WHERE ABS(out_txn.amount + in_txn.amount) >= 0.01
               OR out_txn.account_id = in_txn.account_id
            """
        )
        bad_transfers = pg_cur.fetchone()[0]
        results.append(
            CheckResult(
                3,
                "transfer pairs",
                "PASS" if bad_transfers == 0 else "FAIL",
                "",
                0,
                bad_transfers,
                bad_transfers,
            )
        )

    source_dupes = dedupe_duplicate_groups(mssql_cur, True)
    dupes = dedupe_duplicate_groups(pg_cur, False)
    results.append(
        CheckResult(
            3,
            "legacy dedupe key duplicate groups",
            "PASS" if dupes == source_dupes else "FAIL",
            "historical data may repeat account/date/amount/description",
            source_dupes,
            dupes,
            dupes - source_dupes,
        )
    )

    return results


def compare_event_totals(mssql_cur, pg_cur) -> CheckResult:
    mssql_cur.execute(
        """
        SELECT e.taggedEventTag,
               COUNT(t.transactionId),
               SUM(COALESCE(CAST(sd.splitAmount AS decimal(19,4)), CAST(t.amount AS decimal(19,4))))
        FROM [dbo].[transactionTaggedEvent] te
        INNER JOIN [dbo].[bankTransaction] t ON te.transactionId = t.transactionId
        LEFT JOIN [dbo].[categorySplitDetails] sd
          ON t.transactionId = sd.parentTransactionId
         AND COALESCE(sd.splitTransactionId, 0) = COALESCE(te.splitTransactionId, 0)
        INNER JOIN [dbo].[taggedEvent] e ON te.taggedEventId = e.taggedEventId
        GROUP BY e.taggedEventTag
        """
    )
    source = {row[0]: (row[1], Decimal(row[2] or 0)) for row in mssql_cur.fetchall()}
    pg_cur.execute(
        """
        SELECT te.tag,
               COUNT(bt.id),
               SUM(COALESCE(sd.split_amount, bt.amount))
        FROM transaction_tagged_events tte
        INNER JOIN tagged_events te ON te.id = tte.tagged_event_id
        INNER JOIN bank_transactions bt ON bt.id = tte.bank_transaction_id
        LEFT JOIN category_split_details sd ON sd.id = tte.category_split_detail_id
        GROUP BY te.tag
        """
    )
    target = {row[0]: (row[1], Decimal(row[2] or 0)) for row in pg_cur.fetchall()}
    failures = [
        tag
        for tag in sorted(set(source) | set(target))
        if source.get(tag, (0, Decimal(0))) != target.get(tag, (0, Decimal(0)))
    ]
    return CheckResult(
        3,
        "event totals vs legacy",
        "PASS" if not failures else "FAIL",
        ", ".join(failures[:5]) + ("..." if len(failures) > 5 else ""),
        len(source),
        len(target),
        len(failures),
    )


def run_validation(mssql_cur, pg_cur) -> list[CheckResult]:
    results = run_layer1(mssql_cur, pg_cur)
    results.extend(run_layer2(mssql_cur, pg_cur))
    results.extend(run_layer3(mssql_cur, pg_cur))
    results.append(compare_event_totals(mssql_cur, pg_cur))
    return results


def format_report(results: list[CheckResult]) -> str:
    lines = ["# Migration acceptance report", ""]
    current_layer = 0
    for result in results:
        if result.layer != current_layer:
            current_layer = result.layer
            lines.append(f"## Layer {current_layer}")
            lines.append("")
        line = f"- **{result.status}** {result.name}"
        if result.source is not None or result.target is not None:
            line += f" — source={result.source!r} target={result.target!r}"
        if result.diff is not None:
            line += f" diff={result.diff!r}"
        if result.detail:
            line += f" ({result.detail})"
        lines.append(line)
    lines.append("")
    fails = sum(1 for r in results if r.status == "FAIL")
    warns = sum(1 for r in results if r.status == "WARN")
    lines.append(f"Summary: {fails} FAIL, {warns} WARN, {len(results) - fails - warns} PASS")
    return "\n".join(lines)


def build_fixture_manifest(pg_cur) -> dict:
    counts, amounts = pg_monthly_metrics(pg_cur)
    pg_cur.execute(
        "SELECT COUNT(*) FROM bank_transactions WHERE category_status = %s",
        (STATUS_NEEDS_CATEGORIZATION,),
    )
    uncat = pg_cur.fetchone()[0]
    return {
        "row_counts": {table: pg_count(pg_cur, table) for table in LEGACY_TABLE_COUNTS},
        "monthly_counts": counts,
        "monthly_amounts": {k: decimal_str(v) for k, v in amounts.items()},
        "uncategorized_count": uncat,
        "splits_on_non_approved": _splits_on_non_approved(pg_cur, False),
        "dedupe_duplicate_groups": dedupe_duplicate_groups(pg_cur, False),
    }


def _splits_on_non_approved(cur, is_mssql: bool) -> int:
    if is_mssql:
        cur.execute(
            """
            SELECT COUNT(*) FROM [dbo].[categorySplitDetails] sd
            INNER JOIN [dbo].[bankTransaction] bt ON sd.parentTransactionId = bt.transactionId
            WHERE bt.categoryStatus <> %s
            """,
            (STATUS_APPROVED,),
        )
    else:
        cur.execute(
            """
            SELECT COUNT(*) FROM category_split_details sd
            INNER JOIN bank_transactions bt ON bt.id = sd.bank_transaction_id
            WHERE bt.category_status <> %s
            """,
            (STATUS_APPROVED,),
        )
    return cur.fetchone()[0]


def run_layer3_pg_only(pg_cur, manifest: dict | None = None) -> list[CheckResult]:
    results: list[CheckResult] = []

    pg_cur.execute(
        """
        SELECT bt.external_id, bt.amount, COALESCE(SUM(sd.split_amount), 0)
        FROM bank_transactions bt
        INNER JOIN category_split_details sd ON sd.bank_transaction_id = bt.id
        GROUP BY bt.external_id, bt.amount
        HAVING ABS(bt.amount - COALESCE(SUM(sd.split_amount), 0)) >= 0.01
        """
    )
    imbalanced = pg_cur.fetchall()
    results.append(
        CheckResult(
            3,
            "split balance",
            "PASS" if not imbalanced else "FAIL",
            f"{len(imbalanced)} imbalanced parents",
            0,
            len(imbalanced),
            len(imbalanced),
        )
    )

    orphan_splits = _splits_on_non_approved(pg_cur, False)
    expected_splits = manifest.get("splits_on_non_approved") if manifest else None
    if expected_splits is not None:
        results.append(
            CheckResult(
                3,
                "splits on non-approved parents (fixture)",
                "PASS" if orphan_splits == expected_splits else "FAIL",
                "",
                expected_splits,
                orphan_splits,
                orphan_splits - expected_splits,
            )
        )

    pg_cur.execute(
        """
        SELECT
            COUNT(*) FILTER (WHERE category_status = %s) AS approved,
            COUNT(*) FILTER (WHERE category_status = %s AND payee_id IS NOT NULL) AS approved_with_payee
        FROM bank_transactions
        """,
        (STATUS_APPROVED, STATUS_APPROVED),
    )
    approved, approved_with_payee = pg_cur.fetchone()
    coverage = (approved_with_payee / approved * 100) if approved else 100.0
    results.append(
        CheckResult(
            3,
            "payee backfill coverage",
            "PASS" if coverage >= 95 else "FAIL",
            f"{coverage:.1f}% of approved txns have payee_id",
            95.0,
            round(coverage, 1),
            round(coverage - 95.0, 1),
        )
    )

    pg_cur.execute(
        f"""
        SELECT COUNT(*) FROM (
            SELECT DISTINCT {PAYEE_EXPR} AS payee_text
            FROM bank_transactions
            WHERE {PAYEE_EXPR} IS NOT NULL
        ) d
        WHERE NOT EXISTS (
            SELECT 1 FROM payee_aliases pa WHERE pa.raw_text = d.payee_text
        )
        """
    )
    missing_aliases = pg_cur.fetchone()[0]
    results.append(
        CheckResult(
            3,
            "payee alias coverage",
            "PASS" if missing_aliases == 0 else "FAIL",
            "",
            0,
            missing_aliases,
            missing_aliases,
        )
    )

    pg_cur.execute(
        """
        SELECT COUNT(*) FROM bank_transactions bt
        INNER JOIN category_suggestions cs ON cs.bank_transaction_id = bt.id
        WHERE bt.category_status = %s
        """,
        (STATUS_APPROVED,),
    )
    stale_suggestions = pg_cur.fetchone()[0]
    results.append(
        CheckResult(
            3,
            "category suggestion cleanup",
            "PASS" if stale_suggestions == 0 else "FAIL",
            "",
            0,
            stale_suggestions,
            stale_suggestions,
        )
    )

    dupes = dedupe_duplicate_groups(pg_cur, False)
    expected_dupes = manifest.get("dedupe_duplicate_groups") if manifest else None
    if expected_dupes is not None:
        results.append(
            CheckResult(
                3,
                "legacy dedupe key duplicate groups (fixture)",
                "PASS" if dupes == expected_dupes else "FAIL",
                "",
                expected_dupes,
                dupes,
                dupes - expected_dupes,
            )
        )

    return results


def validate_against_manifest(pg_cur, manifest: dict) -> list[CheckResult]:
    results: list[CheckResult] = []
    for table, expected in manifest.get("row_counts", {}).items():
        actual = pg_count(pg_cur, table)
        results.append(
            CheckResult(
                1,
                f"{table} row count (fixture)",
                "PASS" if actual == expected else "FAIL",
                "",
                expected,
                actual,
                actual - expected,
            )
        )
    target_counts, target_amounts = pg_monthly_metrics(pg_cur)
    for ym, expected in manifest.get("monthly_counts", {}).items():
        actual = target_counts.get(ym, 0)
        results.append(
            CheckResult(
                2,
                f"monthly count {ym} (fixture)",
                "PASS" if actual == expected else "FAIL",
                "",
                expected,
                actual,
                actual - expected,
            )
        )
    for ym, expected in manifest.get("monthly_amounts", {}).items():
        actual = decimal_str(target_amounts.get(ym, Decimal(0)))
        status = "PASS" if actual == expected else "FAIL"
        results.append(
            CheckResult(2, f"monthly amount {ym} (fixture)", status, "", expected, actual, None)
        )
    pg_cur.execute(
        "SELECT COUNT(*) FROM bank_transactions WHERE category_status = %s",
        (STATUS_NEEDS_CATEGORIZATION,),
    )
    uncat = pg_cur.fetchone()[0]
    expected_uncat = manifest.get("uncategorized_count")
    if expected_uncat is not None:
        results.append(
            CheckResult(
                2,
                "uncategorized backlog (fixture)",
                "PASS" if uncat == expected_uncat else "FAIL",
                "",
                expected_uncat,
                uncat,
                uncat - expected_uncat,
            )
        )
    results.extend(run_layer3_pg_only(pg_cur, manifest))
    return results


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--database", default="Finances")
    parser.add_argument("--pg-dsn", default=os.environ.get("PG_DSN", DEFAULT_PG_DSN))
    parser.add_argument("--report-dir", default="tools/reports")
    parser.add_argument("--write-manifest", help="Write manifest JSON for CI fixture validation")
    parser.add_argument("--manifest", help="Validate Postgres against a manifest JSON (no MSSQL)")
    args = parser.parse_args()

    pg = connect_pg(args.pg_dsn)
    try:
        pcur = pg.cursor()
        if args.manifest:
            manifest = json.loads(Path(args.manifest).read_text())
            results = validate_against_manifest(pcur, manifest)
        elif args.write_manifest:
            manifest = build_fixture_manifest(pcur)
            path = Path(args.write_manifest)
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text(json.dumps(manifest, indent=2) + "\n")
            print(f"Wrote manifest to {path}")
            results = validate_against_manifest(pcur, manifest)
        else:
            mssql = connect_mssql(args.database)
            try:
                mcur = mssql.cursor()
                results = run_validation(mcur, pcur)
            finally:
                mssql.close()
    finally:
        pg.close()

    report = format_report(results)
    print(report)

    report_dir = Path(args.report_dir)
    report_dir.mkdir(parents=True, exist_ok=True)
    stamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    report_path = report_dir / f"migration_acceptance_{stamp}.md"
    report_path.write_text(report + "\n")
    print(f"\nReport written to {report_path}")

    if any(r.status == "FAIL" for r in results):
        raise SystemExit(1)


if __name__ == "__main__":
    main()
