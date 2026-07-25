from datetime import date, datetime, timezone
from decimal import Decimal

from app.services.simplefin import parse_accounts


def test_parse_accounts_keeps_balance_instant_and_local_day():
    # 2026-07-19 02:36 UTC == 2026-07-18 21:36 America/Chicago
    payload = {
        "accounts": [
            {
                "id": "acct-1",
                "name": "Checking",
                "balance": "32902.92",
                "balance-date": 1784428560,  # 2026-07-19T02:36:00Z
                "transactions": [],
            }
        ]
    }
    account = parse_accounts(payload)[0]
    assert account.balance == Decimal("32902.92")
    assert account.balance_at == datetime.fromtimestamp(1784428560, tz=timezone.utc)
    assert account.balance_at.tzinfo is not None
    assert account.balance_date == date(2026, 7, 18)


def test_parse_accounts_handles_missing_balance_date():
    payload = {
        "accounts": [
            {"id": "a", "name": "X", "balance": "1.00", "transactions": []}
        ]
    }
    account = parse_accounts(payload)[0]
    assert account.balance_at is None
    assert account.balance_date is None
