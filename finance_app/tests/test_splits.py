from decimal import Decimal
from unittest.mock import MagicMock

import pytest

from app.services.splits import (
    SPLIT_CATEGORY_ID,
    SplitBalanceError,
    _validate_balance,
    clear_splits,
    get_splits,
    replace_splits,
)


def test_validate_balance_ok():
    _validate_balance(
        Decimal("-100.00"),
        [(1, Decimal("-40.00")), (2, Decimal("-60.00"))],
    )


def test_validate_balance_rejects_mismatch():
    with pytest.raises(SplitBalanceError):
        _validate_balance(
            Decimal("-100.00"),
            [(1, Decimal("-40.00")), (2, Decimal("-50.00"))],
        )


def test_validate_balance_needs_two_lines():
    with pytest.raises(SplitBalanceError):
        _validate_balance(Decimal("-10.00"), [(1, Decimal("-10.00"))])


def test_get_splits_missing_txn():
    db = MagicMock()
    db.scalar.return_value = None
    assert get_splits(db, 999) is None


def test_replace_splits_missing_txn():
    db = MagicMock()
    db.scalar.return_value = None
    with pytest.raises(LookupError):
        replace_splits(
            db,
            external_id=1,
            lines=[
                {"category_id": 1, "split_amount": "-1"},
                {"category_id": 2, "split_amount": "-1"},
            ],
            commit=False,
        )


def test_clear_splits_sets_parent_uncategorized():
    txn = MagicMock()
    txn.id = 10
    txn.external_id = 100
    txn.spending_category_id = SPLIT_CATEGORY_ID
    split_row = MagicMock()
    split_row.id = 5

    db = MagicMock()
    db.scalar.return_value = txn
    db.scalars.return_value.all.return_value = [split_row]

    assert clear_splits(db, external_id=100, commit=False) is True
    assert txn.spending_category_id is None
    db.delete.assert_called_once_with(split_row)
