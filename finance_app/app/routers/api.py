from datetime import date

from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session

from app.database import get_db
from app.schemas.payee import (
    PayeeApplyRequest,
    PayeeApplyResult,
    PayeeAutocompleteItem,
    PayeeSuggestRequest,
    PayeeSuggestionOut,
)
from app.schemas.transaction import CategoryOut, TransactionOut
from app.services import payees as payee_service
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


@router.get("/payees", response_model=list[PayeeAutocompleteItem])
def search_payees(
    q: str = Query(default="", min_length=1),
    limit: int = Query(20, ge=1, le=50),
    db: Session = Depends(get_db),
) -> list[PayeeAutocompleteItem]:
    rows = payee_service.autocomplete_payees(db, q, limit=limit)
    return [PayeeAutocompleteItem(id=r.id, canonical_name=r.canonical_name) for r in rows]


@router.post("/transactions/payee/suggest", response_model=PayeeSuggestionOut | None)
def suggest_payee(
    body: PayeeSuggestRequest,
    db: Session = Depends(get_db),
) -> PayeeSuggestionOut | None:
    txn = payee_service.get_transaction_by_external_id(db, body.transaction_ids[0])
    if txn is None:
        raise HTTPException(status_code=404, detail="Transaction not found")
    hit = payee_service.suggest_payee(db, txn)
    if hit is None:
        return None
    return PayeeSuggestionOut(
        canonical_name=hit.canonical_name,
        observation_count=hit.observation_count,
        source=hit.source,
    )


@router.post("/transactions/payee/apply", response_model=PayeeApplyResult)
def apply_payee(
    body: PayeeApplyRequest,
    db: Session = Depends(get_db),
) -> PayeeApplyResult:
    name = body.canonical_name.strip()
    if not name:
        raise HTTPException(status_code=400, detail="canonical_name required")
    updated = payee_service.apply_payee_name(
        db,
        external_ids=body.transaction_ids,
        canonical_name=name,
    )
    if updated == 0:
        raise HTTPException(status_code=404, detail="No matching transactions")
    return PayeeApplyResult(updated=updated, canonical_name=name)
