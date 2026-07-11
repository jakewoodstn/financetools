"""Shared helpers for legacy MSSQL → Postgres migration and validation."""

from __future__ import annotations

import os
from dataclasses import dataclass
from decimal import Decimal
from typing import Any, Literal

DEFAULT_PG_DSN = "postgresql://finance:finance@localhost:5432/finances"

STATUS_APPROVED = -1
STATUS_NEEDS_CATEGORIZATION = 0

ACCOUNT_COLUMNS = [
    ("accountId", "id"),
    ("accountName", "account_name"),
    ("createdAt", "created_at"),
    ("closedOn", "closed_on"),
    ("importTransactions", "import_transactions"),
]
TRANSACTION_ACCOUNT_COLUMNS = [
    ("transactionAccountName", "name"),
    ("accountId", "account_id"),
]
GROUP_COLUMNS = [
    ("groupID", "id"),
    ("groupName", "group_name"),
]
CATEGORY_COLUMNS = [
    ("categoryId", "id"),
    ("categoryName", "category_name"),
    ("groupID", "spending_category_group_id"),
]
TRANSACTION_COLUMNS = [
    ("transactionId", "external_id"),
    ("transactionDate", "transaction_date"),
    ("loadedDate", "loaded_date"),
    ("description", "description"),
    ("category", "import_category"),
    ("amount", "amount"),
    ("categoryId", "spending_category_id"),
    ("origDescription", "orig_description"),
    ("categoryStatus", "category_status"),
    ("bankOrigDescription", "bank_orig_description"),
    ("accountId", "account_id"),
    ("accountingDate", "accounting_date"),
]
SPLIT_COLUMNS = [
    ("splitTransactionId", "external_id"),
    ("parentTransactionId", "parent_external_id"),
    ("categoryId", "spending_category_id"),
    ("splitAmount", "split_amount"),
]
TAGGED_EVENT_COLUMNS = [
    ("taggedEventId", "id"),
    ("taggedEventTag", "tag"),
    ("taggedEventDescription", "description"),
    ("effectiveDate", "effective_date"),
    ("retiredDate", "retired_date"),
]
TAG_LINK_COLUMNS = [
    ("transactionTaggedEventId", "id"),
    ("transactionId", "transaction_external_id"),
    ("taggedEventId", "tagged_event_id"),
    ("taggedAt", "tagged_at"),
    ("splitTransactionId", "split_external_id"),
]

LEGACY_TABLE_COUNTS = {
    "accounts": ("account", None),
    "transaction_accounts": ("transactionAccount", None),
    "spending_category_groups": ("spendingCategoryGroup", None),
    "spending_categories": ("spendingCategories", None),
    "bank_transactions": ("bankTransaction", None),
    "category_split_details": ("categorySplitDetails", None),
    "tagged_events": ("taggedEvent", None),
    "transaction_tagged_events": ("transactionTaggedEvent", None),
}

TRUNCATE_TABLES = (
    "transfer_links, transaction_tagged_events, tagged_events, "
    "category_suggestions, category_rules, payee_aliases, payees, "
    "raw_transactions, import_batches, category_split_details, bank_transactions, "
    "transaction_accounts, spending_categories, spending_category_groups, accounts"
)

# SimpleFIN Bridge account names → accounts.id (verified 2026-07-11).
SIMPLEFIN_TRANSACTION_ACCOUNTS: list[tuple[str, int]] = [
    ("Adv Plus Banking- 8971 (8971)", 1),  # Bank of America Checking
    ("Rapid Rewards Priority (2985)", 2),  # Chase Southwest Rewards Credit Card
    ("Savings Account (8193)", 3),  # Ally Bank - General Savings
    ("Money Market Savings Account (2395)", 4),  # Ally Bank - Tax Withholding
]

# Legacy MSSQL has import_transactions=0 for account 4; enable on replatform.
ACCOUNT_IMPORT_OVERRIDES: dict[int, int] = {
    4: 1,
}

PAYEE_EXPR = "COALESCE(NULLIF(TRIM(description), ''), NULLIF(TRIM(bank_orig_description), ''))"


@dataclass
class CheckResult:
    layer: int
    name: str
    status: Literal["PASS", "FAIL", "WARN"]
    detail: str
    source: Any = None
    target: Any = None
    diff: Any = None


def env(name: str, default: str | None = None) -> str:
    value = os.environ.get(name, default)
    if not value:
        raise SystemExit(f"Missing required environment variable: {name}")
    return value


def connect_mssql(database: str):
    import pymssql

    return pymssql.connect(
        server=env("MSSQL_HOST"),
        user=env("MSSQL_USER"),
        password=env("MSSQL_PASSWORD"),
        database=database,
    )


def connect_pg(dsn: str | None = None):
    import psycopg

    return psycopg.connect(dsn or os.environ.get("PG_DSN", DEFAULT_PG_DSN))


def fetch_all(mssql_cur, src_columns: list[tuple[str, str]], table: str, where: str = "") -> list[tuple]:
    cols = ", ".join(f"[{src}]" for src, _ in src_columns)
    mssql_cur.execute(f"SELECT {cols} FROM [dbo].[{table}] {where}")
    return mssql_cur.fetchall()


def fetch_all_transactions(mssql_cur) -> list[tuple]:
    cols = ", ".join(f"[{src}]" for src, _ in TRANSACTION_COLUMNS)
    mssql_cur.execute(
        f"SELECT {cols} FROM [dbo].[bankTransaction] ORDER BY [transactionDate], [transactionId]"
    )
    return mssql_cur.fetchall()


def sample_transactions(mssql_cur, years: int, sample: int) -> list[tuple]:
    cols = ", ".join(f"[{src}]" for src, _ in TRANSACTION_COLUMNS)
    where = (
        "WHERE [transactionDate] IS NOT NULL "
        f"AND [transactionDate] >= DATEADD(YEAR, -{years}, "
        "(SELECT MAX([transactionDate]) FROM [dbo].[bankTransaction])) "
        "ORDER BY [transactionDate], [transactionId]"
    )
    mssql_cur.execute(f"SELECT {cols} FROM [dbo].[bankTransaction] {where}")
    rows = mssql_cur.fetchall()
    if len(rows) <= sample:
        return rows
    step = len(rows) / sample
    return [rows[int(i * step)] for i in range(sample)]


def insert_rows(pg_cur, table: str, columns: list[tuple[str, str]], rows: list[tuple]) -> None:
    if not rows:
        return
    target_cols = ", ".join(tgt for _, tgt in columns)
    placeholders = ", ".join(["%s"] * len(columns))
    pg_cur.executemany(
        f"INSERT INTO {table} ({target_cols}) VALUES ({placeholders})",
        rows,
    )


def reset_sequence(pg_cur, table: str, pk: str = "id") -> None:
    pg_cur.execute(
        f"SELECT setval(pg_get_serial_sequence(%s, %s), (SELECT MAX({pk}) FROM {table})) "
        f"WHERE EXISTS (SELECT 1 FROM {table})",
        (table, pk),
    )


def date_index(columns: list[tuple[str, str]], target: str) -> int:
    for idx, (_, tgt) in enumerate(columns):
        if tgt == target:
            return idx
    raise ValueError(f"No column mapped to {target}")


def external_id_map(pg_cur, table: str) -> dict[int, int]:
    pg_cur.execute(f"SELECT id, external_id FROM {table}")
    return {external_id: internal_id for internal_id, external_id in pg_cur.fetchall()}


def load_splits(pg_cur, splits: list[tuple]) -> int:
    if not splits:
        return 0
    parent_idx = date_index(SPLIT_COLUMNS, "parent_external_id")
    external_idx = date_index(SPLIT_COLUMNS, "external_id")
    category_idx = date_index(SPLIT_COLUMNS, "spending_category_id")
    amount_idx = date_index(SPLIT_COLUMNS, "split_amount")
    txn_id_by_external = external_id_map(pg_cur, "bank_transactions")
    split_rows = []
    for row in splits:
        bank_transaction_id = txn_id_by_external.get(row[parent_idx])
        if bank_transaction_id is None:
            continue
        split_rows.append(
            (row[external_idx], bank_transaction_id, row[category_idx], row[amount_idx])
        )
    insert_rows(
        pg_cur,
        "category_split_details",
        [
            ("external_id", "external_id"),
            ("bank_transaction_id", "bank_transaction_id"),
            ("spending_category_id", "spending_category_id"),
            ("split_amount", "split_amount"),
        ],
        split_rows,
    )
    return len(split_rows)


def load_tag_links(pg_cur, tag_links: list[tuple]) -> int:
    if not tag_links:
        return 0
    id_idx = date_index(TAG_LINK_COLUMNS, "id")
    txn_idx = date_index(TAG_LINK_COLUMNS, "transaction_external_id")
    event_idx = date_index(TAG_LINK_COLUMNS, "tagged_event_id")
    tagged_at_idx = date_index(TAG_LINK_COLUMNS, "tagged_at")
    split_idx = date_index(TAG_LINK_COLUMNS, "split_external_id")
    txn_id_by_external = external_id_map(pg_cur, "bank_transactions")
    split_id_by_external = external_id_map(pg_cur, "category_split_details")
    rows = []
    for link in tag_links:
        bank_transaction_id = txn_id_by_external.get(link[txn_idx])
        if bank_transaction_id is None:
            continue
        split_external = link[split_idx]
        split_id = None
        if split_external not in (None, 0):
            split_id = split_id_by_external.get(split_external)
        rows.append(
            (
                link[id_idx],
                bank_transaction_id,
                link[event_idx],
                split_id,
                link[tagged_at_idx],
            )
        )
    insert_rows(
        pg_cur,
        "transaction_tagged_events",
        [
            ("id", "id"),
            ("bank_transaction_id", "bank_transaction_id"),
            ("tagged_event_id", "tagged_event_id"),
            ("category_split_detail_id", "category_split_detail_id"),
            ("tagged_at", "tagged_at"),
        ],
        rows,
    )
    return len(rows)


def upsert_simplefin_transaction_accounts(pg_cur) -> int:
    for name, account_id in SIMPLEFIN_TRANSACTION_ACCOUNTS:
        pg_cur.execute(
            """
            INSERT INTO transaction_accounts (name, account_id)
            VALUES (%s, %s)
            ON CONFLICT (name) DO UPDATE SET account_id = EXCLUDED.account_id
            """,
            (name, account_id),
        )
    return len(SIMPLEFIN_TRANSACTION_ACCOUNTS)


def apply_account_import_overrides(pg_cur) -> int:
    for account_id, flag in ACCOUNT_IMPORT_OVERRIDES.items():
        pg_cur.execute(
            "UPDATE accounts SET import_transactions = %s WHERE id = %s",
            (flag, account_id),
        )
    return len(ACCOUNT_IMPORT_OVERRIDES)


def backfill_payees(pg_cur) -> tuple[int, int]:
    pg_cur.execute(
        f"""
        INSERT INTO payees (canonical_name)
        SELECT DISTINCT {PAYEE_EXPR}
        FROM bank_transactions
        WHERE {PAYEE_EXPR} IS NOT NULL
        ORDER BY 1
        """
    )
    pg_cur.execute("SELECT COUNT(*) FROM payees")
    payee_count = pg_cur.fetchone()[0]

    pg_cur.execute(
        f"""
        INSERT INTO payee_aliases (payee_id, raw_text, source)
        SELECT p.id, p.canonical_name, 'import'
        FROM payees p
        """
    )
    pg_cur.execute("SELECT COUNT(*) FROM payee_aliases")
    alias_count = pg_cur.fetchone()[0]

    pg_cur.execute(
        f"""
        UPDATE bank_transactions bt
        SET payee_id = p.id
        FROM payees p
        WHERE {PAYEE_EXPR} = p.canonical_name
        """
    )
    return payee_count, alias_count


def seed_category_rules(pg_cur) -> int:
    pg_cur.execute(
        """
        INSERT INTO category_rules (payee_id, spending_category_id, source)
        SELECT payee_id, spending_category_id, 'import'
        FROM (
            SELECT
                payee_id,
                spending_category_id,
                ROW_NUMBER() OVER (
                    PARTITION BY payee_id
                    ORDER BY COUNT(*) DESC, spending_category_id
                ) AS rn
            FROM bank_transactions
            WHERE category_status = %s
              AND payee_id IS NOT NULL
              AND spending_category_id IS NOT NULL
            GROUP BY payee_id, spending_category_id
        ) ranked
        WHERE rn = 1
        """,
        (STATUS_APPROVED,),
    )
    pg_cur.execute("SELECT COUNT(*) FROM category_rules")
    return pg_cur.fetchone()[0]


def legacy_count(mssql_cur, table: str) -> int:
    mssql_cur.execute(f"SELECT COUNT(*) FROM [dbo].[{table}]")
    return mssql_cur.fetchone()[0]


def pg_count(pg_cur, table: str) -> int:
    pg_cur.execute(f"SELECT COUNT(*) FROM {table}")
    return pg_cur.fetchone()[0]


def decimal_str(value: Decimal | float | None) -> str:
    if value is None:
        return "0"
    return f"{Decimal(value):.2f}"
