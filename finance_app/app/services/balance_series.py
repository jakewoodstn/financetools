"""Set-based daily balance series, observations, and drift reporting."""

from __future__ import annotations

from dataclasses import dataclass
from datetime import date, datetime, timezone
from decimal import Decimal

from sqlalchemy import delete, func, select, text
from sqlalchemy.dialects.postgresql import insert
from sqlalchemy.orm import Session

from app.models import BalanceAnchor, BalanceObservation, BankTransaction, DailyBalance
from app.services.calendar_dates import local_today

DRIFT_TOLERANCE = Decimal("0.01")
SOURCE_SIMPLEFIN = "simplefin"
SOURCE_LEGACY = "legacy"
SOURCE_MANUAL = "manual"
SOURCE_CSV = "csv"


@dataclass
class DriftRow:
    account_id: int
    as_of_date: date
    source: str
    observed: Decimal
    computed: Decimal | None
    drift: Decimal | None


@dataclass
class BalanceReconciliation:
    account_id: int
    as_of_date: date
    observed: Decimal
    computed: Decimal | None
    drift: Decimal | None
    holds: bool


def record_balance_observation(
    db: Session,
    account_id: int,
    as_of_date: date,
    amount: Decimal,
    source: str,
    *,
    observed_at: datetime | None = None,
    commit: bool = True,
) -> BalanceObservation:
    observed_at = observed_at or datetime.now(timezone.utc).replace(tzinfo=None)
    stmt = (
        insert(BalanceObservation)
        .values(
            account_id=account_id,
            as_of_date=as_of_date,
            amount=amount,
            source=source,
            observed_at=observed_at,
        )
        .on_conflict_do_update(
            constraint="uq_balance_observations_account_date_source",
            set_={
                "amount": amount,
                "observed_at": observed_at,
            },
        )
        .returning(BalanceObservation.id)
    )
    row_id = db.execute(stmt).scalar_one()
    if commit:
        db.commit()
    return db.get(BalanceObservation, row_id)  # type: ignore[return-value]


def _earliest_anchor(db: Session, account_id: int) -> BalanceAnchor | None:
    return db.scalar(
        select(BalanceAnchor)
        .where(BalanceAnchor.account_id == account_id)
        .order_by(BalanceAnchor.as_of_date.asc())
        .limit(1)
    )


def recompute_daily_balances(
    db: Session,
    account_id: int | None = None,
    *,
    commit: bool = True,
) -> int:
    """Rebuild daily_balances from earliest anchor + cumulative transaction sums.

    Anchor amount is end-of-day on as_of_date; transactions on that day are already
    included. Running totals add sums for dates strictly after the anchor.
    """
    if account_id is not None:
        account_ids = [account_id]
    else:
        account_ids = list(
            db.scalars(select(BalanceAnchor.account_id).distinct().order_by(BalanceAnchor.account_id)).all()
        )

    total_rows = 0
    today = local_today()
    for acct_id in account_ids:
        anchor = _earliest_anchor(db, acct_id)
        if anchor is None:
            db.execute(delete(DailyBalance).where(DailyBalance.account_id == acct_id))
            continue

        max_txn = db.scalar(
            select(func.max(BankTransaction.transaction_date)).where(
                BankTransaction.account_id == acct_id
            )
        )
        end_date = max(filter(None, [max_txn, today, anchor.as_of_date]))

        db.execute(delete(DailyBalance).where(DailyBalance.account_id == acct_id))
        result = db.execute(
            text(
                """
                INSERT INTO daily_balances (account_id, measurement_date, amount)
                SELECT
                    :account_id AS account_id,
                    days.d AS measurement_date,
                    CAST(:anchor_amount AS numeric)
                      + COALESCE(
                          SUM(COALESCE(daily.day_total, 0)) OVER (
                              ORDER BY days.d
                              ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
                          ),
                          0
                      ) AS amount
                FROM generate_series(
                    CAST(:anchor_date AS date),
                    CAST(:end_date AS date),
                    interval '1 day'
                ) AS days(d)
                LEFT JOIN (
                    SELECT
                        transaction_date,
                        COALESCE(SUM(amount), 0) AS day_total
                    FROM bank_transactions
                    WHERE account_id = :account_id
                      AND transaction_date > CAST(:anchor_date AS date)
                      AND transaction_date <= CAST(:end_date AS date)
                    GROUP BY transaction_date
                ) AS daily ON daily.transaction_date = days.d
                """
            ),
            {
                "account_id": acct_id,
                "anchor_date": anchor.as_of_date,
                "anchor_amount": anchor.amount,
                "end_date": end_date,
            },
        )
        total_rows += result.rowcount or 0

    if commit:
        db.commit()
    return total_rows


def computed_balance_on(db: Session, account_id: int, as_of_date: date) -> Decimal | None:
    """Balance as of a date: latest computed value on or before it (carry-forward)."""
    return db.scalar(
        select(DailyBalance.amount)
        .where(
            DailyBalance.account_id == account_id,
            DailyBalance.measurement_date <= as_of_date,
        )
        .order_by(DailyBalance.measurement_date.desc())
        .limit(1)
    )


def reconcile_observation(
    db: Session,
    account_id: int,
    as_of_date: date,
    observed: Decimal,
) -> BalanceReconciliation:
    computed = computed_balance_on(db, account_id, as_of_date)
    drift = None if computed is None else (observed - computed)
    holds = drift is not None and abs(drift) <= DRIFT_TOLERANCE
    return BalanceReconciliation(
        account_id=account_id,
        as_of_date=as_of_date,
        observed=observed,
        computed=computed,
        drift=drift,
        holds=holds,
    )


def drift_series(
    db: Session,
    *,
    account_ids: list[int] | None = None,
    start: date | None = None,
    end: date | None = None,
) -> dict[int, list[tuple[date, str, Decimal, Decimal | None, Decimal | None]]]:
    """Per-account (date, source, observed, computed, drift) with carry-forward computed."""
    computed_carry_forward = (
        select(DailyBalance.amount)
        .where(
            DailyBalance.account_id == BalanceObservation.account_id,
            DailyBalance.measurement_date <= BalanceObservation.as_of_date,
        )
        .order_by(DailyBalance.measurement_date.desc())
        .limit(1)
        .correlate(BalanceObservation)
        .scalar_subquery()
    )
    query = select(
        BalanceObservation.account_id,
        BalanceObservation.as_of_date,
        BalanceObservation.source,
        BalanceObservation.amount,
        computed_carry_forward.label("computed"),
    ).order_by(BalanceObservation.account_id, BalanceObservation.as_of_date)
    if account_ids:
        query = query.where(BalanceObservation.account_id.in_(account_ids))
    if start is not None:
        query = query.where(BalanceObservation.as_of_date >= start)
    if end is not None:
        query = query.where(BalanceObservation.as_of_date <= end)

    result: dict[int, list[tuple[date, str, Decimal, Decimal | None, Decimal | None]]] = {}
    for acct_id, as_of, source, observed, computed in db.execute(query).all():
        drift = None if computed is None else (observed - computed)
        result.setdefault(acct_id, []).append((as_of, source, observed, computed, drift))
    return result


def drift_report(db: Session, account_id: int | None = None) -> list[DriftRow]:
    computed_carry_forward = (
        select(DailyBalance.amount)
        .where(
            DailyBalance.account_id == BalanceObservation.account_id,
            DailyBalance.measurement_date <= BalanceObservation.as_of_date,
        )
        .order_by(DailyBalance.measurement_date.desc())
        .limit(1)
        .correlate(BalanceObservation)
        .scalar_subquery()
    )
    query = select(
        BalanceObservation.account_id,
        BalanceObservation.as_of_date,
        BalanceObservation.source,
        BalanceObservation.amount,
        computed_carry_forward.label("computed"),
    ).order_by(BalanceObservation.as_of_date.desc(), BalanceObservation.account_id)
    if account_id is not None:
        query = query.where(BalanceObservation.account_id == account_id)

    rows: list[DriftRow] = []
    for acct_id, as_of, source, observed, computed in db.execute(query).all():
        drift = None if computed is None else (observed - computed)
        rows.append(
            DriftRow(
                account_id=acct_id,
                as_of_date=as_of,
                source=source,
                observed=observed,
                computed=computed,
                drift=drift,
            )
        )
    return rows


def latest_observations(db: Session) -> dict[int, tuple[date, Decimal]]:
    """Latest observation per account by as_of_date (then observed_at)."""
    ranked = (
        select(
            BalanceObservation.account_id,
            BalanceObservation.as_of_date,
            BalanceObservation.amount,
            func.row_number()
            .over(
                partition_by=BalanceObservation.account_id,
                order_by=(
                    BalanceObservation.as_of_date.desc(),
                    BalanceObservation.observed_at.desc(),
                    BalanceObservation.id.desc(),
                ),
            )
            .label("rn"),
        )
        .subquery()
    )
    rows = db.execute(
        select(ranked.c.account_id, ranked.c.as_of_date, ranked.c.amount).where(ranked.c.rn == 1)
    ).all()
    return {account_id: (as_of_date, amount) for account_id, as_of_date, amount in rows}


def balance_series(
    db: Session,
    *,
    account_ids: list[int] | None = None,
    start: date | None = None,
    end: date | None = None,
) -> dict[int, list[tuple[date, Decimal]]]:
    query = select(
        DailyBalance.account_id,
        DailyBalance.measurement_date,
        DailyBalance.amount,
    ).order_by(DailyBalance.account_id, DailyBalance.measurement_date)
    if account_ids:
        query = query.where(DailyBalance.account_id.in_(account_ids))
    if start is not None:
        query = query.where(DailyBalance.measurement_date >= start)
    if end is not None:
        query = query.where(DailyBalance.measurement_date <= end)

    series: dict[int, list[tuple[date, Decimal]]] = {}
    for acct_id, measurement_date, amount in db.execute(query).all():
        series.setdefault(acct_id, []).append((measurement_date, amount))
    return series


def observations_in_range(
    db: Session,
    *,
    account_ids: list[int] | None = None,
    start: date | None = None,
    end: date | None = None,
) -> dict[int, list[tuple[date, Decimal, str]]]:
    query = select(
        BalanceObservation.account_id,
        BalanceObservation.as_of_date,
        BalanceObservation.amount,
        BalanceObservation.source,
    ).order_by(BalanceObservation.account_id, BalanceObservation.as_of_date)
    if account_ids:
        query = query.where(BalanceObservation.account_id.in_(account_ids))
    if start is not None:
        query = query.where(BalanceObservation.as_of_date >= start)
    if end is not None:
        query = query.where(BalanceObservation.as_of_date <= end)

    result: dict[int, list[tuple[date, Decimal, str]]] = {}
    for acct_id, as_of, amount, source in db.execute(query).all():
        result.setdefault(acct_id, []).append((as_of, amount, source))
    return result
