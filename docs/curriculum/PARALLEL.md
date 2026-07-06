# The Parallel Paths Overhaul — 2026-07-06

**Status: APPLIED to `skill_data.dart`.** Supersedes the four proposal docs
(INT/WIS/CHA/DEX.md, kept for history). 4 stats → 21 skills → **431 nodes**.

The earlier catalog was verifiable and self-achievable, but many trees were
still *chains* — one node at a time, single file to the crown. A real
apprenticeship never works like that: you drill technique while you learn
repertoire while you train your ear. This overhaul makes every constellation
a **braid of simultaneous branches**, so on any given week the sky offers
several stars you could be working toward, and a stuck branch never stalls
the whole skill.

## The five laws (enforced by `test/skill_data_test.dart`)

1. **PARALLEL** — every tree is 3–5 named branches workable at the same time.
   Structural floor: ≥4 tiers offering ≥2 stars, ≥1 tier offering ≥3, and no
   tree below 16 nodes.
2. **SELF-ACHIEVABLE** — books, free courses, released exams, video-assessed
   certificates (ABRSM, ServSafe, BLS, EPA 608), public arenas (Memory
   League, Good Judgment Open, picoCTF, NaNoWriMo), and logged deliberate
   practice. Exam mimicry wherever the official gate is closed (timed CFA
   mocks, TYS-format mocks, ASE practice exams). No institution's permission
   required anywhere.
3. **PROOF-BEARING** — every node carries a completion standard the Examiner
   verifies evidence against and the Reviewer quizzes from.
4. **CONVERGENT** — branches braid at synthesis nodes and every path ends at
   **one crown**: exactly one star at each tree's max tier, and every star
   lies on a path to it. No orphan stars — everything you light matters at
   the summit. (Previously e.g. General Relativity and SPQR dead-ended.)
5. **SAFE** — nothing demands unsupervised danger: home electrical work is on
   dead practice circuits, sparring is dojo-supervised, vocal power is gated
   behind vocal health, engines sit on jack stands, cooking starts with the
   food-safety certificate. Tiers strictly increase along every prerequisite
   edge, so nothing advanced ever unlocks before its foundations.

Node ids are preserved wherever the star survived, so existing progress
carries over untouched. Tier renumbering is free (progress keys only use ids).

---

## INT — Intelligence (98)

**science · 27** — *Publish an Original Scientific Result*
Branches: Physics (sc2→sc4→sc7/sc6→sc10→sc13/sc12→sc21/sc14) · Chemistry
(sc3→sc5→sc9/sc22, sc8, sc11) · Math & Computation (sc19, sc20) ·
**NEW Experimental Craft**: home lab instruments (sc24) → error analysis
(sc23) → replicate classic experiments (sc25) → scientific writing & LaTeX
(sc26) → arXiv journal club (sc27). All eight streams converge at the thesis
gate (sc15) — the autodidact's qualifying exams.

**maths · 26** — *Prove and Publish an Original Theorem*
Branches: Analysis (m4→m7→m9/m10→m12→m15/m20) · Algebra & Discrete —
**NEW** combinatorics (m23) and number theory (m22) feeding Dummit & Foote ·
Probability & Applied (m5, m6, m11, m13, m14, m21) · **NEW Problem Craft &
Exposition**: Putnam sets (m19) → mathematical essays (m24) → full timed
Putnams (m25) → reading real papers (m26). Converges at quals (m16) then the
monograph (m17).

**medicine · 23** — *Chief Attending / Diagnostician*
Branches: Basic-science → Step spine (unchanged core md2–md15) · Clinical
Craft (Bates, ECG, **NEW imaging md23**) · **NEW Emergency Response** — real
public certificates: First Aid + Stop the Bleed (md19) → Wilderness First
Aid (md20), which now gates the physical-exam star · **NEW Evidence**:
epidemiology & biostats (md21) → critical appraisal of RCTs (md22), which
gates the NEJM case gauntlet.

**engineering · 22** — *Build Your Own Computer, OS & Distributed System*
Branches: Software Systems (eg5→eg21 **NEW Crafting Interpreters**→eg10→
eg14→eg16) · Hardware & Embedded (eg4→eg9→eg13→eg15→eg17) · Electronics &
Signals (eg6→eg8→eg12) · **NEW Craft**: Unix/git tooling (eg19) → CTF
security training (eg20) and shipping a real product to real users (eg22).
Crown demands the cluster *and* the security and shipping stars.

## WIS — Wisdom (83)

**geography · 20** — *Global Geospatial Analyst & Forecaster*
Branches: World Knowledge (g1→g3→g6) · Physical & Human (g2→g5/g18 **NEW
weather & climate**→g19 **NEW demography**) · Geopolitics (g4→g8→g12→g14) ·
Spatial Tech & **NEW Field Craft**: QGIS→PostGIS→GeoPandas→remote sensing,
plus surveying your own region (g20) → cartographic design (g17). Dashboard
(g15) then crown pulls all four.

**history · 20** — *Master Historian & Archival Synthesis*
Branches: Grand Survey (Durant spine + Sapiens) · Methods & Primary Sources
— **NEW historiography Carr-vs-Evans (h18)**, primary sources (h11) → **NEW
local history of your own town (h20)** → **NEW oral history interviews
(h19)** · Thematic Depth (SPQR, Sleepwalkers, WWII, Cold War, economic
history) · Craft (AP World → DBQs → era synthesis → archive → monograph).
SPQR now feeds the synthesis star instead of dead-ending.

**business · 22** — *Run Money Like an Institution*
Branches: Economics & Markets (b2, b3 → **NEW market history & bubbles
b23**) · Accounting → CFA spine (b4→b6/b7→b8/b12→b11→b19/b13→b14/b15) ·
Strategy & Operations (b5→b10) · **NEW Practice**: field negotiation (b20) →
a real micro-venture with honest P&L (b21) → marketing + landing-page test
(b22). The paper portfolio requires market history; the crown requires the
venture thread — money you run *and* a business you ran.

**socialSci · 21** — *Run a Real Behavioral Study*
Branches: Psych Core (ss3→ss4/ss6→ss7) · Methods & Stats (ss2→ss17, **NEW
game theory ss18**) · Mind & Society (ss5→ss8→ss9/ss10, **NEW behavioral
economics — replication-audited ss20**, ss11) · Applied Practice (stoicism
ss12 → **NEW wellbeing science ss21**, **NEW ethnography ss19**). Study
chain ss13→ss14→ss15 → crown, which also demands the clinical, field and
lived-practice stars.

## CHA — Charisma (139)

**english · 19** — *Command the Room and the Page*
Branches: Language (e2→e4→e16) · Writing Craft (**NEW close reading e17** →
**NEW style pastiches e20** → essays e10) · Rhetoric & Speech (e6→e9→e11→
e13/**NEW storytelling e19**) · Argument (e5 → **NEW formal debates e18**).
Keynote (e14) then crown.

**turkish · 19** — *C1+ and Real-Time Interpretation*
Now a true 4-lane language tree: Grammar spine (tr2→tr3→tr4→tr5→tr6→tr8) ·
Input (tr9, **NEW 5k vocabulary SRS tr15**, Pamuk tr10) · Output (**NEW
scripted monologues tr18** → conversation tr7→tr11; **NEW corrected writing
tr19** → C1 essays tr12) · **NEW Culture & Song** (tr16 music & lyrics from
day one, tr17 history & culture) feeding the literature star.

**japanese · 22** — *N1 + the Spoken Skill JLPT Never Tests*
Branches: Script & Kanji (j3→j5→j8) · Grammar (j2→j4→j7→j13) · Vocabulary &
Input (j6→j9/j11/j12→**NEW Input II 250 hrs j21**) · Output (**NEW pitch
accent + shadowing j19**, **NEW corrected journal j20**, speaking j16,
keigo j15) · **NEW Culture** (j22). JLPT spine unchanged; N1 also demands
the input mileage, and the crown demands the writing and culture stars.

**khmer · 18** — *Fluency Where No Textbook Ecosystem Exists*
Branches: Script & Literacy (kh2→kh6→kh9, **NEW digital Khmer typing
kh15**) · Core Language (kh3→kh4→kh5→kh8→kh10) · Output (**NEW first
exchanges kh18** → kh7→kh12, **NEW songs & karaoke kh16**) · Culture (**NEW
Chandler history kh17**, day one) feeding the Reamker star.

**musicTheory · 19** — *Compose and Hear It Performed*
Branches: Written Theory / ABRSM spine (mt2→mt4→mt5→mt7→mt8→mt9/mt10) · Ear
(mt3→mt15→**NEW transcription mt20**) · **NEW Rhythm** (mt19, gating Grade
5) · **Composition now starts at tier 3, not the summit**: 8-bar melodies
(mt16) → theme & variations (mt17) → **NEW jazz & pop harmony (mt18)** —
all three feed the portfolio (mt13).

**piano · 22** — *The One-Hour Memorised Recital*
Branches: Technique (p3→p4/p5→p8/p9→p12) · Reading (p2→p13) · Repertoire /
ABRSM spine (p18→p6→p19→p10→p11→p14→p15) · Musicianship (lead sheets p7 →
**NEW improvisation p20** → **NEW accompanying others p22**) · **NEW
Performance Craft**: monthly one-take ritual (p21), memorisation-by-analysis
(p23, gating Grade 8). Crown = recital, requiring the ensemble star too.

**singing · 20** — *Release an EP and Sing It Live*
Branches: Technique with **NEW vocal health first (v17, gates both
registers)** · Ear & Musicianship (**NEW interval singing v21** → **NEW
harmony duets v18**) · Repertoire & Style (v16→v10, **NEW songwriting v20 —
the EP carries your own songs**) · Performance & Production (v11, **NEW
stage & mic craft v19** → open mics → EP). Crown = your EP, live, in
harmony-capable voice.

## DEX — Dexterity (111)

**drawing · 20** — *A Body of Work Worth Exhibiting*
Branches: Construction (d2→d3→d4→d7) · Observation (gesture→anatomy I–III,
Bargue → **NEW master studies d19**) · Light & Color (d5→d9→d12) ·
Imagination, Habit & Digital: **NEW 100-day sketchbook habit (d18, fuels
gesture)**, **NEW plein-air environments (d21)**, **NEW digital craft
(d20)**. All feed composition (d13) → portfolio → exhibit.

**writing · 19** — *A Published Novel*
Branches: Reading (w2→**NEW genre immersion w20**) · Craft (**NEW prose
rhythm & poetry w18**, structure, **NEW research/world-building bible
w19**) · Production spine (stories→NaNo→novel→revision→betas) · Community &
Submission: critique circle → **NEW flash submissions w17** → **NEW place a
short story w21** — real arena scars before the query trenches.

**cooking · 20** — *Chef of Your Own Table*
Branches: Technique spine (knife→eggs→SFAH→vegetables/sauces→proteins) ·
**NEW Food Science (McGee c17, gates framework cooking and fermentation)** ·
Baking & Pastry (bread → **NEW lamination & desserts c21**) · World &
Presentation (cuisines → **NEW plating c18** → **NEW menu craft & costing
c19**) · **NEW tool care & sharpening (c20, gates butchery)**. Crown = the
tasting menu, planned and costed like a professional.

**mechanics · 18** — *Rebuild It Yourself*
Branches: Auto (m2→m4→m6→ASE) · Home (m3→m5→m7→m11, EPA 608) · Machines —
**NEW bicycle full tune-up (m16)** as the safe gateway into engines · **NEW
Making**: woodworking a workbench (m17) → CAD + 3D printing (m18) →
metalwork & fasteners (m19). Crown = a machine rebuilt, a room transformed,
and things you made from raw stock.

**memory · 17** — *Compete Among the Best from Your Desk*
Branches: Systems (link→palaces→Major→PAO→palace network) · **NEW Science of
Learning (mem14)** · **NEW Applied Memory** — memory that enriches life, not
just scores: a poem and a speech (mem15) → a permanent knowledge vault
(mem16) · Competition (names/numbers/cards → **NEW names in the wild
mem17** → league season). Crown demands the applied stars too.

**karate · 17** — *Shodan and Beyond, Honestly Earned*
Branches: Kihon & Kata (k2→k3→k5→k7→k8) · Kumite (k4→k6→k9, dojo-supervised
always) · Conditioning (k15, gates sparring) · **NEW Theory, History &
Mind**: dojo Japanese (k16) → Funakoshi's philosophy (k17) → rules & judging
literacy (k18, feeds the crown — a sandan who can also referee and teach).

---

**Counts:** INT 98 · WIS 83 · CHA 139 · DEX 111 — **431 stars**.
Verification: `flutter test test/skill_data_test.dart` (structure) and
`test/layout_test.dart` (the sky still places every star tappably), or
`dart tool/analyze_catalog.dart` on any machine without Flutter.

## Addendum (same day): research corrections + the effort model

- **ABRSM**: Performance Grades 6–8 are video-assessed but *legally require
  Grade 5 Music Theory (or Practical Musicianship) first* — now stated in the
  piano Grade 8 star's proof, pointing at the Music Theory constellation.
- **Putnam**: the real median is 0–2 points out of 120, so the timed-Putnam
  bar became ≥20/120 self-graded (still far above almost every contestant).
- **Hours**: every star now carries a researched deliberate-practice
  estimate (FSI language categories, JLPT N1 hour surveys, CFA ≈300 h/level,
  ABRSM norms, problem-set volume for textbooks). Full analytics — critical
  paths, braid factors, frontier/choice breadth per tree — are generated
  into `ANALYSIS.md` by `dart tool/analyze_catalog.dart --write`.
- **Branches are data**: each star's lane (`SkillNode.branch`) is
  first-class — Foundations → 3–5 working lanes → a summit lane — enforced
  by tests (≥5 named branches per tree), shown in the node sheet, and
  analysed per branch in `ANALYSIS.md`.
- **XP is effort-weighted**: XP = hours + tier × 10, so the level bar
  measures life actually invested rather than counting a 700-hour thesis
  equal to a 40-hour primer at the same tier.
