"""App settings UI — colors, chrome theme, and import alerts."""

from pathlib import Path

from fastapi import APIRouter, Depends, Form, Request
from fastapi.responses import RedirectResponse
from fastapi.templating import Jinja2Templates
from sqlalchemy import select
from sqlalchemy.orm import Session
from datetime import timezone

from app.database import get_db
from app.models import Account
from app.services.account_colors import (
    COLOR_THEMES,
    account_color_map,
    default_color_for_id,
    normalize_hex,
    set_active_theme,
)
from app.services.app_settings import (
    get_import_stale_days,
    get_last_import_at,
    set_import_stale_days,
)
from app.services.lookup_bookmarks import (
    TOKEN_NAMES,
    get_lookup_bookmarks,
    set_lookup_bookmarks,
)
from app.services.ui_context import ui_page_context

router = APIRouter(tags=["settings"])
templates = Jinja2Templates(directory=str(Path(__file__).resolve().parent.parent / "templates"))


@router.get("/settings")
def settings_page(
    request: Request,
    db: Session = Depends(get_db),
    saved: str | None = None,
    error: str | None = None,
):
    accounts = list(db.scalars(select(Account).where(Account.id > 0).order_by(Account.id)).all())
    colors = account_color_map(accounts)
    defaults = {account.id: default_color_for_id(account.id) for account in accounts}
    theme_ctx = ui_page_context(db, nav_active="settings")
    last = get_last_import_at(db)
    last_display = (
        last.astimezone(timezone.utc).strftime("%Y-%m-%d %H:%M UTC") if last is not None else None
    )
    return templates.TemplateResponse(
        request=request,
        name="settings.html",
        context={
            "accounts": accounts,
            "account_colors": colors,
            "default_colors": defaults,
            "color_themes": [
                {
                    "id": theme.id,
                    "name": theme.name,
                    "colors": list(theme.colors),
                    "header": theme.header,
                    "header_fg": theme.header_fg,
                    "accent": theme.accent,
                    "accent_hover": theme.accent_hover,
                    "accent_fg": theme.accent_fg,
                }
                for theme in COLOR_THEMES
            ],
            "saved": saved,
            "error": error,
            "import_stale_days_value": get_import_stale_days(db),
            "last_import_at_display": last_display,
            "lookup_bookmarks": get_lookup_bookmarks(db),
            "lookup_token_names": TOKEN_NAMES,
            **theme_ctx,
        },
    )


@router.post("/settings/account-colors")
async def save_account_colors(
    request: Request,
    db: Session = Depends(get_db),
):
    form = await request.form()
    accounts = list(db.scalars(select(Account).where(Account.id > 0).order_by(Account.id)).all())
    by_id = {account.id: account for account in accounts}
    updates: dict[int, str] = {}

    for key, value in form.items():
        if not isinstance(key, str) or not key.startswith("color_"):
            continue
        try:
            account_id = int(key.removeprefix("color_"))
        except ValueError:
            continue
        if account_id not in by_id:
            continue
        normalized = normalize_hex(str(value))
        if normalized is None:
            return RedirectResponse(
                url="/settings?error=invalid_color",
                status_code=303,
            )
        updates[account_id] = normalized

    theme_id = form.get("theme_id")
    if isinstance(theme_id, str) and theme_id.strip():
        if set_active_theme(db, theme_id.strip()) is None:
            return RedirectResponse(
                url="/settings?error=invalid_theme",
                status_code=303,
            )

    for account_id, color in updates.items():
        by_id[account_id].color = color
    db.commit()
    return RedirectResponse(url="/settings?saved=colors", status_code=303)


@router.post("/settings/import-alerts")
def save_import_alerts(
    db: Session = Depends(get_db),
    import_stale_days: int = Form(...),
):
    try:
        set_import_stale_days(db, import_stale_days, commit=True)
    except (TypeError, ValueError):
        return RedirectResponse(url="/settings?error=invalid_stale_days", status_code=303)
    return RedirectResponse(url="/settings?saved=import-alerts", status_code=303)


@router.post("/settings/lookup-bookmarks")
async def save_lookup_bookmarks(
    request: Request,
    db: Session = Depends(get_db),
):
    form = await request.form()
    labels = form.getlist("bookmark_label")
    urls = form.getlist("bookmark_url")
    ids = form.getlist("bookmark_id")
    bookmarks = []
    for i, label in enumerate(labels):
        url = urls[i] if i < len(urls) else ""
        bookmark_id = ids[i] if i < len(ids) else ""
        label_s = str(label).strip()
        url_s = str(url).strip()
        if not label_s and not url_s:
            continue
        if not label_s or not url_s:
            return RedirectResponse(url="/settings?error=invalid_bookmark", status_code=303)
        if not (url_s.startswith("https://") or url_s.startswith("http://")):
            return RedirectResponse(url="/settings?error=invalid_bookmark_url", status_code=303)
        bookmarks.append(
            {
                "id": str(bookmark_id).strip(),
                "label": label_s,
                "url": url_s,
            }
        )
    set_lookup_bookmarks(db, bookmarks, commit=True)
    return RedirectResponse(url="/settings?saved=lookup-bookmarks", status_code=303)
