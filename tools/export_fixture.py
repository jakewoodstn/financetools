#!/usr/bin/env python3
"""Export current Postgres migration data as a CI fixture."""

from __future__ import annotations

import argparse
import os
import subprocess
from pathlib import Path

from migration_lib import DEFAULT_PG_DSN

FIXTURE_TABLES = [
    "accounts",
    "transaction_accounts",
    "spending_category_groups",
    "spending_categories",
    "bank_transactions",
    "category_split_details",
    "tagged_events",
    "transaction_tagged_events",
    "payees",
    "payee_aliases",
    "category_rules",
]


def parse_dsn(dsn: str) -> dict[str, str]:
    # postgresql://user:pass@host:port/db
    from urllib.parse import urlparse

    parsed = urlparse(dsn)
    return {
        "host": parsed.hostname or "localhost",
        "port": str(parsed.port or 5432),
        "user": parsed.username or "finance",
        "password": parsed.password or "finance",
        "dbname": parsed.path.lstrip("/") or "finances",
    }


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--pg-dsn", default=os.environ.get("PG_DSN", DEFAULT_PG_DSN))
    parser.add_argument(
        "--output-dir",
        default="tools/fixtures/sample",
        help="Directory for data.sql (default: tools/fixtures/sample)",
    )
    parser.add_argument(
        "--via-docker",
        action="store_true",
        help="Run pg_dump inside finance_app docker compose db container",
    )
    args = parser.parse_args()

    cfg = parse_dsn(args.pg_dsn)
    out_dir = Path(args.output_dir)
    out_dir.mkdir(parents=True, exist_ok=True)
    sql_path = out_dir / "data.sql"

    table_args = [f"--table={table}" for table in FIXTURE_TABLES]
    env = os.environ.copy()
    env["PGPASSWORD"] = cfg["password"]

    if args.via_docker:
        compose_file = Path(__file__).resolve().parent.parent / "finance_app" / "docker-compose.yml"
        cmd = [
            "docker",
            "compose",
            "-f",
            str(compose_file),
            "exec",
            "-T",
            "db",
            "pg_dump",
            "-U",
            cfg["user"],
            "-d",
            cfg["dbname"],
            "--data-only",
            "--no-owner",
            "--no-privileges",
            *table_args,
        ]
    else:
        cmd = [
            "pg_dump",
            "-h",
            cfg["host"],
            "-p",
            cfg["port"],
            "-U",
            cfg["user"],
            "-d",
            cfg["dbname"],
            "--data-only",
            "--no-owner",
            "--no-privileges",
            *table_args,
        ]

    print("Running:", " ".join(cmd))
    result = subprocess.run(cmd, capture_output=True, text=True, env=env, check=False)
    if result.returncode != 0:
        raise SystemExit(result.stderr or result.stdout)

    sql_path.write_text(result.stdout)
    print(f"Wrote {sql_path} ({sql_path.stat().st_size} bytes)")


if __name__ == "__main__":
    main()
