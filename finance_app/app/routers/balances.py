"""Account balance chart page and series API."""

from __future__ import annotations

from datetime import date, timedelta
from decimal import Decimal
from pathlib import Path

from fastapi import APIRouter, Depends, Query, Request
from fastapi.templating import Jinja2Templates
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.database import get_db
from app.models import Account
from app.services.balance_series import (
    DRIFT_TOLERANCE,
    balance_series,
    drift_report,
    drift_series,
    observations_in_range,
)

router = APIRouter(tags=["balances"])
templates = Jinja2Templates(directory=str(Path(__file__).resolve().parent.parent / "templates"))

CHART_COLORS = [
    "#1d4ed8",
    "#b45309",
    "#166534",
    "#7c3aed",
    "#be123c",
    "#0f766e",
]


def _parse_account_ids(account: list[int] | None) -> list[int] | None:
    if not account:
        return None
    return [int(value) for value in account]


@router.get("/balances")
def balances_page(
    request: Request,
    db: Session = Depends(get_db),
):
    accounts = db.execute(select(Account).where(Account.id > 0).order_by(Account.id)).scalars().all()
    end = date.today()
    start = end - timedelta(days=365)
    drift_rows = drift_report(db)
    recent_drift = [
        row
        for row in drift_rows
        if row.drift is None or abs(row.drift) > DRIFT_TOLERANCE
    ][:50]
    return templates.TemplateResponse(
        request=request,
        name="balances.html",
        context={
            "accounts": accounts,
            "start_default": start.isoformat(),
            "end_default": end.isoformat(),
            "drift_rows": recent_drift,
            "drift_tolerance": DRIFT_TOLERANCE,
        },
    )


@router.get("/api/balances")
def balances_api(
    db: Session = Depends(get_db),
    account: list[int] | None = Query(default=None),
    start: date | None = Query(default=None),
    end: date | None = Query(default=None),
    include_total: bool = Query(default=True),
) -> dict:
    account_ids = _parse_account_ids(account)
    if account_ids is None:
        account_ids = list(
            db.scalars(select(Account.id).where(Account.id > 0).order_by(Account.id)).all()
        )

    names = dict(
        db.execute(
            select(Account.id, Account.account_name).where(Account.id.in_(account_ids))
        ).all()
    )
    series = balance_series(db, account_ids=account_ids, start=start, end=end)
    observations = observations_in_range(db, account_ids=account_ids, start=start, end=end)
    drift = drift_series(db, account_ids=account_ids, start=start, end=end)

    datasets = []
    for idx, acct_id in enumerate(account_ids):
        color = CHART_COLORS[idx % len(CHART_COLORS)]
        name = names.get(acct_id) or f"Account {acct_id}"
        points = series.get(acct_id, [])
        datasets.append(
            {
                "account_id": acct_id,
                "label": f"{name} — computed (txns)",
                "color": color,
                "kind": "series",
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
                    "label": f"{name} — confirmed balance",
                    "color": color,
                    "kind": "observation",
                    "points": [
                        {
                            "date": as_of.isoformat(),
                            "amount": float(amount),
                            "source": source,
                        }
                        for as_of, amount, source in obs_points
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
                            "source": source,
                            "observed": float(observed),
                            "computed": float(computed) if computed is not None else None,
                        }
                        for as_of, source, observed, computed, drift in drift_points
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
                "kind": "series",
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
