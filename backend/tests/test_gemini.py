"""The Gemini client's request-building logic — pure, no network."""
from app.config import settings
from app.gemini import _build, _model_for, _thinking_for


def test_effort_tiers_pick_model_and_thinking(monkeypatch):
    monkeypatch.setattr(settings, "gemini_model", "gemini-3.5-flash")
    monkeypatch.setattr(settings, "gemini_model_deep", "gemini-3.1-pro")
    monkeypatch.setattr(settings, "gemini_thinking_chat", "low")
    monkeypatch.setattr(settings, "gemini_thinking_deep", "high")
    assert _model_for("chat") == "gemini-3.5-flash"
    assert _model_for("deep") == "gemini-3.1-pro"
    assert _thinking_for("chat") == "low"
    assert _thinking_for("deep") == "high"


def test_deep_model_defaults_to_chat_model(monkeypatch):
    monkeypatch.setattr(settings, "gemini_model", "gemini-3.5-flash")
    monkeypatch.setattr(settings, "gemini_model_deep", "gemini-3.5-flash")
    assert _model_for("deep") == _model_for("chat")


def test_build_places_thinking_and_budget():
    body = _build("sys", [{"role": "user", "text": "hi"}], 0.2, 4096,
                  {"thinkingLevel": "low"})
    assert body["generationConfig"]["maxOutputTokens"] == 4096
    assert body["generationConfig"]["thinkingConfig"] == {
        "thinkingLevel": "low"}
    assert body["system_instruction"]["parts"][0]["text"] == "sys"
    plain = _build("sys", [{"role": "user", "text": "hi"}], 0.2, 2048, None)
    assert "thinkingConfig" not in plain["generationConfig"]
