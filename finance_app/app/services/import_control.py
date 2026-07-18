"""Per-account SimpleFIN import orchestration (experimental UI)."""

from __future__ import annotations

from dataclasses import dataclass
from datetime import date, datetime, timedelta
from typing import Literal

from sqlalchemy import func, select
from sqlalchemy.orm import Session

from app.config import settings
from app.models import Account, BankTransaction, ImportBatch, RawTransaction, TransactionAccount
from app.services.csv_import import CsvImportError, CsvTableRegion, parse_csv_rows
from app.services.ingest_staging import StageResult, stage_csv_rows, stage_simplefin_account
from app.services.promote_staging import (
    PROMOTION_STATUS_NEEDS_REVIEW,
    PromoteResult,
    promote_raw_transactions,
)
from app.services.simplefin import (
    SimpleFinError,
    api_errors,
    fetch_account_set,
    parse_accounts,
    validate_access_url,
)

# Verified SimpleFIN Bridge account name per accounts.id (see docs/database.md).
SIMPLEFIN_SOURCE_BY_ACCOUNT_ID: dict[int, str] = {
    1: "Adv Plus Banking- 8971 (8971)",
    2: "Rapid Rewards Priority (2985)",
    3: "Savings Account (8193)",
    4: "Money Market Savings Account (2395)",
}

ImportMode = Literal["merge", "replace"]


@dataclass
class RawSampleRow:
    transaction_date: date | None
    description: str


@dataclass
class ImportableAccount:
    id: int
    account_name: str | None
    import_transactions: int | None
    simplefin_source_name: str | None
    raw_staged_count: int
    needs_review_count: int = 0
    latest_import_at: datetime | None = None
    latest_transaction_date: date | None = None


@dataclass
class ImportRunResult:
    account_id: int
    account_name: str | None
    mode: ImportMode
    stage: StageResult
    promote: PromoteResult | None
    source: Literal["simplefin", "csv"] = "simplefin"
    start_date: date | None = None
    end_date: date | None = None
    simplefin_found: bool = True
    filename: str | None = None
    column_mapping: dict[str, str] | None = None
    csv_region: "CsvTableRegion | None" = None


def default_date_range() -> tuple[date, date]:
    end = date.today()
    start = end - timedelta(days=30)
    return start, end


def lookup_account_import_stats(db: Session) -> dict[int, tuple[datetime | None, date | None]]:
    latest_imports = dict(
        db.execute(
            select(ImportBatch.account_id, func.max(ImportBatch.imported_at))
            .where(ImportBatch.account_id.is_not(None))
            .group_by(ImportBatch.account_id)
        ).all()
    )
    latest_txn_dates = dict(
        db.execute(
            select(BankTransaction.account_id, func.max(BankTransaction.transaction_date)).group_by(
                BankTransaction.account_id
            )
        ).all()
    )
    account_ids = set(latest_imports) | set(latest_txn_dates)
    return {
        account_id: (latest_imports.get(account_id), latest_txn_dates.get(account_id))
        for account_id in account_ids
    }


def account_import_stats(db: Session, account_id: int) -> tuple[datetime | None, date | None]:
    latest_import = db.scalar(
        select(func.max(ImportBatch.imported_at))
        .where(ImportBatch.account_id == account_id)
    )
    latest_txn = db.scalar(
        select(func.max(BankTransaction.transaction_date)).where(
            BankTransaction.account_id == account_id
        )
    )
    return latest_import, latest_txn


def list_importable_accounts(db: Session) -> list[ImportableAccount]:
    rows = db.execute(select(Account).where(Account.id > 0).order_by(Account.id)).scalars().all()
    raw_counts = dict(
        db.execute(
            select(RawTransaction.account_id, func.count())
            .where(RawTransaction.bank_transaction_id.is_(None))
            .group_by(RawTransaction.account_id)
        ).all()
    )
    review_counts = dict(
        db.execute(
            select(RawTransaction.account_id, func.count())
            .where(
                RawTransaction.bank_transaction_id.is_(None),
                RawTransaction.promotion_status == PROMOTION_STATUS_NEEDS_REVIEW,
            )
            .group_by(RawTransaction.account_id)
        ).all()
    )
    import_stats = lookup_account_import_stats(db)
    results: list[ImportableAccount] = []
    for account in rows:
        latest_import_at, latest_transaction_date = import_stats.get(account.id, (None, None))
        results.append(
            ImportableAccount(
                id=account.id,
                account_name=account.account_name,
                import_transactions=account.import_transactions,
                simplefin_source_name=SIMPLEFIN_SOURCE_BY_ACCOUNT_ID.get(account.id),
                raw_staged_count=int(raw_counts.get(account.id, 0)),
                needs_review_count=int(review_counts.get(account.id, 0)),
                latest_import_at=latest_import_at,
                latest_transaction_date=latest_transaction_date,
            )
        )
    return results


def run_simplefin_import(
    db: Session,
    account_id: int,
    *,
    start_date: date,
    end_date: date,
    mode: ImportMode,
) -> ImportRunResult:
    if start_date > end_date:
        raise ValueError("start_date must be on or before end_date")

    account = db.get(Account, account_id)
    if account is None:
        raise ValueError(f"Unknown account id {account_id}")

    source_name = SIMPLEFIN_SOURCE_BY_ACCOUNT_ID.get(account_id)
    if not source_name:
        raise ValueError(f"Account {account_id} has no SimpleFIN source mapping")

    if not settings.simplefin_access_url:
        raise SimpleFinError("SIMPLEFIN_ACCESS_URL is not configured")

    access_url = validate_access_url(settings.simplefin_access_url)
    payload = fetch_account_set(access_url, start_date=start_date, end_date=end_date)
    accounts = parse_accounts(payload)
    sf_account = next((item for item in accounts if item.name == source_name), None)

    if sf_account is None:
        stage = StageResult(import_batch_id=0, api_errors=api_errors(payload))
        return ImportRunResult(
            account_id=account_id,
            account_name=account.account_name,
            mode=mode,
            source="simplefin",
            start_date=start_date,
            end_date=end_date,
            stage=stage,
            promote=None,
            simplefin_found=False,
        )

    stage = stage_simplefin_account(
        db,
        sf_account,
        account_id=account_id,
        start_date=start_date,
        end_date=end_date,
        mode=mode,
        api_errors=api_errors(payload),
    )
    promote = promote_raw_transactions(db, account_id=account_id)
    return ImportRunResult(
        account_id=account_id,
        account_name=account.account_name,
        mode=mode,
        source="simplefin",
        start_date=start_date,
        end_date=end_date,
        stage=stage,
        promote=promote,
        simplefin_found=True,
    )


def run_csv_import(
    db: Session,
    account_id: int,
    *,
    filename: str,
    content: bytes,
    mode: ImportMode,
    column_overrides: dict[str, str | None] | None = None,
) -> ImportRunResult:
    account = db.get(Account, account_id)
    if account is None:
        raise ValueError(f"Unknown account id {account_id}")

    if not account.import_transactions:
        raise ValueError(f"Account {account_id} is not enabled for transaction import")

    mapping, rows, region = parse_csv_rows(content, column_overrides=column_overrides)
    stage = stage_csv_rows(db, rows, account_id=account_id, filename=filename, mode=mode)
    promote = promote_raw_transactions(db, account_id=account_id)
    dates = [row.transaction_date for row in rows]
    return ImportRunResult(
        account_id=account_id,
        account_name=account.account_name,
        mode=mode,
        source="csv",
        start_date=min(dates),
        end_date=max(dates),
        stage=stage,
        promote=promote,
        simplefin_found=True,
        filename=filename,
        column_mapping=mapping.as_dict(),
        csv_region=region,
    )


def lookup_simplefin_names(db: Session) -> dict[int, list[str]]:
    """All transaction_account names per account (for display)."""
    rows = db.execute(
        select(TransactionAccount.account_id, TransactionAccount.name)
        .where(TransactionAccount.account_id.is_not(None))
        .order_by(TransactionAccount.account_id, TransactionAccount.name)
    ).all()
    mapping: dict[int, list[str]] = {}
    for account_id, name in rows:
        mapping.setdefault(account_id, []).append(name)
    return mapping


def staged_raw_count(db: Session, account_id: int) -> int:
    count = db.scalar(
        select(func.count())
        .select_from(RawTransaction)
        .where(
            RawTransaction.account_id == account_id,
            RawTransaction.bank_transaction_id.is_(None),
        )
    )
    return int(count or 0)


def needs_review_count(db: Session, account_id: int) -> int:
    count = db.scalar(
        select(func.count())
        .select_from(RawTransaction)
        .where(
            RawTransaction.account_id == account_id,
            RawTransaction.bank_transaction_id.is_(None),
            RawTransaction.promotion_status == PROMOTION_STATUS_NEEDS_REVIEW,
        )
    )
    return int(count or 0)


def sample_raw_transactions(db: Session, *, limit: int = 10) -> dict[int, list[RawSampleRow]]:
    """Latest pending raw rows per account (description truncated to 30 chars)."""
    rows = db.execute(
        select(
            RawTransaction.account_id,
            RawTransaction.transaction_date,
            RawTransaction.bank_orig_description,
        )
        .order_by(
            RawTransaction.account_id,
            RawTransaction.transaction_date.desc().nullslast(),
            RawTransaction.id.desc(),
        )
    ).all()

    samples: dict[int, list[RawSampleRow]] = {}
    for account_id, transaction_date, description in rows:
        bucket = samples.setdefault(account_id, [])
        if len(bucket) >= limit:
            continue
        text = (description or "")[:30]
        bucket.append(RawSampleRow(transaction_date=transaction_date, description=text))
    return samples
