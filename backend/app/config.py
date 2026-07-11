"""Configuration — all via environment variables (Railway → Variables).

The backend is stateless: no database. It holds only the Gemini key and a
shared app token; every request carries the node context it needs.
"""
import os


class Settings:
    # Gemini (Google AI Studio key) — same ecosystem as physical's coach.
    gemini_api_key: str = os.environ.get("GEMINI_API_KEY", "")

    # Two model tiers (both default to the GA frontier flash, which is strong
    # AND cheap; ~$1.50/$9 per M tokens as of mid-2026):
    #  - CHAT: conversational journal replies — latency matters, depth less.
    #  - DEEP: examiner verdicts, review grading, the nightly close/advisor —
    #    the calls whose judgement quality IS the product. Override
    #    GEMINI_MODEL_DEEP=gemini-3.1-pro for maximum judgement at ~2.5× cost.
    gemini_model: str = os.environ.get("GEMINI_MODEL", "gemini-3.5-flash")
    gemini_model_deep: str = os.environ.get(
        "GEMINI_MODEL_DEEP", os.environ.get("GEMINI_MODEL", "gemini-3.5-flash"))

    # Thinking effort per tier (Gemini 3+ `thinkingLevel`; older 2.5 models
    # fall back automatically — see gemini.py's degradation ladder).
    gemini_thinking_chat: str = os.environ.get("GEMINI_THINKING_CHAT", "low")
    gemini_thinking_deep: str = os.environ.get("GEMINI_THINKING_DEEP", "high")

    # Shared bearer token. The Flutter app ships it via --dart-define and the
    # backend rejects requests without it. This keeps drive-by abuse off the
    # Gemini key; it is NOT user auth (single-user app — real accounts arrive
    # with cloud sync, following physical's JWT pattern).
    app_token: str = os.environ.get("APP_TOKEN", "")

    cors_origins: list[str] = os.environ.get("CORS_ORIGINS", "*").split(",")
    app_name: str = os.environ.get("APP_NAME", "Mental")


settings = Settings()
