"""POST /verify — the Examiner endpoint. Stateless: the app sends the node's
context + the summary sheet; the verdict comes back and the app decides
whether the star ignites."""
from fastapi import APIRouter, Header, HTTPException
from pydantic import BaseModel, Field

from ..config import settings
from ..examiner import MIN_SUMMARY_CHARS, examine
from ..gemini import GeminiError

router = APIRouter(tags=["examiner"])


class VerifyRequest(BaseModel):
    stat: str = Field(min_length=1, max_length=60)
    skill: str = Field(min_length=1, max_length=80)
    goal: str = Field(default="", max_length=160)
    node: str = Field(min_length=1, max_length=160)
    tier: int = Field(ge=1, le=30)
    prerequisites: list[str] = Field(default_factory=list, max_length=12)
    summary: str = Field(min_length=1, max_length=8000)


class VerifyResponse(BaseModel):
    verdict: str  # "pass" | "fail"
    confidence: float
    feedback: str


def _check_token(authorization: str | None) -> None:
    if not settings.app_token:
        return  # dev mode — no token configured
    if authorization != f"Bearer {settings.app_token}":
        raise HTTPException(status_code=401, detail="Invalid or missing app token")


@router.post("/verify", response_model=VerifyResponse)
def verify(req: VerifyRequest, authorization: str | None = Header(default=None)):
    _check_token(authorization)
    if len(req.summary.strip()) < MIN_SUMMARY_CHARS:
        # Cheap server-side floor so thin sheets never burn a Gemini call.
        return VerifyResponse(
            verdict="fail",
            confidence=1.0,
            feedback=(
                "Your summary sheet is too brief for any judgement. Describe what "
                "you actually worked through, the hardest part, and one thing you "
                f"now understand that you didn't before (at least {MIN_SUMMARY_CHARS} characters)."
            ),
        )
    try:
        v = examine(
            stat=req.stat, skill=req.skill, goal=req.goal, node=req.node,
            tier=req.tier, prerequisites=req.prerequisites, summary=req.summary,
        )
    except GeminiError as e:
        raise HTTPException(status_code=502, detail=f"Examiner unavailable: {e}")
    except ValueError as e:
        raise HTTPException(status_code=502, detail=f"Examiner verdict unreadable: {e}")
    return VerifyResponse(
        verdict="pass" if v.passed else "fail",
        confidence=v.confidence,
        feedback=v.feedback,
    )
