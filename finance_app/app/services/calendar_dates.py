"""Calendar-date helpers: never route business dates through UTC midnights."""

from __future__ import annotations

import re
from datetime import date, datetime, timezone
from zoneinfo import ZoneInfo

from app.config import settings

_CALENDAR_DATE = re.compile(r"^\d{4}-\d{2}-\d{2}$")


def app_zone() -> ZoneInfo:
    return ZoneInfo(settings.app_timezone)


def local_today() -> date:
    """Today's calendar date in the app timezone."""
    return datetime.now(app_zone()).date()


def instant_to_calendar_date(instant: datetime) -> date:
    """Convert a UTC (or naive-as-UTC) instant to the app-local calendar day."""
    if instant.tzinfo is None:
        instant = instant.replace(tzinfo=timezone.utc)
    return instant.astimezone(app_zone()).date()


def parse_calendar_date(value: str) -> date:
    """Parse a business date. Only plain YYYY-MM-DD is accepted."""
    text = (value or "").strip()
    if not _CALENDAR_DATE.fullmatch(text):
        raise ValueError("Date must be YYYY-MM-DD with no time or timezone")
    return date.fromisoformat(text)
