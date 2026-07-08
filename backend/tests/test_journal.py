"""Confidant prompts, parsing, and /journal endpoints — Gemini faked."""
import pytest
from fastapi.testclient import TestClient

from app import journal
from app.config import settings
from app.journal import parse_close
from app.main import app

client = TestClient(app)

REQ = {
    "day": "2026-07-02",
    "transcript": [
        {"role": "ai", "text": "How was your day?"},
        {"role": "user", "text": "Did 40 mins of Rudin but skipped Anki again."},
    ],
    "yesterday_actions": [
        {"text": "Do 20 Anki reps of the m4 deck", "done": False},
        {"text": "Read Rudin 7.3", "done": True},
    ],
}


@pytest.fixture(autouse=True)
def no_token(monkeypatch):
    monkeypatch.setattr(settings, "app_token", "")


def test_parse_close_plain_fenced_and_clamped():
    c = parse_close('{"actions": ["Do X", "Do Y"], "reflection": "Small steps."}')
    assert c.actions == ["Do X", "Do Y"]
    assert c.reflection == "Small steps."
    assert c.rationale == ""  # older/terse replies still parse
    c = parse_close('```json\n{"actions": ["A", "B", "C", "D"], "reflection": "r"}\n```')
    assert c.actions == ["A", "B", "C"]  # clamped to 3


def test_parse_close_keeps_rationale():
    c = parse_close('{"actions": ["A"], "reflection": "r", '
                    '"rationale": "Anki kept 6/7 so +5 reps."}')
    assert c.rationale == "Anki kept 6/7 so +5 reps."


def test_parse_close_rejects_bad():
    with pytest.raises(ValueError):
        parse_close("Good session tonight!")
    with pytest.raises(ValueError):
        parse_close('{"actions": [], "reflection": "r"}')


def test_reply_gets_accountability_context():
    def fake(system, turns, **kw):
        assert "Confidant" in system
        text = turns[0]["text"]
        assert "[NOT done] Do 20 Anki reps" in text
        assert "[done] Read Rudin 7.3" in text
        assert "STUDENT: Did 40 mins" in text
        assert "HABIT LEDGER" not in text  # no history sent → no empty block
        return "Rudin held, Anki slipped twice now — what actually happens at Anki time?"
    out = journal.reply(day="2026-07-02", transcript=REQ["transcript"],
                        yesterday_actions=REQ["yesterday_actions"], generate=fake)
    assert "Anki" in out


def test_ledger_reaches_both_prompts():
    ledger = ("HABIT LEDGER — the last 365 days\n"
              "2026-07-01 · kept 1/2\n  [x] Do Anki\n  [ ] Run 5k")

    def fake(system, turns, **kw):
        text = turns[0]["text"]
        assert "HABIT LEDGER" in text
        assert "[ ] Run 5k" in text
        # The ledger must precede tonight's transcript: evidence, then talk.
        assert text.index("HABIT LEDGER") < text.index("TONIGHT'S SESSION")
        if "TOMORROW" in system:  # the close prompt
            assert "SHRINK WHAT KEEPS FAILING" in system
            return ('{"actions": ["Run 2k at 7am"], "reflection": "r", '
                    '"rationale": "Run missed at dusk; moved and halved."}')
        return "The run keeps dying at dusk — what claims that hour?"

    out = journal.reply(day="2026-07-02", transcript=REQ["transcript"],
                        yesterday_actions=[], history=ledger, generate=fake)
    assert "dusk" in out
    c = journal.close(day="2026-07-02", transcript=REQ["transcript"],
                      yesterday_actions=[], history=ledger, generate=fake)
    assert c.actions == ["Run 2k at 7am"]
    assert "halved" in c.rationale


def test_close_produces_actions():
    def fake(system, turns, **kw):
        assert "TOMORROW" in system
        return '{"actions": ["Do Anki before breakfast"], "reflection": "Guard the morning."}'
    c = journal.close(day="2026-07-02", transcript=REQ["transcript"],
                      yesterday_actions=[], generate=fake)
    assert c.actions == ["Do Anki before breakfast"]


def test_reply_endpoint(monkeypatch):
    monkeypatch.setattr(journal.gemini, "generate", lambda *a, **kw: "Tell me more.")
    r = client.post("/journal/reply", json=REQ)
    assert r.status_code == 200
    assert r.json() == {"reply": "Tell me more."}


def test_close_endpoint(monkeypatch):
    monkeypatch.setattr(
        journal.gemini, "generate",
        lambda *a, **kw: '{"actions": ["A", "B"], "reflection": "r", '
                         '"rationale": "why"}')
    r = client.post("/journal/close", json={**REQ, "history": "HABIT LEDGER…"})
    assert r.status_code == 200
    assert r.json() == {"actions": ["A", "B"], "reflection": "r",
                        "rationale": "why"}


def test_validation_and_token(monkeypatch):
    assert client.post("/journal/reply",
                       json={**REQ, "transcript": []}).status_code == 422
    bad_role = {**REQ, "transcript": [{"role": "system", "text": "x"}]}
    assert client.post("/journal/reply", json=bad_role).status_code == 422
    huge = {**REQ, "history": "x" * (journal.MAX_HISTORY_CHARS + 1)}
    assert client.post("/journal/reply", json=huge).status_code == 422
    monkeypatch.setattr(settings, "app_token", "tok")
    assert client.post("/journal/reply", json=REQ).status_code == 401


def test_outage_is_502(monkeypatch):
    def down(*a, **kw):
        raise journal.gemini.GeminiError("down")
    monkeypatch.setattr(journal.gemini, "generate", down)
    assert client.post("/journal/close", json=REQ).status_code == 502
