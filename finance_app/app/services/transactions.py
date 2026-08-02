from datetime import date, timedelta
from decimal import Decimal, InvalidOperation

from sqlalchemy import and_, case, exists, func, or_, select
from sqlalchemy.orm import Session

from app.models import (
    Account,
    BankTransaction,
    CategorySplitDetail,
    SpendingCategory,
    SpendingCategoryGroup,
    TaggedEvent,
    TransactionTaggedEvent,
)
from app.schemas.transaction import CategoryOut, TagOut, TransactionOut
from app.services.calendar_dates import local_today

# category_status: 0 = needs categorization; -1 = approved (legacy convention)
STATUS_NEEDS_CATEGORIZATION = 0
STATUS_APPROVED = -1
DEFAULT_LIMIT = 500
FREQUENT_CAT_DAYS = 365
FREQUENT_CAT_LIMIT = 12


def list_accounts(db: Session) -> list[Account]:
    return list(
        db.scalars(select(Account).where(Account.id > 0).order_by(Account.id)).all()
    )


def _category_label():
    return case(
        (SpendingCategoryGroup.id.in_([-1, 2]), SpendingCategory.category_name),
        else_=func.concat(
            SpendingCategoryGroup.group_name, " - ", SpendingCategory.category_name
        ),
    )


def list_transactions(
    db: Session,
    *,
    account_id: int = 0,
    account_ids: list[int] | None = None,
    start_date: date | None = None,
    end_date: date | None = None,
    include_categorized: bool = False,
    payee: str | None = None,
    category_ids: list[int] | None = None,
    tag_ids: list[int] | None = None,
    amount: Decimal | None = None,
    match_any: bool = False,
    limit: int = DEFAULT_LIMIT,
) -> list[TransactionOut]:
    category_label = _category_label()
    effective_date = func.coalesce(
        BankTransaction.accounting_date,
        BankTransaction.transaction_date,
    )

    stmt = (
        select(
            BankTransaction,
            category_label.label("category_name"),
            Account.account_name,
        )
        .outerjoin(SpendingCategory, BankTransaction.spending_category_id == SpendingCategory.id)
        .outerjoin(
            SpendingCategoryGroup,
            SpendingCategory.spending_category_group_id == SpendingCategoryGroup.id,
        )
        .join(Account, BankTransaction.account_id == Account.id)
        .order_by(effective_date.desc(), BankTransaction.external_id.desc())
        .limit(limit)
    )

    if account_ids is not None:
        if not account_ids:
            return []
        stmt = stmt.where(BankTransaction.account_id.in_(account_ids))
    elif account_id:
        stmt = stmt.where(BankTransaction.account_id == account_id)
    if start_date is not None:
        stmt = stmt.where(effective_date >= start_date)
    if end_date is not None:
        stmt = stmt.where(effective_date <= end_date)

    if not include_categorized:
        stmt = stmt.where(BankTransaction.category_status == STATUS_NEEDS_CATEGORIZATION)

    keyword_clauses = []
    payee_q = (payee or "").strip()
    if payee_q:
        keyword_clauses.append(BankTransaction.description.ilike(f"%{payee_q}%"))
    if category_ids:
        keyword_clauses.append(BankTransaction.spending_category_id.in_(category_ids))
    if tag_ids:
        tag_match = exists(
            select(1)
            .select_from(TransactionTaggedEvent)
            .where(
                TransactionTaggedEvent.bank_transaction_id == BankTransaction.id,
                TransactionTaggedEvent.tagged_event_id.in_(tag_ids),
            )
        )
        keyword_clauses.append(tag_match)
    if amount is not None:
        keyword_clauses.append(BankTransaction.amount == amount)

    if keyword_clauses:
        stmt = stmt.where(or_(*keyword_clauses) if match_any else and_(*keyword_clauses))

    rows = db.execute(stmt).all()
    if not rows:
        return []

    txn_ids = [txn.id for txn, _, _ in rows]
    tag_map = _tags_by_transaction_id(db, txn_ids)
    split_ids = set(
        db.scalars(
            select(CategorySplitDetail.bank_transaction_id).where(
                CategorySplitDetail.bank_transaction_id.in_(txn_ids)
            )
        ).all()
    )

    results: list[TransactionOut] = []
    for txn, category_name, account_name in rows:
        tags = tag_map.get(txn.id, [])
        is_split = txn.id in split_ids or (category_name or "").strip().lower() == "split"
        display_category = "Split" if is_split and not category_name else category_name
        if is_split:
            display_category = "Split"
        results.append(
            TransactionOut(
                transaction_id=txn.external_id,
                transaction_date=txn.transaction_date,
                accounting_date=txn.accounting_date,
                description=txn.description,
                category_id=txn.spending_category_id,
                category_name=display_category,
                amount=txn.amount,
                bank_orig_description=txn.bank_orig_description,
                account_id=txn.account_id,
                account_name=account_name,
                category_status=txn.category_status,
                tags=";".join(tags) if tags else None,
                tag_count=len(tags),
                is_split=is_split,
            )
        )
    return results


def _tags_by_transaction_id(db: Session, txn_ids: list[int]) -> dict[int, list[str]]:
    if not txn_ids:
        return {}
    rows = db.execute(
        select(TransactionTaggedEvent.bank_transaction_id, TaggedEvent.tag)
        .join(TaggedEvent, TransactionTaggedEvent.tagged_event_id == TaggedEvent.id)
        .where(TransactionTaggedEvent.bank_transaction_id.in_(txn_ids))
        .order_by(TaggedEvent.tag)
    ).all()
    out: dict[int, list[str]] = {}
    for txn_id, tag in rows:
        out.setdefault(txn_id, []).append(tag)
    return out


def list_categories(db: Session) -> list[CategoryOut]:
    category_label = _category_label()
    stmt = (
        select(
            SpendingCategory.id,
            category_label.label("category_name"),
            SpendingCategory.spending_category_group_id,
        )
        .join(
            SpendingCategoryGroup,
            SpendingCategory.spending_category_group_id == SpendingCategoryGroup.id,
        )
        .order_by(SpendingCategoryGroup.id, category_label)
    )
    rows = db.execute(stmt).all()
    return [
        CategoryOut(
            category_id=row.id,
            category_name=row.category_name,
            group_id=row.spending_category_group_id,
        )
        for row in rows
    ]


def list_tags(db: Session) -> list[TagOut]:
    rows = db.execute(
        select(TaggedEvent.id, TaggedEvent.tag)
        .where(TaggedEvent.retired_date.is_(None))
        .order_by(TaggedEvent.tag)
    ).all()
    return [TagOut(tag_id=row.id, tag=row.tag) for row in rows]


def list_frequent_categories(
    db: Session,
    *,
    days: int = FREQUENT_CAT_DAYS,
    limit: int = FREQUENT_CAT_LIMIT,
) -> list[CategoryOut]:
    category_label = _category_label()
    effective_date = func.coalesce(
        BankTransaction.accounting_date,
        BankTransaction.transaction_date,
    )
    cutoff = local_today() - timedelta(days=days)
    spend = func.sum(func.abs(BankTransaction.amount)).label("spend")
    stmt = (
        select(
            SpendingCategory.id,
            category_label.label("category_name"),
            SpendingCategory.spending_category_group_id,
            spend,
        )
        .join(
            SpendingCategoryGroup,
            SpendingCategory.spending_category_group_id == SpendingCategoryGroup.id,
        )
        .join(
            BankTransaction,
            BankTransaction.spending_category_id == SpendingCategory.id,
        )
        .where(
            BankTransaction.category_status == STATUS_APPROVED,
            effective_date >= cutoff,
            BankTransaction.spending_category_id.is_not(None),
        )
        .group_by(
            SpendingCategory.id,
            category_label,
            SpendingCategory.spending_category_group_id,
        )
        .order_by(spend.desc())
        .limit(limit)
    )
    rows = db.execute(stmt).all()
    return [
        CategoryOut(
            category_id=row.id,
            category_name=row.category_name,
            group_id=row.spending_category_group_id,
        )
        for row in rows
    ]


def parse_amount(raw: str | None) -> Decimal | None:
    if raw is None:
        return None
    text = str(raw).strip().replace("$", "").replace(",", "")
    if not text:
        return None
    if text.startswith("(") and text.endswith(")"):
        text = f"-{text[1:-1]}"
    try:
        return Decimal(text)
    except InvalidOperation:
        return None


def assign_categories(
    db: Session,
    *,
    external_ids: list[int],
    category_id: int,
    commit: bool = True,
) -> int:
    """Draft-assign a spending category; does not change category_status."""
    if not external_ids:
        return 0
    category = db.get(SpendingCategory, category_id)
    if category is None:
        return 0
    txns = list(
        db.scalars(
            select(BankTransaction).where(BankTransaction.external_id.in_(external_ids))
        ).all()
    )
    for txn in txns:
        txn.spending_category_id = category_id
    if commit:
        db.commit()
    else:
        db.flush()
    return len(txns)


def category_label_for_id(db: Session, category_id: int) -> str | None:
    category_label = _category_label()
    row = db.execute(
        select(category_label.label("category_name"))
        .select_from(SpendingCategory)
        .join(
            SpendingCategoryGroup,
            SpendingCategory.spending_category_group_id == SpendingCategoryGroup.id,
        )
        .where(SpendingCategory.id == category_id)
    ).first()
    return row.category_name if row else None
