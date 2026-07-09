#!/usr/bin/env python3
"""Migrate a sample of real data from SQL Server (Finances) into local Postgres.

Loads the small lookup tables in full (account, spendingCategoryGroup,
spendingCategories) and an evenly-spaced sample of bankTransaction rows spread
across the most recent N years, plus any categorySplitDetails belonging to the
sampled transactions. Source primary keys are preserved.

Setup (once):
    cd tools && uv sync

    export MSSQL_HOST=your-rds.region.rds.amazonaws.com
    export MSSQL_USER=webuser
    export MSSQL_PASSWORD=...

Run:
    uv run python migrate_data.py                 # ~1000 rows over last 4 years
    uv run python migrate_data.py --sample 500 --years 3

Target Postgres defaults to the local docker compose DB; override with PG_DSN.
"""

from __future__ import annotations

import argparse
import os
import sys
from collections import Counter

DEFAULT_PG_DSN = "postgresql://finance:finance@localhost:5432/finances"

# Source (MSSQL) column order -> target (Postgres) column name.
# Lookups are loaded in full; preserve identity values from the source.
ACCOUNT_COLUMNS = [
    ("accountId", "account_id"),
    ("accountName", "account_name"),
    ("createdAt", "created_at"),
    ("closedOn", "closed_on"),
    ("importTransactions", "import_transactions"),
]
GROUP_COLUMNS = [
    ("groupID", "group_id"),
    ("groupName", "group_name"),
]
CATEGORY_COLUMNS = [
    ("categoryId", "category_id"),
    ("categoryName", "category_name"),
    ("groupID", "group_id"),
]
# bankTransaction: source "category" maps to target column literally named "category".
TRANSACTION_COLUMNS = [
    ("transactionId", "transaction_id"),
    ("transactionDate", "transaction_date"),
    ("loadedDate", "loaded_date"),
    ("description", "description"),
    ("category", "category"),
    ("amount", "amount"),
    ("account", "account"),
    ("categoryId", "category_id"),
    ("origDescription", "orig_description"),
    ("categoryStatus", "category_status"),
    ("bankOrigDescription", "bank_orig_description"),
    ("accountId", "account_id"),
    ("accountingDate", "accounting_date"),
]
SPLIT_COLUMNS = [
    ("splitTransactionId", "split_transaction_id"),
    ("parentTransactionId", "parent_transaction_id"),
    ("categoryId", "category_id"),
    ("splitAmount", "split_amount"),
]


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


def connect_pg(dsn: str):
    import psycopg

    return psycopg.connect(dsn)


def fetch_all(mssql_cur, src_columns: list[tuple[str, str]], table: str, where: str = "") -> list[tuple]:
    cols = ", ".join(f"[{src}]" for src, _ in src_columns)
    mssql_cur.execute(f"SELECT {cols} FROM [dbo].[{table}] {where}")
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
    # Evenly spaced pick across the ordered window -> spread across all N years.
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


def reset_sequence(pg_cur, table: str, pk: str) -> None:
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


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--database", default="Finances", help="Source SQL Server database (default: Finances)")
    parser.add_argument("--sample", type=int, default=1000, help="Approx number of transactions to load (default: 1000)")
    parser.add_argument("--years", type=int, default=4, help="Sample transactions from the last N years (default: 4)")
    parser.add_argument("--pg-dsn", default=os.environ.get("PG_DSN", DEFAULT_PG_DSN), help="Target Postgres DSN")
    args = parser.parse_args()

    print(f"Connecting to SQL Server {env('MSSQL_HOST')} / {args.database} ...")
    mssql = connect_mssql(args.database)
    print(f"Connecting to Postgres {args.pg_dsn} ...")
    pg = connect_pg(args.pg_dsn)

    try:
        mcur = mssql.cursor()

        print("Reading lookups (account, groups, categories) ...")
        accounts = fetch_all(mcur, ACCOUNT_COLUMNS, "account")
        groups = fetch_all(mcur, GROUP_COLUMNS, "spendingCategoryGroup")
        categories = fetch_all(mcur, CATEGORY_COLUMNS, "spendingCategories")

        print(f"Sampling ~{args.sample} transactions across last {args.years} years ...")
        transactions = sample_transactions(mcur, args.years, args.sample)
        txn_id_idx = date_index(TRANSACTION_COLUMNS, "transaction_id")
        sampled_ids = {row[txn_id_idx] for row in transactions}

        print("Reading split details for sampled transactions ...")
        all_splits = fetch_all(mcur, SPLIT_COLUMNS, "categorySplitDetails")
        parent_idx = date_index(SPLIT_COLUMNS, "parent_transaction_id")
        splits = [row for row in all_splits if row[parent_idx] in sampled_ids]

        with pg:  # transaction: commit on success, rollback on error
            pcur = pg.cursor()
            print("Clearing existing target rows ...")
            pcur.execute(
                "TRUNCATE bank_transaction, category_split_detail, spending_category, "
                "spending_category_group, account, transaction_account RESTART IDENTITY CASCADE"
            )

            print(f"Loading {len(accounts)} accounts ...")
            insert_rows(pcur, "account", ACCOUNT_COLUMNS, accounts)
            print(f"Loading {len(groups)} category groups ...")
            insert_rows(pcur, "spending_category_group", GROUP_COLUMNS, groups)
            print(f"Loading {len(categories)} categories ...")
            insert_rows(pcur, "spending_category", CATEGORY_COLUMNS, categories)
            print(f"Loading {len(transactions)} transactions ...")
            insert_rows(pcur, "bank_transaction", TRANSACTION_COLUMNS, transactions)
            print(f"Loading {len(splits)} split details ...")
            insert_rows(pcur, "category_split_detail", SPLIT_COLUMNS, splits)

            print("Resetting sequences ...")
            reset_sequence(pcur, "account", "account_id")
            reset_sequence(pcur, "spending_category_group", "group_id")
            reset_sequence(pcur, "spending_category", "category_id")
            reset_sequence(pcur, "category_split_detail", "split_transaction_id")

        # Report year spread.
        date_idx = date_index(TRANSACTION_COLUMNS, "transaction_date")
        by_year = Counter(row[date_idx].year for row in transactions if row[date_idx])
        print("\nDone. Transactions loaded by year:")
        for year in sorted(by_year):
            print(f"  {year}: {by_year[year]}")
    finally:
        mssql.close()
        pg.close()


if __name__ == "__main__":
    main()
