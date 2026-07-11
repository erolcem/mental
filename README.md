# Mental — a constellation of lifetime mastery

Skyrim-style skill trees for real life. The sky holds **4 stats** (Intelligence,
Wisdom, Charisma, Dexterity) → **22 skills** → **1,108 mastery stars**, each a
star in that skill's constellation. Ignite a star by completing the work and
writing a **mastery summary sheet**; the constellation lights up star by star
until the crown — the skill's endgame (e.g. *"The One-Hour Memorised Recital"*).

Every constellation is a **braid of 6–9 parallel branches** (technique / theory
/ practice / craft / arena) that can be worked simultaneously and all converge
on a single crown — see `docs/curriculum/PARALLEL.md` for the six laws every
tree obeys (parallel, self-achievable, quest-bearing, convergent, safe, honest
hours). Every star is a **quest**: a `guide` (what to do — the materials, the
method, the route) and a `proof` (the completion standard the Examiner judges).
Each carries a **researched effort estimate** (FSI/JLPT hour studies, CFA
guidance, ABRSM norms): the full sky is **≈92,000 hours** of deliberate work —
a lifetime, on purpose. `dart tool/analyze_catalog.dart` recomputes the whole
analysis (critical paths, braid factors, choice breadth) without a Flutter
toolchain → `docs/curriculum/ANALYSIS.md`.

Native Flutter app, structured after `physical` (the sibling repo): local-first,
Riverpod state, `shared_preferences` persistence, Codemagic → TestFlight.

## Layout

```
lib/
  data/
    skill_data.dart            catalog spine: re-exports the model, assembles the sky
    catalog/model.dart         pure-Dart model + braidSkill (derived tiers + relaxation)
    catalog/{int,wis,cha,dex}_skills.dart   the 1,058-star curriculum
    repository.dart            NodeProgress model + repository interface
    persistent_repository.dart shared_preferences implementation
    transfer.dart              cross-device export/import (newer-wins merge)
  state/
    providers.dart             Riverpod: progress notifier + mastery/XP/level derivations
  ui/
    galaxy_screen.dart         home sky: pannable/pinchable tall galaxy, 4 stat clusters
    constellation_screen.dart  one skill as a pan/zoom constellation (CustomPainter)
    constellation_layout.dart  branch-lane layout: each branch its own strand of sky
    node_sheet.dart            the quest sheet: guide, proof, prereqs, unlocks, examiner
    starfield.dart             animated night sky (keyed baked-picture cache + twinkle)
    theme.dart                 palette + Cinzel/Raleway variable fonts
test/                          data integrity, progress rules, locks, layout, widget flows
tool/analyze_catalog.dart      pure-Dart catalog verifier + analytics generator
Wisdom/                        legacy React prototype (reference only)
```

## Rules of the sky

- A node unlocks only when **all** prerequisite stars are lit.
- Igniting grants **effort-weighted XP** (hours + tier × 10 — a star pays what
  it costs); level 1–99 on a square-root curve — full sky = 99.
- Extinguishing a star darkens every star that depended on it (summaries are kept).
- Progress keys are `skillId.nodeId` (node ids repeat across trees, e.g. maths/mechanics `m1`).
- Trees are braids, not chains: 6–9 branches stay workable at once, tiers
  strictly increase along every edge, no tier exceeds 7 stars, and every star
  lies on a path to its tree's single crown (all enforced by
  `test/skill_data_test.dart` and the CI catalog gate).

## The Examiner (stage 2)

`backend/` is a stateless FastAPI + Gemini service (`POST /verify`): the app
sends a node's context + your summary sheet; the Examiner passes or fails it
with feedback. Pass → the star ignites **verified**, with the Examiner's note
kept on the node. Fail → the feedback appears in the sheet and you revise and
resubmit. No backend configured → honour-system ignition (stage-1 behaviour).
Deploy: `backend/DEPLOY.md`; wire the app via `BACKEND_URL`/`APP_TOKEN` in
`codemagic.yaml`. Models are tiered: `GEMINI_MODEL` (chat replies, low
thinking) and `GEMINI_MODEL_DEEP` (verdicts, grading, the nightly close — high
thinking); both default to `gemini-3.5-flash`.

## The Review (stage 3)

Every ignited star carries a spaced-repetition schedule (3 → 7 → 14 → 30 → 60 →
120 → 240 days). When any star is overdue, **the sky locks** — no new ignitions
until every due star is faced in the Review: the Reviewer (`/review/questions` +
`/review/grade`) asks two probing questions from your own summary sheet and
grades your from-memory answers. Pass → the interval climbs; fail → the star
falls a rung and returns tomorrow (a faced review always unlocks — lockout
demands you show up, not that you ace it). Overdue stars gutter amber in their
constellations; without a backend, reviews are self-attested on honour.

## The Journal (stage 4)

The nightly closed loop. You talk the day through with the **Confidant**
(`/journal/reply`) — it knows yesterday's action items and asks about
follow-through — then **close the day** (`/journal/close`): the session
distills **1–3 concrete actions for tomorrow** plus a one-line reflection.
Today's actions live on the galaxy's bottom bar as a checklist; tonight's
journal asks how they went. Once the habit has begun (first closed entry),
a day without journaling **locks the sky the next morning** until today's
session is closed. Without a backend: freeform entry + self-written actions.

**The advisor has memory.** The app ships up to **365 days of habit history**
(every action, its done/not-done state, every reflection) with each call; the
backend compiles it into a **habit ledger** — per-habit success rates, streak
patterns, the last fortnight verbatim — and the close runs a progression
doctrine: advance what succeeds (~80%+ → one notch harder), shrink what fails
(3+ misses → a floor version or a new trigger), at most one new habit at a
time. Every prescribed action carries a **why** ("hit 6/7 this week — stepping
up"), shown beside its checkbox.

## Cross-device progress

**Sky Link (server sync):** `⋮ → Sky Link` mints a 24-character Sky Key on
one device; enter it on another and every sync is pull → merge → push against
the backend's `/sync` blob store (the server only ever sees the key's SHA-256;
snapshots merge conservatively — nothing lit or written is ever lost). Set
`SYNC_DB` on the backend (see `backend/DEPLOY.md`).

**Clipboard transfer (no backend needed):** `⋮ → Export sky to clipboard` serialises everything (progress + journal) to a
JSON blob; paste it into `⋮ → Import sky from clipboard` on the other device.
Import **merges** — per star and per journal day the newer record wins, and a
lit star never goes dark — so you can carry the sky phone ↔ phone ↔ desktop
without accounts. (Real sign-in sync would follow `physical`'s JWT + Postgres
pattern on the backend; the transfer format in `lib/data/transfer.dart` is the
migration path.)

## Roadmap

1. **Stage 1 (done)** — native constellation app on TestFlight.
2. **Stage 2 (done)** — the AI Examiner verifies summary sheets before a star may ignite.
3. **Stage 3 (done)** — spaced-repetition reviews with AI quizzes; overdue reviews lock the sky.
4. **Stage 4 (done)** — daily closed-loop AI journal → 1–3 next-day actions; skipping locks the sky.
5. **Stage 5 (this)** — the Grand Braid: 1,058-star quest catalog, habit-ledger
   advisor, pannable galaxy, cross-device transfer.

## Build

```
flutter pub get
flutter test && flutter analyze
flutter run -d linux        # desktop dev
```

Push to GitHub → Codemagic builds a signed IPA and submits to TestFlight
(`codemagic.yaml`; bundle id `com.cemiloglu.mental`).
