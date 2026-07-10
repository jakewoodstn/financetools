from sqlalchemy import case, func, select
from sqlalchemy.orm import Session

from app.models import Account, BankTransaction, SpendingCategory, SpendingCategoryGroup
from app.schemas.transaction import CategoryOut, TransactionOut

# category_status: 0 = needs categorization; -1 = approved (legacy convention)
STATUS_NEEDS_CATEGORIZATION = 0
STATUS_APPROVED = -1
DEFAULT_LIMIT = 500


def list_transactions(
    db: Session,
    *,
    account_id: int = 0,
    include_categorized: bool = False,
    limit: int = DEFAULT_LIMIT,
) -> list[TransactionOut]:
    category_label = case(
        (SpendingCategoryGroup.id.in_([-1, 2]), SpendingCategory.category_name),
        else_=func.concat(SpendingCategoryGroup.group_name, " - ", SpendingCategory.category_name),
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
        .order_by(BankTransaction.accounting_date.desc(), BankTransaction.external_id.desc())
        .limit(limit)
    )

    if account_id:
        stmt = stmt.where(BankTransaction.account_id == account_id)

    if not include_categorized:
        stmt = stmt.where(BankTransaction.category_status == STATUS_NEEDS_CATEGORIZATION)

    rows = db.execute(stmt).all()
    results: list[TransactionOut] = []
    for txn, category_name, account_name in rows:
        results.append(
            TransactionOut(
                transaction_id=txn.external_id,
                transaction_date=txn.transaction_date,
                accounting_date=txn.accounting_date,
                description=txn.description,
                category_id=txn.spending_category_id,
                category_name=category_name,
                amount=txn.amount,
                bank_orig_description=txn.bank_orig_description,
                account_id=txn.account_id,
                account_name=account_name,
                category_status=txn.category_status,
            )
        )
    return results


def list_categories(db: Session) -> list[CategoryOut]:
    category_label = case(
        (SpendingCategoryGroup.id.in_([-1, 2]), SpendingCategory.category_name),
        else_=func.concat(SpendingCategoryGroup.group_name, " - ", SpendingCategory.category_name),
    )
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
