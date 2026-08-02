from pathlib import Path

from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles

from app.config import settings
from app.routers import api, balances, import_ui, pages, settings as settings_ui

app = FastAPI(title="Finance Tools", debug=settings.app_debug)
app.include_router(pages.router)
app.include_router(import_ui.router)
app.include_router(balances.router)
app.include_router(settings_ui.router)
app.include_router(api.router)

static_dir = Path(__file__).parent / "static"
if static_dir.is_dir():
    app.mount("/static", StaticFiles(directory=static_dir), name="static")


def run() -> None:
    import uvicorn

    uvicorn.run("app.main:app", host="0.0.0.0", port=8000, reload=settings.app_debug)
