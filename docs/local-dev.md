# Local development

## Prerequisites

- [Colima](https://github.com/abiosoft/colima) + Docker CLI
- [uv](https://docs.astral.sh/uv/)
- Python 3.12+

## Start the stack

```bash
# 1. Docker runtime
colima start

# 2. Postgres
cd finance_app
docker compose up -d db

# 3. Python deps + migrations
cp .env.example .env   # first time only
uv sync
uv run alembic upgrade head

# 4. API server
uv run uvicorn app.main:app --reload --host 127.0.0.1 --port 8000
```

Verify:

- http://127.0.0.1:8000/api/health → `{"status":"ok"}`
- http://127.0.0.1:8000/transcat → transaction UI (requires DB data)

## Run tests

```bash
cd finance_app
uv run pytest -v
```

CI runs the same tests against a Postgres service container (see `.github/workflows/ci.yml`).

## Sample data migration

To load ~1000 real transactions from SQL Server into local Postgres:

```bash
cd tools
uv sync
export MSSQL_HOST=...
export MSSQL_USER=...
export MSSQL_PASSWORD=...
uv run python migrate_data.py --sample 1000 --years 4
```

## Environment variables (local)

Local dev uses `finance_app/.env` (gitignored). Copy from `.env.example`:

| Variable | Local default | Notes |
|---|---|---|
| `DATABASE_URL` | `postgresql+psycopg://finance:finance@localhost:5432/finances` | Must match docker-compose db service |
| `APP_DEBUG` | `true` | Enables FastAPI reload |

Production secrets live in **GitHub Environment secrets** only — see [github-setup.md](github-setup.md).
