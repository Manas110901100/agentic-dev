from fastapi import FastAPI

app = FastAPI(title="Approval UI")


@app.get("/health")
def health():
    """Report that the service is running."""
    return {"status": "ok"}
