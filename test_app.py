from fastapi.testclient import TestClient

from app import app, fetch_requests

client = TestClient(app)

FAKE_ROWS = [
    {"id": 1, "title": "Add modulo()", "status": "submitted"},
    {"id": 3, "title": "Add sqrt() function", "status": "pending_approval"},
]


def fake_fetch_requests():
    """Stand-in for the database: CI has no Postgres."""
    return FAKE_ROWS


def test_health_returns_ok():
    """The /health endpoint answers 200 with status ok."""
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json() == {"status": "ok"}


def test_list_requests_returns_rows_from_data_source():
    """GET /requests answers 200 with exactly the rows the data source gives."""
    app.dependency_overrides[fetch_requests] = fake_fetch_requests
    try:
        response = client.get("/requests")
    finally:
        app.dependency_overrides.clear()
    assert response.status_code == 200
    assert response.json() == FAKE_ROWS
