#!/usr/bin/env python3
"""Rebuild daily_balances from observations + bank_transactions.

Usage:
    cd finance_app
    uv run python scripts/recompute_balances.py
    uv run python scripts/recompute_balances.py --account 1
    uv run python scripts/recompute_balances.py --drift
"""

from __future__ import annotations

import argparse
import sys

from app.database import SessionLocal
from app.services.balance_series import DRIFT_TOLERANCE, drift_report, recompute_daily_balances


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--account", type=int, help="Recompute one accounts.id")
    parser.add_argument("--drift", action="store_true", help="Print drift report after recompute")
    args = parser.parse_args()

    db = SessionLocal()
    try:
        rows = recompute_daily_balances(db, account_id=args.account)
        print(f"daily_balances rows written: {rows}")
        if args.drift:
            report = drift_report(db, account_id=args.account)
            if not report:
                print("No observations to compare.")
                return
            mismatches = 0
            for row in report:
                status = "OK"
                if row.computed is None:
                    status = "NO_PRIOR"
                elif row.drift is not None and abs(row.drift) > DRIFT_TOLERANCE:
                    status = "DRIFT"
                    mismatches += 1
                print(
                    f"  acct={row.account_id} {row.as_of_date} "
                    f"obs={row.observed} computed={row.computed} drift={row.drift} [{status}]"
                )
            print(f"mismatches: {mismatches} / {len(report)}")
            if mismatches:
                sys.exit(1)
    finally:
        db.close()


if __name__ == "__main__":
    main()
