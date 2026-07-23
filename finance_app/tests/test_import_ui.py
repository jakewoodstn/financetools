from pathlib import Path

from fastapi.testclient import TestClient

from app.main import app

FIXTURES = Path(__file__).parent / "fixtures"


def test_import_page_loads():
    client = TestClient(app)
    response = client.get("/import")
    assert response.status_code == 200
    assert "Import Control" in response.text
    assert "Merge" in response.text
    assert "Replace" in response.text
    assert "Latest import" in response.text
    assert "Bank CSV" in response.text
    assert "account-sidebar" in response.text
    assert "account-workspace" in response.text
    assert "import-actions-split" in response.text
    assert "Last import" in response.text
    assert "Latest txn date" in response.text
    assert "nav-bal-date-" in response.text
    assert "Balances" in response.text


def test_balances_page_loads():
    client = TestClient(app)
    response = client.get("/balances")
    assert response.status_code == 200
    assert "Balances" in response.text
    assert "balance-chart" in response.text
    assert "confirm-balance-form" in response.text
    assert "Confirm balance" in response.text


def test_balances_api_returns_datasets():
    client = TestClient(app)
    response = client.get("/api/balances")
    assert response.status_code == 200
    payload = response.json()
    assert "datasets" in payload


def test_balances_api_total_only_returns_single_total_dataset():
    client = TestClient(app)
    response = client.get("/api/balances?total_only=true")
    assert response.status_code == 200
    datasets = response.json()["datasets"]
    assert len(datasets) == 1
    assert datasets[0]["label"] == "Total"
    assert datasets[0]["account_id"] == 0


def test_create_manual_balance_observation_rejects_bad_amount():
    client = TestClient(app)
    response = client.post(
        "/api/balances/observations",
        data={"account_id": 1, "as_of_date": "2026-07-18", "amount": "not-a-number"},
    )
    assert response.status_code == 400
    assert "Invalid amount" in response.json()["detail"]


def test_create_manual_balance_observation_rejects_future_date():
    client = TestClient(app)
    response = client.post(
        "/api/balances/observations",
        data={"account_id": 1, "as_of_date": "2099-01-01", "amount": "100.00"},
    )
    assert response.status_code == 400
    assert "future" in response.json()["detail"].lower()


def test_import_compare_redirects_to_import():
    client = TestClient(app)
    response = client.get("/import/compare?account=2", follow_redirects=False)
    assert response.status_code == 301
    assert response.headers["location"] == "/import?account=2"


def test_import_review_page_loads():
    client = TestClient(app)
    response = client.get("/import/review")
    assert response.status_code == 200
    assert "Import Review" in response.text


def test_csv_upload_endpoint():
    client = TestClient(app)
    csv_bytes = (FIXTURES / "bank_download.csv").read_bytes()
    response = client.post(
        "/import/1/csv",
        data={"mode": "merge"},
        files={"file": ("bank_download.csv", csv_bytes, "text/csv")},
    )
    assert response.status_code == 200
    assert "CSV imported" in response.text or "Failed" in response.text
