# Mental — a constellation of lifetime mastery

Skyrim-style skill trees for real life. The sky holds **4 stats** (Intelligence,
Wisdom, Charisma, Dexterity) → **21 skills** → **431 mastery nodes**, each a star
in that skill's constellation. Ignite a star by completing the work and writing a
**mastery summary sheet**; the constellation lights up star by star until the
crown — the skill's endgame (e.g. *"The One-Hour Memorised Recital"*).

Every constellation is a **braid of parallel branches** (technique / theory /
practice / craft) that can be worked simultaneously and all converge on a
single crown — see `docs/curriculum/PARALLEL.md` for the five laws every tree
obeys (parallel, self-achievable, proof-bearing, convergent, safe). Each star
carries a **researched effort estimate** (FSI/JLPT hour studies, CFA guidance,
ABRSM norms): the full sky is **≈50,750 hours** of deliberate work — about 35
years at four focused hours a day. `dart tool/analyze_catalog.dart` recomputes
the whole analysis (critical paths, braid factors, choice breadth) without a
Flutter toolchain → `docs/curriculum/ANALYSIS.md`.

Native Flutter app, structured after `physical` (the sibling repo): local-first,
Riverpod state, `shared_preferences` persistence, Codemagic → TestFlight.

## Layout

```
lib/
  data/
    skill_data.dart            the full catalog (parallel-paths overhaul applied)
    repository.dart            NodeProgress + JournalEntry models, repo interfaces
    persistent_repository.dart shared_preferences implementation
    habit_ledger.dart          the advisor's memory: 365-day kept/missed digest
    sync.dart                  Sky Link: keys, snapshots, conservative merge
  state/
    providers.dart             Riverpod: progress notifier + mastery/XP/level derivations
    sync_controller.dart       Sky Link orchestration (pull → merge → push)
  ui/
    galaxy_screen.dart         home sky: a tall drifting canvas (pan + pinch zoom)
    constellation_screen.dart  one skill as a pan/zoom constellation (CustomPainter)
    constellation_layout.dart  deterministic organic star layout (seeded per node)
    node_sheet.dart            the quest sheet: road, briefing, standard, unlocks, rite
    habit_ledger_sheet.dart    the Habit Ledger: every kept and missed action
    sky_link_sheet.dart        Sky Link: forge/link keys, sync across devices
    starfield.dart             animated night sky (cached static layer + twinkle + meteors)
    theme.dart                 palette + Cinzel/Raleway variable fonts
test/                          data integrity, progress rules, locks, merge laws, widget smoke
tool/analyze_catalog.dart      pure-Dart catalog verifier + analytics generator
Wisdom/                        legacy React prototype (reference only)
```

## Rules of the sky

- A node unlocks only when **all** prerequisite stars are lit.
- Igniting grants **effort-weighted XP** (hours + tier × 10 — a star pays what
  it costs); level 1–99 on a square-root curve — full sky = 99.
- Extinguishing a star darkens every star that depended on it (summaries are kept).
- Progress keys are `skillId.nodeId` (node ids repeat across trees, e.g. maths/mechanics `m1`).
- Trees are braids, not chains: several branches stay workable at once, tiers
  strictly increase along every edge, and every star lies on a path to its
  tree's single crown (all enforced by `test/skill_data_test.dart`).

## The Examiner (stage 2)

`backend/` is a stateless FastAPI + Gemini service (`POST /verify`): the app
sends a node's context + your summary sheet; the Examiner passes or fails it
with feedback. Pass → the star ignites **verified**, with the Examiner's note
kept on the node. Fail → the feedback appears in the sheet and you revise and
resubmit. No backend configured → honour-system ignition (stage-1 behaviour).
Deploy: `backend/DEPLOY.md`; wire the app via `BACKEND_URL`/`APP_TOKEN` in
`codemagic.yaml`.

## The Review (stage 3)

Every ignited star carries a spaced-repetition schedule (3 → 7 → 14 → 30 → 60 →
120 → 240 days). When any star is overdue, **the sky locks** — no new ignitions
until every due star is faced in the Review: the Reviewer (`/review/questions` +
`/review/grade`) asks two probing questions from your own summary sheet and
grades your from-memory answers. Pass → the interval climbs; fail → the star
falls a rung and returns tomorrow (a faced review always unlocks — lockout
demands you show up, not that you ace it). Overdue stars gutter amber in their
constellations; without a backend, reviews are self-attested on honour.

## The Journal (stage 4) — and the Disciplined Advisor

The nightly closed loop. You talk the day through with the **Confidant**
(`/journal/reply`) — it knows yesterday's action items and asks about
follow-through — then **close the day** (`/journal/close`): the session
distills **1–3 concrete actions for tomorrow** plus a one-line reflection.
Today's actions live on the galaxy's bottom bar as a checklist; tonight's
journal asks how they went. Once the habit has begun (first closed entry),
a day without journaling **locks the sky the next morning** until today's
session is closed. Without a backend: freeform entry + self-written actions.

The Confidant is also a **disciplined habit advisor with a year of memory**.
Every request carries the **habit ledger** (`lib/data/habit_ledger.dart`): a
client-built digest of the last 365 days — every action kept or missed,
each night's lesson, and the advisor's own past **rationale** — verbose for
the recent weeks, monthly rollups beyond, hard-capped to match the backend.
Closing the day is prescribed by iteration, not invention: *continuity*
(evolve yesterday's list), *one notch up* after ~a week kept, *shrink what
keeps failing* (never verbatim a third time, never silently dropped), *one
new thing at a time* — and the advisor writes its reasoning down, which
feeds back through the ledger the next night. The **Habit Ledger sheet**
(journal header, or the galaxy menu) shows the same evidence: streaks,
follow-through rate, and every day's checkmarks.

## Sky Link (cross-device sync)

Forge a **Sky Key** (galaxy menu → Sky Link), enter it on another device,
and the two skies merge and stay in step. Every sync is pull → merge →
push; the merge is a conservative union with tested laws — a lit star
beats a dark one, an offline-drafted sheet survives, the higher review
rung carries the schedule, a closed journal day beats an open one, and a
tick given anywhere stays given. The server (`/sync/*`) stores one opaque
snapshot per key, only ever sees the key's SHA-256, and sits behind the
same APP_TOKEN as everything else. Losing the key means minting a new sky
— no accounts, nothing to phish, nothing to recover.

## Roadmap

1. **Stage 1 (done)** — native constellation app on TestFlight.
2. **Stage 2 (done)** — the AI Examiner verifies summary sheets before a star may ignite.
3. **Stage 3 (done)** — spaced-repetition reviews with AI quizzes; overdue reviews lock the sky.
4. **Stage 4 (done)** — daily closed-loop AI journal → 1–3 next-day actions; skipping locks the sky.
5. **Stage 5 (this)** — the Disciplined Advisor (365-day habit ledger + rationale memory),
   Sky Link cross-device sync, the tall drifting home sky, quest briefings on every star,
   per-role Gemini models (`GEMINI_MODEL` / `GEMINI_JOURNAL_MODEL`, default `gemini-3.5-flash`).

## Build

```
flutter pub get
flutter test && flutter analyze
flutter run -d linux        # desktop dev
```

Push to GitHub → Codemagic builds a signed IPA and submits to TestFlight
(`codemagic.yaml`; bundle id `com.cemiloglu.mental`).
