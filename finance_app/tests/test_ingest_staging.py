from datetime import date
from decimal import Decimal

from app.services.ingest_staging import dedupe_hash


def test_dedupe_hash_stable():
    h1 = dedupe_hash(1, date(2026, 7, 10), Decimal("-59.99"), "AMAZON")
    h2 = dedupe_hash(1, date(2026, 7, 10), Decimal("-59.99"), "AMAZON")
    assert h1 == h2
    assert len(h1) == 64


def test_dedupe_hash_differs_by_account():
    h1 = dedupe_hash(1, date(2026, 7, 10), Decimal("-59.99"), "AMAZON")
    h2 = dedupe_hash(2, date(2026, 7, 10), Decimal("-59.99"), "AMAZON")
    assert h1 != h2
