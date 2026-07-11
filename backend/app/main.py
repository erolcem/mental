"""Mental backend — FastAPI app.

The Examiner: verifies mastery summary sheets with Gemini before the app lets
a star ignite. Stateless (no DB) — stage 3 (spaced-repetition quizzes) and
stage 4 (journal loop) will extend this service.

Run:  uvicorn app.main:app --reload      (from the backend/ directory)
Docs: http://localhost:8000/docs
"""
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import RedirectResponse

from .config import settings
from .routers import health, journal, review, sync, verify

app = FastAPI(title="Mental Backend", version="0.1.0")
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.cors_origins,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/", include_in_schema=False)
def root():
    return RedirectResponse(url="/docs")


app.include_router(health.router)
app.include_router(verify.router)
app.include_router(review.router)
app.include_router(journal.router)
app.include_router(sync.router)
