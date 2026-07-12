from fastapi.testclient import TestClient

from app.main import app


def test_import_page_loads():
    client = TestClient(app)
    response = client.get("/import")
    assert response.status_code == 200
    assert "Import Control" in response.text
    assert "Merge" in response.text
    assert "Replace" in response.text
    assert "Recent imports" in response.text
