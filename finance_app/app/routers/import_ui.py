from datetime import date
from pathlib import Path

from fastapi import APIRouter, Depends, Form, Request
from fastapi.templating import Jinja2Templates
from sqlalchemy.orm import Session

from app.config import settings
from app.database import get_db
from app.services import import_control as import_service
from app.services.simplefin import SimpleFinError

router = APIRouter(tags=["ui"])
templates = Jinja2Templates(directory=str(Path(__file__).resolve().parent.parent / "templates"))


@router.get("/import")
def import_page(request: Request, db: Session = Depends(get_db)):
    start_default, end_default = import_service.default_date_range()
    return templates.TemplateResponse(
        request=request,
        name="import.html",
        context={
            "accounts": import_service.list_importable_accounts(db),
            "alias_map": import_service.lookup_simplefin_names(db),
            "sample_map": import_service.sample_raw_transactions(db),
            "start_default": start_default.isoformat(),
            "end_default": end_default.isoformat(),
            "simplefin_configured": bool(settings.simplefin_access_url),
        },
    )


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
            error = str(exc)
        except Exception as exc:
            db.rollback()
            error = f"{type(exc).__name__}: {exc}"

    sample_map = import_service.sample_raw_transactions(db)
    return templates.TemplateResponse(
        request=request,
        name="_import_result.html",
        context={
            "account_id": account_id,
            "error": error,
            "result": result,
            "samples": sample_map.get(account_id, []),
            "raw_staged_count": import_service.staged_raw_count(db, account_id),
            "oob": True,
        },
    )
