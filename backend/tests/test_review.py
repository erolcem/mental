"""Reviewer prompts, parsing, and the /review endpoints — Gemini faked."""
import pytest
from fastapi.testclient import TestClient

from app import reviewer
from app.config import settings
from app.main import app
from app.reviewer import ReviewGrade, parse_grade, parse_questions

client = TestClient(app)

CTX = {
    "stat": "Intelligence",
    "skill": "Mathematics",
    "goal": "Fields Medal / Proof Mastery",
    "node": "Linear Algebra (Axler)",
    "tier": 3,
    "summary": "Worked through Axler: vector spaces, eigenvalues without determinants…",
}


@pytest.fixture(autouse=True)
def no_token(monkeypatch):
    monkeypatch.setattr(settings, "app_token", "")


# ---------- parsing ----------

def test_parse_questions_plain_and_fenced():
    assert parse_questions('{"questions": ["Q1?", "Q2?"]}') == ["Q1?", "Q2?"]
    assert parse_questions('```json\n{"questions": ["A?", "B?", "C?"]}\n```') == ["A?", "B?"]


def test_parse_questions_rejects_empty():
    with pytest.raises(ValueError):
        parse_questions('{"questions": []}')
    with pytest.raises(ValueError):
        parse_questions("no json here")


def test_parse_grade():
    g = parse_grade(
        '{"passed": false, "feedback": "Eigenvalues faded.", "notes": ["ok", "weak"]}', 2)
    assert g == ReviewGrade(passed=False, feedback="Eigenvalues faded.", notes=["ok", "weak"])
    with pytest.raises(ValueError):
        parse_grade('{"passed": "yes", "feedback": "?"}', 1)


def test_make_questions_grounds_in_summary():
    def fake(system, turns, **kw):
        assert "REVIEW" in system
        assert "Axler" in turns[0]["text"]
        return '{"questions": ["Explain eigenvalues sans determinants.", "Apply rank-nullity."]}'
    qs = reviewer.make_questions(**CTX, generate=fake)
    assert len(qs) == 2


def test_grade_includes_transcript():
    def fake(system, turns, **kw):
        assert "Q1" in turns[0]["text"] and "A1" in turns[0]["text"]
        assert "(no answer)" in turns[0]["text"]  # empty answer normalised
        return '{"passed": true, "feedback": "Alive and well.", "notes": ["good", "good"]}'
    g = reviewer.grade(**CTX, questions=["Q?", "R?"], answers=["ans", "  "], generate=fake)
    assert g.passed


# ---------- endpoints ----------

def test_questions_endpoint(monkeypatch):
    monkeypatch.setattr(reviewer.gemini, "generate",
                        lambda *a, **kw: '{"questions": ["Q1?", "Q2?"]}')
    r = client.post("/review/questions", json=CTX)
    assert r.status_code == 200
    assert r.json() == {"questions": ["Q1?", "Q2?"]}


def test_grade_endpoint(monkeypatch):
    monkeypatch.setattr(
        reviewer.gemini, "generate",
        lambda *a, **kw: '{"passed": true, "feedback": "Solid.", "notes": ["ok", "ok"]}')
    r = client.post("/review/grade",
                    json={**CTX, "questions": ["Q1?", "Q2?"], "answers": ["a", "b"]})
    assert r.status_code == 200
    assert r.json()["passed"] is True


def test_grade_rejects_mismatched_lengths():
    r = client.post("/review/grade",
                    json={**CTX, "questions": ["Q1?", "Q2?"], "answers": ["only one"]})
    assert r.status_code == 422


def test_review_endpoints_respect_token(monkeypatch):
    monkeypatch.setattr(settings, "app_token", "tok")
    assert client.post("/review/questions", json=CTX).status_code == 401


def test_outage_is_502(monkeypatch):
    def down(*a, **kw):
        raise reviewer.gemini.GeminiError("down")
    monkeypatch.setattr(reviewer.gemini, "generate", down)
    assert client.post("/review/questions", json=CTX).status_code == 502
