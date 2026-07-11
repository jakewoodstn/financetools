"""Stage imported transactions into import_batches and raw_transactions."""

from __future__ import annotations

import hashlib
from dataclasses import dataclass, field
from datetime import date
from decimal import Decimal
from typing import Literal

from sqlalchemy import delete, select
from sqlalchemy.dialects.postgresql import insert
from sqlalchemy.orm import Session

from app.models import ImportBatch, RawTransaction, TransactionAccount
from app.services.simplefin import SimpleFinAccount, SimpleFinTransaction

ImportMode = Literal["merge", "replace"]


@dataclass
class StageResult:
    import_batch_id: int
    accounts_seen: int = 0
    transactions_fetched: int = 0
    inserted: int = 0
    skipped_duplicate: int = 0
    deleted: int = 0
    skipped_unmapped_account: int = 0
    api_errors: list[str] = field(default_factory=list)
    unmapped_account_names: list[str] = field(default_factory=list)


def dedupe_hash(
    account_id: int,
    transaction_date: date,
    amount: Decimal,
    bank_orig_description: str | None,
) -> str:
    description = (bank_orig_description or "").strip()
    amount_normalized = format(amount, "f")
    key = f"{account_id}|{transaction_date.isoformat()}|{amount_normalized}|{description}"
    return hashlib.sha256(key.encode()).hexdigest()


def _transaction_account_map(db: Session) -> dict[str, int]:
    rows = db.execute(select(TransactionAccount.name, TransactionAccount.account_id)).all()
    return {name: account_id for name, account_id in rows if account_id is not None}


def _filter_transactions(
    transactions: list[SimpleFinTransaction],
    start_date: date,
    end_date: date,
) -> list[SimpleFinTransaction]:
    return [txn for txn in transactions if start_date <= txn.transaction_date <= end_date]


def _delete_raw_in_range(
    db: Session,
    account_id: int,
    start_date: date,
    end_date: date,
) -> int:
    result = db.execute(
        delete(RawTransaction).where(
            RawTransaction.account_id == account_id,
            RawTransaction.bank_transaction_id.is_(None),
            RawTransaction.transaction_date >= start_date,
            RawTransaction.transaction_date <= end_date,
        )
    )
    return result.rowcount or 0


def stage_simplefin_account(
    db: Session,
    account: SimpleFinAccount,
    *,
    account_id: int,
    start_date: date,
    end_date: date,
    mode: ImportMode = "merge",
    api_errors: list[str] | None = None,
) -> StageResult:
    """Stage one SimpleFIN account into raw_transactions for a date window."""
    batch = ImportBatch(source="simplefin", filename=None, status="staged")
    db.add(batch)
    db.flush()

    result = StageResult(import_batch_id=batch.id, accounts_seen=1, api_errors=list(api_errors or []))
    transactions = _filter_transactions(account.transactions, start_date, end_date)
    result.transactions_fetched = len(transactions)

    if mode == "replace":
        result.deleted = _delete_raw_in_range(db, account_id, start_date, end_date)

    for txn in transactions:
        inserted = _insert_raw_transaction(db, batch.id, account_id, txn, mode=mode)
        if inserted:
            result.inserted += 1
        else:
            result.skipped_duplicate += 1

    db.commit()
    return result


def stage_simplefin_accounts(
    db: Session,
    accounts: list[SimpleFinAccount],
    *,
    api_errors: list[str] | None = None,
) -> StageResult:
    """Write fetched SimpleFIN transactions to raw_transactions (all mapped accounts)."""
    batch = ImportBatch(source="simplefin", filename=None, status="staged")
    db.add(batch)
    db.flush()

    name_to_account_id = _transaction_account_map(db)
    result = StageResult(import_batch_id=batch.id, api_errors=list(api_errors or []))

    for account in accounts:
        result.accounts_seen += 1
        account_id = name_to_account_id.get(account.name)
        if account_id is None:
            result.skipped_unmapped_account += len(account.transactions)
            if account.name not in result.unmapped_account_names:
                result.unmapped_account_names.append(account.name)
            continue

        for txn in account.transactions:
            result.transactions_fetched += 1
            if _insert_raw_transaction(db, batch.id, account_id, txn, mode="merge"):
                result.inserted += 1
            else:
                result.skipped_duplicate += 1

    db.commit()
    return result


def _insert_raw_transaction(
    db: Session,
    import_batch_id: int,
    account_id: int,
    txn: SimpleFinTransaction,
    *,
    mode: ImportMode = "merge",
) -> bool:
    digest = dedupe_hash(account_id, txn.transaction_date, txn.amount, txn.bank_orig_description)
    values = dict(
        import_batch_id=import_batch_id,
        account_id=account_id,
        transaction_date=txn.transaction_date,
        amount=txn.amount,
        bank_orig_description=txn.bank_orig_description or None,
        import_category="pending" if txn.pending else None,
        dedupe_hash=digest,
        bank_transaction_id=None,
    )
    if mode == "merge":
        stmt = (
            insert(RawTransaction)
            .values(**values)
            .on_conflict_do_nothing(index_elements=[RawTransaction.dedupe_hash])
            .returning(RawTransaction.id)
        )
        inserted_id = db.execute(stmt).scalar_one_or_none()
        db.flush()
        return inserted_id is not None

    stmt = (
        insert(RawTransaction)
        .values(**values)
        .on_conflict_do_nothing(index_elements=[RawTransaction.dedupe_hash])
        .returning(RawTransaction.id)
    )
    inserted_id = db.execute(stmt).scalar_one_or_none()
    db.flush()
    return inserted_id is not None
