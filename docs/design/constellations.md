# Constellation Design — Improvement Directions

**Status: MENU for Erol's markup.** The skill-tree (constellation) screen is
"decent but could be much more". Below: how it works today, an honest
critique, and ten directions ranked by impact. Mark what excites you (or
sketch your own) and return it — I'll build from your selections.

---

## How it renders today

- **Layout** (`constellation_layout.dart`): tier bands bottom→top, seeded
  jitter (±22px x, ±26px y), children pulled toward the mean of their
  prerequisites, collision sweep. Deterministic per skill.
- **Stars** (`constellation_screen.dart` painter): ignited = white core +
  colour halo + 4-point diffraction spikes + breathing; frontier (unlockable)
  = pulsing ember; locked = 1.7px dot at 22% alpha; review-overdue = amber
  gutter-flicker.
- **Edges**: lit→lit = glowing solid line; parent-lit = colour dashes;
  locked = faint white dashes.
- **Labels**: 9px Raleway under every star, dark backing pill, 2-line max.
- **Chrome**: tier numerals (I–XIII) down the left, header with goal +
  mastery %, pan/zoom via InteractiveViewer starting at the base.

## Honest critique

1. Every label always visible = a *chart*, not a sky. Real star atlases show
   names sparsely; the eye should find stars first, words second.
2. Straight polyline edges look computed. Real constellation figures have
   character because a human drew them.
3. All stars are the same *kind* of object — the crown star, exam gates,
   and ordinary milestones deserve different presences.
4. Zoomed out, everything shrinks equally; zoomed in, nothing new is
   revealed. Zoom should *mean* something.
5. The vertical tier ladder is legible but rigid — every constellation is a
   tall tree. Real constellations sprawl.

---

## Directions (pick any; roughly ranked by impact/effort)

### A. Zoom-adaptive labels ("atlas mode") — high impact, low effort
Labels fade with zoom: zoomed out, only the skill name + crown star + your
frontier stars are named; mid-zoom adds lit stars; full zoom names all.
The sky breathes; the chart appears only when you lean in.

### B. Star-kind hierarchy — high impact, low effort
- **Crown star**: visibly regal — larger halo, 6-point spikes, faint corona.
- **Exam/gate nodes** (mocks, gradings, quals): drawn as *binary stars* or
  ringed stars — you can see the gates from across the constellation.
- **Ordinary nodes**: as now. Legend goes in the ledger sheet.

### C. Hand-authored figure lines — high impact, medium effort
Replace prerequisite-edge rendering with a designed "figure" per skill: a
curated subset of edges drawn as the constellation's *shape* (like Lyra's
parallelogram), remaining prerequisites shown only on tap/highlight. Data:
one optional `figure: [[a,b],...]` list per skill. This is the single
biggest step from flowchart → constellation.

### D. Constellation art layer (Stellarium-style) — highest wow, high effort
A faint mythic engraving behind each skill's stars (the Scholar, the
Serpent, the Anvil...), Uranometria etching style, ~8% opacity, fading in
at mid-zoom. Needs 21 illustrations (AI-generated, then curated — I can
draft them; you approve). The single biggest immersion unlock.

### E. Ignition trails — medium impact, low effort
When a star ignites, a slow comet travels from it along the figure lines to
the next unlockable stars, igniting their "ember" state. Progress becomes
literal light spreading through the constellation.

### F. Depth & parallax — medium impact, medium effort
Split each constellation into 3 depth layers (background dust, mid stars,
the skill's stars). Panning parallaxes them; the tree floats *in* the sky
instead of *on* it. (Phone gyroscope parallax optional later.)

### G. Organic layout pass — medium impact, medium effort
Relax the strict tier bands: allow ±half-tier drift, radial "spray" for
sibling branches, wider aspect ratio with horizontal panning. Trees stop
being uniformly tall; Cassiopeia-like sprawls emerge. (Tier numerals become
subtle iso-arcs instead of a left ruler.)

### H. The crown's constellation completion moment — high delight, medium effort
At 100%: the full figure flashes gold once, the constellation gets a
permanent aura + its name engraved in the galaxy in gold, and a "named star
certificate" card you can share/screenshot.

### I. Progress rail / minimap — utility, low effort
A thin vertical rail on the right: your position in the tree, lit/frontier/
locked segments, tap to jump tiers. Helps the 13-tier constellations.

### J. Sound & haptics — atmosphere, low effort
Soft chime + haptic on ignition, low rumble on lock, paper-rustle on sheet
open. (Flutter `HapticFeedback` + bundled samples; fully offline.)

---

## Suggested bundle

If you want a single coherent next step: **A + B + C + E** — sparse atlas
labels, star-kind hierarchy, authored figures, ignition trails. That set
transforms the read from "graph UI" to "living star atlas" without any
artwork dependency, and D (the art layer) can land on top later.

*Your markup:*
