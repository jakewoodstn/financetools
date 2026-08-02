from decimal import Decimal

from app.services.payee_normalize import (
    fingerprint_tokens,
    normalize_payee_text,
    payee_fingerprint,
    payee_prefix_key,
)


def test_strips_checkcard_dates_and_ids():
    raw = "CHECKCARD 07/08 AMAZON MKTPLACE 1234567890 SEATTLE WA"
    assert payee_fingerprint(raw) == "AMAZON MKTPLACE"


def test_strips_card_mask_and_digit_runs():
    raw = "POS SHELL OIL ****1234 REF 99887766"
    fp = payee_fingerprint(raw)
    assert "SHELL" in fp
    assert "OIL" in fp
    assert "1234" not in fp
    assert "99887766" not in fp


def test_normalize_collapses_noise():
    assert normalize_payee_text("  amazon   marketplace  ") == "AMAZON MARKETPLACE"


def test_prefix_key():
    raw = "ACH COSTCO WHSE #1234 AUSTIN TX"
    # long digits / store nums stripped; COSTCO WHSE remain
    tokens = fingerprint_tokens(raw)
    assert tokens[0] == "COSTCO"
    assert payee_prefix_key(raw, n=2) == " ".join(tokens[:2])


def test_empty():
    assert payee_fingerprint(None) == ""
    assert payee_fingerprint("   ") == ""
    assert payee_prefix_key("") == ""
