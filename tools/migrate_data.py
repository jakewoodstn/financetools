#!/usr/bin/env python3
"""Migrate data from SQL Server (Finances) into Postgres.

Loads lookup tables in full. Transactions can be sampled (default) or full history
(--full). Tags, splits, payee backfill, and category rules are always loaded for
the selected transaction set.

Setup (once):
    cd tools && uv sync

    export MSSQL_HOST=your-rds.region.rds.amazonaws.com
    export MSSQL_USER=webuser
    export MSSQL_PASSWORD=...

Run:
    uv run python migrate_data.py                    # ~1000 rows over last 4 years
    uv run python migrate_data.py --full             # all transactions + tags
    uv run python migrate_data.py --sample 500 --years 3

Target Postgres defaults to the local docker compose DB; override with PG_DSN.
"""

from __future__ import annotations

import argparse
import os
from collections import Counter

from migration_lib import (
    ACCOUNT_COLUMNS,
    CATEGORY_COLUMNS,
    DAILY_BALANCE_COLUMNS,
    DEFAULT_PG_DSN,
    GROUP_COLUMNS,
    SPLIT_COLUMNS,
    TAGGED_EVENT_COLUMNS,
    TAG_LINK_COLUMNS,
    TRANSACTION_ACCOUNT_COLUMNS,
    TRANSACTION_COLUMNS,
    TRUNCATE_TABLES,
    backfill_payees,
    connect_mssql,
    connect_pg,
    date_index,
    env,
    fetch_all,
    fetch_all_transactions,
    insert_rows,
    legacy_balance_drift_summary,
    load_splits,
    load_tag_links,
    recompute_daily_balances_sql,
    reset_sequence,
    sample_transactions,
    seed_balance_history,
    seed_category_rules,
    upsert_simplefin_transaction_accounts,
    apply_account_import_overrides,
)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--database", default="Finances", help="Source SQL Server database (default: Finances)")
    parser.add_argument("--full", action="store_true", help="Load all transactions (not a sample)")
    parser.add_argument("--sample", type=int, default=1000, help="Approx sample size when not using --full (default: 1000)")
    parser.add_argument("--years", type=int, default=4, help="Sample window in years when not using --full (default: 4)")
    parser.add_argument("--pg-dsn", default=os.environ.get("PG_DSN", DEFAULT_PG_DSN), help="Target Postgres DSN")
    args = parser.parse_args()

    print(f"Connecting to SQL Server {env('MSSQL_HOST')} / {args.database} ...")
    mssql = connect_mssql(args.database)
    print(f"Connecting to Postgres {args.pg_dsn} ...")
    pg = connect_pg(args.pg_dsn)

    try:
        mcur = mssql.cursor()

        print("Reading lookups (accounts, transaction accounts, groups, categories, tags) ...")
        accounts = fetch_all(mcur, ACCOUNT_COLUMNS, "account")
        transaction_accounts = fetch_all(mcur, TRANSACTION_ACCOUNT_COLUMNS, "transactionAccount")
        groups = fetch_all(mcur, GROUP_COLUMNS, "spendingCategoryGroup")
        categories = fetch_all(mcur, CATEGORY_COLUMNS, "spendingCategories")
        tagged_events = fetch_all(mcur, TAGGED_EVENT_COLUMNS, "taggedEvent")
        print("Reading DailyBalance history ...")
        daily_balances = fetch_all(mcur, DAILY_BALANCE_COLUMNS, "DailyBalance")

        if args.full:
            print("Reading all transactions ...")
            transactions = fetch_all_transactions(mcur)
        else:
            print(f"Sampling ~{args.sample} transactions across last {args.years} years ...")
            transactions = sample_transactions(mcur, args.years, args.sample)

        txn_external_idx = date_index(TRANSACTION_COLUMNS, "external_id")
        migrated_external_ids = {row[txn_external_idx] for row in transactions}

        print("Reading splits and tag links for migrated transactions ...")
        all_splits = fetch_all(mcur, SPLIT_COLUMNS, "categorySplitDetails")
        parent_idx = date_index(SPLIT_COLUMNS, "parent_external_id")
        splits = [row for row in all_splits if row[parent_idx] in migrated_external_ids]

        all_tag_links = fetch_all(mcur, TAG_LINK_COLUMNS, "transactionTaggedEvent")
        txn_idx = date_index(TAG_LINK_COLUMNS, "transaction_external_id")
        tag_links = [row for row in all_tag_links if row[txn_idx] in migrated_external_ids]

        with pg:
            pcur = pg.cursor()
            print("Clearing existing target rows ...")
            pcur.execute(f"TRUNCATE {TRUNCATE_TABLES} RESTART IDENTITY CASCADE")

            print(f"Loading {len(accounts)} accounts ...")
            insert_rows(pcur, "accounts", ACCOUNT_COLUMNS, accounts)
            apply_account_import_overrides(pcur)
            print(f"Loading {len(transaction_accounts)} transaction accounts ...")
            insert_rows(pcur, "transaction_accounts", TRANSACTION_ACCOUNT_COLUMNS, transaction_accounts)
            print("Upserting SimpleFIN transaction account mappings ...")
            upsert_simplefin_transaction_accounts(pcur)
            print(f"Loading {len(groups)} category groups ...")
            insert_rows(pcur, "spending_category_groups", GROUP_COLUMNS, groups)
            print(f"Loading {len(categories)} categories ...")
            insert_rows(pcur, "spending_categories", CATEGORY_COLUMNS, categories)
            print(f"Loading {len(transactions)} transactions ...")
            insert_rows(pcur, "bank_transactions", TRANSACTION_COLUMNS, transactions)
            print(f"Loading {len(splits)} split details ...")
            split_count = load_splits(pcur, splits)
            print(f"Loading {len(tagged_events)} tagged events ...")
            insert_rows(pcur, "tagged_events", TAGGED_EVENT_COLUMNS, tagged_events)
            print(f"Loading {len(tag_links)} transaction tag links ...")
            tag_link_count = load_tag_links(pcur, tag_links)
            print("Backfilling payees ...")
            payee_count, alias_count = backfill_payees(pcur)
            print(f"  {payee_count} payees, {alias_count} aliases")
            print("Seeding category rules ...")
            rule_count = seed_category_rules(pcur)
            print(f"  {rule_count} rules")
            print(f"Seeding balance anchors/observations from {len(daily_balances)} DailyBalance rows ...")
            anchor_count, observation_count = seed_balance_history(pcur, daily_balances)
            print(f"  anchors: {anchor_count}, legacy observations: {observation_count}")
            print("Recomputing daily_balances ...")
            daily_balance_rows = recompute_daily_balances_sql(pcur)
            print(f"  daily_balances rows: {daily_balance_rows}")
            drift_rows = legacy_balance_drift_summary(pcur)

            print("Resetting sequences ...")
            for table in (
                "accounts",
                "transaction_accounts",
                "spending_category_groups",
                "spending_categories",
                "category_split_details",
                "tagged_events",
                "transaction_tagged_events",
                "payees",
                "payee_aliases",
                "category_rules",
                "balance_anchors",
                "balance_observations",
            ):
                reset_sequence(pcur, table)

        date_idx = date_index(TRANSACTION_COLUMNS, "transaction_date")
        by_year = Counter(row[date_idx].year for row in transactions if row[date_idx])
        print("\nDone.")
        print(f"  transactions: {len(transactions)}")
        print(f"  splits loaded: {split_count}")
        print(f"  tag links loaded: {tag_link_count}")
        print(f"  payees: {payee_count}")
        print(f"  category rules: {rule_count}")
        print(f"  balance anchors: {anchor_count}")
        print(f"  legacy balance observations: {observation_count}")
        print(f"  daily_balances rows: {daily_balance_rows}")
        if drift_rows:
            print("\nLegacy balance drift (max abs / mismatches):")
            for account_id, max_drift, avg_drift, mismatches in drift_rows:
                print(
                    f"  account {account_id}: max_abs={max_drift} avg_abs={avg_drift} "
                    f"mismatches={mismatches}"
                )
        print("\nTransactions by year:")
        for year in sorted(by_year):
            print(f"  {year}: {by_year[year]}")
    finally:
        mssql.close()
        pg.close()


if __name__ == "__main__":
    main()
