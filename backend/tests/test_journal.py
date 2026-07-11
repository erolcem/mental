"""Confidant prompts, parsing, habit ledger, and /journal endpoints — Gemini
faked."""
import pytest
from fastapi.testclient import TestClient

from app import journal
from app.config import settings
from app.journal import JournalAction, build_habit_ledger, parse_close
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

HISTORY = [
    {"day": "2026-06-28",
     "actions": [{"text": "Do 20 Anki reps", "done": True},
                 {"text": "Read Rudin 7.1", "done": True}],
     "reflection": "Momentum builds."},
    {"day": "2026-06-29",
     "actions": [{"text": "Do 20 Anki reps", "done": False}],
     "reflection": ""},
    {"day": "2026-06-30",
     "actions": [{"text": "Do 25 anki reps", "done": False},
                 {"text": "Sketch for 10 minutes", "done": True}],
     "reflection": "Evenings defeat the deck."},
    {"day": "2026-07-01",
     "actions": [{"text": "Do 20 Anki reps", "done": False}],
     "reflection": "Try mornings."},
]


@pytest.fixture(autouse=True)
def no_token(monkeypatch):
    monkeypatch.setattr(settings, "app_token", "")


def test_parse_close_plain_fenced_and_clamped():
    c = parse_close('{"actions": ["Do X", "Do Y"], "reflection": "Small steps."}')
    assert c.actions == [JournalAction("Do X"), JournalAction("Do Y")]
    assert c.reflection == "Small steps."
    c = parse_close('```json\n{"actions": ["A", "B", "C", "D"], "reflection": "r"}\n```')
    assert [a.text for a in c.actions] == ["A", "B", "C"]  # clamped to 3


def test_parse_close_object_actions_with_why():
    c = parse_close(
        '{"actions": [{"text": "10 Anki reps after breakfast", '
        '"why": "0/3 evenings — shrink and move the trigger"}], '
        '"reflection": "Mornings are yours."}')
    assert c.actions[0].text == "10 Anki reps after breakfast"
    assert "shrink" in c.actions[0].why


def test_parse_close_rejects_bad():
    with pytest.raises(ValueError):
        parse_close("Good session tonight!")
    with pytest.raises(ValueError):
        parse_close('{"actions": [], "reflection": "r"}')


def test_habit_ledger_groups_and_counts():
    ledger = build_habit_ledger(HISTORY)
    # Grouping is number-insensitive and case-insensitive: 20/25 reps unite.
    assert 'set 4×' in ledger and '25%' in ledger
    assert 'pattern ✓✗✗✗' in ledger
    # One-off actions (Rudin 7.1, the sketch) aggregate — no recurring line.
    assert '2 one-off actions, 2 of them done' in ledger
    assert '4 journaled days on record (2026-06-28 → 2026-07-01)' in ledger
    # Recent-days block lists each day verbatim with the reflection.
    assert '- 2026-07-01: [✗] Do 20 Anki reps — “Try mornings.”' in ledger
    assert build_habit_ledger([]) == ""


def test_reply_gets_accountability_and_ledger_context():
    def fake(system, turns, **kw):
        assert "Confidant" in system and "HABIT LEDGER" in system
        text = turns[0]["text"]
        assert "[NOT done] Do 20 Anki reps" in text
        assert "[done] Read Rudin 7.3" in text
        assert "STUDENT: Did 40 mins" in text
        assert "RECURRING HABITS" in text  # the ledger made it into the turn
        assert kw.get("effort") == "chat"
        return "Rudin held, Anki slipped twice now — what actually happens at Anki time?"
    out = journal.reply(day="2026-07-02", transcript=REQ["transcript"],
                        yesterday_actions=REQ["yesterday_actions"],
                        history=HISTORY, generate=fake)
    assert "Anki" in out


def test_reply_without_history_says_first_nights():
    def fake(system, turns, **kw):
        assert "no history yet" in turns[0]["text"]
        return "Tell me more."
    journal.reply(day="2026-07-02", transcript=REQ["transcript"],
                  yesterday_actions=[], generate=fake)


def test_close_produces_actions_with_doctrine():
    def fake(system, turns, **kw):
        assert "TOMORROW" in system and "PROGRESSION DOCTRINE" in system
        assert kw.get("effort") == "deep"
        return ('{"actions": [{"text": "Do Anki before breakfast", '
                '"why": "0/3 evenings"}], "reflection": "Guard the morning."}')
    c = journal.close(day="2026-07-02", transcript=REQ["transcript"],
                      yesterday_actions=[], history=HISTORY, generate=fake)
    assert c.actions == [JournalAction("Do Anki before breakfast", "0/3 evenings")]


def test_reply_endpoint(monkeypatch):
    monkeypatch.setattr(journal.gemini, "generate", lambda *a, **kw: "Tell me more.")
    r = client.post("/journal/reply", json=REQ)
    assert r.status_code == 200
    assert r.json() == {"reply": "Tell me more."}


def test_close_endpoint_returns_whys(monkeypatch):
    monkeypatch.setattr(
        journal.gemini, "generate",
        lambda *a, **kw: '{"actions": [{"text": "A", "why": "streak"}, "B"], '
                         '"reflection": "r"}')
    r = client.post("/journal/close", json={**REQ, "history": HISTORY})
    assert r.status_code == 200
    assert r.json() == {"actions": ["A", "B"], "whys": ["streak", ""],
                        "reflection": "r"}


def test_history_reaches_the_model(monkeypatch):
    seen = {}

    def fake(system, turns, **kw):
        seen["turn"] = turns[0]["text"]
        return '{"actions": ["A"], "reflection": "r"}'
    monkeypatch.setattr(journal.gemini, "generate", fake)
    r = client.post("/journal/close", json={**REQ, "history": HISTORY})
    assert r.status_code == 200
    assert "RECURRING HABITS" in seen["turn"]
    assert "2026-06-30" in seen["turn"]


def test_validation_and_token(monkeypatch):
    assert client.post("/journal/reply",
                       json={**REQ, "transcript": []}).status_code == 422
    bad_role = {**REQ, "transcript": [{"role": "system", "text": "x"}]}
    assert client.post("/journal/reply", json=bad_role).status_code == 422
    too_much_history = {**REQ, "history": [
        {"day": f"2020-01-{i % 28 + 1:02d}", "actions": []} for i in range(367)]}
    assert client.post("/journal/reply", json=too_much_history).status_code == 422
    monkeypatch.setattr(settings, "app_token", "tok")
    assert client.post("/journal/reply", json=REQ).status_code == 401


def test_outage_is_502(monkeypatch):
    def down(*a, **kw):
        raise journal.gemini.GeminiError("down")
    monkeypatch.setattr(journal.gemini, "generate", down)
    assert client.post("/journal/close", json=REQ).status_code == 502
