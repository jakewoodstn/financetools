"""Compose shared template context for themed chrome and nav alerts."""

from __future__ import annotations

from typing import Any

from sqlalchemy.orm import Session

from app.services.account_colors import theme_template_context
from app.services.app_settings import import_status_context


def ui_page_context(db: Session, *, nav_active: str | None = None) -> dict[str, Any]:
    ctx = {
        **theme_template_context(db),
        **import_status_context(db),
    }
    if nav_active is not None:
        ctx["nav_active"] = nav_active
    return ctx
