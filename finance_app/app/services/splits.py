"""Category split details for a parent bank transaction."""

from __future__ import annotations

from dataclasses import dataclass
from decimal import Decimal

from sqlalchemy import func, select, update
from sqlalchemy.orm import Session

from app.models import (
    BankTransaction,
    CategorySplitDetail,
    SpendingCategory,
    SpendingCategoryGroup,
    TransactionTaggedEvent,
)
from app.services.transactions import _category_label

SPLIT_CATEGORY_ID = -1
BALANCE_TOLERANCE = Decimal("0.01")


@dataclass(frozen=True)
class SplitLine:
    id: int | None
    external_id: int | None
    category_id: int
    category_name: str | None
    split_amount: Decimal


@dataclass(frozen=True)
class SplitBundle:
    transaction_id: int  # external_id
    amount: Decimal
    lines: list[SplitLine]


class SplitBalanceError(ValueError):
    """Raised when split line amounts do not sum to the parent amount."""


def _get_txn(db: Session, external_id: int) -> BankTransaction | None:
    return db.scalar(
        select(BankTransaction).where(BankTransaction.external_id == external_id)
    )


def _next_split_external_id(db: Session) -> int:
    current = db.scalar(select(func.max(CategorySplitDetail.external_id))) or 0
    return int(current) + 1


def _lines_for_txn(db: Session, bank_transaction_id: int) -> list[SplitLine]:
    category_label = _category_label()
    rows = db.execute(
        select(
            CategorySplitDetail.id,
            CategorySplitDetail.external_id,
            CategorySplitDetail.spending_category_id,
            CategorySplitDetail.split_amount,
            category_label.label("category_name"),
        )
        .outerjoin(
            SpendingCategory,
            CategorySplitDetail.spending_category_id == SpendingCategory.id,
        )
        .outerjoin(
            SpendingCategoryGroup,
            SpendingCategory.spending_category_group_id == SpendingCategoryGroup.id,
        )
        .where(CategorySplitDetail.bank_transaction_id == bank_transaction_id)
        .order_by(CategorySplitDetail.id)
    ).all()
    out: list[SplitLine] = []
    for row in rows:
        if row.spending_category_id is None or row.split_amount is None:
            continue
        out.append(
            SplitLine(
                id=row.id,
                external_id=row.external_id,
                category_id=row.spending_category_id,
                category_name=row.category_name,
                split_amount=Decimal(row.split_amount),
            )
        )
    return out


def get_splits(db: Session, external_id: int) -> SplitBundle | None:
    txn = _get_txn(db, external_id)
    if txn is None:
        return None
    amount = Decimal(txn.amount or 0)
    return SplitBundle(
        transaction_id=txn.external_id,
        amount=amount,
        lines=_lines_for_txn(db, txn.id),
    )


def _validate_balance(parent_amount: Decimal, lines: list[tuple[int, Decimal]]) -> None:
    if len(lines) < 2:
        raise SplitBalanceError("A split needs at least two lines")
    total = sum((amt for _, amt in lines), Decimal("0"))
    if abs(total - parent_amount) > BALANCE_TOLERANCE:
        raise SplitBalanceError(
            f"Split amounts ({total}) must equal transaction amount ({parent_amount})"
        )


def replace_splits(
    db: Session,
    *,
    external_id: int,
    lines: list[dict],
    commit: bool = True,
) -> SplitBundle:
    """Replace all split lines for a transaction. lines: category_id, split_amount, optional id."""
    txn = _get_txn(db, external_id)
    if txn is None:
        raise LookupError("Transaction not found")

    cleaned: list[tuple[int | None, int, Decimal]] = []
    for raw in lines:
        cat_id = int(raw.get("category_id") or 0)
        if cat_id <= 0:
            continue
        amt = Decimal(str(raw.get("split_amount") or "0"))
        if amt == 0:
            continue
        line_id = raw.get("id")
        cleaned.append((int(line_id) if line_id else None, cat_id, amt))

    _validate_balance(Decimal(txn.amount or 0), [(c, a) for _, c, a in cleaned])

    # Validate categories exist and are not the Split sentinel.
    cat_ids = {c for _, c, _ in cleaned}
    found = set(
        db.scalars(select(SpendingCategory.id).where(SpendingCategory.id.in_(cat_ids))).all()
    )
    missing = cat_ids - found
    if missing:
        raise ValueError(f"Unknown category id(s): {sorted(missing)}")
    if SPLIT_CATEGORY_ID in cat_ids:
        raise ValueError("Cannot use Split as a line category")

    existing = list(
        db.scalars(
            select(CategorySplitDetail).where(
                CategorySplitDetail.bank_transaction_id == txn.id
            )
        ).all()
    )
    existing_by_id = {row.id: row for row in existing}
    keep_ids: set[int] = set()
    next_ext = _next_split_external_id(db)

    for line_id, cat_id, amt in cleaned:
        row = existing_by_id.get(line_id) if line_id else None
        if row is None:
            row = CategorySplitDetail(
                external_id=next_ext,
                bank_transaction_id=txn.id,
                spending_category_id=cat_id,
                split_amount=amt,
            )
            next_ext += 1
            db.add(row)
            db.flush()
        else:
            row.spending_category_id = cat_id
            row.split_amount = amt
        keep_ids.add(row.id)

    remove_ids = [row.id for row in existing if row.id not in keep_ids]
    if remove_ids:
        db.execute(
            update(TransactionTaggedEvent)
            .where(TransactionTaggedEvent.category_split_detail_id.in_(remove_ids))
            .values(category_split_detail_id=None)
        )
        for row in existing:
            if row.id in remove_ids:
                db.delete(row)

    txn.spending_category_id = SPLIT_CATEGORY_ID

    if commit:
        db.commit()
    else:
        db.flush()

    bundle = get_splits(db, external_id)
    assert bundle is not None
    return bundle


def clear_splits(
    db: Session,
    *,
    external_id: int,
    commit: bool = True,
) -> bool:
    """Delete all split lines and clear the parent Split category."""
    txn = _get_txn(db, external_id)
    if txn is None:
        return False

    existing = list(
        db.scalars(
            select(CategorySplitDetail).where(
                CategorySplitDetail.bank_transaction_id == txn.id
            )
        ).all()
    )
    remove_ids = [row.id for row in existing]
    if remove_ids:
        db.execute(
            update(TransactionTaggedEvent)
            .where(TransactionTaggedEvent.category_split_detail_id.in_(remove_ids))
            .values(category_split_detail_id=None)
        )
        for row in existing:
            db.delete(row)

    if txn.spending_category_id == SPLIT_CATEGORY_ID:
        txn.spending_category_id = None

    if commit:
        db.commit()
    else:
        db.flush()
    return True
