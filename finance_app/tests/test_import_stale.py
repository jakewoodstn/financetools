from datetime import datetime, timedelta, timezone
from unittest.mock import MagicMock

from fastapi.testclient import TestClient

from app.database import SessionLocal
from app.main import app
from app.services.app_settings import (
    DEFAULT_IMPORT_STALE_DAYS,
    LAST_IMPORT_AT_KEY,
    get_import_stale_days,
    get_import_stale_status,
    get_last_import_at,
    set_import_stale_days,
    set_setting,
    touch_last_import_at,
)


def test_import_stale_when_never_imported():
    db = MagicMock()
    db.get.return_value = None
    status = get_import_stale_status(db)
    assert status.stale is True
    assert status.days_since_import is None
    assert status.threshold_days == DEFAULT_IMPORT_STALE_DAYS


def test_import_stale_after_threshold():
    db = SessionLocal()
    try:
        original_days = get_import_stale_days(db)
        original_last = get_setting_value(db, LAST_IMPORT_AT_KEY)
        set_import_stale_days(db, 3, commit=True)
        touch_last_import_at(db, datetime.now(timezone.utc) - timedelta(days=5), commit=True)
        status = get_import_stale_status(db)
        assert status.stale is True
        assert status.days_since_import is not None
        assert status.days_since_import >= 5
    finally:
        restore_setting(db, LAST_IMPORT_AT_KEY, original_last)
        set_import_stale_days(db, original_days, commit=True)
        db.close()


def test_import_not_stale_within_threshold():
    db = SessionLocal()
    try:
        original_days = get_import_stale_days(db)
        original_last = get_setting_value(db, LAST_IMPORT_AT_KEY)
        set_import_stale_days(db, 7, commit=True)
        touch_last_import_at(db, datetime.now(timezone.utc) - timedelta(hours=12), commit=True)
        status = get_import_stale_status(db)
        assert status.stale is False
        assert status.days_since_import is not None
        assert status.days_since_import <= 1
    finally:
        restore_setting(db, LAST_IMPORT_AT_KEY, original_last)
        set_import_stale_days(db, original_days, commit=True)
        db.close()


def test_settings_saves_import_stale_days_and_nav_shows_badge():
    db = SessionLocal()
    try:
        original_days = get_import_stale_days(db)
        original_last = get_setting_value(db, LAST_IMPORT_AT_KEY)
    finally:
        db.close()

    client = TestClient(app)
    try:
        # Force stale so the badge is visible.
        db = SessionLocal()
        try:
            set_import_stale_days(db, 2, commit=True)
            touch_last_import_at(db, datetime.now(timezone.utc) - timedelta(days=10), commit=True)
        finally:
            db.close()

        response = client.post(
            "/settings/import-alerts",
            data={"import_stale_days": "4"},
            follow_redirects=False,
        )
        assert response.status_code == 303
        assert "saved=import-alerts" in response.headers["location"]
        db = SessionLocal()
        try:
            assert get_import_stale_days(db) == 4
        finally:
            db.close()

        page = client.get("/transcat")
        assert page.status_code == 200
        assert "nav-badge" in page.text
        assert "Import" in page.text
    finally:
        db = SessionLocal()
        try:
            restore_setting(db, LAST_IMPORT_AT_KEY, original_last)
            set_import_stale_days(db, original_days, commit=True)
        finally:
            db.close()


def test_touch_last_import_at_round_trip():
    db = SessionLocal()
    try:
        original = get_setting_value(db, LAST_IMPORT_AT_KEY)
        stamp = datetime(2026, 8, 1, 15, 30, tzinfo=timezone.utc)
        touch_last_import_at(db, stamp, commit=True)
        loaded = get_last_import_at(db)
        assert loaded is not None
        assert loaded.astimezone(timezone.utc).replace(microsecond=0) == stamp
    finally:
        restore_setting(db, LAST_IMPORT_AT_KEY, original)
        db.close()


def get_setting_value(db, key: str) -> str | None:
    from app.models import AppSetting

    row = db.get(AppSetting, key)
    return row.value if row is not None else None


def restore_setting(db, key: str, value: str | None) -> None:
    from app.models import AppSetting

    row = db.get(AppSetting, key)
    if value is None:
        if row is not None:
            db.delete(row)
            db.commit()
        return
    set_setting(db, key, value, commit=True)
