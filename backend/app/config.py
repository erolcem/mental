"""Configuration — all via environment variables (Railway → Variables).

The backend is stateless: no database. It holds only the Gemini key and a
shared app token; every request carries the node context it needs.
"""
import os


class Settings:
    # Gemini (Google AI Studio key) — same ecosystem as physical's coach.
    gemini_api_key: str = os.environ.get("GEMINI_API_KEY", "")
    gemini_model: str = os.environ.get("GEMINI_MODEL", "gemini-2.5-flash")

    # The Confidant runs on a stronger model: it reasons over a year of habit
    # history nightly, and one call a day on Pro costs roughly a cent. The
    # Examiner/Reviewer stay on the fast default (many small JSON verdicts).
    journal_model: str = os.environ.get("JOURNAL_MODEL", "gemini-2.5-pro")

    # Shared bearer token. The Flutter app ships it via --dart-define and the
    # backend rejects requests without it. This keeps drive-by abuse off the
    # Gemini key; it is NOT user auth (single-user app — real accounts arrive
    # with cloud sync, following physical's JWT pattern).
    app_token: str = os.environ.get("APP_TOKEN", "")

    cors_origins: list[str] = os.environ.get("CORS_ORIGINS", "*").split(",")
    app_name: str = os.environ.get("APP_NAME", "Mental")


settings = Settings()
