"""API tests for /verify and /health — Gemini faked at the examiner boundary."""
import pytest
from fastapi.testclient import TestClient

from app import examiner
from app.config import settings
from app.main import app

client = TestClient(app)

GOOD_REQ = {
    "stat": "Intelligence",
    "skill": "Mathematics",
    "goal": "Fields Medal / Proof Mastery",
    "node": "Real Analysis I (Baby Rudin)",
    "tier": 5,
    "prerequisites": ["Calculus I-III (Stewart)"],
    "summary": "Worked through Rudin chapters 1-7, wrote up 120 proofs including the "
               "Heine-Borel theorem; the hardest part was epsilon-delta arguments in "
               "uniform convergence, which finally clicked via the sup-norm view.",
}


@pytest.fixture(autouse=True)
def no_token(monkeypatch):
    monkeypatch.setattr(settings, "app_token", "")


def test_health():
    r = client.get("/health")
    assert r.status_code == 200
    body = r.json()
    assert body["status"] == "ok"
    assert body["app"] == "Mental"


def test_verify_pass(monkeypatch):
    monkeypatch.setattr(
        examiner.gemini, "generate",
        lambda system, turns, **kw:
            '{"verdict": "pass", "confidence": 0.85, "feedback": "Strong, specific evidence."}')
    r = client.post("/verify", json=GOOD_REQ)
    assert r.status_code == 200
    assert r.json() == {"verdict": "pass", "confidence": 0.85,
                        "feedback": "Strong, specific evidence."}


def test_verify_fail(monkeypatch):
    monkeypatch.setattr(
        examiner.gemini, "generate",
        lambda system, turns, **kw:
            '{"verdict": "fail", "confidence": 0.9, "feedback": "No specific theorems named."}')
    r = client.post("/verify", json=GOOD_REQ)
    assert r.status_code == 200
    assert r.json()["verdict"] == "fail"


def test_short_summary_fails_without_llm(monkeypatch):
    def boom(*a, **kw):
        raise AssertionError("Gemini must not be called for thin sheets")
    monkeypatch.setattr(examiner.gemini, "generate", boom)
    r = client.post("/verify", json={**GOOD_REQ, "summary": "I finished it."})
    assert r.status_code == 200
    assert r.json()["verdict"] == "fail"
    assert "too brief" in r.json()["feedback"]


def test_gemini_outage_is_502(monkeypatch):
    def down(*a, **kw):
        raise examiner.gemini.GeminiError("boom")
    monkeypatch.setattr(examiner.gemini, "generate", down)
    r = client.post("/verify", json=GOOD_REQ)
    assert r.status_code == 502
    assert "Examiner unavailable" in r.json()["detail"]


def test_unreadable_verdict_is_502(monkeypatch):
    monkeypatch.setattr(examiner.gemini, "generate", lambda *a, **kw: "not json at all")
    r = client.post("/verify", json=GOOD_REQ)
    assert r.status_code == 502
    assert "unreadable" in r.json()["detail"]


def test_token_enforced(monkeypatch):
    monkeypatch.setattr(settings, "app_token", "secret-token")
    monkeypatch.setattr(
        examiner.gemini, "generate",
        lambda *a, **kw: '{"verdict": "pass", "confidence": 0.9, "feedback": "ok"}')
    assert client.post("/verify", json=GOOD_REQ).status_code == 401
    assert client.post("/verify", json=GOOD_REQ,
                       headers={"Authorization": "Bearer wrong"}).status_code == 401
    r = client.post("/verify", json=GOOD_REQ,
                    headers={"Authorization": "Bearer secret-token"})
    assert r.status_code == 200


def test_validation_rejects_bad_payload():
    assert client.post("/verify", json={"stat": "x"}).status_code == 422
    assert client.post(
        "/verify", json={**GOOD_REQ, "tier": 0}).status_code == 422
