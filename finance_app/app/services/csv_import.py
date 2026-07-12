"""Parse bank CSV downloads with header synonym mapping."""

from __future__ import annotations

import csv
import io
import re
from dataclasses import dataclass
from datetime import date, datetime
from decimal import Decimal, InvalidOperation

CANONICAL_FIELDS = ("transaction_date", "amount", "description", "category")

FIELD_SYNONYMS: dict[str, tuple[str, ...]] = {
    "transaction_date": (
        "date",
        "transaction date",
        "trans date",
        "posted date",
        "posting date",
        "post date",
        "posted",
    ),
    "amount": (
        "amount",
        "transaction amount",
        "amt",
        "debit/credit",
        "debit credit",
    ),
    "description": (
        "description",
        "payee",
        "memo",
        "name",
        "transaction description",
        "details",
        "merchant",
    ),
    "category": (
        "category",
        "type",
        "transaction type",
    ),
}

FOOTER_PREFIXES = (
    "total",
    "totals",
    "summary",
    "beginning balance",
    "ending balance",
    "opening balance",
    "closing balance",
    "available balance",
    "account number",
    "downloaded",
    "exported",
    "generated on",
    "report generated",
    "disclaimer",
    "note:",
    "notes:",
    "page ",
)

DATE_FORMATS = (
    "%Y-%m-%d",
    "%m/%d/%Y",
    "%m/%d/%y",
    "%m-%d-%Y",
    "%m-%d-%y",
    "%Y/%m/%d",
    "%d/%m/%Y",
)


class CsvImportError(Exception):
    """CSV parse or mapping error."""


NOT_DELIMITED_MESSAGE = (
    "This file does not look like a delimited export (no comma- or tab-separated columns). "
    "Re-export from your bank as CSV, or save as .csv with separate columns for date, description, and amount."
)

NO_HEADER_MESSAGE = (
    "Could not find a header row with separate date, amount, and description columns. "
    "The file may be a fixed-width statement rather than CSV — re-export as delimited CSV, "
    "or set column overrides if the headers use unusual names."
)


@dataclass(frozen=True)
class ColumnMapping:
    transaction_date: str
    amount: str
    description: str
    category: str | None = None

    def as_dict(self) -> dict[str, str]:
        mapping = {
            "transaction_date": self.transaction_date,
            "amount": self.amount,
            "description": self.description,
        }
        if self.category:
            mapping["category"] = self.category
        return mapping


@dataclass(frozen=True)
class CsvRow:
    transaction_date: date
    amount: Decimal
    bank_orig_description: str
    import_category: str | None = None


@dataclass(frozen=True)
class CsvTableRegion:
    """Where transaction data lives inside a noisy bank export."""

    header_line: int
    first_data_line: int
    last_data_line: int
    skipped_top: int
    skipped_bottom: int


def normalize_header(header: str) -> str:
    return re.sub(r"\s+", " ", header.strip().lower())


def _score_header(header: str, synonyms: tuple[str, ...]) -> int:
    normalized = normalize_header(header)
    if normalized in synonyms:
        return 100
    best = 0
    for synonym in synonyms:
        if synonym in normalized or normalized in synonym:
            best = max(best, 60)
        synonym_tokens = synonym.split()
        header_tokens = normalized.split()
        overlap = len(set(synonym_tokens) & set(header_tokens))
        if overlap:
            best = max(best, 20 * overlap)
    return best


def detect_column_mapping(headers: list[str]) -> ColumnMapping | None:
    """Map file headers to canonical fields using synonyms. Returns None if required fields missing."""
    cleaned = [header.strip() for header in headers if header and header.strip()]
    if not cleaned:
        return None

    chosen: dict[str, str] = {}
    used: set[str] = set()
    for field in CANONICAL_FIELDS:
        if field == "category":
            continue
        best_header = None
        best_score = 0
        for header in cleaned:
            if header in used:
                continue
            score = _score_header(header, FIELD_SYNONYMS[field])
            if score > best_score:
                best_score = score
                best_header = header
        if best_header is None or best_score < 20:
            return None
        chosen[field] = best_header
        used.add(best_header)

    category_header = None
    best_score = 0
    for header in cleaned:
        if header in used:
            continue
        score = _score_header(header, FIELD_SYNONYMS["category"])
        if score > best_score:
            best_score = score
            category_header = header
    if category_header and best_score >= 20:
        chosen["category"] = category_header

    return ColumnMapping(
        transaction_date=chosen["transaction_date"],
        amount=chosen["amount"],
        description=chosen["description"],
        category=chosen.get("category"),
    )


def resolve_column_mapping(
    headers: list[str],
    *,
    overrides: dict[str, str | None] | None = None,
) -> ColumnMapping:
    overrides = overrides or {}
    explicit = {
        field: overrides.get(field)
        for field in CANONICAL_FIELDS
        if overrides.get(field)
    }
    if {"transaction_date", "amount", "description"} <= set(explicit):
        for header in explicit.values():
            if header not in headers:
                raise CsvImportError(f"Column '{header}' not found in file headers: {headers}")
        return ColumnMapping(
            transaction_date=explicit["transaction_date"],  # type: ignore[arg-type]
            amount=explicit["amount"],  # type: ignore[arg-type]
            description=explicit["description"],  # type: ignore[arg-type]
            category=explicit.get("category"),
        )

    detected = detect_column_mapping(headers)
    if detected is None:
        raise CsvImportError(
            "Could not map required columns (date, amount, description). "
            f"Found headers: {headers}. Use the column overrides on the form."
        )
    return detected


def try_parse_date(value: str) -> date | None:
    text = value.strip()
    if not text:
        return None
    for fmt in DATE_FORMATS:
        try:
            return datetime.strptime(text, fmt).date()
        except ValueError:
            continue
    return None


def parse_date(value: str) -> date:
    parsed = try_parse_date(value)
    if parsed is None:
        raise CsvImportError(f"Unrecognized date format: {value!r}")
    return parsed


def try_parse_amount(value: str) -> Decimal | None:
    text = value.strip()
    if not text:
        return None
    negative = False
    if text.startswith("(") and text.endswith(")"):
        negative = True
        text = text[1:-1]
    cleaned = (
        text.replace("$", "")
        .replace(",", "")
        .replace("+", "")
        .strip()
    )
    if not cleaned or cleaned in {"-", "--"}:
        return None
    if cleaned.startswith("-"):
        negative = True
        cleaned = cleaned[1:].strip()
    try:
        amount = Decimal(cleaned)
    except InvalidOperation:
        return None
    if negative and amount > 0:
        amount = -amount
    return amount


def parse_amount(value: str) -> Decimal:
    parsed = try_parse_amount(value)
    if parsed is None:
        raise CsvImportError(f"Invalid amount: {value!r}")
    return parsed


def decode_csv_text(content: bytes) -> str:
    try:
        return content.decode("utf-8-sig")
    except UnicodeDecodeError as exc:
        raise CsvImportError("CSV must be UTF-8 text") from exc


def read_raw_csv_rows(text: str) -> list[list[str]]:
    return list(csv.reader(io.StringIO(text)))


def _non_empty_lines(text: str, limit: int = 30) -> list[str]:
    return [line for line in text.splitlines() if line.strip()][:limit]


def looks_like_space_aligned_columns(text: str) -> bool:
    """True when column titles appear on one line but csv.reader sees a single field."""
    for line in _non_empty_lines(text, 20):
        lower = line.lower()
        if "date" not in lower or "description" not in lower or "amount" not in lower:
            continue
        row = next(csv.reader(io.StringIO(line)))
        if len(row) <= 1:
            return True
    return False


def rows_look_like_single_column(rows: list[list[str]]) -> bool:
    """True when csv.reader produced one field per line (typical of fixed-width text)."""
    sample = [row for row in rows[:30] if any(cell.strip() for cell in row)]
    if len(sample) < 2:
        return False
    return all(len(row) <= 1 for row in sample)


def assert_delimited_export(text: str, rows: list[list[str]]) -> None:
    if looks_like_space_aligned_columns(text) or rows_look_like_single_column(rows):
        raise CsvImportError(NOT_DELIMITED_MESSAGE)


def is_blank_row(row: list[str]) -> bool:
    return not any(cell.strip() for cell in row)


def row_as_dict(headers: list[str], row: list[str]) -> dict[str, str]:
    values = list(row) + [""] * max(0, len(headers) - len(row))
    return {header: (values[index] or "").strip() for index, header in enumerate(headers)}


def is_footer_row(row: list[str]) -> bool:
    non_empty = [cell.strip() for cell in row if cell.strip()]
    if not non_empty:
        return True
    first = non_empty[0].lower()
    joined = " ".join(non_empty).lower()
    return any(
        first.startswith(prefix) or joined.startswith(prefix) for prefix in FOOTER_PREFIXES
    )


def looks_like_data_row(row_dict: dict[str, str], mapping: ColumnMapping) -> bool:
    date_value = row_dict.get(mapping.transaction_date, "")
    amount_value = row_dict.get(mapping.amount, "")
    description = row_dict.get(mapping.description, "").strip()
    if try_parse_date(date_value) is None:
        return False
    if try_parse_amount(amount_value) is None:
        return False
    return bool(description)


def _find_header_row(
    rows: list[list[str]],
    *,
    column_overrides: dict[str, str | None] | None = None,
) -> tuple[int, list[str], ColumnMapping]:
    overrides = column_overrides or {}
    explicit_headers = [overrides[field] for field in CANONICAL_FIELDS if overrides.get(field)]

    if len(explicit_headers) >= 3:
        required = {
            overrides["transaction_date"],
            overrides["amount"],
            overrides["description"],
        }
        for index, row in enumerate(rows):
            headers = [cell.strip() for cell in row]
            if required <= set(headers):
                mapping = resolve_column_mapping(headers, overrides=overrides)
                return index, headers, mapping
        raise CsvImportError(
            "Could not find a header row containing override columns: "
            f"{sorted(required)}"
        )

    for index, row in enumerate(rows):
        headers = [cell.strip() for cell in row]
        mapping = detect_column_mapping(headers)
        if mapping is not None:
            return index, headers, mapping

    raise CsvImportError(NO_HEADER_MESSAGE)


def locate_csv_table(
    content: bytes,
    *,
    column_overrides: dict[str, str | None] | None = None,
) -> tuple[list[str], list[dict[str, str]], ColumnMapping, CsvTableRegion]:
    """Find the data table inside a bank CSV, skipping title and footer fluff."""
    text = decode_csv_text(content)
    rows = read_raw_csv_rows(text)
    if not rows:
        raise CsvImportError("Uploaded file is empty")

    assert_delimited_export(text, rows)

    try:
        header_index, headers, mapping = _find_header_row(rows, column_overrides=column_overrides)
    except CsvImportError:
        if looks_like_space_aligned_columns(text) or rows_look_like_single_column(rows):
            raise CsvImportError(NOT_DELIMITED_MESSAGE) from None
        raise
    data_rows: list[dict[str, str]] = []
    last_data_index = header_index

    for index in range(header_index + 1, len(rows)):
        row = rows[index]
        if is_blank_row(row):
            break
        row_dict = row_as_dict(headers, row)
        if is_footer_row(row):
            break
        if not looks_like_data_row(row_dict, mapping):
            if data_rows:
                break
            continue
        data_rows.append(row_dict)
        last_data_index = index

    if not data_rows:
        raise CsvImportError("No transaction rows found after header (file may be title/footer only)")

    skipped_bottom = max(0, len(rows) - last_data_index - 1)
    region = CsvTableRegion(
        header_line=header_index + 1,
        first_data_line=header_index + 2,
        last_data_line=last_data_index + 1,
        skipped_top=header_index,
        skipped_bottom=skipped_bottom,
    )
    return headers, data_rows, mapping, region


def read_csv_table(content: bytes) -> tuple[list[str], list[dict[str, str]]]:
    headers, table, _, _ = locate_csv_table(content)
    return headers, table


def parse_csv_rows(
    content: bytes,
    *,
    column_overrides: dict[str, str | None] | None = None,
) -> tuple[ColumnMapping, list[CsvRow], CsvTableRegion]:
    _, table, mapping, region = locate_csv_table(content, column_overrides=column_overrides)
    parsed: list[CsvRow] = []
    for index, row in enumerate(table, start=region.first_data_line):
        try:
            txn_date = parse_date(row[mapping.transaction_date])
            amount = parse_amount(row[mapping.amount])
            description = row[mapping.description].strip()
            if not description:
                raise CsvImportError("empty description")
            category = None
            if mapping.category:
                category = row.get(mapping.category, "").strip() or None
            parsed.append(
                CsvRow(
                    transaction_date=txn_date,
                    amount=amount,
                    bank_orig_description=description,
                    import_category=category,
                )
            )
        except CsvImportError as exc:
            raise CsvImportError(f"Row {index}: {exc}") from exc
        except KeyError as exc:
            raise CsvImportError(f"Row {index}: missing column {exc}") from exc

    if not parsed:
        raise CsvImportError("CSV contains no data rows")
    return mapping, parsed, region
