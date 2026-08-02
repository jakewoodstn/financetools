from __future__ import annotations

from collections import Counter
from dataclasses import dataclass

from sqlalchemy import func, select
from sqlalchemy.orm import Session

from app.models import BankTransaction, Payee, PayeeAlias
from app.services.payee_brands import match_brand
from app.services.payee_normalize import (
    looks_like_clean_payee_name,
    payee_fingerprint,
    payee_prefix_key,
)

SOURCE_USER = "user"
SOURCE_FINGERPRINT = "fingerprint"
SOURCE_IMPORT = "import"
HISTORY_SCAN_LIMIT = 800
AUTOCOMPLETE_LIMIT = 20


@dataclass(frozen=True)
class PayeeSuggestion:
    canonical_name: str
    observation_count: int
    source: str  # alias | fingerprint | prefix | brand


@dataclass(frozen=True)
class PayeeOut:
    id: int
    canonical_name: str


def bank_text_for_transaction(txn: BankTransaction) -> str:
    for value in (txn.bank_orig_description, txn.orig_description, txn.description):
        if value and str(value).strip():
            return str(value).strip()
    return ""


def suggest_payee(db: Session, txn: BankTransaction) -> PayeeSuggestion | None:
    """On-demand suggest: alias, fingerprint/prefix history, then brand list."""
    raw = bank_text_for_transaction(txn)
    if not raw:
        return None

    alias_hit = _suggest_from_aliases(db, raw)
    if alias_hit:
        return alias_hit

    if txn.payee_id:
        payee = db.get(Payee, txn.payee_id)
        if payee and looks_like_clean_payee_name(payee.canonical_name):
            return PayeeSuggestion(payee.canonical_name, 1, "alias")

    history_hit = _suggest_from_history(db, raw)
    if history_hit:
        return history_hit

    brand_name = match_brand(raw)
    if brand_name:
        return PayeeSuggestion(brand_name, 0, "brand")
    return None


def _suggest_from_aliases(db: Session, raw: str) -> PayeeSuggestion | None:
    fp = payee_fingerprint(raw)
    keys = {raw.strip(), raw.strip().upper(), fp}
    keys = {k for k in keys if k}
    if not keys:
        return None

    lowered = {k.lower() for k in keys}
    rows = db.execute(
        select(Payee.canonical_name, PayeeAlias.raw_text, Payee.id)
        .join(Payee, PayeeAlias.payee_id == Payee.id)
        .where(func.lower(PayeeAlias.raw_text).in_(lowered))
    ).all()

    clean_exact = [
        name for name, _, _ in rows if looks_like_clean_payee_name(name)
    ]
    if clean_exact:
        name, count = Counter(clean_exact).most_common(1)[0]
        return PayeeSuggestion(name, count, "alias")

    if fp:
        # Fingerprint-match aliases whose stored raw fingerprints equal ours.
        # Narrow with first significant token, then exact-compare in Python.
        token = fp.split(" ", 1)[0]
        candidates = db.execute(
            select(Payee.canonical_name, PayeeAlias.raw_text)
            .join(Payee, PayeeAlias.payee_id == Payee.id)
            .where(PayeeAlias.raw_text.ilike(f"%{token}%"))
            .limit(HISTORY_SCAN_LIMIT)
        ).all()
        matched = [
            name
            for name, alias_raw in candidates
            if looks_like_clean_payee_name(name)
            and payee_fingerprint(alias_raw) == fp
        ]
        if matched:
            name, count = Counter(matched).most_common(1)[0]
            return PayeeSuggestion(name, count, "alias")
    return None


def _suggest_from_history(db: Session, raw: str) -> PayeeSuggestion | None:
    fp = payee_fingerprint(raw)
    if not fp:
        return None
    token0 = fp.split(" ", 1)[0]

    rows = db.execute(
        select(
            BankTransaction.bank_orig_description,
            BankTransaction.description,
        )
        .where(
            BankTransaction.bank_orig_description.is_not(None),
            BankTransaction.description.is_not(None),
            BankTransaction.bank_orig_description.ilike(f"%{token0}%"),
            BankTransaction.description != BankTransaction.bank_orig_description,
        )
        .limit(HISTORY_SCAN_LIMIT)
    ).all()

    exact_names: list[str] = []
    prefix_map: dict[str, set[str]] = {}
    prefix = payee_prefix_key(raw, n=3)
    prefix2 = payee_prefix_key(raw, n=2)

    for bank_orig, description in rows:
        cleaned = (description or "").strip()
        if not cleaned:
            continue
        other_fp = payee_fingerprint(bank_orig)
        if other_fp == fp:
            exact_names.append(cleaned)
        other_p3 = payee_prefix_key(bank_orig, n=3)
        other_p2 = payee_prefix_key(bank_orig, n=2)
        if prefix and other_p3 == prefix:
            prefix_map.setdefault(prefix, set()).add(cleaned)
        if prefix2 and other_p2 == prefix2:
            prefix_map.setdefault(prefix2, set()).add(cleaned)

    if exact_names:
        name, count = Counter(exact_names).most_common(1)[0]
        return PayeeSuggestion(name, count, "fingerprint")

    # Unique prefix fallback: only if that prefix maps to exactly one clean name.
    for key in (prefix, prefix2):
        if not key:
            continue
        names = prefix_map.get(key) or set()
        if len(names) == 1:
            name = next(iter(names))
            return PayeeSuggestion(name, 1, "prefix")
    return None


def autocomplete_payees(db: Session, query: str, *, limit: int = AUTOCOMPLETE_LIMIT) -> list[PayeeOut]:
    q = (query or "").strip()
    if not q:
        return []
    rows = db.execute(
        select(Payee.id, Payee.canonical_name)
        .where(Payee.canonical_name.ilike(f"%{q}%"))
        .order_by(Payee.canonical_name)
        .limit(limit)
    ).all()
    return [PayeeOut(id=row.id, canonical_name=row.canonical_name) for row in rows]


def apply_payee_name(
    db: Session,
    *,
    external_ids: list[int],
    canonical_name: str,
    commit: bool = True,
) -> int:
    """Set clean payee on transactions; upsert payee + aliases from bank text."""
    name = (canonical_name or "").strip()
    if not name or not external_ids:
        return 0

    txns = list(
        db.scalars(
            select(BankTransaction).where(BankTransaction.external_id.in_(external_ids))
        ).all()
    )
    if not txns:
        return 0

    payee = _get_or_create_payee(db, name)
    for txn in txns:
        txn.description = name
        txn.payee_id = payee.id
        raw = bank_text_for_transaction(txn)
        _ensure_aliases(db, payee.id, raw)

    if commit:
        db.commit()
    else:
        db.flush()
    return len(txns)


def _get_or_create_payee(db: Session, canonical_name: str) -> Payee:
    existing = db.scalar(
        select(Payee).where(func.lower(Payee.canonical_name) == canonical_name.lower())
    )
    if existing:
        if existing.canonical_name != canonical_name:
            existing.canonical_name = canonical_name
        return existing
    payee = Payee(canonical_name=canonical_name)
    db.add(payee)
    db.flush()
    return payee


def _ensure_aliases(db: Session, payee_id: int, raw_bank_text: str) -> None:
    raw = (raw_bank_text or "").strip()
    if not raw:
        return
    fp = payee_fingerprint(raw)
    desired: list[tuple[str, str]] = [(raw, SOURCE_USER)]
    if fp and fp.lower() != raw.lower():
        desired.append((fp, SOURCE_FINGERPRINT))

    for text, source in desired:
        key = text.lower()
        other = db.scalar(
            select(PayeeAlias).where(func.lower(PayeeAlias.raw_text) == key)
        )
        if other:
            other.payee_id = payee_id
            other.source = source
            continue
        db.add(PayeeAlias(payee_id=payee_id, raw_text=text, source=source))


def get_transaction_by_external_id(db: Session, external_id: int) -> BankTransaction | None:
    return db.scalar(
        select(BankTransaction).where(BankTransaction.external_id == external_id)
    )
