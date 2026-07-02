# Mental — a constellation of lifetime mastery

Skyrim-style skill trees for real life. The sky holds **4 stats** (Intelligence,
Wisdom, Charisma, Dexterity) → **21 skills** → **332 mastery nodes**, each a star
in that skill's constellation. Ignite a star by completing the work and writing a
**mastery summary sheet**; the constellation lights up star by star until the
crown — the skill's endgame (e.g. *"Perform Concerto with Live Orchestra"*).

Native Flutter app, structured after `physical` (the sibling repo): local-first,
Riverpod state, `shared_preferences` persistence, Codemagic → TestFlight.

## Layout

```
lib/
  data/
    skill_data.dart            the full catalog (PROVISIONAL — curriculum review pending)
    repository.dart            NodeProgress model + repository interface
    persistent_repository.dart shared_preferences implementation
  state/
    providers.dart             Riverpod: progress notifier + mastery/XP/level derivations
  ui/
    galaxy_screen.dart         home sky: 4 stat clusters, skill stars
    constellation_screen.dart  one skill as a pan/zoom constellation (CustomPainter)
    constellation_layout.dart  deterministic organic star layout (seeded per node)
    node_sheet.dart            node detail: prereqs, summary sheet editor, ignite/extinguish
    starfield.dart             animated night sky (cached static layer + twinkle + meteors)
    theme.dart                 palette + Cinzel/Raleway variable fonts
test/                          data integrity, progress rules, layout, widget smoke
Wisdom/                        legacy React prototype (reference only)
```

## Rules of the sky

- A node unlocks only when **all** prerequisite stars are lit.
- Igniting grants XP (tier × 10); level 1–99 on a square-root curve — full sky = 99.
- Extinguishing a star darkens every star that depended on it (summaries are kept).
- Progress keys are `skillId.nodeId` (node ids repeat across trees, e.g. maths/mechanics `m1`).

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

## Roadmap

1. **Stage 1 (done)** — native constellation app on TestFlight.
2. **Stage 2 (done)** — the AI Examiner verifies summary sheets before a star may ignite.
3. **Stage 3 (this)** — spaced-repetition reviews with AI quizzes; overdue reviews lock the sky.
4. **Stage 4** — daily closed-loop AI journal → 1–3 next-day actions; skipping locks the sky.

## Build

```
flutter pub get
flutter test && flutter analyze
flutter run -d linux        # desktop dev
```

Push to GitHub → Codemagic builds a signed IPA and submits to TestFlight
(`codemagic.yaml`; bundle id `com.cemiloglu.mental`).
