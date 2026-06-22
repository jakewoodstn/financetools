from pathlib import Path

from fastapi import APIRouter, Depends, Request
from fastapi.templating import Jinja2Templates
from sqlalchemy.orm import Session

from app.database import get_db
from app.services import transactions as txn_service

router = APIRouter(tags=["ui"])
templates = Jinja2Templates(directory=str(Path(__file__).resolve().parent.parent / "templates"))


@router.get("/")
def home(request: Request):
    return templates.TemplateResponse(
        request=request,
        name="redirect.html",
        context={},
    )


@router.get("/transcat")
def transcat(request: Request, db: Session = Depends(get_db)):
    categories = txn_service.list_categories(db)
    transactions = txn_service.list_transactions(db)
    return templates.TemplateResponse(
        request=request,
        name="transcat.html",
        context={
            "categories": categories,
            "transactions": transactions,
        },
    )
