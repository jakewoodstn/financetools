from datetime import date
from unittest.mock import MagicMock

from app.services import transactions as txn_service
from app.services.transactions import autocomplete_tags, detach_tag, get_or_create_tag, list_tags


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


def test_detach_tag_deletes_links_and_keeps_tag(monkeypatch):
    tag = MagicMock()
    tag.id = 7
    tag.tag = "Vacation"
    txn = MagicMock()
    txn.id = 42
    link = MagicMock()
    db = MagicMock()
    db.scalar.return_value = tag
    db.scalars.return_value.all.side_effect = [[txn], [link]]

    removed, found = detach_tag(db, external_ids=[1001], tag_name="vacation", commit=True)

    assert removed == 1
    assert found is tag
    db.delete.assert_called_once_with(link)
    db.commit.assert_called_once()


def test_detach_tag_missing_name_is_noop():
    db = MagicMock()
    assert detach_tag(db, external_ids=[1], tag_name="  ") == (0, None)
    db.scalar.assert_not_called()


def test_list_tags_still_loads(monkeypatch):
    monkeypatch.setattr(txn_service, "local_today", lambda: date(2026, 8, 2))
    db = MagicMock()
    db.execute.return_value.all.return_value = [MagicMock(id=1, tag="Core")]
    assert list_tags(db)[0].tag == "Core"
