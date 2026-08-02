from datetime import date, timedelta
from pathlib import Path

from fastapi import APIRouter, Depends, Query, Request
from fastapi.templating import Jinja2Templates
from sqlalchemy.orm import Session

from app.database import get_db
from app.services import transactions as txn_service
from app.services.calendar_dates import local_today

router = APIRouter(tags=["ui"])
templates = Jinja2Templates(directory=str(Path(__file__).resolve().parent.parent / "templates"))

ACCOUNT_COLORS = [
    "#1d4ed8",
    "#b45309",
    "#166534",
    "#7c3aed",
    "#be123c",
    "#0f766e",
]


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
):
    today = local_today()
    start_date = start if start is not None else (today - timedelta(days=30))
    end_date = end if end is not None else today

    categories = txn_service.list_categories(db)
    accounts = txn_service.list_accounts(db)
    all_account_ids = [a.id for a in accounts]

    # Initial load (no start/end in query): all accounts selected.
    # Explicit search with no account checkboxes: empty result set.
    initial_load = start is None and end is None
    if initial_load:
        selected_account_ids = all_account_ids
        account_filter: list[int] | None = None
    else:
        selected_account_ids = list(account)
        account_filter = selected_account_ids

    transactions = txn_service.list_transactions(
        db,
        account_ids=account_filter,
        start_date=start_date,
        end_date=end_date,
    )
    account_colors = {
        account.id: ACCOUNT_COLORS[idx % len(ACCOUNT_COLORS)]
        for idx, account in enumerate(accounts)
    }
    return templates.TemplateResponse(
        request=request,
        name="transcat.html",
        context={
            "categories": categories,
            "accounts": accounts,
            "transactions": transactions,
            "selected_account_ids": selected_account_ids,
            "account_colors": account_colors,
            "start_date": start_date.isoformat(),
            "end_date": end_date.isoformat(),
        },
    )
