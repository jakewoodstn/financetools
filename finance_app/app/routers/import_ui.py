from datetime import date
from pathlib import Path

from fastapi import APIRouter, Depends, File, Form, Request, UploadFile
from fastapi.responses import RedirectResponse
from fastapi.templating import Jinja2Templates
from sqlalchemy.orm import Session

from app.config import settings
from app.database import get_db
from app.services import import_control as import_service
from app.services.csv_import import CsvImportError
from app.services.simplefin import SimpleFinError

router = APIRouter(tags=["ui"])
templates = Jinja2Templates(directory=str(Path(__file__).resolve().parent.parent / "templates"))


def _import_page_context(db: Session, account: int | None) -> dict:
    start_default, end_default = import_service.default_date_range()
    accounts = import_service.list_importable_accounts(db)
    selected_account_id = account
    if selected_account_id is None and accounts:
        selected_account_id = accounts[0].id
    selected_account = next((row for row in accounts if row.id == selected_account_id), None)
    return {
        "accounts": accounts,
        "selected_account_id": selected_account_id,
        "selected_account": selected_account,
        "alias_map": import_service.lookup_simplefin_names(db),
        "sample_map": import_service.sample_raw_transactions(db),
        "review_map": import_service.review_raw_transactions(db),
        "start_default": start_default.isoformat(),
        "end_default": end_default.isoformat(),
        "simplefin_configured": bool(settings.simplefin_access_url),
    }


@router.get("/import")
def import_page(
    request: Request,
    account: int | None = None,
    db: Session = Depends(get_db),
):
    return templates.TemplateResponse(
        request=request,
        name="import.html",
        context=_import_page_context(db, account),
    )


@router.get("/import/compare")
def import_compare_redirect(account: int | None = None):
    url = "/import"
    if account is not None:
        url = f"{url}?account={account}"
    return RedirectResponse(url, status_code=301)


def _result_context(
    db: Session,
    account_id: int,
    *,
    error: str | None,
    result: import_service.ImportRunResult | None,
) -> dict:
    sample_map = import_service.sample_raw_transactions(db)
    review_map = import_service.review_raw_transactions(db)
    latest_import_at, latest_transaction_date = import_service.account_import_stats(db, account_id)
    return {
        "account_id": account_id,
        "error": error,
        "result": result,
        "samples": sample_map.get(account_id, []),
        "review_rows": review_map.get(account_id, []),
        "raw_staged_count": import_service.staged_raw_count(db, account_id),
        "needs_review_count": import_service.needs_review_count(db, account_id),
        "latest_import_at": latest_import_at,
        "latest_transaction_date": latest_transaction_date,
        "oob": True,
    }


@router.post("/import/{account_id}")
def run_import(
    request: Request,
    account_id: int,
    db: Session = Depends(get_db),
    start_date: date = Form(...),
    end_date: date = Form(...),
    mode: str = Form("merge"),
):
    error: str | None = None
    result = None
    import_mode = "merge" if mode != "replace" else "replace"

    if not settings.simplefin_access_url:
        error = "SIMPLEFIN_ACCESS_URL is not configured"
    else:
        try:
            result = import_service.run_simplefin_import(
                db,
                account_id,
                start_date=start_date,
                end_date=end_date,
                mode=import_mode,  # type: ignore[arg-type]
            )
        except (ValueError, SimpleFinError) as exc:
            db.rollback()
            error = str(exc)
        except Exception as exc:
            db.rollback()
            error = str(exc) if str(exc).strip() else exc.__class__.__name__

    return templates.TemplateResponse(
        request=request,
        name="_import_result.html",
        context=_result_context(db, account_id, error=error, result=result),
    )


@router.post("/import/{account_id}/csv")
async def run_csv_import(
    request: Request,
    account_id: int,
    db: Session = Depends(get_db),
    mode: str = Form("merge"),
    file: UploadFile = File(...),
    col_date: str | None = Form(None),
    col_amount: str | None = Form(None),
    col_description: str | None = Form(None),
    col_category: str | None = Form(None),
):
    error: str | None = None
    result = None
    import_mode = "merge" if mode != "replace" else "replace"
    column_overrides = {
        "transaction_date": col_date,
        "amount": col_amount,
        "description": col_description,
        "category": col_category,
    }

    try:
        content = await file.read()
        if not content:
            raise CsvImportError("Uploaded file is empty")
        result = import_service.run_csv_import(
            db,
            account_id,
            filename=file.filename or "upload.csv",
            content=content,
            mode=import_mode,  # type: ignore[arg-type]
            column_overrides=column_overrides,
        )
    except (ValueError, CsvImportError) as exc:
        db.rollback()
        error = str(exc)
    except Exception as exc:
        db.rollback()
        error = str(exc) if str(exc).strip() else exc.__class__.__name__

    return templates.TemplateResponse(
        request=request,
        name="_import_result.html",
        context=_result_context(db, account_id, error=error, result=result),
    )
