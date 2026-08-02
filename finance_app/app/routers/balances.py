"""Account balance chart page and series API."""

from __future__ import annotations

from datetime import date, timedelta
from decimal import Decimal, InvalidOperation
from pathlib import Path

from fastapi import APIRouter, Depends, Form, HTTPException, Query, Request
from fastapi.templating import Jinja2Templates
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.database import get_db
from app.models import Account
from app.services.account_colors import account_color_map, default_color_for_id
from app.services.balance_series import (
    DRIFT_TOLERANCE,
    balance_series,
    drift_series,
    observations_in_range,
    recompute_daily_balances,
    record_balance_observation,
)
from app.services.calendar_dates import local_today, parse_calendar_date
from app.services.ui_context import ui_page_context

router = APIRouter(tags=["balances"])
templates = Jinja2Templates(directory=str(Path(__file__).resolve().parent.parent / "templates"))


def _parse_account_ids(account: list[int] | None) -> list[int] | None:
    if not account:
        return None
    return [int(value) for value in account]


@router.get("/balances")
def balances_page(
    request: Request,
    db: Session = Depends(get_db),
):
    accounts = list(
        db.execute(select(Account).where(Account.id > 0).order_by(Account.id)).scalars().all()
    )
    end = local_today()
    start = end - timedelta(days=365)
    return templates.TemplateResponse(
        request=request,
        name="balances.html",
        context={
            "accounts": accounts,
            "account_colors": account_color_map(accounts),
            "start_default": start.isoformat(),
            "end_default": end.isoformat(),
            "drift_tolerance": DRIFT_TOLERANCE,
            **ui_page_context(db, nav_active="balances"),
        },
    )


@router.get("/api/balances")
def balances_api(
    db: Session = Depends(get_db),
    account: list[int] | None = Query(default=None),
    start: date | None = Query(default=None),
    end: date | None = Query(default=None),
    include_total: bool = Query(default=True),
    total_only: bool = Query(default=False),
) -> dict:
    account_ids = _parse_account_ids(account)
    if account_ids is None:
        account_ids = list(
            db.scalars(select(Account.id).where(Account.id > 0).order_by(Account.id)).all()
        )

    series = balance_series(db, account_ids=account_ids, start=start, end=end)

    if total_only:
        totals: dict[date, Decimal] = {}
        for acct_id in account_ids:
            for measurement_date, amount in series.get(acct_id, []):
                totals[measurement_date] = totals.get(measurement_date, Decimal("0")) + amount
        return {
            "start": start.isoformat() if start else None,
            "end": end.isoformat() if end else None,
            "datasets": [
                {
                    "account_id": 0,
                    "label": "Total",
                    "color": "#111827",
                    "kind": "computed",
                    "points": [
                        {"date": day.isoformat(), "amount": float(totals[day])}
                        for day in sorted(totals)
                    ],
                }
            ],
        }

    account_rows = list(
        db.scalars(select(Account).where(Account.id.in_(account_ids))).all()
    )
    names = {row.id: row.account_name for row in account_rows}
    colors = account_color_map(account_rows)
    observations = observations_in_range(db, account_ids=account_ids, start=start, end=end)
    drift = drift_series(db, account_ids=account_ids, start=start, end=end)

    datasets = []
    for acct_id in account_ids:
        color = colors.get(acct_id) or default_color_for_id(acct_id)
        name = names.get(acct_id) or f"Account {acct_id}"
        points = series.get(acct_id, [])
        datasets.append(
            {
                "account_id": acct_id,
                "label": f"{name} — computed",
                "color": color,
                "kind": "computed",
                "points": [
                    {"date": measurement_date.isoformat(), "amount": float(amount)}
                    for measurement_date, amount in points
                ],
            }
        )
        obs_points = observations.get(acct_id, [])
        if obs_points:
            datasets.append(
                {
                    "account_id": acct_id,
                    "label": f"{name} — observed",
                    "color": color,
                    "kind": "observed",
                    "points": [
                        {
                            "date": as_of.isoformat(),
                            "amount": float(amount),
                        }
                        for as_of, amount in obs_points
                    ],
                }
            )
        drift_points = drift.get(acct_id, [])
        if drift_points:
            datasets.append(
                {
                    "account_id": acct_id,
                    "label": f"{name} — drift",
                    "color": color,
                    "kind": "drift",
                    "points": [
                        {
                            "date": as_of.isoformat(),
                            "amount": float(drift) if drift is not None else None,
                            "observed": float(observed),
                            "computed": float(computed) if computed is not None else None,
                        }
                        for as_of, observed, computed, drift in drift_points
                    ],
                }
            )

    if include_total and len(account_ids) > 1:
        totals: dict[date, Decimal] = {}
        for acct_id in account_ids:
            for measurement_date, amount in series.get(acct_id, []):
                totals[measurement_date] = totals.get(measurement_date, Decimal("0")) + amount
        datasets.append(
            {
                "account_id": 0,
                "label": "Total",
                "color": "#111827",
                "kind": "computed",
                "points": [
                    {"date": day.isoformat(), "amount": float(totals[day])}
                    for day in sorted(totals)
                ],
            }
        )

    return {
        "start": start.isoformat() if start else None,
        "end": end.isoformat() if end else None,
        "datasets": datasets,
    }


@router.post("/api/balances/observations")
def create_balance_observation(
    db: Session = Depends(get_db),
    account_id: int = Form(...),
    as_of_date: str = Form(...),
    amount: str = Form(...),
) -> dict:
    account = db.get(Account, account_id)
    if account is None or account.id <= 0:
        raise HTTPException(status_code=404, detail="Account not found")
    try:
        observation_date = parse_calendar_date(as_of_date)
    except ValueError as exc:
        raise HTTPException(
            status_code=400,
            detail="Balance date must be a calendar date (YYYY-MM-DD), not a datetime",
        ) from exc
    try:
        parsed_amount = Decimal(amount.strip().replace(",", ""))
    except (InvalidOperation, AttributeError) as exc:
        raise HTTPException(status_code=400, detail="Invalid amount") from exc
    if observation_date > local_today():
        raise HTTPException(status_code=400, detail="Balance date cannot be in the future")

    observation = record_balance_observation(
        db,
        account_id,
        observation_date,
        parsed_amount,
        commit=True,
    )
    recompute_daily_balances(db, account_id=account_id, commit=True)
    return {
        "id": observation.id,
        "account_id": observation.account_id,
        "as_of_date": observation.as_of_date.isoformat(),
        "amount": float(observation.amount),
    }
