from decimal import Decimal
from pathlib import Path

import pytest

from app.services.csv_import import (
    CsvImportError,
    detect_column_mapping,
    parse_csv_rows,
    parse_amount,
    parse_date,
)


FIXTURES = Path(__file__).parent / "fixtures"


def test_detect_simple_bank_headers():
    mapping = detect_column_mapping(["Date", "Description", "Amount"])
    assert mapping is not None
    assert mapping.transaction_date == "Date"
    assert mapping.description == "Description"
    assert mapping.amount == "Amount"


def test_detect_chase_style_headers():
    mapping = detect_column_mapping(
        ["Transaction Date", "Post Date", "Description", "Category", "Type", "Amount", "Memo"]
    )
    assert mapping is not None
    assert mapping.transaction_date == "Transaction Date"
    assert mapping.amount == "Amount"
    assert mapping.description == "Description"
    assert mapping.category == "Category"


def test_parse_bank_download_fixture():
    content = (FIXTURES / "bank_download.csv").read_bytes()
    mapping, rows, region = parse_csv_rows(content)
    assert mapping.transaction_date == "Date"
    assert len(rows) == 3
    assert rows[0].amount == Decimal("-4.50")
    assert rows[1].amount == Decimal("2500.00")
    assert region.skipped_top == 0
    assert region.skipped_bottom == 0


def test_parse_fluffy_bank_download_skips_title_and_footer():
    content = (FIXTURES / "bank_download_fluffy.csv").read_bytes()
    mapping, rows, region = parse_csv_rows(content)
    assert mapping.transaction_date == "Date"
    assert len(rows) == 3
    assert region.header_line == 5
    assert region.skipped_top == 4
    assert region.skipped_bottom == 3
    assert rows[-1].bank_orig_description == "AMAZON MARKETPLACE"


def test_parse_chase_download_fixture():
    content = (FIXTURES / "chase_download.csv").read_bytes()
    mapping, rows, region = parse_csv_rows(content)
    assert mapping.transaction_date == "Transaction Date"
    assert len(rows) == 2
    assert rows[0].import_category == "Food & Drink"


def test_column_overrides():
    content = (FIXTURES / "chase_download.csv").read_bytes()
    mapping, rows, _region = parse_csv_rows(
        content,
        column_overrides={
            "transaction_date": "Post Date",
            "amount": "Amount",
            "description": "Description",
        },
    )
    assert mapping.transaction_date == "Post Date"
    assert rows[0].transaction_date.isoformat() == "2026-07-11"
    assert len(rows) == 2


def test_parse_amount_parentheses():
    assert parse_amount("(12.34)") == Decimal("-12.34")


def test_parse_date_iso():
    assert parse_date("2026-07-10").isoformat() == "2026-07-10"


def test_missing_required_columns_raises():
    with pytest.raises(CsvImportError):
        parse_csv_rows(b"Account summary\nfoo,bar\n1,2\n")


def test_fixed_width_text_file_rejected():
    content = b"""Description                                                                         Summary Amt.
Beginning balance as of 01/01/2026                                                     20,279.93

Date        Description                                                                   Amount  Running Bal.
01/02/2026  COFFEE SHOP                                                                  -4.50     100.00
"""
    with pytest.raises(CsvImportError, match="does not look like a delimited export"):
        parse_csv_rows(content)


def test_footer_stops_data_collection():
    content = b"""Title line
Date,Description,Amount
07/10/2026,COFFEE,-1.00
Total transactions: 1
"""
    _mapping, rows, region = parse_csv_rows(content)
    assert len(rows) == 1
    assert region.skipped_bottom == 1
