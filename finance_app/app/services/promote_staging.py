"""Promote staged raw_transactions into bank_transactions (Phase 3 step 3)."""

from __future__ import annotations

import hashlib
from dataclasses import dataclass, field
from datetime import date, datetime, timezone
from decimal import Decimal

from sqlalchemy import delete, func, or_, select, update
from sqlalchemy.dialects.postgresql import insert
from sqlalchemy.orm import Session

from app.models import Account, BankTransaction, ImportBatch, RawTransaction

# Legacy MSSQL transactionIds top out around 100M; SimpleFIN-derived ids live above this base.
SIMPLEFIN_EXTERNAL_ID_BASE = 2_000_000_000_000


@dataclass(frozen=True)
class LedgerRowSnapshot:
    """Ledger 4-tuple row for promotion conflict reporting."""

    source: str
    row_id: int
    account_id: int
    transaction_date: date | None
    amount: Decimal | None
    bank_orig_description: str | None
    external_id: int | None = None


class PromoteConflictError(Exception):
    """Formatted ledger-key ambiguity (used for review notes, not batch abort)."""

    def __init__(self, incoming: LedgerRowSnapshot, existing: list[LedgerRowSnapshot]):
        self.incoming = incoming
        self.existing = existing
        super().__init__(format_promote_conflict_message(incoming, existing))


PROMOTION_STATUS_NEEDS_REVIEW = "needs_review"


@dataclass(frozen=True)
class PromoteReviewItem:
    raw_id: int
    transaction_date: date | None
    amount: Decimal | None
    description: str
    note: str


@dataclass(frozen=True)
class ReviewBankCandidate:
    bank_id: int
    external_id: int
    already_linked: bool
    linked_raw_id: int | None = None


@dataclass(frozen=True)
class ReviewRowDetail:
    raw_id: int
    account_id: int
    transaction_date: date | None
    amount: Decimal | None
    description: str
    promotion_note: str
    candidates: list[ReviewBankCandidate]


def snapshot_from_raw(raw: RawTransaction) -> LedgerRowSnapshot:
    return LedgerRowSnapshot(
        source="raw_transactions",
        row_id=raw.id,
        account_id=raw.account_id,
        transaction_date=raw.transaction_date,
        amount=raw.amount,
        bank_orig_description=raw.bank_orig_description,
    )


def snapshot_from_bank(bank: BankTransaction) -> LedgerRowSnapshot:
    return LedgerRowSnapshot(
        source="bank_transactions",
        row_id=bank.id,
        account_id=bank.account_id,
        transaction_date=bank.transaction_date,
        amount=bank.amount,
        bank_orig_description=bank.bank_orig_description,
        external_id=bank.external_id,
    )


def format_ledger_row_line(row: LedgerRowSnapshot) -> str:
    desc = (row.bank_orig_description or "").strip() or "—"
    amount = f"{row.amount}" if row.amount is not None else "—"
    txn_date = row.transaction_date.isoformat() if row.transaction_date else "—"
    parts = [
        f"{row.source} #{row.row_id}",
        f"account={row.account_id}",
        f"date={txn_date}",
        f"amount={amount}",
        f'description="{desc}"',
    ]
    if row.external_id is not None:
        parts.insert(1, f"external_id={row.external_id}")
    return "  " + "  ".join(parts)


def format_promote_conflict_message(
    incoming: LedgerRowSnapshot,
    existing: list[LedgerRowSnapshot],
) -> str:
    lines = [
        (
            f"Held for review: {len(existing)} existing bank_transactions match the same "
            f"ledger key (account, date, amount, bank_orig_description) as this raw row."
        ),
        "",
        "Incoming:",
        format_ledger_row_line(incoming),
        "",
        "Existing:",
    ]
    lines.extend(format_ledger_row_line(row) for row in existing)
    lines.extend(
        [
            "",
            "Link manually to one existing row, or clear review status after fixing bank duplicates.",
        ]
    )
    return "\n".join(lines)


@dataclass
class PromoteResult:
    candidates: int = 0
    promoted: int = 0
    linked_existing: int = 0
    skipped_already_linked: int = 0
    skipped_import_disabled: int = 0
    needs_review: int = 0
    review_items: list[PromoteReviewItem] = field(default_factory=list)
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
        source_external_id=raw.source_external_id,
    )


def _linked_bank_transaction_ids_subquery():
    return select(RawTransaction.bank_transaction_id).where(
        RawTransaction.bank_transaction_id.is_not(None)
    )


def _find_banks_by_ledger_tuple(db: Session, raw: RawTransaction) -> list[BankTransaction]:
    if raw.transaction_date is None or raw.amount is None:
        return []
    return list(
        db.scalars(
            select(BankTransaction).where(
                BankTransaction.account_id == raw.account_id,
                BankTransaction.transaction_date == raw.transaction_date,
                BankTransaction.amount == raw.amount,
                BankTransaction.bank_orig_description == raw.bank_orig_description,
            )
        ).all()
    )


def _find_unlinked_banks_by_ledger_tuple(db: Session, raw: RawTransaction) -> list[BankTransaction]:
    if raw.transaction_date is None or raw.amount is None:
        return []
    linked_ids = _linked_bank_transaction_ids_subquery()
    return list(
        db.scalars(
            select(BankTransaction).where(
                BankTransaction.account_id == raw.account_id,
                BankTransaction.transaction_date == raw.transaction_date,
                BankTransaction.amount == raw.amount,
                BankTransaction.bank_orig_description == raw.bank_orig_description,
                BankTransaction.id.not_in(linked_ids),
            )
        ).all()
    )


def _find_bank_by_source_external_id(db: Session, source_external_id: str) -> int | None:
    return db.scalar(
        select(BankTransaction.id)
        .where(BankTransaction.source_external_id == source_external_id)
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
        .values(
            bank_transaction_id=bank_id,
            promotion_status=None,
            promotion_note=None,
        )
    )


def _attach_source_identity(db: Session, raw: RawTransaction, bank_id: int) -> None:
    if not raw.source_external_id:
        return
    existing_source_id = db.scalar(
        select(BankTransaction.source_external_id).where(BankTransaction.id == bank_id)
    )
    if existing_source_id and existing_source_id != raw.source_external_id:
        raise ValueError(
            f"Bank transaction {bank_id} already has a different source external id"
        )
    if existing_source_id is None:
        db.execute(
            update(BankTransaction)
            .where(BankTransaction.id == bank_id)
            .values(source_external_id=raw.source_external_id)
        )


def _mark_needs_review(db: Session, raw: RawTransaction, note: str) -> PromoteReviewItem:
    db.execute(
        update(RawTransaction)
        .where(RawTransaction.id == raw.id)
        .values(
            promotion_status=PROMOTION_STATUS_NEEDS_REVIEW,
            promotion_note=note,
        )
    )
    description = (raw.bank_orig_description or "")[:80]
    return PromoteReviewItem(
        raw_id=raw.id,
        transaction_date=raw.transaction_date,
        amount=raw.amount,
        description=description,
        note=note,
    )


def _promotable_raw_query(
    *,
    account_id: int | None = None,
    import_batch_id: int | None = None,
):
    stmt = (
        select(RawTransaction, Account.import_transactions)
        .join(Account, RawTransaction.account_id == Account.id)
        .where(
            RawTransaction.bank_transaction_id.is_(None),
            or_(
                RawTransaction.promotion_status.is_(None),
                RawTransaction.promotion_status != PROMOTION_STATUS_NEEDS_REVIEW,
            ),
        )
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
    completed_raw_ids: list[int] = []
    discarded_raw_ids: list[int] = []
    next_legacy_id = int(db.scalar(select(func.max(BankTransaction.external_id))) or 0) + 1

    for raw, import_transactions in rows:
        result.candidates += 1
        batch_ids.add(raw.import_batch_id)

        if raw.bank_transaction_id is not None:
            result.skipped_already_linked += 1
            continue

        if not import_transactions:
            result.skipped_import_disabled += 1
            discarded_raw_ids.append(raw.id)
            continue

        bank_id: int | None = None
        linked_existing = False

        if raw.source_external_id:
            bank_id = _find_bank_by_source_external_id(db, raw.source_external_id)
            if bank_id is not None:
                linked_existing = True

        if bank_id is None:
            unlinked_rows = _find_unlinked_banks_by_ledger_tuple(db, raw)
            if len(unlinked_rows) == 1:
                bank_id = unlinked_rows[0].id
                linked_existing = True
            elif len(unlinked_rows) > 1:
                note = format_promote_conflict_message(
                    snapshot_from_raw(raw),
                    [snapshot_from_bank(row) for row in unlinked_rows],
                )
                review_item = _mark_needs_review(db, raw, note)
                result.needs_review += 1
                result.review_items.append(review_item)
                continue

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

        _attach_source_identity(db, raw, bank_id)
        _link_raw_to_bank(db, raw.id, bank_id)
        completed_raw_ids.append(raw.id)

    db.flush()
    if completed_raw_ids or discarded_raw_ids:
        db.execute(
            delete(RawTransaction).where(
                RawTransaction.id.in_(completed_raw_ids + discarded_raw_ids)
            )
        )
    result.import_batch_ids = sorted(batch_ids)
    for batch_id in result.import_batch_ids:
        _refresh_import_batch_status(db, batch_id)
    db.commit()
    return result


def _refresh_import_batch_status(db: Session, import_batch_id: int) -> None:
    remaining = db.scalar(
        select(func.count()).select_from(RawTransaction).where(RawTransaction.import_batch_id == import_batch_id)
    )
    status = "partial" if remaining else "promoted"
    db.execute(update(ImportBatch).where(ImportBatch.id == import_batch_id).values(status=status))


def _ledger_tuple_matches(raw: RawTransaction, bank: BankTransaction) -> bool:
    return (
        raw.account_id == bank.account_id
        and raw.transaction_date == bank.transaction_date
        and raw.amount == bank.amount
        and raw.bank_orig_description == bank.bank_orig_description
    )


def _linked_raw_id_for_bank(db: Session, bank_id: int) -> int | None:
    return db.scalar(
        select(RawTransaction.id).where(RawTransaction.bank_transaction_id == bank_id).limit(1)
    )


def review_row_detail(db: Session, raw_id: int) -> ReviewRowDetail | None:
    raw = db.get(RawTransaction, raw_id)
    if raw is None or raw.promotion_status != PROMOTION_STATUS_NEEDS_REVIEW:
        return None
    candidates: list[ReviewBankCandidate] = []
    for bank in _find_banks_by_ledger_tuple(db, raw):
        linked_raw_id = _linked_raw_id_for_bank(db, bank.id)
        candidates.append(
            ReviewBankCandidate(
                bank_id=bank.id,
                external_id=bank.external_id,
                already_linked=linked_raw_id is not None,
                linked_raw_id=linked_raw_id,
            )
        )
    return ReviewRowDetail(
        raw_id=raw.id,
        account_id=raw.account_id,
        transaction_date=raw.transaction_date,
        amount=raw.amount,
        description=(raw.bank_orig_description or "")[:120],
        promotion_note=raw.promotion_note or "",
        candidates=candidates,
    )


def list_review_row_details(db: Session, account_id: int) -> list[ReviewRowDetail]:
    raw_ids = db.scalars(
        select(RawTransaction.id)
        .where(
            RawTransaction.account_id == account_id,
            RawTransaction.bank_transaction_id.is_(None),
            RawTransaction.promotion_status == PROMOTION_STATUS_NEEDS_REVIEW,
        )
        .order_by(RawTransaction.id)
    ).all()
    details: list[ReviewRowDetail] = []
    for raw_id in raw_ids:
        detail = review_row_detail(db, raw_id)
        if detail is not None:
            details.append(detail)
    return details


def link_review_raw_to_bank(db: Session, raw_id: int, bank_transaction_id: int) -> None:
    raw = db.get(RawTransaction, raw_id)
    if raw is None:
        raise ValueError(f"Unknown raw transaction id {raw_id}")
    if raw.promotion_status != PROMOTION_STATUS_NEEDS_REVIEW:
        raise ValueError(f"Raw transaction {raw_id} is not held for review")
    if raw.bank_transaction_id is not None:
        raise ValueError(f"Raw transaction {raw_id} is already linked")

    bank = db.get(BankTransaction, bank_transaction_id)
    if bank is None:
        raise ValueError(f"Unknown bank transaction id {bank_transaction_id}")
    if not _ledger_tuple_matches(raw, bank):
        raise ValueError("Selected bank transaction does not match the raw row ledger key")

    linked_raw_id = _linked_raw_id_for_bank(db, bank_transaction_id)
    if linked_raw_id is not None and linked_raw_id != raw_id:
        raise ValueError(
            f"Bank transaction {bank_transaction_id} is already linked to raw #{linked_raw_id}"
        )

    import_batch_id = raw.import_batch_id
    _attach_source_identity(db, raw, bank_transaction_id)
    _link_raw_to_bank(db, raw_id, bank_transaction_id)
    db.flush()
    db.execute(delete(RawTransaction).where(RawTransaction.id == raw_id))
    _refresh_import_batch_status(db, import_batch_id)
    db.commit()


def promote_review_raw_as_new(db: Session, raw_id: int) -> int:
    raw = db.get(RawTransaction, raw_id)
    if raw is None:
        raise ValueError(f"Unknown raw transaction id {raw_id}")
    if raw.promotion_status != PROMOTION_STATUS_NEEDS_REVIEW:
        raise ValueError(f"Raw transaction {raw_id} is not held for review")
    if raw.bank_transaction_id is not None:
        raise ValueError(f"Raw transaction {raw_id} is already linked")

    import_batch_id = raw.import_batch_id
    loaded_at = datetime.now(timezone.utc).replace(tzinfo=None)
    if raw.source_external_id:
        external_id = external_id_from_source(raw.source_external_id)
    else:
        external_id = next_legacy_external_id(db)
    values = bank_transaction_values(raw, external_id=external_id, loaded_at=loaded_at)
    bank_id = _insert_bank_transaction(db, values)
    if bank_id is None:
        raise ValueError("Failed to insert bank transaction")
    _link_raw_to_bank(db, raw_id, bank_id)
    db.flush()
    db.execute(delete(RawTransaction).where(RawTransaction.id == raw_id))
    _refresh_import_batch_status(db, import_batch_id)
    db.commit()
    return bank_id
