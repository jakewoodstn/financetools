"""Promote staged raw_transactions into bank_transactions (Phase 3 step 3)."""

from __future__ import annotations

import hashlib
from dataclasses import dataclass, field
from datetime import datetime, timezone

from sqlalchemy import func, select, update
from sqlalchemy.dialects.postgresql import insert
from sqlalchemy.orm import Session

from app.models import Account, BankTransaction, ImportBatch, RawTransaction

# Legacy MSSQL transactionIds top out around 100M; SimpleFIN-derived ids live above this base.
SIMPLEFIN_EXTERNAL_ID_BASE = 2_000_000_000_000


@dataclass
class PromoteResult:
    candidates: int = 0
    promoted: int = 0
    linked_existing: int = 0
    skipped_already_linked: int = 0
    skipped_import_disabled: int = 0
    import_batch_ids: list[int] = field(default_factory=list)


def external_id_from_source(source_external_id: str) -> int:
    """Stable bank_transactions.external_id for a provider transaction id."""
    digest = hashlib.sha256(source_external_id.encode()).hexdigest()
    offset = int(digest[:12], 16) % 999_999_999_999
    return SIMPLEFIN_EXTERNAL_ID_BASE + offset


def next_legacy_external_id(db: Session) -> int:
    current_max = db.scalar(select(func.max(BankTransaction.external_id))) or 0
    return int(current_max) + 1


def bank_transaction_values(
    raw: RawTransaction,
    *,
    external_id: int,
    loaded_at: datetime,
) -> dict:
    description = (raw.bank_orig_description or "").strip()
    return dict(
        external_id=external_id,
        transaction_date=raw.transaction_date,
        loaded_date=loaded_at,
        description=description or None,
        orig_description=description or None,
        bank_orig_description=raw.bank_orig_description,
        import_category=raw.import_category,
        amount=raw.amount,
        spending_category_id=None,
        category_status=0,
        account_id=raw.account_id,
        accounting_date=raw.transaction_date,
        payee_id=None,
    )


def _find_bank_by_ledger_tuple(db: Session, raw: RawTransaction) -> BankTransaction | None:
    if raw.transaction_date is None or raw.amount is None:
        return None
    return db.execute(
        select(BankTransaction).where(
            BankTransaction.account_id == raw.account_id,
            BankTransaction.transaction_date == raw.transaction_date,
            BankTransaction.amount == raw.amount,
            BankTransaction.bank_orig_description == raw.bank_orig_description,
        )
    ).scalar_one_or_none()


def _find_bank_by_source_external_id(db: Session, source_external_id: str) -> int | None:
    return db.scalar(
        select(RawTransaction.bank_transaction_id)
        .where(
            RawTransaction.source_external_id == source_external_id,
            RawTransaction.bank_transaction_id.is_not(None),
        )
        .limit(1)
    )


def _insert_bank_transaction(db: Session, values: dict) -> int | None:
    stmt = (
        insert(BankTransaction)
        .values(**values)
        .on_conflict_do_nothing(index_elements=[BankTransaction.external_id])
        .returning(BankTransaction.id)
    )
    bank_id = db.execute(stmt).scalar_one_or_none()
    if bank_id is not None:
        return int(bank_id)
    return db.scalar(select(BankTransaction.id).where(BankTransaction.external_id == values["external_id"]))


def _link_raw_to_bank(db: Session, raw_id: int, bank_id: int) -> None:
    db.execute(
        update(RawTransaction)
        .where(RawTransaction.id == raw_id, RawTransaction.bank_transaction_id.is_(None))
        .values(bank_transaction_id=bank_id)
    )


def _promotable_raw_query(
    *,
    account_id: int | None = None,
    import_batch_id: int | None = None,
):
    stmt = (
        select(RawTransaction, Account.import_transactions)
        .join(Account, RawTransaction.account_id == Account.id)
        .where(RawTransaction.bank_transaction_id.is_(None))
        .order_by(RawTransaction.id)
    )
    if account_id is not None:
        stmt = stmt.where(RawTransaction.account_id == account_id)
    if import_batch_id is not None:
        stmt = stmt.where(RawTransaction.import_batch_id == import_batch_id)
    return stmt


def promote_raw_transactions(
    db: Session,
    *,
    account_id: int | None = None,
    import_batch_id: int | None = None,
) -> PromoteResult:
    """Promote unstaged raw rows to bank_transactions (idempotent)."""
    result = PromoteResult()
    loaded_at = datetime.now(timezone.utc).replace(tzinfo=None)
    rows = db.execute(_promotable_raw_query(account_id=account_id, import_batch_id=import_batch_id)).all()
    batch_ids: set[int] = set()
    next_legacy_id = int(db.scalar(select(func.max(BankTransaction.external_id))) or 0) + 1

    for raw, import_transactions in rows:
        result.candidates += 1
        batch_ids.add(raw.import_batch_id)

        if raw.bank_transaction_id is not None:
            result.skipped_already_linked += 1
            continue

        if not import_transactions:
            result.skipped_import_disabled += 1
            continue

        bank_id: int | None = None
        linked_existing = False

        if raw.source_external_id:
            bank_id = _find_bank_by_source_external_id(db, raw.source_external_id)
            if bank_id is not None:
                linked_existing = True

        if bank_id is None:
            existing = _find_bank_by_ledger_tuple(db, raw)
            if existing is not None:
                bank_id = existing.id
                linked_existing = True

        if bank_id is None:
            if raw.source_external_id:
                external_id = external_id_from_source(raw.source_external_id)
            else:
                external_id = next_legacy_id
                next_legacy_id += 1
            values = bank_transaction_values(raw, external_id=external_id, loaded_at=loaded_at)
            bank_id = _insert_bank_transaction(db, values)
            if bank_id is None:
                continue
            result.promoted += 1
        elif linked_existing:
            result.linked_existing += 1

        _link_raw_to_bank(db, raw.id, bank_id)

    db.flush()
    result.import_batch_ids = sorted(batch_ids)
    for batch_id in result.import_batch_ids:
        _refresh_import_batch_status(db, batch_id)
    db.commit()
    return result


def _refresh_import_batch_status(db: Session, import_batch_id: int) -> None:
    total = db.scalar(
        select(func.count()).select_from(RawTransaction).where(RawTransaction.import_batch_id == import_batch_id)
    )
    promoted = db.scalar(
        select(func.count())
        .select_from(RawTransaction)
        .where(
            RawTransaction.import_batch_id == import_batch_id,
            RawTransaction.bank_transaction_id.is_not(None),
        )
    )
    if not total or not promoted:
        return
    status = "promoted" if promoted == total else "partial"
    db.execute(update(ImportBatch).where(ImportBatch.id == import_batch_id).values(status=status))
