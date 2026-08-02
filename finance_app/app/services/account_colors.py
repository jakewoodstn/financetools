"""Stable per-account display colors and app chrome themes."""

from __future__ import annotations

import re
from dataclasses import dataclass
from typing import Any

from sqlalchemy.orm import Session

from app.models import AppSetting

HEX_COLOR_RE = re.compile(r"^#[0-9A-Fa-f]{6}$")

UI_THEME_KEY = "ui_theme"

DEFAULT_PALETTE = [
    "#1d4ed8",
    "#b45309",
    "#166534",
    "#7c3aed",
    "#be123c",
    "#0f766e",
]


@dataclass(frozen=True)
class ColorTheme:
    id: str
    name: str
    colors: tuple[str, ...]
    header: str
    accent: str
    accent_hover: str
    header_fg: str = "#ffffff"
    accent_fg: str = "#ffffff"


COLOR_THEMES: tuple[ColorTheme, ...] = (
    ColorTheme(
        id="default",
        name="Default",
        colors=tuple(DEFAULT_PALETTE),
        header="#1f3b63",
        accent="#1f3b63",
        accent_hover="#274d7e",
    ),
    ColorTheme(
        id="ocean",
        name="Ocean",
        colors=("#0c4a6e", "#0284c7", "#0e7490", "#0369a1", "#155e75", "#1d4ed8"),
        header="#0c4a6e",
        accent="#0284c7",
        accent_hover="#0369a1",
    ),
    ColorTheme(
        id="forest",
        name="Forest",
        colors=("#14532d", "#166534", "#3f6212", "#4d7c0f", "#065f46", "#365314"),
        header="#14532d",
        accent="#166534",
        accent_hover="#14532d",
    ),
    ColorTheme(
        id="sunset",
        name="Sunset",
        colors=("#9f1239", "#c2410c", "#ea580c", "#d97706", "#be123c", "#a21caf"),
        header="#9f1239",
        accent="#c2410c",
        accent_hover="#9a3412",
    ),
    ColorTheme(
        id="mono",
        name="Slate",
        colors=("#0f172a", "#334155", "#475569", "#1e293b", "#64748b", "#0f766e"),
        header="#0f172a",
        accent="#334155",
        accent_hover="#1e293b",
    ),
    ColorTheme(
        id="fall",
        name="Fall Colors",
        colors=("#9a3412", "#c2410c", "#b45309", "#a16207", "#854d0e", "#7c2d12"),
        header="#7c2d12",
        accent="#c2410c",
        accent_hover="#9a3412",
    ),
    ColorTheme(
        id="duke",
        name="Duke University",
        colors=("#012169", "#00539b", "#58595b", "#c84e00", "#5e802c", "#407e99"),
        header="#012169",
        accent="#00539b",
        accent_hover="#012169",
    ),
    ColorTheme(
        id="nashville-sc",
        name="Nashville SC",
        colors=("#ece83a", "#1f1646", "#c4c02a", "#3b2b6e", "#b8b43a", "#0f0b2a"),
        header="#1f1646",
        accent="#ece83a",
        accent_hover="#d4cf2e",
        accent_fg="#1f1646",
    ),
)


def normalize_hex(value: str | None) -> str | None:
    if value is None:
        return None
    text = value.strip()
    if not HEX_COLOR_RE.match(text):
        return None
    return text.lower()


def default_color_for_id(account_id: int) -> str:
    return DEFAULT_PALETTE[int(account_id) % len(DEFAULT_PALETTE)]


def color_for_account(account: Any) -> str:
    stored = normalize_hex(getattr(account, "color", None))
    if stored:
        return stored
    return default_color_for_id(int(account.id))


def account_color_map(accounts: list[Any]) -> dict[int, str]:
    return {int(account.id): color_for_account(account) for account in accounts}


def theme_by_id(theme_id: str) -> ColorTheme | None:
    for theme in COLOR_THEMES:
        if theme.id == theme_id:
            return theme
    return None


def colors_for_theme(theme: ColorTheme, account_ids: list[int]) -> dict[int, str]:
    palette = theme.colors
    return {
        account_id: palette[idx % len(palette)]
        for idx, account_id in enumerate(account_ids)
    }


def get_active_theme(db: Session) -> ColorTheme:
    value = db.get(AppSetting, UI_THEME_KEY)
    theme_id = value.value if value is not None else "default"
    return theme_by_id(theme_id) or COLOR_THEMES[0]


def set_active_theme(db: Session, theme_id: str, *, commit: bool = False) -> ColorTheme | None:
    theme = theme_by_id(theme_id)
    if theme is None:
        return None
    row = db.get(AppSetting, UI_THEME_KEY)
    if row is None:
        db.add(AppSetting(key=UI_THEME_KEY, value=theme.id))
    else:
        row.value = theme.id
    if commit:
        db.commit()
    return theme


def theme_css_vars(theme: ColorTheme) -> str:
    return (
        f"--theme-header: {theme.header}; "
        f"--theme-header-fg: {theme.header_fg}; "
        f"--theme-accent: {theme.accent}; "
        f"--theme-accent-hover: {theme.accent_hover}; "
        f"--theme-accent-fg: {theme.accent_fg};"
    )


def theme_template_context(db: Session) -> dict[str, Any]:
    theme = get_active_theme(db)
    return {
        "ui_theme_id": theme.id,
        "ui_theme_style": theme_css_vars(theme),
        "ui_theme": {
            "id": theme.id,
            "name": theme.name,
            "header": theme.header,
            "header_fg": theme.header_fg,
            "accent": theme.accent,
            "accent_hover": theme.accent_hover,
            "accent_fg": theme.accent_fg,
            "colors": list(theme.colors),
        },
    }
