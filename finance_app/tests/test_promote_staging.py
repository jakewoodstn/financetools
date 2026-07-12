from datetime import date, datetime, timezone
from decimal import Decimal

from app.services.ingest_staging import dedupe_hash
from app.services.promote_staging import (
    SIMPLEFIN_EXTERNAL_ID_BASE,
    bank_transaction_values,
    external_id_from_source,
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
