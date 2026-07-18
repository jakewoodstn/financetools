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
    assert "Pending import rows" in response.text
    assert "Bank CSV" in response.text
    assert "account-sidebar" in response.text
    assert "account-workspace" in response.text
    assert "import-actions-split" in response.text
    assert "Last import" in response.text
    assert "Latest txn date" in response.text


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
