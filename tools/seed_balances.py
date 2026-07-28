#!/usr/bin/env python3
"""Seed observed balances from SQL Server DailyBalance.

Standalone (non-destructive) version of the balance seeding that migrate_data.py
performs during a full reload: reads dbo.DailyBalance, upserts
balance_observations, rebuilds daily_balances, and prints a drift summary.

Setup (same as migrate_data.py):
    cd tools && uv sync
    export MSSQL_HOST=... MSSQL_USER=... MSSQL_PASSWORD=...

Run:
    uv run python seed_balances.py
    uv run python seed_balances.py --pg-dsn postgresql://...
"""

from __future__ import annotations

import argparse
import os

from migration_lib import (
    DAILY_BALANCE_COLUMNS,
    DEFAULT_PG_DSN,
    connect_mssql,
    connect_pg,
    env,
    fetch_all,
    legacy_balance_drift_summary,
    recompute_daily_balances_sql,
    reset_sequence,
    seed_balance_history,
)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--database", default="Finances", help="Source SQL Server database (default: Finances)")
    parser.add_argument("--pg-dsn", default=os.environ.get("PG_DSN", DEFAULT_PG_DSN), help="Target Postgres DSN")
    args = parser.parse_args()

    print(f"Connecting to SQL Server {env('MSSQL_HOST')} / {args.database} ...")
    mssql = connect_mssql(args.database)
    print(f"Connecting to Postgres {args.pg_dsn} ...")
    pg = connect_pg(args.pg_dsn)

    try:
        mcur = mssql.cursor()
        print("Reading DailyBalance history ...")
        daily_balances = fetch_all(mcur, DAILY_BALANCE_COLUMNS, "DailyBalance")
        print(f"  {len(daily_balances)} rows")

        with pg:
            pcur = pg.cursor()
            print("Seeding observed balances ...")
            _, observation_count = seed_balance_history(pcur, daily_balances)
            print(f"  observations: {observation_count}")
            print("Recomputing daily_balances ...")
            rows = recompute_daily_balances_sql(pcur)
            print(f"  daily_balances rows: {rows}")
            reset_sequence(pcur, "balance_observations")
            drift_rows = legacy_balance_drift_summary(pcur)

        if drift_rows:
            print("\nObserved balance drift vs prior+txns (tolerance 0.01):")
            for account_id, max_drift, avg_drift, mismatches in drift_rows:
                print(
                    f"  account {account_id}: max_abs={max_drift} avg_abs={avg_drift} "
                    f"mismatches={mismatches}"
                )
        print("\nDone.")
    finally:
        mssql.close()
        pg.close()


if __name__ == "__main__":
    main()
