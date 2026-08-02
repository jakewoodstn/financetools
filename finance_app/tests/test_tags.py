from datetime import date
from unittest.mock import MagicMock

from app.services import transactions as txn_service
from app.services.transactions import autocomplete_tags, get_or_create_tag, list_tags


def test_autocomplete_tags_requires_query(monkeypatch):
    monkeypatch.setattr(txn_service, "local_today", lambda: date(2026, 8, 2))
    db = MagicMock()
    assert autocomplete_tags(db, "") == []
    assert autocomplete_tags(db, "   ") == []
    db.execute.assert_not_called()


def test_autocomplete_tags_filters_active(monkeypatch):
    monkeypatch.setattr(txn_service, "local_today", lambda: date(2026, 8, 2))
    db = MagicMock()
    db.execute.return_value.all.return_value = [
        MagicMock(id=10, tag="DateNight"),
        MagicMock(id=11, tag="Date"),
    ]
    rows = autocomplete_tags(db, "date")
    assert [r.tag for r in rows] == ["DateNight", "Date"]
    sql = str(db.execute.call_args[0][0].compile(compile_kwargs={"literal_binds": True})).lower()
    assert "%date%" in sql
    assert "2026-08-02" in sql


def test_get_or_create_tag_reuses_case_insensitive(monkeypatch):
    monkeypatch.setattr(txn_service, "local_today", lambda: date(2026, 8, 2))
    existing = MagicMock()
    existing.tag = "Vacation"
    existing.retired_date = date(9999, 12, 31)
    db = MagicMock()
    db.scalar.return_value = existing

    tag = get_or_create_tag(db, "vacation")
    assert tag is existing
    db.add.assert_not_called()


def test_list_tags_still_loads(monkeypatch):
    monkeypatch.setattr(txn_service, "local_today", lambda: date(2026, 8, 2))
    db = MagicMock()
    db.execute.return_value.all.return_value = [MagicMock(id=1, tag="Core")]
    assert list_tags(db)[0].tag == "Core"
