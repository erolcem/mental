"""GET /health — liveness + whether the Examiner is configured."""
from fastapi import APIRouter

from .. import gemini
from ..config import settings

router = APIRouter(tags=["health"])


@router.get("/health")
def health():
    return {
        "status": "ok",
        "app": settings.app_name,
        "examiner_configured": gemini.configured(),
        "auth_required": bool(settings.app_token),
    }
