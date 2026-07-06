"""POST /journal/reply + /journal/close — the nightly Confidant. Stateless:
the app owns the transcript and yesterday's action items."""
from fastapi import APIRouter, Header, HTTPException
from pydantic import BaseModel, Field

from .. import journal
from ..config import settings
from ..gemini import GeminiError

router = APIRouter(prefix="/journal", tags=["journal"])


class Turn(BaseModel):
    role: str = Field(pattern="^(user|ai)$")
    text: str = Field(min_length=1, max_length=4000)


class YesterdayAction(BaseModel):
    text: str = Field(min_length=1, max_length=300)
    done: bool = False


class HistoryAction(BaseModel):
    text: str = Field(min_length=1, max_length=200)
    done: bool = False


class HistoryEntry(BaseModel):
    day: str = Field(min_length=8, max_length=10)  # yyyy-mm-dd
    actions: list[HistoryAction] = Field(default_factory=list, max_length=6)
    reflection: str = Field(default="", max_length=300)


class JournalRequest(BaseModel):
    day: str = Field(min_length=8, max_length=10)  # yyyy-mm-dd
    transcript: list[Turn] = Field(min_length=1, max_length=40)
    yesterday_actions: list[YesterdayAction] = Field(
        default_factory=list, max_length=3)
    # Up to a year of past days — the Confidant's habit memory.
    history: list[HistoryEntry] = Field(default_factory=list, max_length=366)


class ReplyResponse(BaseModel):
    reply: str


class CloseResponse(BaseModel):
    actions: list[str]
    reflection: str


def _check_token(authorization: str | None) -> None:
    if not settings.app_token:
        return  # dev mode
    if authorization != f"Bearer {settings.app_token}":
        raise HTTPException(status_code=401, detail="Invalid or missing app token")


def _dump(req: JournalRequest) -> dict:
    return {
        "day": req.day,
        "transcript": [{"role": t.role, "text": t.text} for t in req.transcript],
        "yesterday_actions": [
            {"text": a.text, "done": a.done} for a in req.yesterday_actions
        ],
        "history": [
            {
                "day": h.day,
                "actions": [{"text": a.text, "done": a.done} for a in h.actions],
                "reflection": h.reflection,
            }
            for h in req.history
        ],
    }


@router.post("/reply", response_model=ReplyResponse)
def reply(req: JournalRequest, authorization: str | None = Header(default=None)):
    _check_token(authorization)
    try:
        text = journal.reply(**_dump(req))
    except GeminiError as e:
        raise HTTPException(status_code=502, detail=f"Confidant unavailable: {e}")
    return ReplyResponse(reply=text)


@router.post("/close", response_model=CloseResponse)
def close(req: JournalRequest, authorization: str | None = Header(default=None)):
    _check_token(authorization)
    try:
        c = journal.close(**_dump(req))
    except GeminiError as e:
        raise HTTPException(status_code=502, detail=f"Confidant unavailable: {e}")
    except ValueError as e:
        raise HTTPException(status_code=502, detail=f"Confidant reply unreadable: {e}")
    return CloseResponse(actions=c.actions, reflection=c.reflection)
