#!/usr/bin/env python3
"""Promote unstaged raw_transactions into bank_transactions.

Usage:
    cd finance_app
    uv run python scripts/promote_staging.py
    uv run python scripts/promote_staging.py --account 3
    uv run python scripts/promote_staging.py --batch 12
"""

from __future__ import annotations

import argparse
import sys

from app.database import SessionLocal
from app.services.promote_staging import promote_raw_transactions


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--account", type=int, help="Promote unstaged rows for one accounts.id")
    parser.add_argument("--batch", type=int, help="Promote unstaged rows from one import_batches.id")
    args = parser.parse_args()

    db = SessionLocal()
    try:
        result = promote_raw_transactions(db, account_id=args.account, import_batch_id=args.batch)
    finally:
        db.close()

    print(f"candidates: {result.candidates}")
    print(f"promoted: {result.promoted}")
    print(f"linked_existing: {result.linked_existing}")
    print(f"skipped_already_linked: {result.skipped_already_linked}")
    print(f"skipped_import_disabled: {result.skipped_import_disabled}")
    if result.import_batch_ids:
        print(f"import_batch_ids: {', '.join(str(batch_id) for batch_id in result.import_batch_ids)}")

    if result.candidates == 0:
        print("Nothing to promote.", file=sys.stderr)


if __name__ == "__main__":
    main()
