from __future__ import annotations

import json
import os
from pathlib import Path

import pytest

from migration_lib import DEFAULT_PG_DSN, connect_pg
from validate_migration import validate_against_manifest

FIXTURE_DIR = Path(__file__).resolve().parent.parent / "fixtures" / "sample"
MANIFEST_PATH = FIXTURE_DIR / "manifest.json"
DATA_SQL_PATH = FIXTURE_DIR / "data.sql"


@pytest.fixture(scope="module")
def manifest() -> dict:
    if not MANIFEST_PATH.exists():
        pytest.skip(f"fixture manifest not found: {MANIFEST_PATH}")
    return json.loads(MANIFEST_PATH.read_text())


def test_fixture_files_exist():
    if not DATA_SQL_PATH.exists():
        pytest.skip(f"fixture SQL not found: {DATA_SQL_PATH}")
    assert MANIFEST_PATH.exists()


def test_migration_acceptance_against_fixture(manifest: dict):
    if not DATA_SQL_PATH.exists():
        pytest.skip(f"fixture SQL not found: {DATA_SQL_PATH}")

    pg = connect_pg(os.environ.get("PG_DSN", DEFAULT_PG_DSN))
    try:
        cur = pg.cursor()
        results = validate_against_manifest(cur, manifest)
    finally:
        pg.close()

    failures = [r for r in results if r.status == "FAIL"]
    if failures:
        lines = [f"{r.name}: source={r.source!r} target={r.target!r}" for r in failures[:10]]
        pytest.fail("Migration acceptance failures:\n" + "\n".join(lines))
