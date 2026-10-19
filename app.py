from typing import Annotated

import psycopg
from fastapi import Depends, FastAPI
from psycopg.rows import dict_row

app = FastAPI(title="Approval UI")


def fetch_requests():
    """Read all requests (id, title, status) from Postgres, oldest first.

    Connection settings come from libpq (PGHOST, PGUSER, ... and
    pgpass.conf), never from this code. Raises psycopg.OperationalError
    if the database can't be reached.
    """
    with psycopg.connect(row_factory=dict_row) as conn:
        return conn.execute(
            "SELECT id, title, status FROM requests ORDER BY id"
        ).fetchall()


@app.get("/health")
def health():
    """Report that the service is running."""
    return {"status": "ok"}


@app.get("/requests")
def list_requests(rows: Annotated[list[dict], Depends(fetch_requests)]):
    """List requests (id, title, status), oldest first."""
    return rows
