from datetime import date, timedelta
from decimal import Decimal
from pathlib import Path

from fastapi import APIRouter, Depends, Query, Request
from fastapi.templating import Jinja2Templates
from sqlalchemy.orm import Session

from app.database import get_db
from app.schemas.transaction import TransactionOut
from app.services import transactions as txn_service
from app.services.account_colors import account_color_map
from app.services.calendar_dates import local_today
from app.services.lookup_bookmarks import get_lookup_bookmarks
from app.services.ui_context import ui_page_context

router = APIRouter(tags=["ui"])
templates = Jinja2Templates(directory=str(Path(__file__).resolve().parent.parent / "templates"))


def _transaction_stats(transactions: list[TransactionOut]) -> dict:
    credit = Decimal("0")
    debit = Decimal("0")
    for txn in transactions:
        if txn.amount is None:
            continue
        if txn.amount > 0:
            credit += txn.amount
        elif txn.amount < 0:
            debit += -txn.amount
    return {
        "count": len(transactions),
        "credit": credit,
        "debit": debit,
        "net": credit - debit,
    }


@router.get("/")
def home(request: Request):
    return templates.TemplateResponse(
        request=request,
        name="redirect.html",
        context={},
    )


@router.get("/transcat")
def transcat(
    request: Request,
    db: Session = Depends(get_db),
    account: list[int] = Query(default=[]),
    start: date | None = Query(default=None),
    end: date | None = Query(default=None),
    queue: str = Query(default="needs"),
    match: str = Query(default="all"),
    payee: str = Query(default=""),
    category: list[int] = Query(default=[]),
    tag: list[int] = Query(default=[]),
    amount: str | None = Query(default=None),
):
    today = local_today()
    start_date = start if start is not None else (today - timedelta(days=30))
    end_date = end if end is not None else today

    categories = txn_service.list_categories(db)
    split_categories = [
        {"category_id": c.category_id, "category_name": c.category_name}
        for c in categories
        if c.category_id > 0
    ]
    tags = txn_service.list_tags(db)
    frequent_categories = txn_service.list_frequent_categories(db)
    accounts = txn_service.list_accounts(db)
    all_account_ids = [a.id for a in accounts]

    # Initial load (no start/end in query): all accounts selected.
    # Explicit search with no account toggles: empty result set.
    initial_load = start is None and end is None
    if initial_load:
        selected_account_ids = all_account_ids
        account_filter: list[int] | None = None
    else:
        selected_account_ids = list(account)
        account_filter = selected_account_ids

    queue_mode = "all" if queue == "all" else "needs"
    match_any = match == "any"
    selected_category_ids = list(category)
    selected_tag_ids = list(tag)
    amount_value = txn_service.parse_amount(amount)

    transactions = txn_service.list_transactions(
        db,
        account_ids=account_filter,
        start_date=start_date,
        end_date=end_date,
        include_categorized=(queue_mode == "all"),
        payee=payee or None,
        category_ids=selected_category_ids or None,
        tag_ids=selected_tag_ids or None,
        amount=amount_value,
        match_any=match_any,
    )
    return templates.TemplateResponse(
        request=request,
        name="transcat.html",
        context={
            "categories": categories,
            "split_categories": split_categories,
            "tags": tags,
            "frequent_categories": frequent_categories,
            "accounts": accounts,
            "transactions": transactions,
            "selected_account_ids": selected_account_ids,
            "selected_category_ids": selected_category_ids,
            "selected_tag_ids": selected_tag_ids,
            "queue_mode": queue_mode,
            "match_mode": "any" if match_any else "all",
            "payee_query": payee,
            "amount_query": amount or "",
            "account_colors": account_color_map(accounts),
            "txn_stats": _transaction_stats(transactions),
            "start_date": start_date.isoformat(),
            "end_date": end_date.isoformat(),
            "lookup_bookmarks": get_lookup_bookmarks(db),
            **ui_page_context(db, nav_active="transcat"),
        },
    )
