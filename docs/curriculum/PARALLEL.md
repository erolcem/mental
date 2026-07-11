# The Grand Braid — the 2026-07 catalog overhaul (current spec)

**Status: SHIPPED.** This document describes the live catalog:
**22 skills · 1,108 stars · 91,965 researched hours** (see ANALYSIS.md for
computed numbers — that file regenerates from the data and never lies).
The per-stat proposals (INT.md, WIS.md, CHA.md, DEX.md) and the earlier
431-node design this file replaces are retained as history.

## Why the overhaul

The previous trees were *decent but linear*: ~20 stars each, mostly chains,
one path to the top. Real mastery is not a chain. A physicist is not a queue
of textbooks; she is classical mechanics AND quantum theory AND lab craft AND
computation AND writing, braided, each strand feeding the others, all
converging on the one thing that counts — an original result. Every tree now
reflects that shape.

## The six laws

Every constellation obeys, and CI enforces (`dart tool/analyze_catalog.dart`,
`test/skill_data_test.dart`):

1. **PARALLEL** — each tree is 6–9 named branches workable at the same time;
   a stuck branch never blocks the sky. Every tree holds **50+ stars**; no
   tier holds more than 7 (so the sky stays readable).
2. **SELF-ACHIEVABLE** — books, free courses, released exams, video-assessed
   certificates, public arenas, logged practice. Exam mimicry wherever the
   official gate is closed; no institution's permission required anywhere.
3. **QUEST-BEARING** — every star carries a **guide** (what to do: the
   materials, the method, the route) and a **proof** (the completion standard
   the Examiner judges and the Reviewer quizzes from). A star is a quest, not
   a checkbox.
4. **CONVERGENT** — branches braid at synthesis stars; every path ends at one
   crown. No orphan stars, no redundant prerequisite edges (transitive
   reduction is enforced).
5. **SAFE** — nothing demands unsupervised danger: dead-circuit electrics,
   dojo-supervised sparring, vocal health before power, jack-stand
   discipline, food safety first, CTF sandboxes for security.
6. **HONEST HOURS** — every star carries a researched deliberate-practice
   estimate; the analytics stay real.

## How the shape is built (code, not hand-tuning)

Authors write only the *semantic* structure — `nx(id, label, requires,
branch, hours, guide, proof)` in `lib/data/catalog/{int,wis,cha,dex}_skills.dart`.
`braidSkill` (catalog/model.dart) then:

- **derives tiers** as longest-prerequisite-chain depth (so "tiers strictly
  increase along every edge" holds by construction);
- **relaxes** overfull tiers — while any tier holds more than 7 stars, the
  member with the fewest descendants slides one deeper, cascading children —
  so the braid spreads instead of bunching;
- keeps the **crown strictly deepest**.

The layout engine (`ui/constellation_layout.dart`) gives every branch its own
lane of sky with the summit lane centred; a star's resting x blends its lane
with the mean of its prerequisites, so strands run beside each other, drift
together where they braid, and visibly converge on the crown. The canvas
widens with the densest tier and the screen pans.

## The braid, per stat

- **INT (203)** — science 51 (Methods · Classical · Quantum & Modern ·
  Chemistry · Computation · Lab Craft · Practice · Research), maths 51,
  medicine 51 (incl. Boards spine, Prevention, Specialty breadth),
  engineering 50 (Systems · Hardware · Electronics · Robotics · Networking ·
  Databases · Security · Craft).
- **WIS (201)** — geography 51 (incl. Spatial Tech chain, Field Craft,
  Forecasting), history 51 (Survey · Sources · Thematic · Regional · Craft ·
  Output), business 50 (CFA spine · Strategy · Marketing · Venture · Arena),
  social science 49 (Methods · Mind & Society · Anthro & Soc · Institutions ·
  Practice · The Study).
- **CHA (405)** — english 51, turkish 51, japanese 51, chinese 51 (HSK
  spine, ids ported from main so progress carries), khmer 50 (each:
  grammar/vocab/listening/speaking/reading/writing/culture + exam spine),
  music theory 50, piano 52, singing 50.
- **DEX (300)** — drawing 50, writing 50, cooking 50, mechanics 50,
  memory 50, karate 50.

## Where the hours come from (verified July 2026)

- **Languages** — FSI category hour studies (Turkish Cat IV ≈ 1,100 h
  classroom; Japanese Cat V ≈ 2,200 h classroom / 3,000–4,500 h self-study
  surveys for N1; Khmer Cat III ≈ 1,100 h plus a resource-scarcity overhead);
  CEFR level deltas for per-level stars.
- **Finance** — CFA Institute's ≈300 h/level guidance.
- **Music** — ABRSM grade norms; **ABRSM Performance Grades remain digital
  video-submission exams (Grades 1–8)**, and Grades 6–8 legally require
  Grade 5 Theory first — encoded in the piano tree.
- **Medicine** — USMLE Step 1 is pass/fail (the NBME Free-120 ≥85% bar);
  Step 2 CK is still scored (mock ≥250).
- **Memory** — Memory League and the IAM circuit are active (2026 ML World
  Championship ran January; the 2026 World Memory Championship is scheduled
  for Bali in December). Crown = ML top-100 or an official IAM event.
- **Writing** — NaNoWriMo the organisation shut down 31 March 2025; the
  50k-in-30-days sprint survives as community challenges (Reedsy Novel
  Sprint, NovelEmber et al.), which is what the tree now names.
- **Forecasting** — Good Judgment Open is live (11th Economist "World
  Ahead" challenge, 2026).
- **Drawing** — Drawabox is active (community events through mid-2026).
- **Textbook stars** — sized by problem-set volume (a Jackson or Peskin pass
  is a 350–400 h object; a first-course text 150–300 h).

Hours measure *deliberate* work toward the proof standard, not elapsed
calendar time or ambient exposure.

## Progress migration

Node ids were kept wherever a star's meaning survived (sc1, m1, md1, j3, p3,
k1…), so existing ignitions carry over; where a concept was split or
re-founded the star gets a fresh id and is simply re-earned. Persistence keys
by `skillId.nodeId` (`progressKey`), so identical short ids across trees
(maths m1 vs mechanics m1) never collide.
