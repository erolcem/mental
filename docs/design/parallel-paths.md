# The Parallel-Path Overhaul

**Status: APPLIED (2026-07-04) to `lib/data/skill_data.dart`.**

The catalog was a set of mostly-linear spines — a to-do list dressed as a sky.
This overhaul rebuilds every skill as a real constellation: **many parallel
paths** that rise from their own roots, run independently, cross-link at
synthesis stars, and converge on a single crown.

## The shape

Each `SkillNode` now carries a **`branch`** — the named track it belongs to.
Within a skill, stars of the same branch form a coherent chain; branches run in
parallel (they spread horizontally across the constellation because the layout
pulls each star toward its own prerequisites), and merge where mastery in one
path is required to advance another.

Three rules hold on every node, unchanged in spirit but now enforced structurally:

- **Self-achievable** — study, practice, or exam-mimicry a determined autodidact
  can complete alone: real public exams (AP, GRE, CFA, JLPT, ABRSM, ASE, EPA
  608, ServSafe), video-verified performances, or published artefacts. No node
  requires an institution's permission unless it genuinely must (a dojo grading,
  a peer-review venue that accepts independents).
- **Proven** — each node keeps its concrete `proof`, the completion standard the
  Examiner judges a summary sheet against and the Reviewer quizzes from.
- **Tree-shaped** — `tier` is real dependency depth; `requires` are the specific
  stars that gate a node; prerequisites always sit in a strictly lower tier so
  the constellation's figure lines flow upward.

## What convergence looks like

The parallel paths are not decorative. Every skill has at least one **synthesis
star** fed by two or more branches, and the crown is the final act that only the
whole constellation makes possible. Examples:

- **science** — Physics, Chemistry, Mathematics, Computation and Exams all feed
  the *Thesis* star; the crown is a result the field cites.
- **piano** — Technique, Reading, Repertoire, Musicianship and Performance run in
  parallel; ABRSM performance grades gate the repertoire, and the crown is the
  60-minute memorised recital that demands all five.
- **turkish / japanese / khmer** — Grammar, Vocabulary, Input, Speaking, Reading
  and Writing advance independently; exam gates (TYS, JLPT) sit where two or
  three of them must meet.
- **mechanics** — Auto, Home and Fabrication are three trades pursued side by
  side; the crown is one machine and one room, end to end.

## Counts

**383 nodes** across 4 stats and 21 skills, each skill a constellation of 5–10
named branches (≥4 enforced by test) with exactly one crown alone at the top
tier. Ids surviving from the previous catalog keep their progress; new stars
(e.g. `sc23` Analytical Chemistry, `p20` Improvisation, `m16` Welding, `w17`
Voice & style, `md20` Radiology) extend the branches rather than replace them.

## Invariants (guarded in `test/skill_data_test.dart`)

- unique ids per tree; every prerequisite exists in the same tree
- no dependency cycles; prerequisites in a strictly lower tier
- every node names a branch; every skill has ≥4 branches
- exactly one crown per skill, alone at the max tier, on the `Crown` branch
- at least one node per skill merges ≥2 branches (genuine convergence)
- globally unique progress keys (`skillId.nodeId`)
