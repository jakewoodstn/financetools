from app.services.payee_brands import match_brand
from app.services.payee_normalize import fingerprint_tokens


def test_amazon_checkcard_blob():
    raw = "CHECKCARD 07/08 AMAZON MKTPLACE AMZN.COM/BILL WA 9876543210"
    assert match_brand(raw) == "Amazon"


def test_shell_gas():
    assert match_brand("CHECKCARD SHELL OIL 12345 ANYTOWN TX") == "Shell"


def test_bp_exact_short_alias():
    assert match_brand("BP") == "BP"
    # Short alias must not match as a mere subsequence inside longer text.
    assert match_brand("CHECKCARD BP GAS AUSTIN TX") == "BP"  # via "BP GAS"
    assert match_brand("SOMETHING ELSE ENTIRELY") is None


def test_no_false_hit_on_unrelated():
    assert match_brand("ACH PAYROLL DES:PAYROLL INDN:JAKE") is None
    assert match_brand("ADHEREHEALTH LLC") is None


def test_longest_alias_wins():
    # Multi-token Costco Gas should beat single-token Costco when both fit.
    assert match_brand("COSTCO GAS #123 SEATTLE WA") == "Costco Gas"


def test_single_token_must_be_first():
    # Avoid AMERICAN EXPRESS → clothing Express.
    assert match_brand("AMERICAN EXPRESS PAYMENT") is None
    assert match_brand("EXPRESS STORE #42") == "Express"


def test_mcdonalds_aliases():
    assert match_brand("POS MCDONALDS F12345") == "McDonald's"
    assert match_brand("MCD #4421") == "McDonald's"


def test_fingerprint_tokens_stable_for_brands():
    assert fingerprint_tokens("WM SUPERCENTER #1234")[0:2] == ["WM", "SUPERCENTER"]
    assert match_brand("CHECKCARD WM SUPERCENTER #1234") == "Walmart"
