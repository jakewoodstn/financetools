from decimal import Decimal

from app.services.transactions import parse_amount


def test_parse_amount_plain():
    assert parse_amount("12.50") == Decimal("12.50")


def test_parse_amount_currency_and_parens():
    assert parse_amount("$1,234.56") == Decimal("1234.56")
    assert parse_amount("(59.99)") == Decimal("-59.99")


def test_parse_amount_empty():
    assert parse_amount("") is None
    assert parse_amount(None) is None
    assert parse_amount("abc") is None
