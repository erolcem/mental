"""Thin Gemini (Google Generative Language API) client — adapted from
physical's, minus tool-calling (the examiner only needs one JSON reply).

Stateless `generate(...)` over the stable v1beta `generateContent` REST shape.
Speaks both thinking dialects: Gemini 2.5 takes an integer `thinkingBudget`,
Gemini 3+ takes a `thinkingLevel` enum — and degrades gracefully to a plain
request when a dialect is rejected, so swapping GEMINI_MODEL never bricks
the service.
"""
import httpx

from .config import settings

BASE = "https://generativelanguage.googleapis.com/v1beta"


class GeminiError(RuntimeError):
    pass


def configured() -> bool:
    return bool(settings.gemini_api_key)


def thinking_config(model: str, effort: str) -> dict | None:
    """Thinking config for a model family at an effort tier.

    - "quick": conversational turns, verdicts, quiz questions — suppress
      thinking on 2.5 (its thinking tokens eat maxOutputTokens and can return
      finishReason=MAX_TOKENS with NO text), floor it on 3+.
    - "deliberate": the advisor weighing a year of habit history before
      prescribing tomorrow — let the model actually think.
    """
    if model.startswith("gemini-2.5"):
        return None if effort == "deliberate" else {"thinkingBudget": 0}
    if model.startswith("gemini-3"):  # 3.x speaks the enum dialect
        return {"thinkingLevel": "high" if effort == "deliberate" else "low"}
    return None  # unknown family — send nothing model-specific


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
             effort: str = "quick", max_tokens: int = 2048,
             model: str = "") -> str:
    """`turns` is [{"role": "user"|"model", "text": "..."}]. Returns reply text.

    `model` overrides settings.gemini_model (used to give the journal a
    stronger brain than the graders). Tier 1 sends the family's thinking
    dialect; if that draws a 400 (dialect drift between releases), tier 2
    retries plain. Raises GeminiError otherwise.
    """
    if not configured():
        raise GeminiError("Examiner not configured (GEMINI_API_KEY unset)")
    mdl = model or settings.gemini_model
    url = f"{BASE}/models/{mdl}:generateContent?key={settings.gemini_api_key}"
    thinking = thinking_config(mdl, effort)
    tiers: list[dict | None] = [thinking, None] if thinking is not None else [None]
    last_err = "unknown"
    for tier in tiers:
        body = _build(system, turns, temperature, max_tokens, tier)
        for _ in range(2):  # transient retry within a tier
            try:
                r = httpx.post(url, json=body, timeout=90)
            except Exception as e:  # network / timeout
                last_err = f"request failed: {str(e)[:160]}"
                continue
            if r.status_code == 400:
                last_err = f"Gemini 400: {r.text[:200]}"
                break  # bad request for THIS config — drop to the plain tier
            if r.status_code >= 500:
                last_err = f"Gemini {r.status_code}"
                continue
            if r.status_code >= 400:
                raise GeminiError(f"Gemini {r.status_code}: {r.text[:300]}")
            data = r.json()
            cands = data.get("candidates") or []
            if cands and cands[0].get("content", {}).get("parts"):
                parts = cands[0]["content"]["parts"]
                # 3.x can return thought parts alongside the answer; keep text only.
                text = "".join(
                    p.get("text", "") for p in parts if not p.get("thought"))
                if text.strip():
                    return text.strip()
            last_err = f"no content ({cands[0].get('finishReason') if cands else 'no candidate'})"
    raise GeminiError(f"Gemini returned {last_err}")
