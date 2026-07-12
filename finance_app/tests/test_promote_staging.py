from datetime import date, datetime, timezone
from decimal import Decimal

from app.services.ingest_staging import dedupe_hash
from app.services.promote_staging import (
    SIMPLEFIN_EXTERNAL_ID_BASE,
    LedgerRowSnapshot,
    bank_transaction_values,
    external_id_from_source,
    format_promote_conflict_message,
    snapshot_from_raw,
)


def test_external_id_from_source_stable():
    value = external_id_from_source("abc-123")
    assert value == external_id_from_source("abc-123")
    assert value >= SIMPLEFIN_EXTERNAL_ID_BASE


def test_external_id_from_source_differs_by_id():
    assert external_id_from_source("one") != external_id_from_source("two")


def test_bank_transaction_values_from_raw_fields():
    class Raw:
        transaction_date = date(2026, 7, 10)
        amount = Decimal("-12.34")
        bank_orig_description = "Coffee shop"
        import_category = None
        account_id = 1

    loaded_at = datetime(2026, 7, 11, 12, 0, tzinfo=timezone.utc).replace(tzinfo=None)
    values = bank_transaction_values(
        Raw(),  # type: ignore[arg-type]
        external_id=external_id_from_source("sf-1"),
        loaded_at=loaded_at,
    )
    assert values["description"] == "Coffee shop"
    assert values["accounting_date"] == date(2026, 7, 10)
    assert values["category_status"] == 0
    assert values["spending_category_id"] is None


def test_dedupe_hash_matches_promotion_tuple():
    h = dedupe_hash(3, date(2026, 7, 1), Decimal("10.00"), "Interest Paid")
    h2 = dedupe_hash(3, date(2026, 7, 1), Decimal("10.00"), "Interest Paid")
    assert h == h2


def test_promote_conflict_message_lists_incoming_and_existing_rows():
    incoming = LedgerRowSnapshot(
        source="raw_transactions",
        row_id=99,
        account_id=1,
        transaction_date=date(2026, 1, 2),
        amount=Decimal("-69.34"),
        bank_orig_description="TST*BURGER UP",
    )
    existing = [
        LedgerRowSnapshot(
            source="bank_transactions",
            row_id=10,
            account_id=1,
            transaction_date=date(2026, 1, 2),
            amount=Decimal("-69.34"),
            bank_orig_description="TST*BURGER UP",
            external_id=100001,
        ),
        LedgerRowSnapshot(
            source="bank_transactions",
            row_id=11,
            account_id=1,
            transaction_date=date(2026, 1, 2),
            amount=Decimal("-69.34"),
            bank_orig_description="TST*BURGER UP",
            external_id=100002,
        ),
    ]
    message = format_promote_conflict_message(incoming, existing)
    assert "Held for review" in message
    assert "Incoming:" in message
    assert "Existing:" in message
    assert "raw_transactions #99" in message
    assert "bank_transactions #10" in message
    assert "bank_transactions #11" in message
    assert "external_id=100001" in message


def test_snapshot_from_raw():
    class Raw:
        id = 42
        account_id = 4
        transaction_date = date(2026, 7, 10)
        amount = Decimal("1.00")
        bank_orig_description = "Coffee"

    snap = snapshot_from_raw(Raw())  # type: ignore[arg-type]
    assert snap.source == "raw_transactions"
    assert snap.row_id == 42
