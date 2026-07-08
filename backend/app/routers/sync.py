"""POST /sync/push + /sync/pull — Sky Link cross-device sync.

POST for both (the Sky Key must never ride in a URL where proxies and
access logs would keep it). The app merges conservatively client-side and
pushes the merged snapshot back, so the server can stay a dumb last-writer
blob store."""
from fastapi import APIRouter, Header, HTTPException
from pydantic import BaseModel, Field

from .. import sync
from ..config import settings

router = APIRouter(prefix="/sync", tags=["sync"])


class PushRequest(BaseModel):
    key: str = Field(min_length=sync.MIN_KEY_CHARS, max_length=128)
    data: str = Field(min_length=2, max_length=sync.MAX_BLOB_BYTES)
    device: str = Field(default="", max_length=64)


class PullRequest(BaseModel):
    key: str = Field(min_length=sync.MIN_KEY_CHARS, max_length=128)


class PushResponse(BaseModel):
    updated_at: str


class PullResponse(BaseModel):
    data: str | None
    updated_at: str | None = None
    device: str | None = None


def _check_token(authorization: str | None) -> None:
    if not settings.app_token:
        return  # dev mode
    if authorization != f"Bearer {settings.app_token}":
        raise HTTPException(status_code=401, detail="Invalid or missing app token")


@router.post("/push", response_model=PushResponse)
def push(req: PushRequest, authorization: str | None = Header(default=None)):
    _check_token(authorization)
    return PushResponse(updated_at=sync.push(req.key, req.data, req.device))


@router.post("/pull", response_model=PullResponse)
def pull(req: PullRequest, authorization: str | None = Header(default=None)):
    _check_token(authorization)
    got = sync.pull(req.key)
    if got is None:
        return PullResponse(data=None)
    return PullResponse(**got)
