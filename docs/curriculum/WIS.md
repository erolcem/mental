# Curriculum Review — WIS (Wisdom)

> **Historical proposal (2026-07).** Long since applied and then surpassed:
> the live catalog is now **495 nodes**, each with a step-by-step `guide`
> (THE WORK). Source of truth: `lib/data/catalog_wis.dart` + the generated
> `docs/curriculum/ANALYSIS.md`.

**Status: PROPOSAL for Erol's markup.** Same three principles as INT, plus the
accessibility rule: **every node is self-studyable or mimics a real
examination** — no employer, university, or institution's permission required
anywhere in this stat.

---

## 1. geography — Geography 🌍
**Goal (proposed):** "Global Geospatial Analyst & Forecaster"

The old tree mixed memorisation, books and GIS into one chain. Now three
branches — **World Knowledge**, **Geopolitics**, **Spatial Tech** — merging
into a forecasting-and-analysis crown. Exam mimicry via AP Human Geography
and the International Geography Olympiad (iGeo) past papers, both public.
Forecasting is scored on Good Judgment Open (free, public, brutal).

| Tier | Id | Node | Requires | Verified by |
|---|---|---|---|---|
| 1 | g1 | Anki: 196 nations, capitals & flags | — | matured deck, 95%+ retention |
| 2 | g3 | Blank-map mastery: 100 rivers, ranges, straits & chokepoints | g1 | draw/place from memory on blank maps |
| 2 | g2 | Physical Geography (Strahler) | g1 | chapter self-exams: landforms, climate, biomes |
| 2 | g4 | Prisoners of Geography + Revenge of Geography | g1 | one-page strategic brief per chapter |
| 3 | g5 | Human Geography (AP HuG) | g2 | ≥4 on two released AP exams, timed |
| 3 | g7 | QGIS Fundamentals (official training manual) | g2 | all manual exercises; 3 finished maps |
| 3 | g8 | Guns, Germs & Steel — read WITH its critics | g4 | 1,500-word assessment arguing both sides |
| 4 | g6 | iGeo past papers | g3, g5 | 2 full papers self-timed, ≥60% |
| 4 | g9 | Spatial SQL (PostGIS workshop) | g7 | all workshop queries + one own analysis |
| 4 | g12 | The Silk Roads + The Grand Chessboard | g8 | comparative essay: geography as strategy |
| 5 | g10 | Python Geospatial (GeoPandas/Rasterio) | g9 | reproduce 3 published maps from raw data |
| 5 | g13 | Commodity chain: map one resource end-to-end (e.g. lithium) | g9, g12 | sourced map + 2,000-word report |
| 6 | g11 | Remote Sensing (Google Earth Engine) | g10 | NDVI change-detection study of a chosen region |
| 6 | g14 | Forecasting: 25 scored geopolitical forecasts | g6, g12 | Good Judgment Open — Brier score beats the median |
| 7 | g15 | Interactive global dashboard (public URL) | g11, g13 | live site with 3 datasets you processed |
| 8 | g16 | Crown: original spatial analysis, published | g14, g15 | write-up + data + code public; forecast record attached |

*(Retired: old g2 flags-into-two-decks split (merged into g1), old g17.)*

---

## 2. history — History 📜
**Goal:** "Master Historian & Archival Synthesis" *(kept — it was already honest)*

The Durant spine survives (it is the immersive heart), but methods and
**primary sources** become a real branch, and exam mimicry enters via AP
World released exams and self-graded DBQs (document-based questions — the
historian's craft in exam form).

| Tier | Id | Node | Requires | Verified by |
|---|---|---|---|---|
| 1 | h1 | Methods: From Reliable Sources (Howell & Prevenier) | — | source-critique exercise on 3 documents |
| 2 | h5 | Big picture: Sapiens + Why the West Rules—For Now | h1 | critical brief: where they disagree and why |
| 2 | h2 | Durant I–III: Antiquity | h1 | era synthesis essay per volume |
| 3 | h6 | SPQR (Beard) | h2 | 2,000-word review against Durant's Rome |
| 3 | h3 | Durant IV–VI: Middle Ages | h2 | era synthesis essays |
| 3 | h11 | Primary sources I: analyse 10 (Avalon Project etc.) | h1 | written source analyses, provenance first |
| 4 | h4 | Durant VII–XI: Modern Era | h3 | era synthesis essays |
| 4 | h16 `NEW` | AP World History | h5, h2 | ≥4 on two released exams, timed |
| 5 | h7 | The Sleepwalkers (WWI origins) | h4 | essay comparing 3 schools on war guilt |
| 5 | h8 | The Second World War (Keegan) | h4 | campaign analysis of one theatre |
| 5 | h17 `NEW` | DBQ craft: 5 document-based essays | h11, h16 | self-graded vs College Board rubrics, ≥5/7 |
| 6 | h9 | Cold War (Gaddis) | h8 | periodisation essay: when did it truly begin/end? |
| 6 | h10 | Economic history (A Farewell to Alms + Global Economic History VSI) | h4 | brief: why the Industrial Revolution, why England |
| 7 | h12 | Lessons of History (Durant) + write your own | h7, h9, h10 | your own 12 "lessons", each sourced |
| 7 | h13 | 5,000-word era synthesis (your chosen era, 15+ sources) | h17 | bibliography, footnotes, argument |
| 8 | h14 | Archival project: work a real digitised archive | h13 | 10 primary finds transcribed + contextualised |
| 9 | h15 | Crown: 10,000-word sourced monograph, published online | h12, h14 | public + critique gathered from 2 historians/enthusiast experts |

---

## 3. business — Business 📊
**Goal (proposed):** "Run Money Like an Institution"

CFA levels stay as **timed full-length mocks** (Schweser/AnalystPrep — the
curriculum and mock ecosystem is fully accessible without enrolling).
Damodaran's free NYU valuation course replaces vague "CFA L2 valuation".
The crown is a documented, benchmarked track record — the only credential
markets respect that no one can gatekeep.

| Tier | Id | Node | Requires | Verified by |
|---|---|---|---|---|
| 1 | b1 | Personal finance: write your own Investment Policy Statement | — | IPS + automated savings running 3 months |
| 2 | b2 | Microeconomics (Mankiw) | — | full problem sets |
| 2 | b3 | Macroeconomics (Mankiw) + indicator watch | — | track CPI/rates/PMI monthly for 3 months, journal |
| 3 | b4 | Financial Accounting | b1 | build 3 statements for a mock firm; parse a real 10-K |
| 3 | b5 | Strategy (Porter) | b2 | five-forces analysis of a real industry |
| 4 | b6 | Corporate Finance (Brealey & Myers) | b4, b3 | problem sets + WACC for a real company |
| 4 | b7 | Managerial Accounting | b4 | costing exercise on a real product teardown |
| 4 | b10 | Operations (The Goal + process mapping) | b5 | map and improve a real process you can observe |
| 5 | b8 | CFA Level 1 | b6, b7 | full-length timed mock ≥70% |
| 5 | b12 | Financial modelling: 3-statement model from scratch | b6 | keyboard-only build of a real company, documented |
| 6 | b11 | Valuation (Damodaran's free NYU course) | b8, b12 | all problem sets; 2 full valuations |
| 7 | b19 `NEW` | CFA Level 2 | b11 | full-length timed mock ≥65% |
| 7 | b13 | DCF + LBO models on 2 real companies | b11 | assumptions documented and defended |
| 8 | b14 | Read 25 10-Ks: one-page memos | b13 | memo book; 5 red flags found and explained |
| 8 | b15 | CFA Level 3 | b19 | full-length timed mock ≥65% |
| 9 | b16 | 12-month paper portfolio vs benchmark | b14, b15 | IPS-governed, quarterly letters, every trade journaled |
| 10 | b17 | 3 published equity research reports | b16 | public (Substack etc.) + 6-month retrospectives on each call |
| 11 | b18 | Crown: multi-year documented track record + fund-style letter book | b17 | 24+ months, benchmark-relative, honest attribution |

---

## 4. socialSci — Social Science 🧠
**Goal (proposed):** "Run a Real Behavioral Study"

The replication crisis is *part of the curriculum* — nothing teaches methods
like discovering which famous findings died. Exam mimicry via AP Psychology;
real practice via reproducing published analyses from open OSF data and
finally running a preregistered study of your own (online samples are
accessible to anyone).

| Tier | Id | Node | Requires | Verified by |
|---|---|---|---|---|
| 1 | ss1 | Intro Psychology (OpenStax) + AP Psych | — | ≥4 on a released AP exam |
| 2 | ss2 | Research Methods & Statistics I | ss1 | design critique of 5 published studies |
| 3 | ss3 | Biological Psych & Neuroscience | ss1 | brain-region/function deck matured + essay |
| 3 | ss17 `NEW` | Statistics in practice: R or JASP | ss2 | reproduce the stats of 3 open-data papers (OSF) |
| 4 | ss4 | Cognitive Psychology | ss3 | chapter self-exams + one experiment replication write-up |
| 4 | ss5 | Social Psychology — replication-aware | ss1 | annotate 10 classic findings: survived or died? |
| 4 | ss6 | Developmental Psych | ss3 | stage-theory comparison essay |
| 5 | ss7 | Abnormal Psych (DSM-5-TR framework) | ss4, ss6 | 10 case vignettes correctly formulated |
| 5 | ss8 | Thinking, Fast & Slow — with its corrections | ss5 | brief: which chapters survived replication |
| 6 | ss9 | Influence (Cialdini) + field notes | ss8 | 20 observed persuasion instances catalogued |
| 6 | ss10 | Moral Philosophy (Sandel's Justice, free course) | ss5 | all lectures + 3 position essays |
| 7 | ss11 | Behave (Sapolsky) | ss3, ss9 | multi-level analysis of one behaviour |
| 7 | ss12 | Applied Stoicism (Meditations + A Guide to the Good Life) | ss10 | 30-day practice journal |
| 8 | ss13 | Design a behavioral study + preregister it | ss2, ss11 | preregistration live on OSF |
| 9 | ss14 | Run it: collect real data (online sample) | ss13, ss17 | data + analysis code public |
| 10 | ss15 | Write it up preprint-style | ss14 | PsyArXiv-format manuscript |
| 11 | ss16 | Crown: publish the preprint + expert critique | ss15, ss12 | posted publicly; feedback from 2 researchers incorporated |

---

**Node counts:** geography 16, history 17, business 18, socialSci 17 (WIS = 68).
All ids preserved where the star survives; retired ids stay archived.
