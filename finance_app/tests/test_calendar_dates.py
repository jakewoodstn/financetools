from datetime import date, datetime, timezone

import pytest

from app.services.calendar_dates import (
    instant_to_calendar_date,
    local_today,
    parse_calendar_date,
)


def test_parse_calendar_date_accepts_plain_iso_date():
    assert parse_calendar_date("2025-01-23") == date(2025, 1, 23)


def test_parse_calendar_date_rejects_datetimes():
    for value in (
        "2025-01-23T00:00:00Z",
        "2025-01-23T06:00:00-06:00",
        "2025-01-23 00:00:00",
        "01/23/2025",
    ):
        with pytest.raises(ValueError):
            parse_calendar_date(value)


def test_instant_to_calendar_date_uses_app_timezone():
    # 2025-01-23 05:30 UTC == 2025-01-22 23:30 America/Chicago
    late_evening_central = datetime(2025, 1, 23, 5, 30, tzinfo=timezone.utc)
    assert instant_to_calendar_date(late_evening_central) == date(2025, 1, 22)

    # 2025-01-23 06:00 UTC == 2025-01-23 00:00 America/Chicago
    start_of_day_central = datetime(2025, 1, 23, 6, 0, tzinfo=timezone.utc)
    assert instant_to_calendar_date(start_of_day_central) == date(2025, 1, 23)


def test_local_today_is_a_date():
    assert isinstance(local_today(), date)
