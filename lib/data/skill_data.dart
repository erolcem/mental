// data/skill_data.dart — the full mastery catalog: 4 stats → 21 skills → 431
// nodes. PARALLEL PATHS overhaul 2026-07-06 (docs/curriculum/PARALLEL.md).
// Five laws govern every constellation:
//
//   1. PARALLEL — each tree is 3–5 named branches that can be worked at the
//      same time; a stuck branch never blocks the whole sky.
//   2. SELF-ACHIEVABLE — books, free courses, released exams, video-assessed
//      certificates, public arenas, logged practice. Exam mimicry wherever
//      the official gate is closed; no institution's permission anywhere.
//   3. PROOF-BEARING — every node carries a `proof`, the completion standard
//      the Examiner demands evidence against and the Reviewer quizzes from.
//   4. CONVERGENT — branches braid at synthesis nodes and every path ends at
//      one crown: no orphan stars, everything you light matters at the top.
//   5. SAFE — nothing demands unsupervised danger: dead-circuit electrics,
//      dojo-supervised sparring, vocal health before power, jack-stand
//      discipline, food safety first.
//
// Node ids are unique per tree but NOT globally (maths and mechanics both use
// m1..); all persistence therefore keys progress by `skillId.nodeId` — see
// [progressKey]. Ids surviving from earlier catalogs keep their progress.
//
// This file is deliberately pure Dart (no dart:ui) so the analysis tool
// (`dart tool/analyze_catalog.dart`) can compute over the catalog without a
// Flutter toolchain. Stat colors live here as ARGB ints; the UI lifts them
// to Color via the StatColor extension in ui/theme.dart.

class SkillNode {
  final String id;
  final String label;

  /// 1-based depth band. Tier 1 sits at the constellation's base; the final
  /// tier is the mastery star at its crown.
  final int tier;

  /// Ids (within the same tree) that must be complete before this unlocks.
  final List<String> requires;

  /// The completion standard: what counts as evidence this node is done.
  final String proof;

  /// Estimated deliberate-practice hours to meet [proof] — a researched
  /// planning figure (FSI/JLPT hour studies, CFA guidance, ABRSM norms),
  /// not a stopwatch. Powers the effort analytics in tool/analyze_catalog.
  final int hours;
  const SkillNode(this.id, this.label, this.tier,
      [this.requires = const [], this.proof = '', this.hours = 0]);
}

class Skill {
  final String id;
  final String label;
  final String icon;

  /// The endgame this constellation represents — shown under the title.
  final String goal;
  final List<SkillNode> tree;
  const Skill(this.id, this.label, this.icon, this.goal, this.tree);

  int get maxTier => tree.fold(1, (m, n) => n.tier > m ? n.tier : m);
  SkillNode nodeById(String id) => tree.firstWhere((n) => n.id == id);

  /// Estimated deliberate-practice hours base → crown.
  int get totalHours => tree.fold(0, (s, n) => s + n.hours);
}

class StatDomain {
  final String id; // INT | WIS | CHA | DEX
  final String label;

  /// ARGB color value (UI lifts this to a Color via ui/theme.dart).
  final int colorValue;
  final List<Skill> skills;
  const StatDomain(this.id, this.label, this.colorValue, this.skills);
}

/// Globally unique progress key for a node.
String progressKey(String skillId, String nodeId) => '$skillId.$nodeId';

SkillNode _n(String id, String label, int tier,
        [Object? req, String proof = '', int hours = 0]) =>
    SkillNode(
        id,
        label,
        tier,
        req == null
            ? const []
            : req is String
                ? [req]
                : List<String>.from(req as List),
        proof,
        hours);

final List<StatDomain> catalog = [
  StatDomain('INT', 'Intelligence', 0xFF00D4FF, [
    // Branches: Physics · Chemistry · Mathematical & Computational Methods ·
    // Experimental Craft — all four converge at the thesis gate (sc15).
    Skill('science', 'Physics & Chem', '⚗', 'Publish an Original Scientific Result', [
      _n('sc1', 'Foundations: AP Physics C & AP Chemistry', 1, null,
          '≥4-equivalent on released AP exams, self-timed', 400),
      // — Physics —
      _n('sc2', 'Classical Mechanics (Taylor)', 2, 'sc1',
          '150+ worked problems incl. the Lagrangian chapter', 350),
      _n('sc4', 'Electromagnetism (Griffiths)', 3, ['sc2', 'sc19'],
          'All in-chapter problems through ch. 9', 350),
      _n('sc7', 'Quantum Mechanics (Griffiths QM)', 4, 'sc4',
          'Derive the hydrogen atom start-to-finish unaided', 350),
      _n('sc6', 'Thermal & Statistical Physics (Schroeder)', 4, 'sc2',
          'Full problem sets, then Kittel & Kroemer', 250),
      _n('sc10', 'Advanced QM (Sakurai)', 6, 'sc7',
          'Perturbation theory + scattering problem sets', 300),
      _n('sc13', 'Classical Electrodynamics (Jackson)', 7, ['sc4', 'sc19'],
          'The gauntlet: 60+ Jackson problems', 400),
      _n('sc12', 'General Relativity (Carroll)', 7, 'sc10',
          'Derive the Schwarzschild solution unaided', 300),
      _n('sc21', 'GRE Physics Subject Test', 8, ['sc10', 'sc13'],
          'Released tests ≥900-equivalent, timed', 100),
      _n('sc14', 'Quantum Field Theory (Peskin, Part I)', 8, ['sc10', 'sc13'],
          'Compute a tree-level cross-section start-to-finish', 350),
      // — Chemistry —
      _n('sc3', 'General Chemistry (Zumdahl)', 2, 'sc1',
          'Full problem sets; home titration & equilibrium labs', 300),
      _n('sc5', 'Organic Chemistry I–II (Clayden)', 3, 'sc3',
          '500 mechanisms drawn from memory', 400),
      _n('sc9', 'Biochemistry (Lehninger)', 5, 'sc5',
          'Glycolysis→ETC pathway maps drawn from memory', 300),
      _n('sc8', 'Physical Chemistry (Atkins)', 5, ['sc6', 'sc7', 'sc3'],
          'Thermo + QM applied to real spectra', 300),
      _n('sc22', 'ACS Chemistry Exams (Gen + Organic)', 5, 'sc5',
          'Practice exams ≥80%, timed', 80),
      _n('sc11', 'Molecular Biology (Alberts)', 6, 'sc9',
          '3 journal-club style paper critiques', 250),
      // — Mathematical & computational methods —
      _n('sc19', 'Mathematical Methods (Boas)', 2, 'sc1',
          'Vector calc, ODE/PDE and linear algebra chapters worked', 300),
      _n('sc20', 'Computational Science: write a simulation', 5, 'sc7',
          'Working MD/Monte-Carlo sim + write-up of one physical result', 120),
      // — Experimental craft —
      _n('sc24', 'Home Lab I: instruments & measurement', 2, 'sc1',
          'Multimeter, calipers, thermometer: 10 measurements with uncertainty budgets', 40),
      _n('sc23', 'Error Analysis & Experiment Design (Taylor)', 3,
          ['sc24', 'sc19'],
          'Propagation-of-error problem sets; one designed experiment critiqued', 80),
      _n('sc25', 'Replicate classic experiments', 4, 'sc23',
          "3 classics with error bars: measure g, laser diffraction, calorimetry", 60),
      _n('sc26', 'Scientific Writing & LaTeX', 6, 'sc25',
          'Two lab reports typeset in LaTeX, structured like journal papers', 50),
      _n('sc27', 'Journal club: 20 arXiv papers', 7, 'sc26',
          '20 paper summaries; 3 full critiques posted for discussion', 100),
      // — Convergence: the research chain —
      _n('sc15', 'Thesis: original research monograph', 9,
          ['sc8', 'sc11', 'sc12', 'sc14', 'sc20', 'sc21', 'sc22', 'sc27'],
          '50+ pages of original research', 700),
      _n('sc16', 'Defend it before domain experts', 10, 'sc15',
          'Present to 2+ experts (forums/meetups); survive Q&A, revise', 60),
      _n('sc17', 'Publish in a peer-reviewed venue', 11, 'sc16',
          'DOI exists — open-access journals accept independents', 120),
      _n('sc18', 'Crown: a result the field cites', 12, 'sc17',
          '≥1 independent citation', 40),
    ]),
    // Branches: Analysis · Algebra & Discrete · Probability & Applied ·
    // Problem Craft & Exposition — converging at the monograph (m17).
    Skill('maths', 'Mathematics', '∑', 'Prove and Publish an Original Theorem', [
      _n('m1', 'Pre-Calculus & Trigonometry', 1, null, 'Timed exam, >90%', 120),
      _n('m2', 'Logic & Proofs (Velleman)', 2, 'm1', '200 written proofs', 150),
      _n('m3', 'Calculus I–III (Stewart)', 2, 'm1',
          'Full problem sets incl. vector calculus', 400),
      // — Analysis —
      _n('m4', 'Linear Algebra (Axler)', 3, ['m2', 'm3'],
          'Every theorem in ch. 1–7 proved unaided', 250),
      _n('m7', 'Real Analysis (Rudin ch. 1–9)', 5, ['m3', 'm4'],
          'All chapter exercises', 350),
      _n('m9', 'Complex Analysis (Ahlfors)', 6, 'm7',
          'Contour-integral computations + proofs', 250),
      _n('m10', 'Point-Set Topology (Munkres, Part I)', 6, 'm7',
          'All exercises ch. 1–4', 200),
      _n('m12', 'Measure & Integration (Folland)', 7, ['m7', 'm10'],
          'Lebesgue theory exercises', 300),
      _n('m15', 'Differential Geometry (do Carmo / Lee)', 9, 'm10',
          'Curves→manifolds exercise sets', 300),
      _n('m20', 'Functional Analysis (Kreyszig → Rudin)', 9, 'm12',
          'Banach/Hilbert space exercises', 250),
      // — Algebra & discrete —
      _n('m23', 'Combinatorics & Graph Theory', 3, 'm2',
          'Full exercise sets; 30 competition combinatorics problems', 200),
      _n('m22', 'Elementary Number Theory', 4, 'm23',
          'Congruences→quadratic reciprocity proved; 30 olympiad problems', 150),
      _n('m8', 'Abstract Algebra (Dummit & Foote I–III)', 5, ['m4', 'm22'],
          'Groups/rings/fields exercise sets', 350),
      // — Probability & applied —
      _n('m5', 'Ordinary Differential Equations (Tenenbaum)', 3, 'm3',
          'Full problem sets', 150),
      _n('m6', 'Probability (Ross)', 4, 'm3', 'Full problem sets', 200),
      _n('m11', 'Mathematical Statistics (Casella & Berger)', 7, 'm6',
          'Full problem sets', 250),
      _n('m13', 'Partial Differential Equations (Evans, Part I)', 8,
          ['m5', 'm12'], 'Full problem sets', 300),
      _n('m14', 'Measure-Theoretic Probability (Durrett)', 8, ['m12', 'm6'],
          'Martingale + CLT chapters', 300),
      _n('m21', 'Stochastic Processes & SDEs (Øksendal)', 10, 'm14',
          'Itô calculus problem sets', 250),
      // — Problem craft & exposition —
      _n('m19', 'Problem Craft: 50 Putnam problems', 4, ['m2', 'm3'],
          'Written solutions, self-graded vs official', 120),
      _n('m24', 'Exposition: 10 mathematical essays', 5, 'm19',
          'Ten posts explaining real proofs to a lay reader, published', 80),
      _n('m25', 'Problem Craft II: full Putnams, timed', 6, 'm19',
          'Two 6-hour Putnams, exam conditions; ≥20/120 self-graded '
              '(the real median is 0–2)', 60),
      _n('m26', 'Read research: 10 papers in one field', 9, ['m24', 'm12'],
          'Ten annotated papers; one presented as a talk (recorded)', 120),
      // — Convergence —
      _n('m16', 'Qualifying Exams (3 real past quals)', 10,
          ['m8', 'm9', 'm13', 'm20'], 'Timed, closed-book, >70%', 200),
      _n('m17', 'Dissertation-grade monograph', 11,
          ['m11', 'm15', 'm16', 'm21', 'm25', 'm26'],
          '60+ pages on one open corner, expert-reviewed', 700),
      _n('m18', 'Crown: original theorem, peer-reviewed', 12, 'm17',
          'DOI exists in a refereed journal', 150),
    ]),
    // Branches: Basic Science → Step exams · Clinical Craft · Emergency
    // Response (real public certs) · Evidence & Epidemiology.
    Skill('medicine', 'Medicine', '⚕', 'Chief Attending / Diagnostician', [
      _n('md1', 'Medical Terminology + BLS/CPR', 1, null,
          'Real BLS card — open to the public', 60),
      // — Basic science spine —
      _n('md2', 'Anatomy (Netter + Anki)', 2, 'md1',
          '2,000-card deck matured', 350),
      _n('md3', 'Physiology (Guyton & Hall)', 3, 'md2',
          'System-by-system self-exams', 300),
      _n('md4', 'Medical Biochemistry (Lippincott)', 3, 'md1',
          'Pathway questions >80%', 200),
      _n('md5', 'Pathology (Robbins + Pathoma)', 4, ['md3', 'md4'],
          'Pathoma complete + Robbins MCQs', 350),
      _n('md6', 'Pharmacology (Katzung + Sketchy)', 4, 'md3',
          'Drug-class Anki deck matured', 250),
      _n('md7', 'Immunology & Micro (Sketchy + Janeway)', 4, 'md4',
          'Bug/drug chart from memory', 200),
      _n('md8', 'First Aid for Step 1 (annotated)', 5, ['md5', 'md6', 'md7'],
          'Own annotated copy, 3 passes', 250),
      _n('md9', 'UWorld Step 1 complete', 6, 'md8', '≥70% cumulative', 400),
      _n('md10', 'NBME Free-120', 7, 'md9',
          '≥85% (Step 1 is pass/fail since 2022 — this is the bar)', 30),
      // — Emergency response: real certificates, open to the public —
      _n('md19', 'First Aid + Stop the Bleed', 2, 'md1',
          'Red Cross First Aid + Stop the Bleed certificates; drills logged', 20),
      _n('md20', 'Wilderness First Aid (16-hr course)', 3, 'md19',
          'Certificate from a publicly bookable WFA course; scenario notes', 20),
      // — Evidence & epidemiology —
      _n('md21', 'Epidemiology & Biostatistics I', 2, 'md1',
          'OpenIntro biostats problem sets; 20 abstracts: design + bias named', 100),
      _n('md22', 'Critical appraisal: 10 RCTs + 5 meta-analyses', 4, 'md21',
          "CASP-checklist appraisals written; JAMA Users' Guides applied", 60),
      // — Clinical craft —
      _n('md11', 'Physical Examination (Bates)', 8, ['md10', 'md20'],
          'OSCE-style checklist performed on a volunteer', 80),
      _n('md12', "Internal Medicine (Harrison's core)", 8, 'md10',
          'Chapter self-exams', 300),
      _n('md13', 'ECG Interpretation (Dubin → Marriott)', 8, 'md10',
          '100 ECGs read and checked', 80),
      _n('md23', 'Imaging: chest X-ray + CT basics', 8, 'md10',
          '100 CXRs read vs reports (free teaching files); Radiopaedia course', 80),
      _n('md14', 'UWorld Step 2 CK complete', 9, ['md11', 'md12', 'md13'],
          '≥70% cumulative', 350),
      _n('md15', 'Step 2 CK mock ≥250', 10, 'md14',
          'NBME practice exam — Step 2 is still scored', 30),
      // — Convergence: the diagnostician chain —
      _n('md16', '100 NEJM Clinical Problem-Solving cases', 11,
          ['md15', 'md22', 'md23'],
          'Written differential before each solution; ≥60% correct', 150),
      _n('md17', 'MKSAP question bank (ABIM level)', 12, 'md16', '≥65%', 250),
      _n('md18', 'Crown: attending-level case accuracy', 13, 'md17',
          '30 consecutive unseen cases, blinded scoring', 60),
    ]),
    // Branches: Software Systems · Hardware & Embedded · Electronics &
    // Signals · Craft (Unix, security, shipping) — crown = your own stack.
    Skill('engineering', 'Engineering', '⚙',
        'Build Your Own Computer, OS & Distributed System', [
      _n('eg1', 'CS50 + Python', 1, null, 'Every problem set passing the autograder', 120),
      _n('eg2', 'C (K&R, every exercise)', 2, 'eg1', 'Exercises in a public repo', 120),
      _n('eg3', 'Engineering Mathematics (LinAlg + ODEs)', 2, 'eg1',
          'Problem sets', 200),
      _n('eg19', 'Unix craft: shell, git, tooling', 2, 'eg1',
          'MIT Missing Semester exercises; dotfiles + 10 scripting katas public', 60),
      // — Software systems —
      _n('eg5', 'Data Structures & Algorithms', 3, 'eg2',
          'CLRS core + 150 LeetCode, timed log', 300),
      _n('eg21', 'Compilers (Crafting Interpreters)', 4, 'eg5',
          'Both jlox and clox complete; one language feature of your own added', 150),
      _n('eg7', 'Computer Systems (CS:APP + labs)', 4, 'eg4',
          'Bomb lab + malloc lab complete', 250),
      _n('eg10', 'Operating Systems (OSTEP)', 5, ['eg5', 'eg7'],
          'All projects: shell, malloc, scheduler', 250),
      _n('eg11', 'Networking: sockets to HTTP server', 6, 'eg5',
          "Beej's guide + your server survives a load test", 100),
      _n('eg14', 'Database Internals (CMU 15-445)', 7, 'eg10',
          'Buffer pool + B+tree + executor passing tests', 200),
      _n('eg16', 'Distributed Systems (DDIA + MIT 6.824)', 9, ['eg11', 'eg14'],
          'Raft implementation passing the labs', 300),
      // — Hardware & embedded —
      _n('eg4', 'Digital Design & Comp. Arch. (Harris & Harris)', 3, 'eg2',
          'HDL exercises', 200),
      _n('eg9', 'Nand2Tetris I: CPU from NAND gates', 5, 'eg4',
          'Working Hack computer in the simulator', 100),
      _n('eg12', 'Embedded: bare-metal STM32', 6, 'eg8',
          'Blink→UART→interrupt drivers from the datasheet', 150),
      _n('eg13', 'Nand2Tetris II: compiler + OS', 7, ['eg9', 'eg10', 'eg21'],
          'Tetris runs on your own stack', 200),
      _n('eg15', 'Write an RTOS in C on real hardware', 8, ['eg12', 'eg13'],
          'Preemptive scheduler + mutexes demoed', 250),
      _n('eg17', 'Autonomous robot on ROS 2', 9, 'eg15',
          'Navigates an unseen room', 300),
      // — Electronics & signals —
      _n('eg6', 'Circuit Analysis', 3, 'eg3',
          'Breadboard measurements match theory', 150),
      _n('eg8', 'Signals & Systems (Oppenheim)', 4, 'eg6',
          'Fourier problem sets + a working filter', 200),
      // — Craft: security & shipping —
      _n('eg20', 'Security fundamentals (CTF training)', 7, ['eg11', 'eg19'],
          'picoCTF 2000+ points or pwn.college belt; 10 challenge write-ups', 120),
      _n('eg22', 'Ship it: a real networked product', 8,
          ['eg11', 'eg14', 'eg19'],
          'Deployed app with real users; monitoring + honest postmortem', 200),
      // — Convergence —
      _n('eg18', 'Crown: 3-node cluster of your kernel + KV store', 10,
          ['eg16', 'eg17', 'eg20', 'eg22'],
          'Kill a node live — the system survives', 400),
    ]),
  ]),
  StatDomain('WIS', 'Wisdom', 0xFFC084FC, [
    // Branches: World Knowledge · Physical & Human Geography · Geopolitics ·
    // Spatial Tech & Field Craft — crown = published analysis + forecasts.
    Skill('geography', 'Geography', '🌍', 'Global Geospatial Analyst & Forecaster', [
      _n('g1', 'Anki: 196 nations, capitals & flags', 1, null,
          'Matured deck, 95%+ retention', 60),
      // — World knowledge —
      _n('g3', 'Blank-map mastery: 100 physical features', 2, 'g1',
          'Rivers, ranges, straits, chokepoints placed from memory', 50),
      _n('g6', 'iGeo past papers', 4, ['g3', 'g5'],
          '2 full papers self-timed, ≥60%', 60),
      // — Physical & human geography —
      _n('g2', 'Physical Geography (Strahler)', 2, 'g1',
          'Chapter self-exams: landforms, climate, biomes', 150),
      _n('g5', 'Human Geography (AP HuG)', 3, 'g2',
          '≥4 on two released AP exams, timed', 120),
      _n('g18', 'Weather & climate systems', 3, 'g2',
          'Cloud/front identification; 30-day forecast journal vs actuals', 60),
      _n('g19', 'Demography & migration', 5, 'g5',
          'UN population data: 5 charted analyses; migration-corridor brief', 60),
      // — Geopolitics & strategy —
      _n('g4', 'Prisoners + Revenge of Geography', 2, 'g1',
          'One-page strategic brief per chapter', 40),
      _n('g8', 'Guns, Germs & Steel — with its critics', 3, 'g4',
          '1,500-word assessment arguing both sides', 50),
      _n('g12', 'The Silk Roads + The Grand Chessboard', 4, 'g8',
          'Comparative essay: geography as strategy', 60),
      _n('g14', 'Forecasting: 25 scored predictions', 6, ['g6', 'g12'],
          'Good Judgment Open — beat the median Brier score', 100),
      // — Spatial tech & field craft —
      _n('g7', 'QGIS Fundamentals', 3, 'g2',
          'Official training manual exercises; 3 finished maps', 80),
      _n('g9', 'Spatial SQL (PostGIS)', 4, 'g7',
          'Workshop queries + one analysis of your own', 60),
      _n('g20', 'Field craft: survey your own region', 4, ['g7', 'g18'],
          'Field notebook + a hand-drawn then QGIS map of your local landscape', 40),
      _n('g10', 'Python Geospatial (GeoPandas)', 5, 'g9',
          'Reproduce 3 published maps from raw data', 80),
      _n('g13', 'Commodity chain: one resource end-to-end', 5, ['g9', 'g12'],
          'Sourced map + 2,000-word report', 80),
      _n('g17', 'Cartographic design', 5, 'g20',
          '5 publication-quality maps; redesigns critiqued against classics', 60),
      _n('g11', 'Remote Sensing (Google Earth Engine)', 6, 'g10',
          'NDVI change-detection study of a region', 80),
      // — Convergence —
      _n('g15', 'Interactive global dashboard', 7, ['g11', 'g13', 'g17'],
          'Public URL, 3 datasets you processed', 120),
      _n('g16', 'Crown: original spatial analysis, published', 8,
          ['g14', 'g15', 'g19'],
          'Write-up + data + code public, forecast record attached', 150),
    ]),
    // Branches: Grand Survey (Durant spine) · Methods & Primary Sources ·
    // Thematic Depth · Craft & Output — crown = a published monograph.
    Skill('history', 'History', '📜', 'Master Historian & Archival Synthesis', [
      _n('h1', 'Methods: From Reliable Sources', 1, null,
          'Source-critique exercise on 3 documents', 40),
      // — Grand survey —
      _n('h5', 'Big picture: Sapiens + Why the West Rules', 2, 'h1',
          'Critical brief: where they disagree and why', 60),
      _n('h2', 'Durant I–III: Antiquity', 2, 'h1',
          'Era synthesis essay per volume', 150),
      _n('h3', 'Durant IV–VI: Middle Ages', 3, 'h2', 'Era synthesis essays', 150),
      _n('h4', 'Durant VII–XI: Modern Era', 4, 'h3', 'Era synthesis essays', 250),
      // — Methods & primary sources —
      _n('h18', 'Historiography: Carr vs Evans', 2, 'h1',
          'What is History? + In Defense of History; your own position essay', 50),
      _n('h11', 'Primary sources I: analyse 10', 3, 'h1',
          'Avalon Project etc. — provenance-first analyses', 40),
      _n('h20', 'Local history: your town from records', 4, 'h11',
          'Census/parish/newspaper archives: 2,000 words on your own street', 60),
      _n('h19', 'Oral history: 3 recorded interviews', 6, 'h20',
          'Consent-documented recordings, transcriptions + contextual essay', 40),
      // — Thematic depth —
      _n('h6', 'SPQR (Beard)', 3, 'h2', "2,000-word review against Durant's Rome", 40),
      _n('h16', 'AP World History', 4, ['h5', 'h2'],
          '≥4 on two released exams, timed', 80),
      _n('h7', 'The Sleepwalkers (WWI origins)', 5, 'h4',
          'Essay comparing 3 schools on war guilt', 50),
      _n('h8', 'The Second World War (Keegan)', 5, 'h4',
          'Campaign analysis of one theatre', 60),
      _n('h9', 'Cold War (Gaddis)', 6, 'h8',
          'Periodisation essay: when did it begin and end?', 40),
      _n('h10', 'Economic history (Clark + VSI)', 6, 'h4',
          'Brief: why the Industrial Revolution, why England', 50),
      // — Craft & output —
      _n('h17', 'DBQ craft: 5 document-based essays', 5, ['h11', 'h16'],
          'Self-graded vs College Board rubrics, ≥5/7', 40),
      _n('h12', 'Lessons of History + write your own', 7, ['h7', 'h9', 'h10'],
          'Your own 12 lessons, each sourced', 60),
      _n('h13', '5,000-word era synthesis', 7, ['h6', 'h17', 'h18'],
          'Your chosen era, 15+ sources, footnoted', 80),
      _n('h14', 'Archival project: a real digitised archive', 8,
          ['h13', 'h19'], '10 primary finds transcribed + contextualised', 80),
      _n('h15', 'Crown: 10,000-word sourced monograph', 9, ['h12', 'h14'],
          'Published online; critique from 2 knowledgeable readers', 200),
    ]),
    // Branches: Economics & Markets · Accounting → CFA spine · Strategy &
    // Operations · Practice (negotiation, a real venture) — crown = record.
    Skill('business', 'Business', '📊', 'Run Money Like an Institution', [
      _n('b1', 'Personal finance: write your own IPS', 1, null,
          'Investment Policy Statement + automated savings, 3 months', 30),
      _n('b2', 'Microeconomics (Mankiw)', 1, null, 'Full problem sets', 120),
      _n('b3', 'Macroeconomics + indicator watch', 1, null,
          'Track CPI/rates/PMI monthly for 3 months, journaled', 120),
      // — Economics & markets —
      _n('b23', 'Market history: Graham, Bogle & bubbles', 2, 'b3',
          'Brief on 3 historical bubbles; your IPS updated with the lessons', 60),
      // — Accounting → CFA spine —
      _n('b4', 'Financial Accounting', 2, 'b1',
          'Build 3 statements for a mock firm; parse a real 10-K', 120),
      _n('b6', 'Corporate Finance (Brealey & Myers)', 3, ['b4', 'b3'],
          'Problem sets + WACC for a real company', 150),
      _n('b7', 'Managerial Accounting', 3, 'b4',
          'Costing exercise on a real product teardown', 80),
      _n('b8', 'CFA Level 1', 4, ['b6', 'b7'],
          'Full-length timed mock ≥70%', 300),
      _n('b12', '3-statement model from scratch', 4, 'b6',
          'Keyboard-only build of a real company', 60),
      _n('b11', "Valuation (Damodaran's NYU course)", 5, ['b8', 'b12'],
          'All problem sets; 2 full valuations', 120),
      _n('b19', 'CFA Level 2', 6, 'b11', 'Full-length timed mock ≥65%', 350),
      _n('b13', 'DCF + LBO models on 2 real companies', 6, 'b11',
          'Assumptions documented and defended', 80),
      _n('b14', '25 10-Ks: one-page memos', 7, 'b13',
          'Memo book; 5 red flags found and explained', 120),
      _n('b15', 'CFA Level 3', 7, 'b19', 'Full-length timed mock ≥65%', 350),
      // — Strategy & operations —
      _n('b5', 'Strategy (Porter)', 2, 'b2',
          'Five-forces analysis of a real industry', 60),
      _n('b10', 'Operations (The Goal)', 3, 'b5',
          'Map and improve a process you can observe', 50),
      // — Practice: negotiation & a real venture —
      _n('b20', 'Negotiation (Voss + Fisher) in the field', 3, 'b5',
          '10 logged real negotiations with prep sheets + outcomes', 50),
      _n('b21', 'Micro-venture: legally sell something', 4, ['b10', 'b20'],
          '3 months of a tiny venture: 20+ sales, honest P&L + retrospective', 150),
      _n('b22', 'Marketing: positioning + landing test', 5, 'b21',
          'Positioning doc; 100-visitor landing-page test, results written up', 60),
      // — Convergence —
      _n('b16', '12-month paper portfolio vs benchmark', 8,
          ['b14', 'b15', 'b23'],
          'IPS-governed, quarterly letters, every trade journaled', 150),
      _n('b17', '3 published equity research reports', 9, 'b16',
          'Public + 6-month retrospectives on each call', 120),
      _n('b18', 'Crown: multi-year documented track record', 10,
          ['b17', 'b22'],
          '24+ months benchmark-relative with honest attribution', 250),
    ]),
    // Branches: Psych Core · Methods & Statistics · Mind & Society ·
    // Applied Practice — crown = a published, preregistered study.
    Skill('socialSci', 'Social Sci', '🧠', 'Run a Real Behavioral Study', [
      _n('ss1', 'Intro Psychology (OpenStax + AP)', 1, null,
          '≥4 on a released AP Psychology exam', 120),
      // — Psych core —
      _n('ss3', 'Biological Psych & Neuroscience', 2, 'ss1',
          'Brain-region deck matured + essay', 120),
      _n('ss4', 'Cognitive Psychology', 3, 'ss3',
          'Self-exams + one experiment replication write-up', 100),
      _n('ss6', 'Developmental Psych', 4, 'ss3', 'Stage-theory comparison essay', 80),
      _n('ss7', 'Abnormal Psych (DSM-5-TR)', 5, ['ss4', 'ss6'],
          '10 case vignettes correctly formulated', 100),
      // — Methods & statistics —
      _n('ss2', 'Research Methods & Statistics I', 2, 'ss1',
          'Design critique of 5 published studies', 80),
      _n('ss17', 'Statistics in practice: R or JASP', 3, 'ss2',
          'Reproduce the stats of 3 open-data papers (OSF)', 80),
      _n('ss18', 'Game Theory (Schelling + Dixit)', 4, 'ss2',
          'Problem sets; 5 real situations modeled as games', 80),
      // — Mind & society —
      _n('ss5', 'Social Psychology — replication-aware', 2, 'ss1',
          '10 classic findings annotated: survived or died?', 80),
      _n('ss8', 'Thinking, Fast & Slow — with corrections', 3, 'ss5',
          'Brief: which chapters survived replication', 40),
      _n('ss9', 'Influence (Cialdini) + field notes', 4, 'ss8',
          '20 observed persuasion instances catalogued', 40),
      _n('ss10', "Moral Philosophy (Sandel's Justice)", 4, 'ss5',
          'All lectures + 3 position essays', 60),
      _n('ss20', 'Behavioral Economics — audited', 5, ['ss8', 'ss18'],
          'Misbehaving + Ariely annotated with replication status; 10 nudges judged', 60),
      _n('ss11', 'Behave (Sapolsky)', 6, ['ss3', 'ss9'],
          'Multi-level analysis of one behaviour', 60),
      // — Applied practice —
      _n('ss12', 'Applied Stoicism', 5, 'ss10', '30-day practice journal', 40),
      _n('ss19', 'Ethnography: 20 hrs public observation', 6, 'ss9',
          'Anonymised, ethics-aware field-note corpus + thematic write-up', 30),
      _n('ss21', 'Wellbeing science + 8-week practice', 6, 'ss12',
          "Yale's Science of Well-Being; 8 weeks of tracked practice, honest data", 40),
      // — Convergence: the study —
      _n('ss13', 'Design + preregister a study', 7, ['ss2', 'ss11', 'ss20'],
          'Preregistration live on OSF', 60),
      _n('ss14', 'Run it: collect real data', 8, ['ss13', 'ss17'],
          'Online sample; data + analysis code public', 80),
      _n('ss15', 'Write it up preprint-style', 9, 'ss14',
          'PsyArXiv-format manuscript', 80),
      _n('ss16', 'Crown: publish the preprint', 10,
          ['ss15', 'ss7', 'ss19', 'ss21'],
          'Posted publicly; critique from 2 researchers incorporated', 60),
    ]),
  ]),
  StatDomain('CHA', 'Charisma', 0xFFFB923C, [
    // Branches: Language (vocab/roots) · Writing Craft · Rhetoric & Speech ·
    // Argument & Analysis — crown = an essay that travels.
    Skill('english', 'English', '🔤', 'Command the Room and the Page', [
      _n('e1', 'Elements of Style + Williams', 1, null,
          'Rewrite 10 bad paragraphs; before/after', 40),
      _n('e2', 'Vocabulary I: 500 GRE words', 1, null,
          'Matured Anki deck, used in writing', 40),
      _n('e3', 'Etymology: 300 Latin & Greek roots', 1, null,
          'Decompose 100 unfamiliar words correctly', 40),
      // — Language —
      _n('e4', 'Vocabulary II: to 2,000 words + idioms', 2, 'e2',
          'Matured deck; GRE verbal practice sets', 80),
      _n('e16', 'GRE Verbal', 3, 'e4', 'ETS POWERPREP timed, ≥163', 80),
      // — Writing craft —
      _n('e17', 'Close reading: poetry & prose', 3, 'e1',
          '15 close readings; 5 poems memorised and recited', 60),
      _n('e20', 'Style imitation: 10 pastiches', 4, 'e17',
          '10 passages imitated (Orwell→Didion); what each taught, noted', 50),
      _n('e8', 'Sense of Style (Pinker)', 4, 'e6',
          'Essay applying the classic-style lens', 40),
      _n('e10', '10 persuasive long-form essays', 5, ['e8', 'e5', 'e20'],
          'Published; 2 revised after critique', 150),
      _n('e12', 'Cognitive Linguistics (Lakoff)', 5, 'e8',
          'Metaphor audit of your own writing', 40),
      // — Rhetoric & speech —
      _n('e6', 'Classical Rhetoric (Farnsworth)', 3, ['e1', 'e3'],
          'Device notebook: 40 devices, own examples', 60),
      _n('e9', 'Speech study: 25 great speeches', 4, 'e6',
          'Rhetorical breakdowns: structure, devices, delivery', 60),
      _n('e11', '10 recorded speeches', 5, 'e9',
          'Self-scored vs Toastmasters rubrics, visible arc', 80),
      _n('e13', 'Impromptu: 30 table-topics drills', 6, 'e11',
          'Recorded 2-min impromptus, no dead air', 30),
      _n('e19', 'Storytelling: 5 true stories, Moth rules', 6, 'e11',
          '5 filmed 5-min stories, no notes; one told to a live audience', 40),
      // — Argument & analysis —
      _n('e5', 'Logical Fallacies & Argument', 2, 'e1',
          '30 fallacies catalogued from real media', 40),
      _n('e18', 'Debate: 10 formal debates', 7, ['e13', 'e5'],
          '10 debates in an online club; 3 filmed + rebuttals self-scored', 60),
      // — Convergence —
      _n('e14', '20-min keynote from memory', 7, ['e10', 'e13', 'e19'],
          'One continuous take, audience of 5+', 60),
      _n('e15', 'Crown: an essay that travels', 8, ['e14', 'e12', 'e16', 'e18'],
          '1,000+ genuine readers, or printed in a venue you respect', 100),
    ]),
    // Branches: Grammar Spine · Input · Output · Culture & Song — crown =
    // consecutive interpretation, the skill no exam grants.
    Skill('turkish', 'Turkish', '🇹🇷', 'C1+ and Real-Time Interpretation', [
      _n('tr1', 'Phonology, vowel harmony, agglutination', 1, null,
          'Transcribe/pronounce 50 words; suffix-chain drills', 30),
      // — Grammar spine —
      _n('tr2', 'A1: 500 words + present tense', 2, 'tr1',
          'Matured deck; 10 self-recorded dialogues', 100),
      _n('tr3', 'A2: 1,500 words; past/future; cases begin', 3, 'tr2',
          'Timed A2 mock (TÖMER-format) ≥70%', 180),
      _n('tr4', 'B1: 3,000 words; full case system', 4, 'tr3',
          'Timed B1 mock; first 5 conversation hours', 300),
      _n('tr5', 'B2 grammar: chains, conditionals, evidentiality', 5, 'tr4',
          'Every structure drilled both ways; error log kept', 200),
      _n('tr6', 'Relative clauses & nominalisation', 6, 'tr5',
          'Translate 30 complex sentences both ways', 60),
      _n('tr8', 'B2 exam', 7, ['tr6', 'tr9', 'tr15'],
          'Full TYS-format mock, timed, ≥B2 band', 40),
      // — Input —
      _n('tr9', 'Input: 60 hrs Turkish media, no subs', 5, 'tr4',
          'Log + weekly summaries written in Turkish', 70),
      _n('tr15', 'Vocabulary: 5,000-word SRS', 5, 'tr4',
          'Deck built from your own input; sampled retention ≥90%', 150),
      _n('tr10', 'C1 reading: a full Pamuk novel', 8, ['tr8', 'tr16', 'tr17'],
          'Reading journal; 500-word review in Turkish', 60),
      // — Output —
      _n('tr18', 'Scripted speaking: 20 monologues', 4, 'tr3',
          '20 recorded 2-min monologues; native feedback on 5', 20),
      _n('tr7', 'Conversation: 30 logged hours', 5, ['tr4', 'tr18'],
          'Session log; self-rated CEFR descriptors', 35),
      _n('tr19', 'Writing I: 20 corrected texts', 6, 'tr5',
          'LangCorrect archive; error classes tracked and shrinking', 40),
      _n('tr11', 'Conversation: 100 total hours', 7, 'tr7',
          '15-min recorded discussion, native-checked', 80),
      _n('tr12', 'C1 writing: 10 essays, corrected', 8, ['tr8', 'tr19'],
          'Corrected drafts archived', 40),
      // — Culture & song —
      _n('tr16', 'Music & lyrics: 30 songs', 2, 'tr1',
          '30 songs studied; 10 sung or recited from memory', 40),
      _n('tr17', 'Culture & history of Türkiye', 3, 'tr2',
          'A short history read; 10 culture briefs (customs, regions, cuisine)', 40),
      // — Convergence —
      _n('tr13', 'C1/C2 exam', 9, ['tr10', 'tr11', 'tr12'],
          'Full TYS mock ≥C1 (sit the real TYS if reachable)', 60),
      _n('tr14', 'Crown: consecutive interpretation', 10, 'tr13',
          'Interpret a 10-min talk EN→TR, recorded, native-verified', 40),
    ]),
    // Branches: Script & Kanji · Grammar · Vocabulary & Input · Output ·
    // Culture — crown = literature + a 30-minute unscripted conversation.
    Skill('japanese', 'Japanese', '🇯🇵', 'N1 + the Spoken Skill JLPT Never Tests', [
      _n('j1', 'Kana + phonetics (pitch-accent aware)', 1, null,
          'Read kana at 60+ chars/min; minimal-pair quiz', 30),
      // — Script & kanji —
      _n('j3', 'Kanji I: 500', 2, 'j1', 'SRS matured', 200),
      _n('j5', 'Kanji II: 1,000', 3, 'j3', 'SRS matured', 200),
      _n('j8', 'Kanji III: all 2,136 jōyō', 5, 'j5',
          'SRS matured; read a news article aloud', 400),
      // — Grammar —
      _n('j2', 'Genki I', 2, 'j1', 'All workbook exercises; N5 mock ≥70%', 150),
      _n('j4', 'Genki II', 3, 'j2', 'Workbook + N4 mock ≥70%', 150),
      _n('j7', 'Tobira', 5, 'j6', 'All exercises; grammar log', 250),
      _n('j13', 'Shin Kanzen Master N2 (all 5)', 7, 'j10', 'Every exercise', 250),
      // — Vocabulary & input —
      _n('j6', 'Core 2k vocabulary', 4, ['j4', 'j5'],
          'Matured deck; 20 graded-reader stories', 200),
      _n('j9', 'Input I: 100 hrs native audio', 5, 'j6',
          'Log + weekly summaries in Japanese', 150),
      _n('j11', 'Core 6k vocabulary', 7, 'j6', 'Matured deck', 300),
      _n('j12', '15 manga volumes + 1 light novel', 7, 'j10',
          'Reading log with lookups declining', 200),
      _n('j21', 'Input II: 250 total hours', 8, ['j9', 'j12'],
          'Log at 250 hrs; a 20-min drama episode summarised, no subs', 250),
      // — Output —
      _n('j19', 'Pitch accent + shadowing I', 3, 'j2',
          'Minimal-pair test ≥90%; 10 shadowed clips, pitch self-compared', 40),
      _n('j20', 'Writing I: 30 corrected journal entries', 6, 'j7',
          'LangCorrect/HelloTalk archive; error log shrinking', 50),
      _n('j16', 'Speaking: 50 hours + shadowing', 9, ['j14', 'j9', 'j19'],
          '10-min recorded conversation, native-rated B2', 80),
      _n('j15', 'Keigo (business honorifics)', 9, 'j14',
          '10 role-play situations, native-checked', 60),
      // — Culture —
      _n('j22', 'Culture: customs & geography of Japan', 4, 'j4',
          '20 culture briefs; a Japan geography deck matured', 40),
      // — Exam spine & convergence —
      _n('j10', 'JLPT N3', 6, ['j7', 'j8'],
          'Full timed mock ≥ pass line +10%', 60),
      _n('j14', 'JLPT N2', 8, ['j11', 'j12', 'j13'],
          'Official sitting if reachable, else 2 timed mocks ≥ pass +10%', 80),
      _n('j17', 'JLPT N1', 10, ['j16', 'j21'],
          'Official sitting if reachable, else 2 timed mocks ≥ pass +10%', 250),
      _n('j18', 'Crown: literature + your own voice', 11,
          ['j15', 'j17', 'j20', 'j22'],
          'A full literary novel finished; 30-min unscripted native conversation', 150),
    ]),
    // Branches: Script & Literacy · Core Language · Input · Output ·
    // Culture — built for a language with no textbook ecosystem.
    Skill('khmer', 'Khmer', '🇰🇭', 'Fluency Where No Textbook Ecosystem Exists', [
      _n('kh1', 'Script I: consonants (two series) + vowels', 1, null,
          'Read any letter; write the alphabet from memory', 40),
      // — Script & literacy —
      _n('kh2', 'Script II: subscripts; length & aspiration', 2, 'kh1',
          'Read 100 real words aloud, native-checked (Khmer has no tones)', 60),
      _n('kh15', 'Digital Khmer: typing & tools', 2, 'kh1',
          'Type 15 wpm in Khmer Unicode; phone + desktop setup documented', 15),
      _n('kh6', 'Street literacy: signs, menus, prices', 5, 'kh2',
          'Read 50 photographed real-world signs', 30),
      _n('kh9', 'Read native news (VOA Khmer)', 7, ['kh6', 'kh8', 'kh15'],
          '20 articles summarised in Khmer', 60),
      // — Core language —
      _n('kh3', 'A1: SVO syntax, 300 words (Aakanee)', 3, 'kh2',
          'Describe 20 Aakanee scenes from memory', 120),
      _n('kh4', 'A2: classifiers, aspect markers, 800 words', 4, 'kh3',
          '10 self-recorded dialogues', 150),
      _n('kh5', 'B1: 1,500 core words', 5, 'kh4',
          'Matured deck; 15-min conversation attempt logged', 200),
      _n('kh8', 'B2 grammar: serial verbs, complex sentences', 6, 'kh5',
          'Translate 30 sentences both ways, checked', 150),
      _n('kh10', 'Registers: formal, clergy & royal', 8, 'kh8',
          'Register-switch drill on 30 sentences', 60),
      // — Input —
      _n('kh11', 'Input: 100 hrs media/news', 8, 'kh9', 'Log + summaries', 100),
      // — Output —
      _n('kh18', 'First output: 10 exchanges', 4, 'kh3',
          '10 short exchanges (HelloTalk/tutor); 5 recorded dialogues corrected', 15),
      _n('kh7', 'Conversation: 25 logged hours', 6, ['kh5', 'kh18'],
          "Session log + tutor's written assessment", 30),
      _n('kh16', 'Songs & karaoke: 20 songs', 7, 'kh7',
          '20 songs studied; 5 sung with lyrics from memory', 30),
      _n('kh12', 'Conversation: 100 total hours', 9, 'kh7',
          'ILR self-assessment + native-rated interview (S-2+)', 90),
      // — Culture —
      _n('kh17', 'Culture & history (Chandler)', 2, 'kh1',
          "A History of Cambodia read; 10 culture briefs written", 40),
      _n('kh13', 'Traditional literature (Reamker excerpts)', 9,
          ['kh10', 'kh17'], 'Reading journal with cultural notes', 60),
      // — Convergence —
      _n('kh14', 'Crown: interpretation + literacy', 10,
          ['kh11', 'kh12', 'kh13', 'kh16'],
          'Interpret a 10-min talk KM→EN, recorded, native-verified', 40),
    ]),
    // Branches: Written Theory (ABRSM spine) · Ear Training · Analysis ·
    // Composition (starts at tier 3, not the summit) — crown = a real work.
    Skill('musicTheory', 'Music Theory', '🎼', 'Compose and Hear It Performed', [
      _n('mt1', 'Notation: pitch, rhythm, clefs, metre', 1, null,
          'ABRSM Grade 1–2 past papers ≥90%', 40),
      // — Written theory —
      _n('mt2', 'Scales, keys & the circle of fifths', 2, 'mt1',
          'Any key signature/scale on demand', 40),
      _n('mt4', 'Triads, inversions & cadences', 4, 'mt3',
          'Four-part cadence exercises', 50),
      _n('mt5', 'ABRSM Grade 5 Theory', 5, ['mt4', 'mt19'],
          'Two past papers ≥ merit, timed', 80),
      _n('mt7', 'Sevenths, figured bass & Roman numerals', 6, 'mt5',
          'Analyse 10 Bach chorales', 80),
      _n('mt8', 'Four-part harmony (chorale writing)', 7, 'mt7',
          'Harmonise 20 melodies; check vs Bach', 120),
      _n('mt9', 'Species Counterpoint (Fux)', 8, 'mt8',
          'All five species, two then three voices', 100),
      _n('mt10', 'ABRSM Grade 8 Theory', 8, 'mt8',
          'Two past papers ≥ merit, timed', 120),
      // — Ear training —
      _n('mt3', 'Intervals & ear training I', 3, 'mt2',
          'Interval dictation ≥90% (functional ear trainer)', 60),
      _n('mt15', 'Ear training II: dictation', 5, 'mt3',
          'Transcribe 20 short passages by ear', 60),
      _n('mt20', 'Ear training III: transcription', 8, 'mt15',
          'Transcribe 10 songs (melody + chords) and 5 chorale phrases by ear', 80),
      // — Rhythm —
      _n('mt19', 'Rhythm I: reading & clapping', 2, 'mt1',
          '20 rhythms clapped at tempo from notation, recorded', 30),
      // — Composition: begins early, grows with the theory —
      _n('mt16', 'Composition I: 12 eight-bar melodies', 3, 'mt2',
          'Notated in MuseScore; 3 peer critiques gathered', 40),
      _n('mt17', 'Composition II: theme & 5 variations', 6, ['mt16', 'mt5'],
          'Score + render; harmonic analysis of your own piece attached', 60),
      _n('mt18', 'Jazz & pop harmony', 7, 'mt7',
          'Levine chapters worked; 10 standards analysed; 5 reharmonisations', 100),
      // — Analysis & orchestration —
      _n('mt11', 'Form & analysis: sonata and fugue', 9, 'mt10',
          'Full analyses of 6 scores (2 fugues)', 100),
      _n('mt12', 'Orchestration (Adler) + MuseScore', 10, 'mt11',
          'Orchestrate a piano piece for 12+ instruments', 120),
      // — Convergence —
      _n('mt13', 'Portfolio I: song + quartet movement', 11,
          ['mt9', 'mt11', 'mt17', 'mt18', 'mt20'],
          'Scores + rendered audio, published', 150),
      _n('mt14', 'Crown: a 10-minute multi-movement work', 12,
          ['mt12', 'mt13'],
          'Full score + performance or convincing render, released', 250),
    ]),
    // Branches: Technique · Repertoire (ABRSM spine) · Reading ·
    // Musicianship (lead sheets, improv, ensemble) · Performance Craft.
    Skill('piano', 'Piano', '🎹', 'The One-Hour Memorised Recital', [
      _n('p1', 'Setup: posture, hand shape, first pieces', 1, null,
          'Video self-check vs reference; 5 beginner pieces', 40),
      // — Technique —
      _n('p3', 'Major scales & arpeggios (2 octaves)', 2, 'p1',
          'Metronome video, all 12 keys, hands together', 80),
      _n('p4', 'Minor scales & arpeggios', 3, 'p3', 'Metronome video', 80),
      _n('p5', 'Technique I: Hanon 1–20 / Czerny 599', 3, 'p3',
          'Clean at marked tempi, video', 120),
      _n('p8', 'Pedalling: legato, syncopated, una corda', 5, 'p5',
          'Before/after recordings of 3 pieces', 40),
      _n('p9', 'Technique II: Czerny School of Velocity', 6, 'p5',
          'Four studies at tempo, video', 150),
      _n('p12', 'Polyrhythm & independence studies', 9, 'p9',
          '3:2 and 4:3 études at tempo', 80),
      // — Reading —
      _n('p2', 'Reading I: grand staff fluency', 2, 'p1',
          'Sight-read Grade 1 pieces at tempo', 60),
      _n('p13', 'Reading II: daily sight-reading to Grade 6', 5, 'p2',
          '8-week log; unseen piece test', 80),
      // — Musicianship: chords, improvisation, playing with others —
      _n('p7', 'Harmonisation & lead sheets', 3, 'p2',
          'Play 10 songs from chords alone', 60),
      _n('p20', 'Improvisation I: blues & pentatonic', 4, 'p7',
          '10 recorded improvisations over backing tracks; honest self-review', 60),
      _n('p22', 'Accompany: play with others', 7, ['p20', 'p21'],
          'Accompany a singer or instrumentalist on 5 songs, recorded', 40),
      // — Repertoire spine —
      _n('p18', 'ABRSM Grade 3 Performance', 4, ['p2', 'p4'],
          'Video submission (real cert) or mock to its criteria', 120),
      _n('p6', 'Bach: three Two-Part Inventions', 5, 'p18',
          'One continuous video take each', 120),
      _n('p19', 'ABRSM Grade 5 Performance', 7, ['p6', 'p8'],
          'Video submission or mock', 150),
      _n('p10', 'Classical: full Mozart/Haydn sonata', 8, 'p19',
          'One-take video, memorised', 200),
      _n('p11', 'Romantic: Chopin nocturne + waltz', 9, ['p10', 'p9'],
          'One-take videos', 200),
      _n('p14', 'ABRSM Grade 8 Performance', 10, ['p11', 'p13', 'p23'],
          'Video submission (real cert — ABRSM requires Grade 5 Theory '
              'first: see the Music Theory tree) or mock to its criteria', 300),
      _n('p15', 'Impressionist: Debussy/Ravel work', 11, 'p14',
          'One-take video', 150),
      // — Performance craft —
      _n('p21', 'Performance ritual: monthly one-takes', 6, 'p18',
          '6 months of monthly one-take videos; log of nerves and fixes', 30),
      _n('p23', 'Memorisation craft', 8, 'p19',
          'Memorise 3 pieces via analysis; test: restart from any section', 60),
      // — Convergence —
      _n('p16', 'Crown: 60-minute memorised recital', 12, ['p15', 'p12', 'p22'],
          'Single continuous recording, 4+ eras, published', 400),
    ]),
    // Branches: Technique (health-first) · Ear & Musicianship · Repertoire &
    // Style · Performance & Production — crown = your EP, sung live.
    Skill('singing', 'Singing', '🎤', 'Release an EP and Sing It Live', [
      _n('v1', 'Breath: diaphragmatic support', 1, null,
          '20-sec sustained tone, steady dB, video', 20),
      // — Technique, vocal health first —
      _n('v17', 'Vocal health & anatomy', 2, 'v1',
          'How the voice works, summarised; warm-up routine; strain red-flags', 20),
      _n('v2', 'Pitch matching & ear', 2, 'v1',
          '≤10-cent average error across 2 octaves (pitch app)', 40),
      _n('v3', 'Chest voice development', 3, ['v2', 'v17'],
          'Recorded scale ladder, no strain, vs rubric', 60),
      _n('v4', 'Head voice & falsetto', 3, ['v2', 'v17'],
          'Recorded sirens through the break', 60),
      _n('v5', 'Diction & vowel modification', 4, 'v3',
          'Same phrase in 5 vowels, spectrogram compare', 40),
      _n('v6', 'Mix voice through the passaggio', 5, ['v3', 'v4'],
          'Recorded bridging, no flip, month-apart comparisons', 120),
      _n('v7', 'Vibrato', 6, 'v6',
          'Straight tone → 5–7 Hz vibrato on demand', 60),
      _n('v8', 'Agility & runs', 7, 'v6',
          'Pentatonic run drills at 120 bpm, clean', 80),
      _n('v9', 'Dynamics (messa di voce)', 8, 'v7',
          'Crescendo–decrescendo on one breath, recorded', 60),
      // — Ear & musicianship —
      _n('v21', 'Ear for singers: intervals & harmony', 3, 'v2',
          'Interval singing ≥90%; root/3rd/5th sung against drones', 40),
      _n('v18', 'Harmony singing: duets', 7, ['v21', 'v16'],
          '5 duet/harmony recordings (virtual duets fine); pitch-checked', 40),
      // — Repertoire & style —
      _n('v16', 'Repertoire I: 10 songs performed clean', 6, ['v5', 'v6'],
          'Full-take recordings + honest self-review', 80),
      _n('v10', 'Style versatility: 3 genres × 3 songs', 9, ['v16', 'v8'],
          'Recordings judged against genre references', 120),
      _n('v20', 'Songwriting I: 5 originals', 8, 'v16',
          '5 songs written (lyrics + melody + chords), rough demos recorded', 80),
      // — Performance & production —
      _n('v11', 'Home recording craft', 10, ['v9', 'v10'],
          'One polished vocal track (Reaper/Audacity)', 60),
      _n('v19', 'Stage & mic technique', 10, 'v10',
          'Mic-distance/plosive demo; 3 filmed performances with movement', 40),
      _n('v13', 'Perform live: 5 open-mic sets', 11, 'v19',
          'Filmed performances', 40),
      _n('v14', 'Produce an EP: 5 tracks', 11, ['v11', 'v20'],
          'Released on streaming platforms — your own songs on it', 150),
      // — Convergence —
      _n('v15', 'Crown: live set of your EP', 12, ['v13', 'v14', 'v18'],
          '20+ min filmed live; critique from 2 musicians', 60),
    ]),
  ]),
  StatDomain('DEX', 'Dexterity', 0xFF4ADE80, [
    // Branches: Construction · Observation (figure, Bargue, masters) ·
    // Light & Color · Imagination, Habit & Digital — crown = an exhibit.
    Skill('drawing', 'Drawing', '✏️', 'A Body of Work Worth Exhibiting', [
      _n('d1', 'Drawabox: lines, ghosting, 250 boxes', 1, null,
          'Completed homework, posted for critique', 100),
      // — Construction —
      _n('d2', 'Shape, proportion & measuring', 2, 'd1',
          '20 still-life studies with measured comparisons', 60),
      _n('d3', 'Form: boxes, cylinders, ellipses in space', 3, 'd2',
          'Drawabox lessons 2–3 homework', 80),
      _n('d4', 'Perspective I: 1 & 2 point', 4, 'd3',
          'A real interior drawn twice, plotted', 60),
      _n('d7', 'Perspective II: 3-point + foreshortening', 5, 'd4',
          'Worm/bird-eye city scene, plotted', 80),
      // — Observation: figure, plates, masters —
      _n('d6', 'Gesture: 500 timed figure poses', 4, ['d3', 'd18'],
          'Dated sketchbook pages, 30s–2min poses', 80),
      _n('d8', 'Anatomy I: skeleton (Proko)', 5, 'd6',
          'Skeleton from imagination, 3 angles', 80),
      _n('d17', 'Bargue plates: 10 copies', 5, 'd5',
          'Side-by-side comparisons, flaws annotated', 100),
      _n('d10', 'Anatomy II: muscles', 6, 'd8',
          'Écorché studies over 10 gesture drawings', 120),
      _n('d19', 'Master studies: 10 copies', 6, 'd17',
          'Ten master copies (Rubens/Sargent/Bridgman); deviations annotated', 100),
      _n('d11', 'Anatomy III: hands, feet, portrait', 7, 'd10',
          '100 hands, 50 feet, 20 portraits', 200),
      // — Light & color —
      _n('d5', 'Value: light logic + 10-step scales', 4, 'd3',
          'Sphere/cube/cylinder under 3 light setups', 60),
      _n('d9', 'Color theory (Gurney)', 6, 'd5',
          '12 limited-palette studies', 100),
      _n('d12', 'Material rendering', 8, ['d9', 'd7'],
          'Metal, glass, cloth, skin — one still life each', 120),
      // — Imagination, habit & digital —
      _n('d18', 'Sketchbook habit: 100 consecutive days', 2, 'd1',
          'Dated pages, 100-day streak; monthly self-critique', 100),
      _n('d21', 'Environments: 20 plein-air sketches', 7, ['d7', 'd9'],
          'On-location sketchbook; 5 finished scenes', 80),
      _n('d20', 'Digital craft (Krita/Procreate)', 8, 'd9',
          '5 studies replicating your traditional values and color digitally', 80),
      _n('d13', 'Composition & storytelling', 9, ['d12', 'd19', 'd21'],
          '10 thumbnails/day for 30 days; 3 narrative pieces', 150),
      // — Convergence —
      _n('d14', 'Portfolio: 20 finished works', 10, ['d11', 'd13', 'd20'],
          'Curated, unified voice + artist statement', 300),
      _n('d16', 'Crown: exhibit', 11, 'd14',
          'A real show (café/library/gallery/online curated), documented reach', 60),
    ]),
    // Branches: Craft Study · Production (the novel spine) · Community &
    // Submission · Reading — crown = a published novel with real readers.
    Skill('writing', 'Writing', '🖊', 'A Published Novel', [
      _n('w1', 'Grammar & mechanics cold', 1, null,
          'Error-free 1,000-word sample; style-guide quiz', 40),
      // — Reading —
      _n('w2', 'Read like a writer: 30 classics', 2, 'w1',
          'Reading journal: one craft lesson per book', 300),
      _n('w20', 'Genre immersion: 20 books', 3, 'w2',
          'Genre map: tropes, expectations, comp titles; reading journal', 150),
      // — Craft study —
      _n('w18', 'Prose rhythm: poetry & sentences', 2, 'w1',
          '30 poems studied; 20 sentence imitations, before/after', 40),
      _n('w4', 'Story structure (McKee + Save the Cat)', 4, 'w3',
          'Beat-sheet 5 favourite novels/films', 60),
      _n('w6', 'On Writing (King) + Bird by Bird', 6, 'w5',
          'Revision philosophy memo', 30),
      _n('w19', 'Research & world-building bible', 5, 'w20',
          'Story bible: places, cast, timeline, research notes with sources', 60),
      // — Production: the novel spine —
      _n('w3', '12 short stories (one a month)', 3, 'w2',
          'Finished drafts — quantity before quality', 200),
      _n('w5', 'NaNoWriMo: 50,000-word draft', 5, 'w4',
          "Winner's word-count export", 100),
      _n('w7', 'The novel: 90,000-word complete draft', 7, ['w6', 'w19'],
          'Full manuscript, beginning–middle–end', 400),
      _n('w8', 'Developmental revision (macro edit)', 8, ['w7', 'w16'],
          'Revision map: what changed and why', 200),
      _n('w9', 'Prose craft (Zinsser + line edits)', 9, ['w8', 'w18'],
          '3 chapters before/after', 100),
      _n('w11', 'Beta cycle: 5 readers', 10, 'w9',
          'Feedback grid + acted-on list', 60),
      // — Community & submission —
      _n('w16', 'Critique circle membership', 4, 'w3',
          '20 critiques given, 5 received (Scribophile/Critters)', 60),
      _n('w17', 'Flash & short: submit 10 pieces', 5, 'w16',
          '10 submissions logged (Duotrope); rejections collected proudly', 40),
      _n('w21', 'Place a short story', 8, 'w17',
          'One story accepted anywhere real, or 3 personal rejections earned', 40),
      _n('w10', 'Submission craft: query + synopsis', 11, ['w11', 'w21'],
          'Package critiqued in a query workshop', 40),
      _n('w12', 'Enter the arena: 20 submissions', 12, 'w10',
          'Log — 3 personal responses OR 1 acceptance', 40),
      // — Convergence —
      _n('w14', 'Crown: publish', 13, 'w12',
          'Traditional deal OR professional self-release, 50+ verified readers', 150),
    ]),
    // Branches: Technique Spine · Baking & Pastry · Food Science · World
    // Cuisines & Presentation — crown = the 8-course tasting menu.
    Skill('cooking', 'Cooking', '🍳', 'Chef of Your Own Table', [
      _n('c1', 'Food safety', 1, null,
          'ServSafe Food Handler — real cert, online', 10),
      // — Technique spine —
      _n('c2', 'Knife skills', 2, 'c1',
          'Uniformity test videos: julienne, brunoise, chiffonade', 40),
      _n('c3', 'Eggs & heat control', 3, 'c2',
          '8 egg preparations photographed at standard', 30),
      _n('c4', 'Salt Fat Acid Heat (framework cooking)', 4, ['c3', 'c17'],
          '12 dishes tagged by which lever fixed them', 60),
      _n('c5', 'Stocks: white, brown, vegetable', 4, 'c2',
          'Gel-set photos + reduction tasting notes', 30),
      _n('c8', 'Vegetables: roast, braise, blanch, pickle', 5, 'c4',
          'Seasonal menu using 8 techniques', 40),
      _n('c6', 'The five mother sauces + derivatives', 6, ['c4', 'c5'],
          'All five + 2 derivatives each, documented', 60),
      _n('c9', 'Proteins: butchery + temperature mastery', 7, ['c6', 'c20'],
          'Whole chicken broken down; temp log for 3 proteins', 60),
      _n('c10', 'Emulsions & dressings', 7, 'c6',
          'Mayo, hollandaise, 5 vinaigrettes from memory', 30),
      // — Food science & tools —
      _n('c17', 'Food science (McGee)', 2, 'c1',
          'Chapter notes; 10 kitchen experiments explained (rest, brine, sear)', 80),
      _n('c20', 'Sharpening & tool care', 3, 'c2',
          'Whetstone progression video; paper-slice test; care log', 20),
      _n('c11', 'Fermentation & preservation', 8, ['c9', 'c17'],
          'Kraut, yogurt, pickles + one long ferment', 40),
      // — Baking & pastry —
      _n('c7', 'Baking ratios (Ruhlman) + bread', 5, 'c4',
          'Baguette, loaf, pizza — crumb shots', 80),
      _n('c21', 'Pastry: desserts & lamination', 7, 'c7',
          'Croissants, tart, custards; lamination layers photographed', 80),
      // — World cuisines & presentation —
      _n('c16', 'World techniques: 5 dishes × 4 cuisines', 6, 'c8',
          'Cook-throughs with authenticity notes', 100),
      _n('c18', 'Plating & presentation', 8, ['c16', 'c10'],
          '10 plated dishes vs reference plating; natural-light photos', 40),
      _n('c19', 'Menu craft: plan & cost 5 menus', 9, 'c18',
          '5 costed menus with prep timelines; one executed on budget', 40),
      // — Convergence —
      _n('c12', 'Replicate 3 Michelin-book recipes', 9, ['c11', 'c21', 'c18'],
          'Full process documented, plating compared', 60),
      _n('c13', 'Develop 10 original recipes', 10, 'c12',
          'Written recipes tested by someone else from the page', 80),
      _n('c15', 'Crown: 8-course tasting menu for 8', 11, ['c13', 'c19'],
          'Menu design → prep schedule → solo execution → guest feedback', 60),
    ]),
    // Branches: Auto · Home · Machines (bike → engine) · Making (wood, CAD,
    // metal) — crown = a rebuilt machine and a transformed room.
    Skill('mechanics', 'Mechanics', '🔧', 'Rebuild It Yourself', [
      _n('m1', 'Shop safety + tool literacy', 1, null,
          'Tool ID quiz; torque practice; jack-stand discipline video', 20),
      // — Auto —
      _n('m2', 'Auto basics: fluids, filters, battery, tyres', 2, 'm1',
          'Perform + document all on a real car', 30),
      _n('m4', 'Auto: brakes & suspension', 3, 'm2',
          'Pad/rotor change documented; ASE A5 practice ≥80%', 40),
      _n('m6', 'Auto: electrics + OBD-II diagnostics', 4, 'm4',
          '3 real faults chased with multimeter + scanner log', 60),
      _n('m12', 'ASE knowledge gauntlet', 7, 'm10',
          'A1–A8 practice exams, all ≥80%', 120),
      // — Home —
      _n('m3', 'Home basics: drywall, painting, patching', 2, 'm1',
          'Repair a wall section, document the finish', 30),
      _n('m5', 'Home: plumbing fundamentals', 3, 'm3',
          'Replace a trap/valve; sweat or press one joint', 40),
      _n('m7', 'Home: electrical theory + code literacy', 4, 'm5',
          'Practice board wired (dead circuits); code quiz ≥80%', 60),
      _n('m9', 'Home: framing & structural basics', 5, 'm17',
          'Stud wall or shed section, square + plumb', 60),
      _n('m11', 'Home: full room renovation', 6, ['m9', 'm7'],
          'Before/after with process log', 150),
      _n('m15', 'EPA 608 (refrigerant handling)', 7, 'm7',
          'The real certificate — publicly bookable', 30),
      // — Machines: bicycle → engine —
      _n('m16', 'Bicycle: full tune-up', 2, 'm1',
          'Brakes, gears, bearings serviced; Park Tool checklist; ride test', 25),
      _n('m8', 'Small-engine teardown: rebuild to running', 5, ['m6', 'm16'],
          'Junkyard/lawnmower engine — video of first start', 60),
      _n('m10', 'Motorcycle/car engine rebuild', 6, 'm8',
          'Compression numbers before/after', 150),
      // — Making: wood, CAD, metal —
      _n('m17', 'Woodworking I: build a workbench', 3, 'm3',
          'Square, level bench from plans; joinery photos; technique video', 60),
      _n('m18', 'CAD + 3D printing', 4, 'm17',
          'Three designed-and-printed functional parts; tolerances measured', 60),
      _n('m19', 'Metalwork & fasteners', 5, 'm18',
          'Tap & die practice; a steel bracket made; makerspace intro class ok', 40),
      // — Convergence —
      _n('m14', 'Crown: one machine + one room, end to end', 8,
          ['m12', 'm11', 'm15', 'm19'],
          'A vehicle you rebuilt driving; a room you transformed', 200),
    ]),
    // Branches: Systems · Applied Memory (real knowledge) · Competition
    // Drills · Science of Learning — crown = ranked competition.
    Skill('memory', 'Memory', '🧩', 'Compete Among the Best from Your Desk', [
      _n('mem1', 'SRS habit: 180-day Anki streak', 1, null, 'Stats export', 60),
      // — Systems —
      _n('mem2', 'Link & story method', 2, 'mem1',
          'Memorise 20-item lists reliably', 20),
      _n('mem3', 'Memory palaces: 5 palaces, 100 loci', 3, 'mem2',
          'Palace maps; 50-item recall demo', 40),
      _n('mem4', 'Major system 00–99', 4, 'mem3',
          'Full table from memory; 40 digits in 2 min', 40),
      _n('mem5', 'PAO system', 5, 'mem4',
          'Full PAO table; 80 digits in 5 min', 60),
      _n('mem6', 'Palace network: 20 palaces, 500 loci', 5, 'mem3',
          'Index + rotation schedule', 60),
      // — Science of learning —
      _n('mem14', 'Learning science (Make It Stick)', 2, 'mem1',
          'Retrieval + interleaving applied to one subject for a month, logged', 30),
      // — Applied memory: real knowledge, kept forever —
      _n('mem15', 'Applied I: a poem and a speech', 3, 'mem2',
          '100-line poem + 10-min speech recited on camera, palace maps shown', 40),
      _n('mem16', 'Applied II: a knowledge vault', 5, ['mem15', 'mem14'],
          'Periodic table, world capitals, 50 constellations: cold-tested ≥95%', 80),
      // — Competition drills —
      _n('mem7', 'Names & faces', 6, 'mem6',
          'Memory League: 15+ names/min level', 60),
      _n('mem9', 'Numbers discipline', 6, 'mem5',
          'Memory League 80-digit level, or 200 digits in 5 min', 80),
      _n('mem8', 'Cards: one deck under 3 minutes', 7, ['mem5', 'mem6'],
          'On-camera single take', 60),
      _n('mem17', 'Names in the wild', 7, 'mem7',
          '50 real people remembered a week later; verified log', 30),
      _n('mem10', 'Cards: under 90 seconds', 8, 'mem8',
          'On-camera single take', 100),
      _n('mem11', 'Images & words events', 8, 'mem9',
          'Memory League level 60+ in both', 60),
      _n('mem12', 'A full Memory League season', 9,
          ['mem7', 'mem10', 'mem11'], 'Season completed; W/L recorded', 60),
      // — Convergence —
      _n('mem13', 'Crown: ranked competitor', 10,
          ['mem12', 'mem16', 'mem17'],
          'Memory League top-100, or an official IAM event completed', 100),
    ]),
    // Branches: Kihon & Kata · Kumite & Partner Work · Conditioning ·
    // Theory, History & Mind — crown = Sandan and a group you lead.
    Skill('karate', 'Karate', '🥋', 'Shodan and Beyond, Honestly Earned', [
      _n('k1', 'Foundations: etiquette, stances, tai sabaki', 1, null,
          'Stance-hold times; video vs JKA reference', 40),
      // — Kihon & kata —
      _n('k2', 'Kihon: 9th–7th kyu syllabus', 2, 'k1',
          'Full syllabus on video, self-scored vs standard', 80),
      _n('k3', 'Heian Shodan–Sandan', 3, 'k2',
          'Each kata one-take video, compared move-by-move', 80),
      _n('k5', 'Heian Yondan–Godan + Tekki Shodan', 4, 'k3',
          'One-take videos + bunkai notes', 80),
      _n('k7', 'Advanced kata: Bassai Dai, Jion, Enpi', 6, 'k5',
          'One-take videos vs JKA reference', 100),
      _n('k8', 'Bunkai: applications of every kata', 7, 'k7',
          'Partner demo video, 3 applications per kata', 80),
      // — Kumite & partner work (always dojo-supervised) —
      _n('k4', 'Partner work: gohon/sanbon kumite', 3, 'k2',
          'Logged dojo sessions', 60),
      _n('k6', 'Jiyu kumite: 50 free-sparring rounds', 5, ['k4', 'k15'],
          'Dojo log; 5 rounds on video, reviewed', 60),
      _n('k9', 'Kumite depth: 150 rounds + shiai', 7, 'k6',
          'Log; one tournament or in-dojo shiai', 120),
      // — Conditioning —
      _n('k15', 'Conditioning: strength & mobility', 3, 'k2',
          '12-week program log; belt-height kicks held 10s', 80),
      // — Theory, history & mind —
      _n('k16', 'Dojo Japanese: terms & etiquette', 2, 'k1',
          'Terminology deck matured: counting, commands, kata names', 20),
      _n('k17', 'History & philosophy (Funakoshi)', 4, 'k16',
          'Karate-Do: My Way of Life + precepts; essay: what karate is for', 30),
      _n('k18', 'Rules & judging literacy', 6, ['k5', 'k17'],
          'WKF/JKA rules summarised; 10 recorded matches scored vs officials', 30),
      // — Convergence: the dan chain —
      _n('k10', 'Shodan grading', 8, ['k8', 'k9'],
          'The real grading at your dojo/organisation', 100),
      _n('k11', 'Sempai: assist teaching, 6 months', 9, 'k10',
          "Instructor's written confirmation", 120),
      _n('k12', 'Nidan → Sandan gradings', 10, 'k11',
          'Real gradings — multi-year, as intended', 400),
      _n('k14', 'Crown: Sandan + your own study group', 11, ['k12', 'k18'],
          '3rd dan certificate; a regular group you lead', 150),
    ]),
  ]),
];

StatDomain statById(String id) => catalog.firstWhere((s) => s.id == id);

Skill skillById(String id) =>
    catalog.expand((s) => s.skills).firstWhere((sk) => sk.id == id);

/// Total node count across every constellation (the "lifetime mastery" count).
final int totalNodeCount = catalog.fold(
    0, (sum, s) => sum + s.skills.fold(0, (x, sk) => x + sk.tree.length));
