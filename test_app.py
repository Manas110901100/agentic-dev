from fastapi.testclient import TestClient

from app import app

client = TestClient(app)


def test_health_returns_ok():
    """The /health endpoint answers 200 with status ok."""
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json() == {"status": "ok"}
