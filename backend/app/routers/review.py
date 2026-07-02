"""POST /review/questions + /review/grade — the spaced-repetition Reviewer.
Stateless like /verify: the app owns schedules; the backend only asks and
grades."""
from fastapi import APIRouter, Header, HTTPException
from pydantic import BaseModel, Field, model_validator

from .. import reviewer
from ..config import settings
from ..gemini import GeminiError

router = APIRouter(prefix="/review", tags=["reviewer"])


class NodeContext(BaseModel):
    stat: str = Field(min_length=1, max_length=60)
    skill: str = Field(min_length=1, max_length=80)
    goal: str = Field(default="", max_length=160)
    node: str = Field(min_length=1, max_length=160)
    tier: int = Field(ge=1, le=30)
    summary: str = Field(default="", max_length=8000)
    proof: str = Field(default="", max_length=300)  # the node's completion standard


class QuestionsResponse(BaseModel):
    questions: list[str]


class GradeRequest(NodeContext):
    questions: list[str] = Field(min_length=1, max_length=4)
    answers: list[str] = Field(min_length=1, max_length=4)

    @model_validator(mode="after")
    def _lengths_match(self):
        if len(self.questions) != len(self.answers):
            raise ValueError("questions and answers must have the same length")
        return self


class GradeResponse(BaseModel):
    passed: bool
    feedback: str
    notes: list[str]


def _check_token(authorization: str | None) -> None:
    if not settings.app_token:
        return  # dev mode
    if authorization != f"Bearer {settings.app_token}":
        raise HTTPException(status_code=401, detail="Invalid or missing app token")


@router.post("/questions", response_model=QuestionsResponse)
def questions(req: NodeContext, authorization: str | None = Header(default=None)):
    _check_token(authorization)
    try:
        qs = reviewer.make_questions(
            stat=req.stat, skill=req.skill, goal=req.goal, node=req.node,
            tier=req.tier, summary=req.summary, proof=req.proof)
    except GeminiError as e:
        raise HTTPException(status_code=502, detail=f"Reviewer unavailable: {e}")
    except ValueError as e:
        raise HTTPException(status_code=502, detail=f"Reviewer reply unreadable: {e}")
    return QuestionsResponse(questions=qs)


@router.post("/grade", response_model=GradeResponse)
def grade(req: GradeRequest, authorization: str | None = Header(default=None)):
    _check_token(authorization)
    try:
        g = reviewer.grade(
            stat=req.stat, skill=req.skill, goal=req.goal, node=req.node,
            tier=req.tier, summary=req.summary, proof=req.proof,
            questions=req.questions, answers=req.answers)
    except GeminiError as e:
        raise HTTPException(status_code=502, detail=f"Reviewer unavailable: {e}")
    except ValueError as e:
        raise HTTPException(status_code=502, detail=f"Reviewer reply unreadable: {e}")
    return GradeResponse(passed=g.passed, feedback=g.feedback, notes=g.notes)
