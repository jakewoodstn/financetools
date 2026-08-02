from types import SimpleNamespace

from fastapi.testclient import TestClient
from sqlalchemy import select

from app.database import SessionLocal
from app.main import app
from app.models import Account
from app.services.account_colors import (
    COLOR_THEMES,
    DEFAULT_PALETTE,
    account_color_map,
    color_for_account,
    colors_for_theme,
    default_color_for_id,
    get_active_theme,
    normalize_hex,
    set_active_theme,
    theme_by_id,
    theme_css_vars,
)


def test_normalize_hex_accepts_valid_colors():
    assert normalize_hex("#1D4ED8") == "#1d4ed8"
    assert normalize_hex("  #be123c  ") == "#be123c"


def test_normalize_hex_rejects_invalid():
    assert normalize_hex(None) is None
    assert normalize_hex("") is None
    assert normalize_hex("#fff") is None
    assert normalize_hex("blue") is None
    assert normalize_hex("#gg0000") is None


def test_color_for_account_uses_stored_color():
    account = SimpleNamespace(id=99, color="#Be123C")
    assert color_for_account(account) == "#be123c"


def test_color_for_account_falls_back_to_palette_by_id():
    account = SimpleNamespace(id=3, color=None)
    assert color_for_account(account) == default_color_for_id(3)
    assert color_for_account(account) == DEFAULT_PALETTE[3 % len(DEFAULT_PALETTE)]


def test_color_for_account_ignores_invalid_stored_color():
    account = SimpleNamespace(id=2, color="not-a-color")
    assert color_for_account(account) == default_color_for_id(2)


def test_account_color_map():
    accounts = [
        SimpleNamespace(id=1, color="#111111"),
        SimpleNamespace(id=2, color=None),
    ]
    assert account_color_map(accounts) == {
        1: "#111111",
        2: default_color_for_id(2),
    }


def test_settings_page_loads():
    client = TestClient(app)
    response = client.get("/settings")
    assert response.status_code == 200
    assert "Account colors" in response.text
    assert "color-form" in response.text
    assert "Settings" in response.text
    assert "Fall Colors" in response.text
    assert "Duke University" in response.text
    assert "Nashville SC" in response.text


def test_color_themes_include_requested_presets():
    ids = {theme.id for theme in COLOR_THEMES}
    assert {"default", "fall", "duke", "nashville-sc"}.issubset(ids)
    duke = theme_by_id("duke")
    assert duke is not None
    assert "#012169" in duke.colors
    assert "#00539b" in duke.colors
    assert duke.header == "#012169"
    assert duke.accent == "#00539b"
    nsc = theme_by_id("nashville-sc")
    assert nsc is not None
    assert "#ece83a" in nsc.colors
    assert "#1f1646" in nsc.colors
    assert nsc.header == "#1f1646"
    assert nsc.accent == "#ece83a"
    assert nsc.accent_fg == "#1f1646"
    mapped = colors_for_theme(nsc, [1, 2, 3])
    assert mapped[1] == "#ece83a"
    assert mapped[2] == "#1f1646"
    css = theme_css_vars(nsc)
    assert "--theme-header: #1f1646" in css
    assert "--theme-accent: #ece83a" in css


def test_settings_saves_ui_theme_chrome():
    db = SessionLocal()
    try:
        original = get_active_theme(db).id
    finally:
        db.close()

    client = TestClient(app)
    response = client.post(
        "/settings/account-colors",
        data={"theme_id": "duke"},
        follow_redirects=False,
    )
    assert response.status_code == 303
    assert "saved=colors" in response.headers["location"]

    try:
        page = client.get("/settings")
        assert page.status_code == 200
        assert "--theme-header: #012169" in page.text
        assert 'data-theme-id="duke"' in page.text
        assert 'class="theme-card is-selected"' in page.text or "theme-card is-selected" in page.text

        transcat = client.get("/transcat")
        assert transcat.status_code == 200
        assert "--theme-header: #012169" in transcat.text
        assert "--theme-accent: #00539b" in transcat.text
    finally:
        db = SessionLocal()
        try:
            set_active_theme(db, original, commit=True)
        finally:
            db.close()


def test_settings_saves_account_color_and_balances_api_uses_it():
    db = SessionLocal()
    try:
        account = db.scalars(select(Account).where(Account.id > 0).order_by(Account.id)).first()
        if account is None:
            return
        account_id = account.id
        original = account.color
        new_color = "#abcdef"
    finally:
        db.close()

    client = TestClient(app)
    response = client.post(
        "/settings/account-colors",
        data={f"color_{account_id}": new_color},
        follow_redirects=False,
    )
    assert response.status_code == 303
    assert "saved=colors" in response.headers["location"]

    try:
        saved = client.get("/settings")
        assert saved.status_code == 200
        assert new_color in saved.text

        api = client.get(f"/api/balances?account={account_id}&include_total=false")
        assert api.status_code == 200
        datasets = api.json()["datasets"]
        account_datasets = [ds for ds in datasets if ds.get("account_id") == account_id]
        assert account_datasets
        assert all(ds["color"] == new_color for ds in account_datasets)
    finally:
        db = SessionLocal()
        try:
            account = db.get(Account, account_id)
            if account is not None:
                account.color = original
                db.commit()
        finally:
            db.close()


def test_settings_rejects_invalid_color():
    db = SessionLocal()
    try:
        account = db.scalars(select(Account).where(Account.id > 0).order_by(Account.id)).first()
        if account is None:
            return
        account_id = account.id
        original = account.color
    finally:
        db.close()

    client = TestClient(app)
    response = client.post(
        "/settings/account-colors",
        data={f"color_{account_id}": "not-a-color"},
        follow_redirects=False,
    )
    assert response.status_code == 303
    assert "error=invalid_color" in response.headers["location"]

    db = SessionLocal()
    try:
        account = db.get(Account, account_id)
        assert account is not None
        assert account.color == original
    finally:
        db.close()
