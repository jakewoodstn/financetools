"""Set-based daily balance series from observed truths, plus drift reporting.

Part A — observed: sparse documented end-of-day balances (one per account/date).
Part B — computed: regenerable daily series from the latest *prior* observation:

    balance(B) = observed(A).amount + SUM(txns where A < D <= B)

where A is the latest observation with as_of_date < B (strictly before).
On an observation day this can differ from the observed amount — that gap is drift.
After an observation, later days reseeds from that new truth.

The first observation day is seeded as computed = observed (no prior).
"""

from __future__ import annotations

from dataclasses import dataclass
from datetime import date, datetime, timezone
from decimal import Decimal

from sqlalchemy import delete, func, select, text
from sqlalchemy.dialects.postgresql import insert
from sqlalchemy.orm import Session

from app.models import BalanceObservation, BankTransaction, DailyBalance
from app.services.calendar_dates import local_today

DRIFT_TOLERANCE = Decimal("0.01")


@dataclass
class DriftRow:
    account_id: int
    as_of_date: date
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
            observed_at=observed_at,
        )
        .on_conflict_do_update(
            constraint="uq_balance_observations_account_date",
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


def _earliest_observation(db: Session, account_id: int) -> BalanceObservation | None:
    return db.scalar(
        select(BalanceObservation)
        .where(BalanceObservation.account_id == account_id)
        .order_by(BalanceObservation.as_of_date.asc())
        .limit(1)
    )


def prior_observation(
    db: Session,
    account_id: int,
    as_of_date: date,
) -> BalanceObservation | None:
    """Latest observed balance strictly before as_of_date."""
    return db.scalar(
        select(BalanceObservation)
        .where(
            BalanceObservation.account_id == account_id,
            BalanceObservation.as_of_date < as_of_date,
        )
        .order_by(BalanceObservation.as_of_date.desc())
        .limit(1)
    )


def expected_balance_from_prior(
    db: Session,
    account_id: int,
    as_of_date: date,
) -> Decimal | None:
    """Implied end-of-day balance on as_of_date from the prior observation.

    prior.amount + SUM(txns where prior.as_of_date < D <= as_of_date)
    """
    prior = prior_observation(db, account_id, as_of_date)
    if prior is None:
        return None
    txn_sum = db.scalar(
        select(func.coalesce(func.sum(BankTransaction.amount), 0)).where(
            BankTransaction.account_id == account_id,
            BankTransaction.transaction_date > prior.as_of_date,
            BankTransaction.transaction_date <= as_of_date,
        )
    )
    return prior.amount + (txn_sum or Decimal("0"))


def recompute_daily_balances(
    db: Session,
    account_id: int | None = None,
    *,
    commit: bool = True,
) -> int:
    """Rebuild daily_balances from observations + cumulative transaction sums.

    For each calendar day B, seed A is the latest observation with A < B:
        balance(B) = observed(A).amount + SUM(txns where A < D <= B)

    The first observation day is stored as computed = observed (no prior seed).
    """
    if account_id is not None:
        account_ids = [account_id]
    else:
        account_ids = list(
            db.scalars(
                select(BalanceObservation.account_id)
                .distinct()
                .order_by(BalanceObservation.account_id)
            ).all()
        )

    total_rows = 0
    today = local_today()
    for acct_id in account_ids:
        earliest = _earliest_observation(db, acct_id)
        if earliest is None:
            db.execute(delete(DailyBalance).where(DailyBalance.account_id == acct_id))
            continue

        max_txn = db.scalar(
            select(func.max(BankTransaction.transaction_date)).where(
                BankTransaction.account_id == acct_id
            )
        )
        end_date = max(filter(None, [max_txn, today, earliest.as_of_date]))

        db.execute(delete(DailyBalance).where(DailyBalance.account_id == acct_id))
        result = db.execute(
            text(
                """
                WITH obs AS (
                    SELECT
                        as_of_date AS seed_date,
                        amount AS seed_amount,
                        LEAD(as_of_date) OVER (ORDER BY as_of_date) AS next_date,
                        LAG(as_of_date) OVER (ORDER BY as_of_date) AS prev_date
                    FROM balance_observations
                    WHERE account_id = :account_id
                ),
                -- First observed day: computed starts at the observed amount.
                first_day AS (
                    SELECT seed_date AS measurement_date, seed_amount AS amount
                    FROM obs
                    WHERE prev_date IS NULL
                ),
                -- Each observation seeds the open interval after it through the
                -- next observation day (inclusive), or through end_date.
                segments AS (
                    SELECT
                        seed_date,
                        seed_amount,
                        (seed_date + INTERVAL '1 day')::date AS segment_start,
                        COALESCE(next_date, CAST(:end_date AS date)) AS segment_end
                    FROM obs
                ),
                days AS (
                    SELECT
                        s.seed_date,
                        s.seed_amount,
                        gs.d::date AS measurement_date
                    FROM segments s
                    CROSS JOIN LATERAL generate_series(
                        s.segment_start,
                        s.segment_end,
                        interval '1 day'
                    ) AS gs(d)
                    WHERE s.segment_end >= s.segment_start
                ),
                daily AS (
                    SELECT
                        transaction_date,
                        COALESCE(SUM(amount), 0) AS day_total
                    FROM bank_transactions
                    WHERE account_id = :account_id
                      AND transaction_date > (
                          SELECT MIN(as_of_date) FROM balance_observations
                          WHERE account_id = :account_id
                      )
                      AND transaction_date <= CAST(:end_date AS date)
                    GROUP BY transaction_date
                ),
                computed_days AS (
                    SELECT
                        days.measurement_date,
                        days.seed_amount
                          + COALESCE(
                              SUM(COALESCE(daily.day_total, 0)) OVER (
                                  PARTITION BY days.seed_date
                                  ORDER BY days.measurement_date
                                  ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
                              ),
                              0
                          ) AS amount
                    FROM days
                    LEFT JOIN daily
                      ON daily.transaction_date = days.measurement_date
                     AND daily.transaction_date > days.seed_date
                )
                INSERT INTO daily_balances (account_id, measurement_date, amount)
                SELECT :account_id, measurement_date, amount FROM first_day
                UNION ALL
                SELECT :account_id, measurement_date, amount FROM computed_days
                """
            ),
            {
                "account_id": acct_id,
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
    """Compare an observed balance to the implication from the prior observation."""
    computed = expected_balance_from_prior(db, account_id, as_of_date)
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
) -> dict[int, list[tuple[date, Decimal, Decimal | None, Decimal | None]]]:
    """Per-account (date, observed, computed_from_prior, drift) via set-based SQL."""
    from sqlalchemy import bindparam

    params: dict = {}
    filters: list[str] = []
    if account_ids:
        params["account_ids"] = list(account_ids)
        filters.append("o.account_id IN :account_ids")
    if start is not None:
        params["start"] = start
        filters.append("o.as_of_date >= :start")
    if end is not None:
        params["end"] = end
        filters.append("o.as_of_date <= :end")
    where_extra = (" AND " + " AND ".join(filters)) if filters else ""

    stmt = text(
        f"""
        WITH ordered AS (
            SELECT
                account_id,
                as_of_date,
                amount,
                LAG(as_of_date) OVER (
                    PARTITION BY account_id ORDER BY as_of_date
                ) AS prior_date,
                LAG(amount) OVER (
                    PARTITION BY account_id ORDER BY as_of_date
                ) AS prior_amount
            FROM balance_observations
        ),
        compared AS (
            SELECT
                o.account_id,
                o.as_of_date,
                o.amount AS observed,
                CASE
                    WHEN o.prior_date IS NULL THEN NULL
                    ELSE o.prior_amount + COALESCE((
                        SELECT SUM(t.amount)
                        FROM bank_transactions t
                        WHERE t.account_id = o.account_id
                          AND t.transaction_date > o.prior_date
                          AND t.transaction_date <= o.as_of_date
                    ), 0)
                END AS computed
            FROM ordered o
            WHERE true
              {where_extra}
        )
        SELECT
            account_id,
            as_of_date,
            observed,
            computed,
            CASE WHEN computed IS NULL THEN NULL ELSE observed - computed END AS drift
        FROM compared
        ORDER BY account_id, as_of_date
        """
    )
    if account_ids:
        stmt = stmt.bindparams(bindparam("account_ids", expanding=True))

    rows = db.execute(stmt, params).all()

    result: dict[int, list[tuple[date, Decimal, Decimal | None, Decimal | None]]] = {}
    for acct_id, as_of, observed, computed, drift in rows:
        result.setdefault(acct_id, []).append((as_of, observed, computed, drift))
    return result


def drift_report(db: Session, account_id: int | None = None) -> list[DriftRow]:
    series = drift_series(
        db,
        account_ids=[account_id] if account_id is not None else None,
    )
    rows: list[DriftRow] = []
    for acct_id, points in series.items():
        for as_of, observed, computed, drift in points:
            rows.append(
                DriftRow(
                    account_id=acct_id,
                    as_of_date=as_of,
                    observed=observed,
                    computed=computed,
                    drift=drift,
                )
            )
    rows.sort(key=lambda row: (row.as_of_date, row.account_id), reverse=True)
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
) -> dict[int, list[tuple[date, Decimal]]]:
    query = select(
        BalanceObservation.account_id,
        BalanceObservation.as_of_date,
        BalanceObservation.amount,
    ).order_by(BalanceObservation.account_id, BalanceObservation.as_of_date)
    if account_ids:
        query = query.where(BalanceObservation.account_id.in_(account_ids))
    if start is not None:
        query = query.where(BalanceObservation.as_of_date >= start)
    if end is not None:
        query = query.where(BalanceObservation.as_of_date <= end)

    result: dict[int, list[tuple[date, Decimal]]] = {}
    for acct_id, as_of, amount in db.execute(query).all():
        result.setdefault(acct_id, []).append((as_of, amount))
    return result
