"""Thin Gemini (Google Generative Language API) client — adapted from
physical's, minus tool-calling (the examiner only needs one JSON reply).

Stateless `generate(...)` over the stable v1beta `generateContent` REST shape.

Two effort tiers ("chat" and "deep") select the model and thinking level from
config. Thinking-config negotiation degrades gracefully across model
generations:

  1. `thinkingConfig.thinkingLevel` — Gemini 3+ (minimal/low/medium/high);
  2. `thinkingConfig.thinkingBudget: 0` — Gemini 2.5 family (disable thinking
     so it can't eat the output budget, which returns MAX_TOKENS with no text);
  3. no thinkingConfig at all.

A 400 on one rung drops to the next, so any GEMINI_MODEL override keeps
working without code changes.
"""
import httpx

from .config import settings

BASE = "https://generativelanguage.googleapis.com/v1beta"


class GeminiError(RuntimeError):
    pass


def configured() -> bool:
    return bool(settings.gemini_api_key)


def _model_for(effort: str) -> str:
    return settings.gemini_model_deep if effort == "deep" else settings.gemini_model


def _thinking_for(effort: str) -> str:
    return (settings.gemini_thinking_deep if effort == "deep"
            else settings.gemini_thinking_chat)


def _build(system: str, turns: list[dict], temperature: float,
           max_tokens: int, thinking: dict | None) -> dict:
    gen: dict = {"temperature": temperature, "maxOutputTokens": max_tokens}
    if thinking is not None:
        gen["thinkingConfig"] = thinking
    return {
        "system_instruction": {"parts": [{"text": system}]},
        "contents": [{"role": t["role"], "parts": [{"text": t["text"]}]} for t in turns],
        "generationConfig": gen,
    }


def generate(system: str, turns: list[dict], *, temperature: float = 0.2,
             effort: str = "deep") -> str:
    """`turns` is [{"role": "user"|"model", "text": "..."}]. Returns reply text.

    `effort` picks the model + thinking tier: "chat" for conversational
    replies, "deep" for verdicts, grading and the nightly close.
    """
    if not configured():
        raise GeminiError("Examiner not configured (GEMINI_API_KEY unset)")
    model = _model_for(effort)
    url = f"{BASE}/models/{model}:generateContent?key={settings.gemini_api_key}"
    # Deep calls may spend tokens thinking before they answer; give them room.
    max_tokens = 4096 if effort == "deep" else 1024
    ladder: list[dict | None] = [
        {"thinkingLevel": _thinking_for(effort)},
        {"thinkingBudget": 0},
        None,
    ]
    last_err = "unknown"
    for thinking in ladder:
        body = _build(system, turns, temperature, max_tokens, thinking)
        for _ in range(2):  # transient retry within a rung
            try:
                r = httpx.post(url, json=body, timeout=90)
            except Exception as e:  # network / timeout
                last_err = f"request failed: {str(e)[:160]}"
                continue
            if r.status_code == 400:
                last_err = f"Gemini 400: {r.text[:200]}"
                break  # bad request for THIS config — drop a rung
            if r.status_code >= 500:
                last_err = f"Gemini {r.status_code}"
                continue
            if r.status_code >= 400:
                raise GeminiError(f"Gemini {r.status_code}: {r.text[:300]}")
            data = r.json()
            cands = data.get("candidates") or []
            if cands and cands[0].get("content", {}).get("parts"):
                parts = cands[0]["content"]["parts"]
                text = "".join(
                    p.get("text", "") for p in parts
                    if not p.get("thought")).strip()
                if text:
                    return text
            last_err = f"no content ({cands[0].get('finishReason') if cands else 'no candidate'})"
    raise GeminiError(f"Gemini returned {last_err}")
