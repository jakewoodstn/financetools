from decimal import Decimal

from app.services.payee_normalize import (
    fingerprint_tokens,
    looks_like_clean_payee_name,
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


def test_looks_like_clean_payee_name():
    assert looks_like_clean_payee_name("AdhereHealth")
    assert looks_like_clean_payee_name("Amazon Marketplace")
    assert not looks_like_clean_payee_name(
        "ADHEREHEALTH SOL DES:PAYROLL ID:12V05 A0A50CJP1 INDN:WOODS, JAKE CO ID:XXXXX34033 PPD"
    )
    assert not looks_like_clean_payee_name(
        "Adherehealth Sol Des:payroll Id:12v05 A0a50cjp1 Indn:woods, Jake Co Id:xxxxxx4033 Ppd"
    )
    assert not looks_like_clean_payee_name("")
    assert not looks_like_clean_payee_name(None)
