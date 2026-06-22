#!/usr/bin/env python3
"""Bulk-export SQL Server schema from RDS (or any MSSQL instance) without SSMS.

Exports stored procedures, views, functions, triggers, and table DDL by querying
catalog views. Output uses Redgate-style layout: {database}/{object type}/{schema}.{name}.sql

Setup (once):
    cd tools && uv sync

    export MSSQL_HOST=your-rds.region.rds.amazonaws.com
    export MSSQL_USER=webuser
    export MSSQL_PASSWORD=...

Run once per database:

    uv run dump-mssql-schema --database Finances
    uv run dump-mssql-schema --database financeReporting

    # Procs/views/functions only (skip table DDL):
    uv run dump-mssql-schema --database Finances --skip-tables
"""

from __future__ import annotations

import argparse
import json
import os
import re
import sys
from dataclasses import dataclass
from datetime import datetime, timezone
from pathlib import Path

MODULE_TYPES = ("SQL_STORED_PROCEDURE", "VIEW", "SQL_INLINE_TABLE_VALUED_FUNCTION",
                "SQL_TABLE_VALUED_FUNCTION", "SQL_SCALAR_FUNCTION", "SQL_TRIGGER")

# Redgate SQL Source Control-style folder names
REDGATE_TYPE_FOLDERS = {
    "SQL_STORED_PROCEDURE": "Stored Procedures",
    "VIEW": "Views",
    "SQL_SCALAR_FUNCTION": "Functions",
    "SQL_INLINE_TABLE_VALUED_FUNCTION": "Functions",
    "SQL_TABLE_VALUED_FUNCTION": "Functions",
    "SQL_TRIGGER": "Triggers",
}
TABLES_FOLDER = "Tables"

MODULE_QUERY = """
SELECT
    s.name AS schema_name,
    o.name AS object_name,
    o.type_desc,
    m.definition,
    o.create_date,
    o.modify_date
FROM sys.sql_modules AS m
INNER JOIN sys.objects AS o ON m.object_id = o.object_id
INNER JOIN sys.schemas AS s ON o.schema_id = s.schema_id
WHERE o.type_desc IN ({type_placeholders})
  AND o.is_ms_shipped = 0
ORDER BY s.name, o.type_desc, o.name
"""

TABLE_LIST_QUERY = """
SELECT s.name AS schema_name, t.name AS table_name
FROM sys.tables AS t
INNER JOIN sys.schemas AS s ON t.schema_id = s.schema_id
WHERE t.is_ms_shipped = 0
ORDER BY s.name, t.name
"""

COLUMN_QUERY = """
SELECT
    s.name AS schema_name,
    t.name AS table_name,
    c.name AS column_name,
    ty.name AS type_name,
    c.max_length,
    c.precision,
    c.scale,
    c.is_nullable,
    c.is_identity,
    ic.seed_value,
    ic.increment_value,
    dc.definition AS default_definition,
    c.column_id
FROM sys.tables AS t
INNER JOIN sys.schemas AS s ON t.schema_id = s.schema_id
INNER JOIN sys.columns AS c ON t.object_id = c.object_id
INNER JOIN sys.types AS ty ON c.user_type_id = ty.user_type_id
LEFT JOIN sys.identity_columns AS ic ON c.object_id = ic.object_id AND c.column_id = ic.column_id
LEFT JOIN sys.default_constraints AS dc ON c.default_object_id = dc.object_id
WHERE t.is_ms_shipped = 0
ORDER BY s.name, t.name, c.column_id
"""

PK_QUERY = """
SELECT
    s.name AS schema_name,
    t.name AS table_name,
    i.name AS index_name,
    c.name AS column_name,
    ic.key_ordinal
FROM sys.indexes AS i
INNER JOIN sys.tables AS t ON i.object_id = t.object_id
INNER JOIN sys.schemas AS s ON t.schema_id = s.schema_id
INNER JOIN sys.index_columns AS ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
INNER JOIN sys.columns AS c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
WHERE i.is_primary_key = 1
  AND t.is_ms_shipped = 0
ORDER BY s.name, t.name, ic.key_ordinal
"""

FK_QUERY = """
SELECT
    fk_s.name AS schema_name,
    fk_t.name AS table_name,
    fk.name AS fk_name,
    col_s.name AS column_name,
    ref_s.name AS ref_schema_name,
    ref_t.name AS ref_table_name,
    ref_col.name AS ref_column_name,
    fkc.constraint_column_id
FROM sys.foreign_keys AS fk
INNER JOIN sys.foreign_key_columns AS fkc ON fk.object_id = fkc.constraint_object_id
INNER JOIN sys.tables AS fk_t ON fkc.parent_object_id = fk_t.object_id
INNER JOIN sys.schemas AS fk_s ON fk_t.schema_id = fk_s.schema_id
INNER JOIN sys.columns AS col_s ON fkc.parent_object_id = col_s.object_id
    AND fkc.parent_column_id = col_s.column_id
INNER JOIN sys.tables AS ref_t ON fkc.referenced_object_id = ref_t.object_id
INNER JOIN sys.schemas AS ref_s ON ref_t.schema_id = ref_s.schema_id
INNER JOIN sys.columns AS ref_col ON fkc.referenced_object_id = ref_col.object_id
    AND fkc.referenced_column_id = ref_col.column_id
WHERE fk_t.is_ms_shipped = 0
ORDER BY fk_s.name, fk_t.name, fk.name, fkc.constraint_column_id
"""

INVENTORY_QUERY = """
SELECT type_desc, COUNT(*) AS object_count
FROM sys.objects
WHERE is_ms_shipped = 0
GROUP BY type_desc
ORDER BY type_desc
"""


@dataclass
class ExportStats:
    modules_written: int = 0
    modules_skipped: int = 0
    tables_written: int = 0
    errors: list[str] | None = None

    def __post_init__(self) -> None:
        if self.errors is None:
            self.errors = []


def env(name: str, default: str | None = None) -> str:
    value = os.environ.get(name, default)
    if not value:
        raise SystemExit(f"Missing required environment variable: {name}")
    return value


def safe_filename(name: str) -> str:
    return re.sub(r"[^\w.\-]", "_", name)


def object_filename(schema_name: str, object_name: str) -> str:
    return f"{safe_filename(schema_name)}.{safe_filename(object_name)}.sql"


def redgate_type_folder(type_desc: str) -> str:
    try:
        return REDGATE_TYPE_FOLDERS[type_desc]
    except KeyError:
        raise ValueError(f"No Redgate folder mapping for object type: {type_desc}")


def connect(database: str):
    import pymssql

    return pymssql.connect(
        server=env("MSSQL_HOST"),
        user=env("MSSQL_USER"),
        password=env("MSSQL_PASSWORD"),
        database=database,
    )


def write_text(path: Path, content: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content, encoding="utf-8")


def format_column_type(row: dict) -> str:
    type_name = row["type_name"].lower()
    if type_name in ("varchar", "char", "varbinary", "binary"):
        length = row["max_length"]
        if length == -1:
            size = "max"
        elif type_name in ("varchar", "char") and length > 0:
            size = str(length)
        else:
            size = str(length)
        return f"{type_name}({size})"
    if type_name in ("nvarchar", "nchar"):
        length = row["max_length"]
        if length == -1:
            size = "max"
        else:
            size = str(length // 2)
        return f"{type_name}({size})"
    if type_name in ("decimal", "numeric"):
        return f"{type_name}({row['precision']}, {row['scale']})"
    return type_name


def build_table_ddl(
    schema_name: str,
    table_name: str,
    columns: list[dict],
    pk_columns: list[str],
    fk_groups: dict[str, list[dict]],
) -> str:
    lines = [f"CREATE TABLE [{schema_name}].[{table_name}] ("]
    col_lines: list[str] = []
    for col in columns:
        parts = [f"    [{col['column_name']}] {format_column_type(col)}"]
        if col["is_identity"]:
            seed = col.get("seed_value") or 1
            increment = col.get("increment_value") or 1
            parts.append(f"IDENTITY({seed},{increment})")
        col_line = " ".join(parts)
        if not col["is_nullable"]:
            col_line += " NOT NULL"
        if col["default_definition"]:
            col_line += f" DEFAULT {col['default_definition']}"
        col_lines.append(col_line)
    if pk_columns:
        pk = ", ".join(f"[{c}]" for c in pk_columns)
        col_lines.append(f"    CONSTRAINT [PK_{table_name}] PRIMARY KEY ({pk})")
    lines.append(",\n".join(col_lines))
    lines.append(");")
    lines.append("")

    for fk_name, fk_cols in fk_groups.items():
        local_cols = ", ".join(f"[{c['column_name']}]" for c in fk_cols)
        ref_schema = fk_cols[0]["ref_schema_name"]
        ref_table = fk_cols[0]["ref_table_name"]
        ref_cols = ", ".join(f"[{c['ref_column_name']}]" for c in fk_cols)
        lines.append(
            f"ALTER TABLE [{schema_name}].[{table_name}] ADD CONSTRAINT [{fk_name}] "
            f"FOREIGN KEY ({local_cols}) REFERENCES [{ref_schema}].[{ref_table}] ({ref_cols});"
        )
    return "\n".join(lines) + "\n"


def fetchall_dict(cursor) -> list[dict]:
    rows = cursor.fetchall()
    if not rows:
        return []
    if isinstance(rows[0], dict):
        return rows
    columns = [desc[0] for desc in cursor.description]
    return [dict(zip(columns, row)) for row in rows]


def export_modules(conn, output_dir: Path, stats: ExportStats) -> None:
    placeholders = ", ".join("%s" for _ in MODULE_TYPES)
    query = MODULE_QUERY.format(type_placeholders=placeholders)
    cursor = conn.cursor(as_dict=True)
    cursor.execute(query, MODULE_TYPES)

    for row in cursor:
        schema_name = row["schema_name"]
        object_name = row["object_name"]
        type_desc = row["type_desc"]
        definition = row["definition"]

        rel_path = Path(redgate_type_folder(type_desc)) / object_filename(schema_name, object_name)
        out_path = output_dir / rel_path

        header = (
            f"-- Exported: {datetime.now(timezone.utc).isoformat()}\n"
            f"-- Schema:   {schema_name}\n"
            f"-- Object:   {object_name}\n"
            f"-- Type:     {type_desc}\n"
            f"-- Created:  {row['create_date']}\n"
            f"-- Modified: {row['modify_date']}\n\n"
        )

        if not definition:
            stats.modules_skipped += 1
            write_text(
                out_path,
                header + "-- WARNING: definition is NULL (object may be encrypted or not scriptable).\n",
            )
            continue

        write_text(out_path, header + definition.rstrip() + "\n")
        stats.modules_written += 1


def export_tables(conn, output_dir: Path, stats: ExportStats) -> None:
    cursor = conn.cursor(as_dict=True)

    cursor.execute(COLUMN_QUERY)
    all_columns = fetchall_dict(cursor)
    columns_by_table: dict[tuple[str, str], list[dict]] = {}
    for col in all_columns:
        key = (col["schema_name"], col["table_name"])
        columns_by_table.setdefault(key, []).append(col)

    cursor.execute(PK_QUERY)
    pk_by_table: dict[tuple[str, str], list[str]] = {}
    for pk in fetchall_dict(cursor):
        key = (pk["schema_name"], pk["table_name"])
        pk_by_table.setdefault(key, []).append(pk["column_name"])

    cursor.execute(FK_QUERY)
    fk_by_table: dict[tuple[str, str], dict[str, list[dict]]] = {}
    for fk in fetchall_dict(cursor):
        key = (fk["schema_name"], fk["table_name"])
        fk_by_table.setdefault(key, {}).setdefault(fk["fk_name"], []).append(fk)

    cursor.execute(TABLE_LIST_QUERY)
    for table in fetchall_dict(cursor):
        schema_name = table["schema_name"]
        table_name = table["table_name"]
        key = (schema_name, table_name)
        columns = columns_by_table.get(key, [])
        pk_columns = pk_by_table.get(key, [])
        fk_groups = fk_by_table.get(key, {})

        rel_path = Path(TABLES_FOLDER) / object_filename(schema_name, table_name)
        out_path = output_dir / rel_path
        ddl = build_table_ddl(schema_name, table_name, columns, pk_columns, fk_groups)
        header = (
            f"-- Exported: {datetime.now(timezone.utc).isoformat()}\n"
            f"-- Schema:   {schema_name}\n"
            f"-- Table:    {table_name}\n\n"
        )
        write_text(out_path, header + ddl)
        stats.tables_written += 1


def write_manifest(
    output_dir: Path,
    database: str,
    stats: ExportStats,
    inventory: list[dict],
) -> None:
    manifest = {
        "database": database,
        "exported_at": datetime.now(timezone.utc).isoformat(),
        "host": env("MSSQL_HOST"),
        "modules_written": stats.modules_written,
        "modules_skipped": stats.modules_skipped,
        "tables_written": stats.tables_written,
        "inventory": inventory,
        "errors": stats.errors,
    }
    write_text(output_dir / "_manifest.json", json.dumps(manifest, indent=2, default=str) + "\n")


def export_database(database: str, output_root: Path, skip_tables: bool) -> ExportStats:
    stats = ExportStats()
    output_dir = output_root / database
    output_dir.mkdir(parents=True, exist_ok=True)

    print(f"Connecting to {env('MSSQL_HOST')} / {database} ...")
    conn = connect(database)
    try:
        cursor = conn.cursor(as_dict=True)
        cursor.execute(INVENTORY_QUERY)
        inventory = fetchall_dict(cursor)
        print("Object inventory:")
        for row in inventory:
            print(f"  {row['type_desc']}: {row['object_count']}")

        print("Exporting modules (procs, views, functions, triggers) ...")
        export_modules(conn, output_dir, stats)

        if skip_tables:
            print("Skipping table DDL (--skip-tables).")
        else:
            print("Exporting table DDL ...")
            export_tables(conn, output_dir, stats)

        write_manifest(output_dir, database, stats, inventory)
    finally:
        conn.close()

    return stats


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Export SQL Server schema objects to sql files (no SSMS required).",
        epilog=(
            "Run once per database, e.g. --database Finances and --database "
            "financeReporting. Add --skip-tables to omit table DDL."
        ),
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    parser.add_argument(
        "--database",
        required=True,
        help="Database to export (e.g. Finances, financeReporting)",
    )
    parser.add_argument(
        "--output-dir",
        type=Path,
        default=Path("sql_export"),
        help="Output root directory (default: ./sql_export)",
    )
    parser.add_argument(
        "--skip-tables",
        action="store_true",
        help="Export only modules; skip CREATE TABLE generation",
    )
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    stats = export_database(args.database, args.output_dir, args.skip_tables)

    print()
    print(f"Done. Output: {args.output_dir / args.database}")
    print(f"  Modules written: {stats.modules_written}")
    print(f"  Modules skipped: {stats.modules_skipped} (null definition)")
    print(f"  Tables written:  {stats.tables_written}")
    if stats.errors:
        print("Errors:")
        for err in stats.errors:
            print(f"  - {err}")
        sys.exit(1)


if __name__ == "__main__":
    main()
