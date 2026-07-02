# Curriculum Review — INT (Intelligence)

**Status: PROPOSAL for Erol's markup — nothing applied to `skill_data.dart` yet.**

Three principles applied to every node:

1. **Verifiable** — each node names the artifact/exam/performance that proves it
   (the Examiner can then judge summaries against a concrete claim, and review
   quizzes have substance to probe). "Read X" becomes "X: worked problems /
   proofs / mock passed".
2. **Canonical** — the standard texts and gates of each discipline, correctly
   attributed.
3. **Escalating** — tier = real dependency depth; the crown is the goal's true
   final gate, ambitious but achievable by a determined autodidact (no node
   requires an institution's permission unless it genuinely does).

Node ids: unchanged ids = same star, progress preserved. `NEW` = added star.
`RETIRED` = removed (any progress on it is archived, not deleted).

---

## 1. science — Physics & Chemistry ⚗
**Goal (proposed rename):** "Publish an Original Scientific Result"
*(was "Nobel-Level Paradigm Shift" — a Nobel isn't a curriculum outcome; an
arXiv-ready original result is, and it is still a lifetime summit.)*

| Tier | Id | Node | Requires | Verified by |
|---|---|---|---|---|
| 1 | sc1 | Foundations: AP Physics C & AP Chemistry | — | ≥4-equivalent on released AP exams, self-timed |
| 2 | sc2 | Classical Mechanics (Taylor) | sc1 | 150+ worked problems incl. Lagrangian chapter |
| 2 | sc3 | General Chemistry (Zumdahl) | sc1 | full problem sets; titration + equilibrium labs at home |
| 2 | sc19 `NEW` | Mathematical Methods (Boas) | sc1 | vector calc, ODEs/PDEs, linear algebra chapters worked — the toolkit Griffiths/Jackson assume |
| 3 | sc4 | Electromagnetism (Griffiths E&M) | sc2, sc19 | all in-chapter problems through ch. 9 |
| 3 | sc5 | Organic Chemistry I–II (Clayden) | sc3 | 500 mechanisms drawn from memory |
| 4 | sc7 | Quantum Mechanics (Griffiths QM) | sc4 | derive hydrogen atom start-to-finish unaided |
| 4 | sc6 | Thermal & Statistical Physics (Schroeder → Kittel & Kroemer) | sc2 | *(rename: "Kittel" alone mislabels the book — it's* Thermal Physics*)* full problem sets |
| 5 | sc9 | Biochemistry (Lehninger) | sc5 | pathway maps (glycolysis→ETC) drawn from memory |
| 5 | sc8 | Physical Chemistry (Atkins) | sc6, sc7, sc3 | thermo + QM applied to real spectra |
| 5 | sc20 `NEW` | Computational Science (write an MD or Monte-Carlo simulation) | sc7 | working simulation + write-up of one physical result |
| 6 | sc10 | Advanced QM (Sakurai) | sc7 | perturbation theory + scattering problem sets |
| 6 | sc11 | Molecular Biology (Alberts) | sc9 | 3 journal-club style paper critiques |
| 7 | sc13 | Classical Electrodynamics (Jackson) | sc4, sc19 | the gauntlet: 60+ Jackson problems |
| 7 | sc12 | General Relativity (Carroll) | sc10 | derive Schwarzschild solution unaided |
| 8 | sc14 | Quantum Field Theory (Peskin & Schroeder, Part I) | sc10, sc13 | compute a tree-level cross-section start-to-finish |
| 9 | sc15 | Thesis: 50+ page original research monograph | sc8, sc11, sc14, sc20 | *(reframed from "PhD Defense" — same act, no university needed)* |
| 10 | sc16 | Defend it: present to 2+ domain experts and survive Q&A | sc15 | recorded session + revisions |
| 11 | sc17 | Contribute: co-author or publish in a peer-reviewed venue | sc16 | DOI exists |
| 12 | sc18 | Crown: publish an original result the field cites | sc17 | ≥1 independent citation |

**Why:** added the missing math spine (sc19 — nothing above tier 3 is honest
without it) and computation (sc20 — half of modern science); fixed the
Kittel attribution; re-ordered stat-mech after mechanics rather than E&M;
made the crown chain acts a person can actually perform.

---

## 2. maths — Mathematics ∑
**Goal (proposed rename):** "Prove and Publish an Original Theorem"
*(was "Fields Medal / Proof Mastery" — the Fields Medal has an age limit of
40 and four winners every four years; the crown should be a real theorem.)*

| Tier | Id | Node | Requires | Verified by |
|---|---|---|---|---|
| 1 | m1 | Pre-Calculus & Trigonometry | — | timed exam, >90% |
| 2 | m2 | Logic & Proofs (Velleman) | m1 | 200 written proofs |
| 2 | m3 | Calculus I–III (Stewart) | m1 | full problem sets incl. vector calculus |
| 3 | m4 | Linear Algebra (Axler) | m2, m3 | every theorem in ch. 1–7 proved unaided |
| 3 | m5 | Ordinary Differential Equations (Tenenbaum & Pollard) | m3 | full problem sets |
| 4 | m6 | Probability (Ross) | m3 | full problem sets |
| 4 | m19 `NEW` | Problem Craft: 50 Putnam problems solved | m2, m3 | written solutions, self-graded vs official |
| 5 | m7 | Real Analysis (Rudin, ch. 1–9) | m3, m4 | all chapter exercises |
| 5 | m8 | Abstract Algebra (Dummit & Foote, Parts I–III) | m4 | groups/rings/fields exercise sets |
| 6 | m9 | Complex Analysis (Ahlfors) | m7 | contour-integral computations + proofs |
| 6 | m10 | Point-Set Topology (Munkres, Part I) | m7 | all exercises ch. 1–4 |
| 7 | m11 | Mathematical Statistics (Casella & Berger) | m6 | full problem sets |
| 7 | m12 | Measure & Integration (Folland or Rudin RCA) | m7, m10 | Lebesgue theory exercises |
| 8 | m13 | Partial Differential Equations (Evans, Part I) | m5, m12 | *(replaces "Stochastic Processes" here — moved below)* |
| 8 | m14 | Measure-Theoretic Probability (Durrett) | m12, m6 | martingale + CLT chapters |
| 9 | m15 | Differential Geometry (do Carmo / Lee) | m10 | curves→manifolds exercise sets |
| 9 | m20 `NEW` | Functional Analysis (Kreyszig → Rudin FA) | m12 | *(glaring gap: the language of modern analysis)* Banach/Hilbert space exercises |
| 10 | m21 `NEW` | Stochastic Processes & SDEs (Øksendal) | m14 | *(was tier-8 m13; belongs after measure-theoretic probability)* |
| 10 | m16 | Qualifying Exams: 3 past PhD quals from a real university, >70% | m8, m9, m13, m20 | timed, closed-book |
| 11 | m17 | Dissertation-grade monograph on one open corner | m15, m16, m21 | 60+ pages, expert-reviewed |
| 12 | m18 | Crown: original theorem in a peer-reviewed journal | m17 | *(was "Annals of Math" — any refereed journal is the honest crown)* DOI exists |

---

## 3. medicine — Medicine ⚕
**Goal:** "Chief Attending / Diagnostician" *(keep — it names a level of
acumen, and the tree treats it as knowledge-mastery, not licensure)*

| Tier | Id | Node | Requires | Verified by |
|---|---|---|---|---|
| 1 | md1 | Medical Terminology + BLS/CPR certification | — | real BLS card (widely available to the public) |
| 2 | md2 | Anatomy (Netter Atlas + Anki deck) | md1 | 2,000-card deck matured |
| 3 | md3 | Physiology (Guyton & Hall) | md2 | system-by-system self-exams |
| 3 | md4 | Medical Biochemistry (Lippincott) | md1 | pathway questions >80% |
| 4 | md5 | Pathology (Robbins **+ Pathoma**) | md3, md4 | *(Pathoma is the canonical companion)* Pathoma videos + Robbins MCQs |
| 4 | md6 | Pharmacology (Katzung + Sketchy Pharm) | md3 | drug-class Anki deck matured |
| 4 | md7 | Immunology & Microbiology (Sketchy Micro + Janeway ch. 1–10) | md4 | bug/drug chart from memory |
| 5 | md8 | First Aid for USMLE Step 1 (full pass, annotated) | md5, md6, md7 | own annotated copy, 3 passes |
| 6 | md9 | UWorld Step 1 (complete, ≥70% cumulative) | md8 | UWorld stats screenshot |
| 7 | md10 | NBME free-120 ≥ 85% | md9 | **(fix: Step 1 went pass/fail in 2022 — "mock >240" no longer exists.** The free-120 percentage is today's honest bar.) |
| 8 | md11 | Physical Examination (Bates) | md10 | OSCE-style checklist performed on a volunteer |
| 8 | md12 | Internal Medicine (Harrison's, core chapters) | md10 | chapter self-exams |
| 8 | md13 | ECG Interpretation (Dubin → Marriott) | md10 | 100 ECGs read, checked vs answers |
| 9 | md14 | UWorld Step 2 CK (complete, ≥70%) | md11, md12, md13 | UWorld stats |
| 10 | md15 | Step 2 CK mock ≥ 250 | md14 | NBME practice exam (Step 2 is still scored) |
| 11 | md16 | Diagnose 100 NEJM Clinical Problem-Solving cases | md15 | written differential before reading each solution; ≥60% correct |
| 12 | md17 | MKSAP question bank (ABIM board level) ≥ 65% | md16 | *(was "Board Certification (Mock)" — MKSAP is what internists actually use)* |
| 13 | md18 | Crown: 30 consecutive unseen cases at attending accuracy | md17 | curated case bank, blinded scoring |

---

## 4. engineering — Engineering ⚙
**Goal:** "Build Your Own Computer, OS, and Distributed System" *(proposed
rename from "Principal Architect / OS Dev" — the crown below IS the title)*

| Tier | Id | Node | Requires | Verified by |
|---|---|---|---|---|
| 1 | eg1 | CS50 + Python (all problem sets) | — | every pset passing the autograder |
| 2 | eg2 | C (K&R, every exercise) | eg1 | exercises in a public repo |
| 2 | eg3 | Engineering Mathematics (LinAlg + ODEs) | eg1 | problem sets |
| 3 | eg4 | Digital Design & Computer Architecture (Harris & Harris) | eg2 | *(names the canonical text)* HDL exercises |
| 3 | eg5 | Data Structures & Algorithms (CLRS core + 150 LeetCode) | eg2 | timed problem log |
| 3 | eg6 | Circuit Analysis (KVL/KCL, RC/RLC) | eg3 | breadboard measurements match theory |
| 4 | eg7 | Computer Systems (CS:APP + its 9 labs) | eg4 | bomb lab + malloc lab complete |
| 4 | eg8 | Signals & Systems (Oppenheim) | eg6 | Fourier problem sets + a working filter |
| 5 | eg9 | Nand2Tetris I: build a CPU from NAND gates | eg4 | working Hack computer in the simulator |
| 5 | eg10 | Operating Systems (**OSTEP**) | eg5, eg7 | *(names the canonical free text)* all projects: shell, malloc, scheduler |
| 6 | eg11 | Networking: Beej's Guide + build an HTTP server from sockets | eg5 | server survives a load test |
| 6 | eg12 | Embedded: bare-metal STM32 (no HAL) | eg8 | blink→UART→interrupt drivers from the datasheet |
| 7 | eg13 | Nand2Tetris II: compiler + OS for your CPU | eg9, eg10 | Tetris runs on your stack |
| 7 | eg14 | Database Internals (CMU 15-445 projects) | eg10 | buffer pool + B+tree + executor passing tests |
| 8 | eg15 | Write an RTOS in C on real hardware | eg12, eg13 | preemptive scheduler + mutexes demoed |
| 9 | eg16 | Distributed Systems (DDIA + MIT 6.824 labs) | eg11, eg14 | *(adds the canonical labs)* Raft implementation passing tests |
| 9 | eg17 | Autonomous robot on ROS 2 | eg15 | navigates an unseen room |
| 10 | eg18 | Crown: 3-node cluster of your own kernel running your own replicated KV store | eg16, eg17 | live demo: kill a node, the system survives |

---

## v2 addendum — accessibility pass (self-studyable / exam-mimicking)

Applying Erol's rule that everything must be self-studyable or mimic a real
examination:

- **science**: add `sc21 NEW` — **GRE Physics subject test** (released exams
  public; ≥900 equivalent, timed) at tier 7 requiring sc10+sc13 — physics'
  best exam mimicry. Add `sc22 NEW` — **ACS General & Organic Chemistry
  practice exams** ≥80% at tier 5 requiring sc5. sc16's "2+ domain experts"
  clarified: found via forums, university office hours, or meetups — no
  institutional standing required. sc17's peer-review crown keeps its
  accessible paths: open-access journals and workshops accept independent
  researchers.
- **maths**: already fully self-studyable (public quals archives, Putnam
  archives). No change.
- **medicine**: already exam-mimicking by design (NBME/UWorld/MKSAP are the
  literal instruments med students use alone at desks). No change.
- **engineering**: already artifact-verified throughout. No change.

## Cross-cutting notes for discussion

1. **Progress migration:** ids kept above preserve your existing stars.
   Retired ids stay in storage untouched (nothing deletes), they just stop
   rendering. If you've ignited a node whose meaning changed (e.g. sc6), say
   so and I'll map it explicitly.
2. **Node count is stable** (science 20, maths 21, medicine 18, engineering 18
   = 77 vs 72 today) — tree shapes stay constellation-sized.
3. **The Examiner gets sharper for free:** each node's "verified by" phrasing
   will ship in the node data so the AI knows exactly what evidence to demand.
   (Requires adding an optional `proof` field to `SkillNode` — small change.)
4. Same treatment ready for WIS, CHA, DEX on your word.
