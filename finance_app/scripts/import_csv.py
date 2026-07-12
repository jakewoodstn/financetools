#!/usr/bin/env python3
"""Import a bank CSV download into raw_transactions and promote.

Usage:
    cd finance_app
    uv run python scripts/import_csv.py --account 1 ~/Downloads/transactions.csv
    uv run python scripts/import_csv.py --account 2 file.csv --replace
    uv run python scripts/import_csv.py --account 1 file.csv --col-date "Transaction Date"
"""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

from app.database import SessionLocal
from app.services import import_control
from app.services.csv_import import CsvImportError


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--account", type=int, required=True, help="Target accounts.id")
    parser.add_argument("csv_file", type=Path, help="Bank CSV download path")
    parser.add_argument("--mode", choices=("merge", "replace"), default="merge")
    parser.add_argument("--col-date", dest="col_date", help="Override date column header")
    parser.add_argument("--col-amount", dest="col_amount", help="Override amount column header")
    parser.add_argument("--col-description", dest="col_description", help="Override description column header")
    parser.add_argument("--col-category", dest="col_category", help="Override category column header")
    args = parser.parse_args()

    if not args.csv_file.is_file():
        print(f"File not found: {args.csv_file}", file=sys.stderr)
        raise SystemExit(1)

    content = args.csv_file.read_bytes()
    overrides = {
        "transaction_date": args.col_date,
        "amount": args.col_amount,
        "description": args.col_description,
        "category": args.col_category,
    }

    db = SessionLocal()
    try:
        result = import_control.run_csv_import(
            db,
            args.account,
            filename=args.csv_file.name,
            content=content,
            mode=args.mode,
            column_overrides=overrides,
        )
    except (ValueError, CsvImportError) as exc:
        print(f"Import error: {exc}", file=sys.stderr)
        raise SystemExit(1) from exc
    finally:
        db.close()

    stage = result.stage
    promote = result.promote
    print(f"account: {result.account_name} ({result.account_id})")
    print(f"file: {result.filename}")
    print(f"mapping: {result.column_mapping}")
    print(f"rows: {stage.transactions_fetched}")
    print(f"inserted: {stage.inserted}")
    print(f"skipped_duplicate: {stage.skipped_duplicate}")
    if promote:
        print(f"promoted: {promote.promoted}")
        print(f"linked_existing: {promote.linked_existing}")


if __name__ == "__main__":
    main()
