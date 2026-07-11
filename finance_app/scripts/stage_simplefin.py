#!/usr/bin/env python3
"""Fetch SimpleFIN transactions and stage them in raw_transactions.

Does not promote to bank_transactions (Phase 3 step 3 — later).

Usage:
    cd finance_app
    uv run python scripts/stage_simplefin.py
    uv run python scripts/stage_simplefin.py --days 30
"""

from __future__ import annotations

import argparse
import sys

from app.config import settings
from app.database import SessionLocal
from app.services.ingest_staging import stage_simplefin_accounts
from app.services.simplefin import SimpleFinError, api_errors, fetch_account_set, parse_accounts, validate_access_url


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument(
        "--days",
        type=int,
        default=None,
        help="Transaction window in days (default: Bridge default window)",
    )
    args = parser.parse_args()

    if not settings.simplefin_access_url:
        print("SIMPLEFIN_ACCESS_URL is not set in .env", file=sys.stderr)
        raise SystemExit(1)

    try:
        access_url = validate_access_url(settings.simplefin_access_url)
        payload = fetch_account_set(access_url, days=args.days)
        accounts = parse_accounts(payload)
    except SimpleFinError as exc:
        print(f"SimpleFIN error: {exc}", file=sys.stderr)
        raise SystemExit(1) from exc

    db = SessionLocal()
    try:
        result = stage_simplefin_accounts(db, accounts, api_errors=api_errors(payload))
    finally:
        db.close()

    if result.api_errors:
        print("API errlist:")
        for err in result.api_errors:
            print(f"  - {err}")

    if result.unmapped_account_names:
        print("Unmapped SimpleFIN accounts (add to transaction_accounts):")
        for name in result.unmapped_account_names:
            print(f"  - {name}")

    print(f"import_batch_id: {result.import_batch_id}")
    print(f"accounts_seen: {result.accounts_seen}")
    print(f"transactions_fetched: {result.transactions_fetched}")
    print(f"inserted: {result.inserted}")
    print(f"skipped_duplicate: {result.skipped_duplicate}")
    print(f"skipped_unmapped_account: {result.skipped_unmapped_account}")


if __name__ == "__main__":
    main()
