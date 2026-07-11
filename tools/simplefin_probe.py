#!/usr/bin/env python3
"""Probe SimpleFIN Bridge — verify access URL and print account sync summary.

Reads SIMPLEFIN_ACCESS_URL from the environment or a .env file (shell-safe;
do not use `source .env` for URLs with embedded credentials).

Usage:
    cd tools
    uv run python simplefin_probe.py
    uv run python simplefin_probe.py --env-file ../finance_app/.env
    uv run python simplefin_probe.py --days 30
"""

from __future__ import annotations

import argparse
import base64
import json
import subprocess
import sys
from datetime import datetime, timedelta, timezone
from pathlib import Path
from urllib.parse import urlencode


def load_access_url(env_file: Path | None) -> str:
    if env_file and env_file.exists():
        for line in env_file.read_text().splitlines():
            line = line.strip()
            if not line or line.startswith("#"):
                continue
            if line.startswith("SIMPLEFIN_ACCESS_URL="):
                return line.split("=", 1)[1].strip().strip('"').strip("'")
    value = __import__("os").environ.get("SIMPLEFIN_ACCESS_URL", "").strip()
    if value:
        return value
    raise SystemExit(
        "SIMPLEFIN_ACCESS_URL not found. Set it in the environment or pass --env-file."
    )


def ensure_access_url(value: str) -> str:
    if value.startswith("http://") or value.startswith("https://"):
        return value
    # Setup token (base64 claim URL) — not usable for GET until claimed.
    try:
        decoded = base64.b64decode(value).decode()
    except Exception as exc:
        raise SystemExit(f"SIMPLEFIN_ACCESS_URL is not a valid access URL or setup token: {exc}") from exc
    if "/claim/" in decoded:
        raise SystemExit(
            "SIMPLEFIN_ACCESS_URL is still a setup token (base64 claim URL).\n"
            "Claim it once, then put the resulting https://user:pass@... URL in .env.\n"
            "See docs or the SimpleFIN developer guide."
        )
    raise SystemExit("SIMPLEFIN_ACCESS_URL format not recognized.")


def fetch_accounts(access_url: str, *, days: int | None) -> dict:
    base = access_url.rstrip("/")
    params: dict[str, str] = {"version": "2"}
    if days is not None:
        end = datetime.now(timezone.utc)
        start = end - timedelta(days=days)
        params["start-date"] = str(int(start.timestamp()))
        params["end-date"] = str(int(end.timestamp()))
    api_url = f"{base}/accounts?{urlencode(params)}"

    result = subprocess.run(
        ["curl", "-sL", "-w", "\n__HTTP_CODE__:%{http_code}", api_url],
        capture_output=True,
        text=True,
        check=False,
    )
    if result.returncode != 0:
        raise SystemExit(f"curl failed: {result.stderr or result.stdout}")

    body, _, trailer = result.stdout.rpartition("\n__HTTP_CODE__:")
    code = trailer.strip() if trailer else "?"
    if code != "200":
        raise SystemExit(f"HTTP {code}: {body[:500]}")

    try:
        return json.loads(body)
    except json.JSONDecodeError as exc:
        raise SystemExit(f"Response is not JSON: {body[:200]!r}") from exc


def ts(value: int | float | None) -> str:
    if not value:
        return "—"
    return datetime.fromtimestamp(value, tz=timezone.utc).strftime("%Y-%m-%d")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument(
        "--env-file",
        type=Path,
        default=Path(__file__).resolve().parent.parent / "finance_app" / ".env",
        help="Path to .env with SIMPLEFIN_ACCESS_URL (default: finance_app/.env)",
    )
    parser.add_argument(
        "--days",
        type=int,
        default=None,
        help="Optional transaction window (start-date/end-date) in days back from now",
    )
    args = parser.parse_args()

    access_url = ensure_access_url(load_access_url(args.env_file))
    data = fetch_accounts(access_url, days=args.days)

    errlist = data.get("errlist") or data.get("errors") or []
    if errlist:
        print(f"errlist ({len(errlist)}):")
        for err in errlist:
            print(f"  - {err}")
    else:
        print("errlist: (empty — no connection errors reported)")

    accounts = data.get("accounts") or []
    print(f"\naccounts: {len(accounts)}")
    if args.days:
        print(f"transaction window: last {args.days} days")

    for account in accounts:
        name = account.get("name", "?")
        balance = account.get("balance")
        balance_date = ts(account.get("balance-date"))
        txns = account.get("transactions") or []
        print(f"\n  {name}")
        print(f"    balance: {balance}  (as of {balance_date})")
        print(f"    transactions: {len(txns)}")
        if txns:
            posted = [t.get("posted") for t in txns if t.get("posted")]
            if posted:
                print(f"    txn dates: {ts(min(posted))} .. {ts(max(posted))}")
            latest = txns[0]
            desc = (latest.get("description") or "")[:60]
            print(f"    latest: {ts(latest.get('posted'))} | {latest.get('amount')} | {desc}")

    if not accounts:
        print("\nNo accounts returned.", file=sys.stderr)
        raise SystemExit(1)


if __name__ == "__main__":
    main()
