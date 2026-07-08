"""The Gemini client's model-dialect logic — pure, no network."""
from app.config import settings
from app.gemini import _build, thinking_config


def test_thinking_dialects_per_family():
    # 2.5: integer budget; quick suppresses thinking, deliberate frees it.
    assert thinking_config("gemini-2.5-flash", "quick") == {"thinkingBudget": 0}
    assert thinking_config("gemini-2.5-pro", "deliberate") is None
    # 3.x: enum dialect at both effort tiers.
    assert thinking_config("gemini-3.5-flash", "quick") == {"thinkingLevel": "low"}
    assert thinking_config("gemini-3.1-pro", "deliberate") == {"thinkingLevel": "high"}
    # Unknown family: send nothing model-specific.
    assert thinking_config("some-future-model", "quick") is None


def test_build_places_thinking_and_budget():
    body = _build("sys", [{"role": "user", "text": "hi"}], 0.2, 4096,
                  {"thinkingLevel": "low"})
    assert body["generationConfig"]["maxOutputTokens"] == 4096
    assert body["generationConfig"]["thinkingConfig"] == {"thinkingLevel": "low"}
    plain = _build("sys", [{"role": "user", "text": "hi"}], 0.2, 2048, None)
    assert "thinkingConfig" not in plain["generationConfig"]


def test_journal_model_falls_back_to_grader_model(monkeypatch):
    from app.journal import _journal_model
    monkeypatch.setattr(settings, "gemini_journal_model", "")
    assert _journal_model() == ""  # empty → generate() uses settings.gemini_model
    monkeypatch.setattr(settings, "gemini_journal_model", "gemini-3.1-pro")
    assert _journal_model() == "gemini-3.1-pro"


def test_close_runs_deliberate_on_journal_model(monkeypatch):
    from app import journal
    monkeypatch.setattr(settings, "gemini_journal_model", "gemini-3.1-pro")
    seen = {}

    def fake(system, turns, **kw):
        seen.update(kw)
        return '{"actions": ["One thing"], "reflection": "r"}'

    journal.close(day="2026-07-08", transcript=[{"role": "user", "text": "day"}],
                  yesterday_actions=[], generate=fake)
    assert seen["effort"] == "deliberate"
    assert seen["model"] == "gemini-3.1-pro"
