"""Normalize bank payee text into a stable fingerprint for alias / history match.

Fuzziness lives in normalization only — matching is exact on the fingerprint
(or a unique short token-prefix fallback).
"""

from __future__ import annotations

import re

# Leading channel / entry-type noise (whole tokens).
_PREFIX_TOKENS = {
    "CHECKCARD",
    "CHKCARD",
    "POS",
    "ACH",
    "DEBIT",
    "CREDIT",
    "PURCHASE",
    "RECURRING",
    "RECURRINGPAYMENT",
    "PAYMENT",
    "WITHDRAWAL",
    "DEPOSIT",
    "TRANSFER",
    "VISA",
    "MC",
    "MASTERCARD",
    "PENDING",
}

# Date-like and card-mask patterns removed before tokenization.
_DATE_RE = re.compile(
    r"""
    \b\d{1,2}[/-]\d{1,2}(?:[/-]\d{2,4})?\b  # 07/08 or 07/08/26
    |\b\d{4}-\d{2}-\d{2}\b                   # 2026-07-08
    """,
    re.VERBOSE,
)
_CARD_MASK_RE = re.compile(r"\*{2,}\d{2,4}|\bX{2,}\d{2,4}\b", re.IGNORECASE)
# Long digit runs: auth / ref / txn ids (keep short nums like store #12 via len).
_LONG_DIGITS_RE = re.compile(r"\b\d{5,}\b")
_DIGIT_SEP_RE = re.compile(r"\b\d{3,}[- ]\d{2,}\b")
# Trailing US state / ZIP (and optional single city token before state).
_TRAILING_LOC_RE = re.compile(
    r"""
    (?:\s+[A-Z][A-Z.'-]{1,20})?   # optional one city-like word
    \s+[A-Z]{2}                   # state
    (?:\s+\d{5}(?:-\d{4})?)?      # zip
    \s*$
    """,
    re.VERBOSE,
)
_NON_ALNUM_RE = re.compile(r"[^A-Z0-9]+")
_SPACE_RE = re.compile(r"\s+")


def normalize_payee_text(raw: str | None) -> str:
    """Uppercase, strip masks/dates/ids/location stubs, collapse whitespace."""
    if not raw:
        return ""
    text = str(raw).upper().strip()
    if not text:
        return ""
    text = _CARD_MASK_RE.sub(" ", text)
    text = _DATE_RE.sub(" ", text)
    text = _DIGIT_SEP_RE.sub(" ", text)
    text = _LONG_DIGITS_RE.sub(" ", text)
    text = _TRAILING_LOC_RE.sub(" ", text)
    text = _NON_ALNUM_RE.sub(" ", text)
    text = _SPACE_RE.sub(" ", text).strip()
    return text


def fingerprint_tokens(raw: str | None) -> list[str]:
    """Significant tokens used for fingerprinting (prefixes stripped)."""
    text = normalize_payee_text(raw)
    if not text:
        return []
    tokens = [t for t in text.split(" ") if t and t not in _PREFIX_TOKENS]
    # Drop pure numeric leftovers (store #s, short refs) after noise strip.
    return [t for t in tokens if not t.isdigit()]


def payee_fingerprint(raw: str | None) -> str:
    """Stable merchant fingerprint — exact-match key after noise removal."""
    return " ".join(fingerprint_tokens(raw))


def payee_prefix_key(raw: str | None, *, n: int = 3) -> str:
    """First N significant tokens; used only when uniquely mapped in history."""
    tokens = fingerprint_tokens(raw)
    if not tokens:
        return ""
    return " ".join(tokens[:n])
