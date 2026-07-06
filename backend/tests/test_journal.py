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
    c = parse_close('```json\n{"actions": ["A", "B", "C", "D"], "reflection": "r"}\n```')
    assert c.actions == ["A", "B", "C"]  # clamped to 3


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
        return "Rudin held, Anki slipped twice now — what actually happens at Anki time?"
    out = journal.reply(day="2026-07-02", transcript=REQ["transcript"],
                        yesterday_actions=REQ["yesterday_actions"], generate=fake)
    assert "Anki" in out


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
        lambda *a, **kw: '{"actions": ["A", "B"], "reflection": "r"}')
    r = client.post("/journal/close", json=REQ)
    assert r.status_code == 200
    assert r.json() == {"actions": ["A", "B"], "reflection": "r"}


def test_validation_and_token(monkeypatch):
    assert client.post("/journal/reply",
                       json={**REQ, "transcript": []}).status_code == 422
    bad_role = {**REQ, "transcript": [{"role": "system", "text": "x"}]}
    assert client.post("/journal/reply", json=bad_role).status_code == 422
    monkeypatch.setattr(settings, "app_token", "tok")
    assert client.post("/journal/reply", json=REQ).status_code == 401


def test_outage_is_502(monkeypatch):
    def down(*a, **kw):
        raise journal.gemini.GeminiError("down")
    monkeypatch.setattr(journal.gemini, "generate", down)
    assert client.post("/journal/close", json=REQ).status_code == 502


# --- the habit ledger (365-day memory) --------------------------------------

HIST = [
    {"day": f"2026-06-{d:02d}",
     "actions": [{"text": "20 Anki reps of the m4 deck", "done": d % 3 != 0}],
     "reflection": "Guard the morning."}
    for d in range(1, 31)
] + [
    {"day": "2026-07-01",
     "actions": [{"text": "20 Anki reps of the m4 deck", "done": True},
                 {"text": "Run 2km", "done": False}],
     "reflection": "Kept the chain."},
]


def test_reply_sees_habit_ledger():
    def fake(system, turns, **kw):
        text = turns[0]["text"]
        assert "HABIT LEDGER" in text
        assert "last 7 days" in text and "last 30 days" in text
        assert "2026-07-01" in text          # recent day, verbatim
        assert "[✗] Run 2km" in text         # with done/not-done marks
        assert "Kept the chain." in text     # and the reflection
        return "The Anki chain held again — 21 of the last 30 days now."
    journal.reply(day="2026-07-02", transcript=REQ["transcript"],
                  yesterday_actions=[], history=HIST, generate=fake)


def test_ledger_stats_are_computed_correctly():
    # June 1..30: done unless the day divides by 3 → 20 of 30 actions.
    # Jul 1 adds 1 of 2. Last-7 entries = Jun 25..Jul 1: misses on Jun 27,
    # Jun 30 and the Run → 5 done of 8 actions.
    block = journal._ledger_block(HIST, "2026-07-02")
    assert "last 7 days 62% (5/8)" in block
    assert "all 31 logged days 66% (21/32)" in block


def test_ledger_absent_without_history():
    def fake(system, turns, **kw):
        assert "HABIT LEDGER" not in turns[0]["text"]
        return "Tell me more."
    journal.reply(day="2026-07-02", transcript=REQ["transcript"],
                  yesterday_actions=[], generate=fake)


def test_ledger_ignores_today_and_future_days():
    def fake(system, turns, **kw):
        assert "HABIT LEDGER" not in turns[0]["text"]
        return "ok"
    journal.reply(day="2026-06-01", transcript=REQ["transcript"],
                  yesterday_actions=[], history=HIST, generate=fake)


def test_confidant_runs_on_the_journal_model(monkeypatch):
    monkeypatch.setattr(settings, "journal_model", "gemini-test-pro")
    seen = {}
    def fake(system, turns, **kw):
        seen["model"] = kw.get("model")
        return '{"actions": ["A"], "reflection": "r"}'
    journal.close(day="2026-07-02", transcript=REQ["transcript"],
                  yesterday_actions=[], generate=fake)
    assert seen["model"] == "gemini-test-pro"


def test_endpoints_accept_history(monkeypatch):
    monkeypatch.setattr(
        journal.gemini, "generate",
        lambda *a, **kw: '{"actions": ["A"], "reflection": "r"}')
    r = client.post("/journal/close", json={**REQ, "history": HIST})
    assert r.status_code == 200
    monkeypatch.setattr(journal.gemini, "generate", lambda *a, **kw: "ok")
    assert client.post("/journal/reply",
                       json={**REQ, "history": HIST}).status_code == 200
    # old clients without the field still work
    assert client.post("/journal/reply", json=REQ).status_code == 200
