from datetime import date

from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session

from app.database import get_db
from app.schemas.transaction import CategoryOut, TransactionOut
from app.services import transactions as txn_service

router = APIRouter(prefix="/api", tags=["api"])


@router.get("/health")
def health() -> dict[str, str]:
    return {"status": "ok"}


@router.get("/transactions", response_model=list[TransactionOut])
def get_transactions(
    account_id: int = Query(0),
    account: list[int] = Query(default=[]),
    start: date | None = Query(default=None),
    end: date | None = Query(default=None),
    include_categorized: bool = Query(False),
    limit: int = Query(500, le=500),
    db: Session = Depends(get_db),
) -> list[TransactionOut]:
    account_ids = account if account else None
    return txn_service.list_transactions(
        db,
        account_id=account_id,
        account_ids=account_ids,
        start_date=start,
        end_date=end,
        include_categorized=include_categorized,
        limit=limit,
    )


@router.get("/categories", response_model=list[CategoryOut])
def get_categories(db: Session = Depends(get_db)) -> list[CategoryOut]:
    return txn_service.list_categories(db)
