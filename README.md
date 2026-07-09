# Finance Tools

Personal finance GL replatform: Python/FastAPI, Postgres, dbt, QuickSight, Dagster.

## Quick start

```bash
colima start
cd finance_app
docker compose up -d db
cp .env.example .env   # first time
uv sync && uv run alembic upgrade head
uv run uvicorn app.main:app --reload
```

See [docs/local-dev.md](docs/local-dev.md) for full setup, [docs/github-setup.md](docs/github-setup.md) for CI/CD secrets.

## Layout

| Path | Purpose |
|---|---|
| `finance_app/` | FastAPI app, Alembic migrations, local Postgres compose |
| `tools/` | SQL Server schema export and data migration scripts |
| `deploy/` | Production env template and docker-compose |
| `sql_export/` | Legacy MSSQL DDL exports |
| `.github/workflows/` | CI and deploy pipelines |
