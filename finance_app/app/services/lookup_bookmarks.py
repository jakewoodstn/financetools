"""Configurable lookup bookmarks for marketplace / payment-app research."""

from __future__ import annotations

import json
import re
import uuid
from dataclasses import dataclass
from urllib.parse import quote_plus

from sqlalchemy.orm import Session

from app.services.app_settings import get_setting, set_setting

LOOKUP_BOOKMARKS_KEY = "lookup_bookmarks"

# Tokens available in URL templates (substituted from the selected transaction).
TOKEN_NAMES = (
    "amount",
    "abs_amount",
    "date",
    "payee",
    "bank_orig",
    "account",
)

DEFAULT_BOOKMARKS: list[dict[str, str]] = [
    {
        "id": "amazon-orders",
        "label": "Amazon orders",
        "url": "https://www.amazon.com/gp/your-account/order-history",
    },
    {
        "id": "paypal-activity",
        "label": "PayPal activity",
        "url": "https://www.paypal.com/myaccount/activities/",
    },
    {
        "id": "venmo-activity",
        "label": "Venmo",
        "url": "https://account.venmo.com/account/statement",
    },
    {
        "id": "google-search",
        "label": "Google payee + amount",
        "url": "https://www.google.com/search?q={payee}+{abs_amount}",
    },
]

# Stock bookmark ids that should appear even if an older saved list omitted them.
_STOCK_MERGE_IDS = ("venmo-activity",)


@dataclass(frozen=True)
class LookupBookmark:
    id: str
    label: str
    url: str


def _parse_bookmarks(raw: str | None) -> list[LookupBookmark]:
    if not raw:
        return [LookupBookmark(**row) for row in DEFAULT_BOOKMARKS]
    try:
        data = json.loads(raw)
    except json.JSONDecodeError:
        return [LookupBookmark(**row) for row in DEFAULT_BOOKMARKS]
    if not isinstance(data, list):
        return [LookupBookmark(**row) for row in DEFAULT_BOOKMARKS]
    out: list[LookupBookmark] = []
    for item in data:
        if not isinstance(item, dict):
            continue
        label = str(item.get("label") or "").strip()
        url = str(item.get("url") or "").strip()
        if not label or not url:
            continue
        bookmark_id = str(item.get("id") or "").strip() or uuid.uuid4().hex[:12]
        out.append(LookupBookmark(id=bookmark_id, label=label, url=url))
    return out or [LookupBookmark(**row) for row in DEFAULT_BOOKMARKS]


def url_needs_transaction(template: str) -> bool:
    """True when the URL template substitutes fields from a selected transaction."""
    return bool(_TOKEN_RE.search(template or ""))


def _merge_stock_bookmarks(bookmarks: list[LookupBookmark]) -> list[LookupBookmark]:
    """Append newer stock bookmarks (e.g. Venmo) missing from an older saved list."""
    by_id = {b.id for b in bookmarks}
    by_label = {b.label.strip().lower() for b in bookmarks}
    extras: list[LookupBookmark] = []
    defaults_by_id = {row["id"]: row for row in DEFAULT_BOOKMARKS}
    for stock_id in _STOCK_MERGE_IDS:
        row = defaults_by_id.get(stock_id)
        if not row:
            continue
        if stock_id in by_id or row["label"].strip().lower() in by_label:
            continue
        extras.append(LookupBookmark(**row))
    if not extras:
        return bookmarks
    # Insert before Google (tokenized) when present; otherwise append.
    out = list(bookmarks)
    insert_at = next(
        (i for i, b in enumerate(out) if url_needs_transaction(b.url)),
        len(out),
    )
    for offset, extra in enumerate(extras):
        out.insert(insert_at + offset, extra)
    return out


def get_lookup_bookmarks(db: Session) -> list[LookupBookmark]:
    return _merge_stock_bookmarks(_parse_bookmarks(get_setting(db, LOOKUP_BOOKMARKS_KEY)))


def set_lookup_bookmarks(
    db: Session,
    bookmarks: list[LookupBookmark] | list[dict[str, str]],
    *,
    commit: bool = False,
) -> list[LookupBookmark]:
    normalized: list[LookupBookmark] = []
    for item in bookmarks:
        if isinstance(item, LookupBookmark):
            bookmark = item
        else:
            label = str(item.get("label") or "").strip()
            url = str(item.get("url") or "").strip()
            if not label or not url:
                continue
            bookmark = LookupBookmark(
                id=str(item.get("id") or "").strip() or uuid.uuid4().hex[:12],
                label=label,
                url=url,
            )
        if not bookmark.label or not bookmark.url:
            continue
        normalized.append(bookmark)

    payload = [
        {"id": b.id, "label": b.label, "url": b.url}
        for b in normalized
    ]
    set_setting(db, LOOKUP_BOOKMARKS_KEY, json.dumps(payload), commit=commit)
    return normalized


_TOKEN_RE = re.compile(r"\{([a-z_]+)\}", re.IGNORECASE)


def fill_bookmark_url(template: str, values: dict[str, str]) -> str:
    """Replace {token} placeholders; unknown tokens left unchanged."""

    def repl(match: re.Match[str]) -> str:
        key = match.group(1).lower()
        if key not in values:
            return match.group(0)
        return quote_plus(values[key])

    return _TOKEN_RE.sub(repl, template)
