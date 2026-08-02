"""Key-value app settings helpers (UI prefs, import freshness)."""

from __future__ import annotations

from dataclasses import dataclass
from datetime import datetime, timezone

from sqlalchemy import func, select
from sqlalchemy.orm import Session

from app.models import AppSetting, ImportBatch
from app.services.calendar_dates import instant_to_calendar_date, local_today

IMPORT_STALE_DAYS_KEY = "import_stale_days"
LAST_IMPORT_AT_KEY = "last_import_at"
DEFAULT_IMPORT_STALE_DAYS = 3


def get_setting(db: Session, key: str) -> str | None:
    row = db.get(AppSetting, key)
    return row.value if row is not None else None


def set_setting(db: Session, key: str, value: str, *, commit: bool = False) -> None:
    row = db.get(AppSetting, key)
    if row is None:
        db.add(AppSetting(key=key, value=value))
    else:
        row.value = value
    if commit:
        db.commit()


def get_import_stale_days(db: Session) -> int:
    raw = get_setting(db, IMPORT_STALE_DAYS_KEY)
    if raw is None:
        return DEFAULT_IMPORT_STALE_DAYS
    try:
        days = int(raw)
    except ValueError:
        return DEFAULT_IMPORT_STALE_DAYS
    return max(1, min(days, 3650))


def set_import_stale_days(db: Session, days: int, *, commit: bool = False) -> int:
    value = max(1, min(int(days), 3650))
    set_setting(db, IMPORT_STALE_DAYS_KEY, str(value), commit=commit)
    return value


def get_last_import_at(db: Session) -> datetime | None:
    raw = get_setting(db, LAST_IMPORT_AT_KEY)
    if not raw:
        return None
    try:
        # Stored as ISO-8601; tolerate trailing Z.
        text = raw.replace("Z", "+00:00")
        value = datetime.fromisoformat(text)
    except ValueError:
        return None
    if value.tzinfo is None:
        value = value.replace(tzinfo=timezone.utc)
    return value


def touch_last_import_at(
    db: Session,
    when: datetime | None = None,
    *,
    commit: bool = False,
) -> datetime:
    stamp = when or datetime.now(timezone.utc)
    if stamp.tzinfo is None:
        stamp = stamp.replace(tzinfo=timezone.utc)
    set_setting(db, LAST_IMPORT_AT_KEY, stamp.astimezone(timezone.utc).isoformat(), commit=commit)
    return stamp


def backfill_last_import_at_from_batches(db: Session, *, commit: bool = False) -> datetime | None:
    """Seed last_import_at from the newest import batch when unset."""
    if get_last_import_at(db) is not None:
        return get_last_import_at(db)
    latest = db.scalar(select(func.max(ImportBatch.imported_at)))
    if latest is None:
        return None
    if latest.tzinfo is None:
        latest = latest.replace(tzinfo=timezone.utc)
    touch_last_import_at(db, latest, commit=commit)
    return latest


@dataclass(frozen=True)
class ImportStaleStatus:
    stale: bool
    threshold_days: int
    days_since_import: int | None
    last_import_at: datetime | None


def get_import_stale_status(db: Session) -> ImportStaleStatus:
    threshold = get_import_stale_days(db)
    last_at = get_last_import_at(db)
    if last_at is None:
        # No known import yet — treat as stale so the badge prompts first import.
        return ImportStaleStatus(
            stale=True,
            threshold_days=threshold,
            days_since_import=None,
            last_import_at=None,
        )
    last_day = instant_to_calendar_date(last_at)
    days_since = (local_today() - last_day).days
    return ImportStaleStatus(
        stale=days_since >= threshold,
        threshold_days=threshold,
        days_since_import=max(0, days_since),
        last_import_at=last_at,
    )


def import_status_context(db: Session) -> dict:
    status = get_import_stale_status(db)
    title = None
    if status.stale:
        if status.days_since_import is None:
            title = f"No imports recorded yet (alert after {status.threshold_days} days)"
        else:
            title = (
                f"Last import {status.days_since_import} day"
                f"{'' if status.days_since_import == 1 else 's'} ago "
                f"(alert after {status.threshold_days})"
            )
    return {
        "import_stale": status.stale,
        "import_stale_days": status.threshold_days,
        "import_days_since": status.days_since_import,
        "last_import_at": status.last_import_at,
        "import_stale_title": title,
    }
