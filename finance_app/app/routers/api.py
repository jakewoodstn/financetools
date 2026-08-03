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
from app.schemas.transaction import (
    ApproveCategoryRequest,
    ApproveCategoryResult,
    AssignCategoryRequest,
    AssignCategoryResult,
    CategoryOut,
    SplitBundleOut,
    SplitLineOut,
    SplitReplaceRequest,
    TagAttachRequest,
    TagAttachResult,
    TagOut,
    TransactionOut,
)
from app.services import payees as payee_service
from app.services import splits as split_service
from app.services import transactions as txn_service
from app.services.splits import SplitBalanceError

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


@router.get("/tags", response_model=list[TagOut])
def search_tags(
    q: str = Query(default="", min_length=1),
    limit: int = Query(20, ge=1, le=50),
    db: Session = Depends(get_db),
) -> list[TagOut]:
    return txn_service.autocomplete_tags(db, q, limit=limit)


@router.post("/transactions/tags/attach", response_model=TagAttachResult)
def attach_tag(
    body: TagAttachRequest,
    db: Session = Depends(get_db),
) -> TagAttachResult:
    name = body.tag.strip()
    if not name:
        raise HTTPException(status_code=400, detail="tag required")
    updated, tag = txn_service.attach_tag(
        db,
        external_ids=body.transaction_ids,
        tag_name=name,
    )
    if tag is None or updated == 0:
        raise HTTPException(status_code=404, detail="No matching transactions")
    return TagAttachResult(updated=updated, tag_id=tag.id, tag=tag.tag)


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


@router.post("/transactions/assign", response_model=AssignCategoryResult)
def assign_category(
    body: AssignCategoryRequest,
    db: Session = Depends(get_db),
) -> AssignCategoryResult:
    updated = txn_service.assign_categories(
        db,
        external_ids=body.transaction_ids,
        category_id=body.category_id,
    )
    if updated == 0:
        raise HTTPException(status_code=404, detail="Category or transactions not found")
    return AssignCategoryResult(
        updated=updated,
        category_id=body.category_id,
        category_name=txn_service.category_label_for_id(db, body.category_id),
    )


@router.post("/transactions/approve", response_model=ApproveCategoryResult)
def approve_category(
    body: ApproveCategoryRequest,
    db: Session = Depends(get_db),
) -> ApproveCategoryResult:
    updated = txn_service.approve_categories(
        db,
        external_ids=body.transaction_ids,
    )
    if updated == 0:
        raise HTTPException(status_code=404, detail="No matching transactions")
    return ApproveCategoryResult(updated=updated)


def _split_bundle_out(bundle: split_service.SplitBundle) -> SplitBundleOut:
    return SplitBundleOut(
        transaction_id=bundle.transaction_id,
        amount=bundle.amount,
        lines=[
            SplitLineOut(
                id=line.id or 0,
                external_id=line.external_id or 0,
                category_id=line.category_id,
                category_name=line.category_name,
                split_amount=line.split_amount,
            )
            for line in bundle.lines
        ],
    )


@router.get("/transactions/{transaction_id}/splits", response_model=SplitBundleOut)
def get_splits(
    transaction_id: int,
    db: Session = Depends(get_db),
) -> SplitBundleOut:
    bundle = split_service.get_splits(db, transaction_id)
    if bundle is None:
        raise HTTPException(status_code=404, detail="Transaction not found")
    return _split_bundle_out(bundle)


@router.put("/transactions/{transaction_id}/splits", response_model=SplitBundleOut)
def put_splits(
    transaction_id: int,
    body: SplitReplaceRequest,
    db: Session = Depends(get_db),
) -> SplitBundleOut:
    try:
        bundle = split_service.replace_splits(
            db,
            external_id=transaction_id,
            lines=[line.model_dump() for line in body.lines],
        )
    except LookupError as exc:
        raise HTTPException(status_code=404, detail=str(exc)) from exc
    except SplitBalanceError as exc:
        raise HTTPException(status_code=400, detail=str(exc)) from exc
    except ValueError as exc:
        raise HTTPException(status_code=400, detail=str(exc)) from exc
    return _split_bundle_out(bundle)


@router.delete("/transactions/{transaction_id}/splits")
def delete_splits(
    transaction_id: int,
    db: Session = Depends(get_db),
) -> dict[str, int]:
    ok = split_service.clear_splits(db, external_id=transaction_id)
    if not ok:
        raise HTTPException(status_code=404, detail="Transaction not found")
    return {"cleared": 1}
