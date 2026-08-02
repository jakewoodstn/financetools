from datetime import date
from decimal import Decimal
from unittest.mock import MagicMock

from app.services import transactions as txn_service
from app.services.transactions import list_tags, parse_amount


def test_parse_amount_plain():
    assert parse_amount("12.50") == Decimal("12.50")


def test_parse_amount_currency_and_parens():
    assert parse_amount("$1,234.56") == Decimal("1234.56")
    assert parse_amount("(59.99)") == Decimal("-59.99")


def test_parse_amount_empty():
    assert parse_amount("") is None
    assert parse_amount(None) is None
    assert parse_amount("abc") is None


def test_list_tags_treats_far_future_retired_date_as_active(monkeypatch):
    """Legacy rows use 9999-12-31 as not-retired; those must be queryable."""
    monkeypatch.setattr(txn_service, "local_today", lambda: date(2026, 8, 2))
    db = MagicMock()
    db.execute.return_value.all.return_value = [
        MagicMock(id=2287, tag="DateNight"),
    ]

    tags = list_tags(db)
    assert tags[0].tag_id == 2287
    assert tags[0].tag == "DateNight"

    stmt = db.execute.call_args[0][0]
    sql = str(stmt.compile(compile_kwargs={"literal_binds": True})).lower()
    assert "retired_date" in sql
    assert "2026-08-02" in sql
