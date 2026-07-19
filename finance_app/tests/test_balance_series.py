from datetime import date
from decimal import Decimal
from unittest.mock import MagicMock

from app.services.balance_series import (
    DRIFT_TOLERANCE,
    BalanceReconciliation,
    reconcile_observation,
)


def test_reconcile_observation_holds_within_tolerance():
    db = MagicMock()
    db.scalar.return_value = Decimal("100.00")
    result = reconcile_observation(db, 1, date(2026, 7, 18), Decimal("100.005"))
    assert isinstance(result, BalanceReconciliation)
    assert result.holds
    assert abs(result.drift) <= DRIFT_TOLERANCE


def test_reconcile_observation_reports_drift():
    db = MagicMock()
    db.scalar.return_value = Decimal("100.00")
    result = reconcile_observation(db, 1, date(2026, 7, 18), Decimal("105.00"))
    assert not result.holds
    assert result.observed == Decimal("105.00")
    assert result.computed == Decimal("100.00")
    assert result.drift == Decimal("5.00")


def test_reconcile_observation_missing_computed():
    db = MagicMock()
    db.scalar.return_value = None
    result = reconcile_observation(db, 1, date(2026, 7, 18), Decimal("50.00"))
    assert not result.holds
    assert result.computed is None
    assert result.drift is None


def test_record_balance_observation_uses_upsert_constraint():
    from app.services.balance_series import record_balance_observation

    db = MagicMock()
    db.execute.return_value.scalar_one.return_value = 9
    obs = MagicMock()
    db.get.return_value = obs

    result = record_balance_observation(
        db,
        account_id=1,
        as_of_date=date(2026, 7, 18),
        amount=Decimal("12.34"),
        source="simplefin",
        commit=False,
    )
    assert result is obs
    statement = db.execute.call_args.args[0]
    compiled = str(statement.compile(compile_kwargs={"literal_binds": False}))
    assert "balance_observations" in compiled.lower() or "BalanceObservation" in type(statement).__name__
