"""Thin Gemini (Google Generative Language API) client — adapted from
physical's, minus tool-calling (the examiner only needs one JSON reply).

Stateless `generate(...)` over the stable v1beta `generateContent` REST shape.
"""
import httpx

from .config import settings

BASE = "https://generativelanguage.googleapis.com/v1beta"


class GeminiError(RuntimeError):
    pass


def configured() -> bool:
    return bool(settings.gemini_api_key)


def _build(system: str, turns: list[dict], temperature: float, minimal: bool,
           model: str) -> dict:
    pro = "pro" in model
    gen: dict = {"temperature": temperature,
                 "maxOutputTokens": 4096 if pro else 1024}
    if not minimal and not pro:
        # Disable 2.5 "thinking" on flash so thinking tokens can't eat the
        # output budget (which returns finishReason=MAX_TOKENS with NO text).
        # Pro models refuse thinkingBudget=0 — they think, and get a bigger
        # output budget instead.
        gen["thinkingConfig"] = {"thinkingBudget": 0}
    return {
        "system_instruction": {"parts": [{"text": system}]},
        "contents": [{"role": t["role"], "parts": [{"text": t["text"]}]} for t in turns],
        "generationConfig": gen,
    }


def generate(system: str, turns: list[dict], *, temperature: float = 0.2,
             model: str | None = None) -> str:
    """`turns` is [{"role": "user"|"model", "text": "..."}]. Returns reply text.
    `model` overrides the default (the Confidant runs a stronger one).

    Degrades gracefully: if the request with thinkingConfig is rejected with a
    400 (some models/regions), retries plain. Raises GeminiError otherwise.
    """
    if not configured():
        raise GeminiError("Examiner not configured (GEMINI_API_KEY unset)")
    mdl = model or settings.gemini_model
    url = f"{BASE}/models/{mdl}:generateContent?key={settings.gemini_api_key}"
    last_err = "unknown"
    for minimal in (False, True):
        body = _build(system, turns, temperature, minimal, mdl)
        for _ in range(2):  # transient retry within a tier
            try:
                r = httpx.post(url, json=body, timeout=60)
            except Exception as e:  # network / timeout
                last_err = f"request failed: {str(e)[:160]}"
                continue
            if r.status_code == 400:
                last_err = f"Gemini 400: {r.text[:200]}"
                break  # bad request for THIS config — drop to the minimal tier
            if r.status_code >= 500:
                last_err = f"Gemini {r.status_code}"
                continue
            if r.status_code >= 400:
                raise GeminiError(f"Gemini {r.status_code}: {r.text[:300]}")
            data = r.json()
            cands = data.get("candidates") or []
            if cands and cands[0].get("content", {}).get("parts"):
                parts = cands[0]["content"]["parts"]
                return "".join(p.get("text", "") for p in parts).strip()
            last_err = f"no content ({cands[0].get('finishReason') if cands else 'no candidate'})"
    raise GeminiError(f"Gemini returned {last_err}")
