# Deploying the Examiner (mental backend)

Stateless FastAPI service — one Railway service, no database. Same flow you
used for physical's backend.

## 1. Railway (one-time)

1. Railway → New Project → **Deploy from GitHub repo** → pick `mental`.
   `railway.json` already points the builder at `backend/Dockerfile`.
2. Service → **Variables**:
   - `GEMINI_API_KEY` — from [aistudio.google.com](https://aistudio.google.com)
     (same key type as physical's coach; you can reuse that key).
   - `APP_TOKEN` — any long random string, e.g. `openssl rand -hex 24`.
   - (optional) `GEMINI_MODEL` — defaults to `gemini-2.5-flash`.
   - (optional) `JOURNAL_MODEL` — defaults to `gemini-2.5-pro`: the Confidant
     reasons over a year of habit history nightly (~a cent/day on Pro).
3. Settings → **Generate Domain** → note the URL,
   e.g. `https://mental-production-xxxx.up.railway.app`.
4. Check `https://<domain>/health` →
   `{"status":"ok", "examiner_configured":true, "auth_required":true}`.

## 2. Point the app at it

In the **Codemagic UI** (your app → Settings → Environment variables — NOT
the yaml; Codemagic rejects empty yaml vars, and the token shouldn't live in
git) add:

| Variable | Value | Group | Secure |
|---|---|---|---|
| `BACKEND_URL` | `https://mental-production-xxxx.up.railway.app` | **`ios_signing`** | no |
| `APP_TOKEN` | the same token as on Railway | **`ios_signing`** | **yes** |

**The group matters.** Codemagic only passes variables whose group is listed
under `environment.groups` in `codemagic.yaml` — this workflow imports
`ios_signing`, so put both variables there. Variables added to any other
group, or typed in one-off when starting a single build manually, will be
MISSING from later push-triggered builds — the app then shows "Examiner
offline / Confidant offline" and runs on the honour system.

Start a build → the app now submits summary sheets to the Examiner before a
star may ignite. **Until those vars exist the build still works** — stars
ignite on the honour system (stage-1 behaviour).

## Local dev

```bash
cd backend
python3 -m venv .venv && .venv/bin/pip install -r requirements.txt
GEMINI_API_KEY=... .venv/bin/uvicorn app.main:app --reload   # docs at :8000/docs
```

Run the app against it:

```bash
flutter run -d linux --dart-define=BACKEND_URL=http://localhost:8000
```

Tests (Gemini faked, no key needed): `.venv/bin/python -m pytest`
— note on this machine: prefix `env -u PYTHONPATH PYTEST_DISABLE_PLUGIN_AUTOLOAD=1`
so ROS Jazzy's Python doesn't leak into the venv.

## API

`POST /verify` (Bearer `APP_TOKEN`) — body: stat, skill, goal, node, tier,
prerequisites[], summary → `{verdict: pass|fail, confidence, feedback}`.
Summaries under 80 chars fail instantly without calling Gemini. Gemini
failures return 502 (the app shows "Examiner could not be reached" and lets
you retry — a submission is never lost).
