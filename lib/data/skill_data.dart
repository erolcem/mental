// data/skill_data.dart — the full mastery catalog: 4 stats → 21 skills → the
// constellation of a lifetime. Overhauled 2026-07-04 into PARALLEL PATHS.
//
// Every skill is no longer a single vertical spine but a constellation of
// named BRANCHES — parallel tracks that rise from their own roots, run
// independently, cross-link at synthesis stars, and converge on one crown
// (the skill's true endgame). You can pour a season into one branch, but the
// summit always demands several. That is the "many parallel paths" shape: a
// real skill tree, not a to-do list.
//
// Three rules hold on every node:
//   • SELF-ACHIEVABLE — study, practice, or exam-mimicry a determined
//     autodidact can complete alone, with no institution's permission (real
//     public exams, video-verified performances, published artefacts).
//   • PROVEN — each node carries a `proof`: the concrete completion standard
//     the Examiner demands evidence against and the Reviewer quizzes from.
//   • TREE-SHAPED — `tier` is real dependency depth (the vertical band a star
//     sits in); `requires` are the specific stars that must be lit first;
//     `branch` names the parallel path the star belongs to.
//
// Node ids are unique per tree but NOT globally (maths and mechanics both use
// m1..); persistence keys progress by `skillId.nodeId` — see [progressKey].
// Ids surviving from the previous catalog keep their progress.
import 'dart:ui' show Color;

class SkillNode {
  final String id;
  final String label;

  /// 1-based depth band. Tier 1 sits at the constellation's base; the final
  /// tier is the lone mastery star at its crown.
  final int tier;

  /// The parallel path (track) this star belongs to — e.g. "Physics",
  /// "Kata", "Publishing". Stars in the same branch form a coherent chain;
  /// branches run in parallel and cross-link into the crown.
  final String branch;

  /// Ids (within the same tree) that must be complete before this unlocks.
  final List<String> requires;

  /// The completion standard: what counts as evidence this node is done.
  final String proof;
  const SkillNode(this.id, this.label, this.tier, this.branch,
      [this.requires = const [], this.proof = '']);
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

  /// The distinct parallel paths in this constellation, in first-seen order.
  List<String> get branches {
    final seen = <String>[];
    for (final n in tree) {
      if (n.branch.isNotEmpty && !seen.contains(n.branch)) seen.add(n.branch);
    }
    return seen;
  }
}

class StatDomain {
  final String id; // INT | WIS | CHA | DEX
  final String label;
  final Color color;
  final List<Skill> skills;
  const StatDomain(this.id, this.label, this.color, this.skills);
}

/// Globally unique progress key for a node.
String progressKey(String skillId, String nodeId) => '$skillId.$nodeId';

SkillNode _n(String id, String label, int tier, String branch,
        [Object? req, String proof = '']) =>
    SkillNode(
        id,
        label,
        tier,
        branch,
        req == null
            ? const []
            : req is String
                ? [req]
                : List<String>.from(req as List),
        proof);

final List<StatDomain> catalog = [
  // ═══════════════════════════════════════════════════════════════════════
  // INTELLIGENCE
  // ═══════════════════════════════════════════════════════════════════════
  StatDomain('INT', 'Intelligence', const Color(0xFF00D4FF), [
    Skill('science', 'Physics & Chem', '⚗', 'Publish an Original Scientific Result', [
      // Two roots: a physics/maths foundation and a chemistry foundation.
      _n('sc1', 'Foundations: AP Physics C', 1, 'Physics', null,
          '≥4-equivalent on both released AP Physics C exams, self-timed'),
      _n('sc24', 'Foundations: AP Chemistry', 1, 'Chemistry', null,
          '≥4-equivalent on a released AP Chemistry exam, self-timed'),
      // Physics spine.
      _n('sc2', 'Classical Mechanics (Taylor)', 2, 'Physics', 'sc1',
          '150+ worked problems incl. the Lagrangian chapter'),
      _n('sc19', 'Mathematical Methods (Boas)', 2, 'Mathematics', 'sc1',
          'Vector calc, ODE/PDE and linear algebra chapters worked'),
      _n('sc4', 'Electromagnetism (Griffiths)', 3, 'Physics', ['sc2', 'sc19'],
          'All in-chapter problems through ch. 9'),
      _n('sc7', 'Quantum Mechanics (Griffiths QM)', 4, 'Physics', 'sc4',
          'Derive the hydrogen atom start-to-finish unaided'),
      _n('sc6', 'Thermal & Statistical Physics (Schroeder)', 4, 'Physics', 'sc2',
          'Full problem sets, then Kittel & Kroemer'),
      _n('sc10', 'Advanced QM (Sakurai)', 6, 'Physics', 'sc7',
          'Perturbation theory + scattering problem sets'),
      _n('sc27', 'Solid State Physics (Kittel)', 6, 'Physics', ['sc6', 'sc7'],
          'Band-structure derivation + solid-state problem sets'),
      _n('sc13', 'Classical Electrodynamics (Jackson)', 7, 'Physics', ['sc4', 'sc19'],
          'The gauntlet: 60+ Jackson problems'),
      _n('sc12', 'General Relativity (Carroll)', 7, 'Physics', 'sc10',
          'Derive the Schwarzschild solution unaided'),
      _n('sc14', 'Quantum Field Theory (Peskin, Part I)', 8, 'Physics', ['sc10', 'sc13'],
          'Compute a tree-level cross-section start-to-finish'),
      // Chemistry spine.
      _n('sc3', 'General Chemistry (Zumdahl)', 2, 'Chemistry', 'sc24',
          'Full problem sets; home titration & equilibrium labs'),
      _n('sc5', 'Organic Chemistry I–II (Clayden)', 3, 'Chemistry', 'sc3',
          '500 mechanisms drawn from memory'),
      _n('sc23', 'Analytical Chemistry & Instrumentation (Skoog)', 3, 'Chemistry', 'sc3',
          'Spectroscopy & chromatography sets; interpret real spectra'),
      _n('sc22', 'ACS Chemistry Exams (Gen + Organic)', 4, 'Chemistry', 'sc5',
          'Practice exams ≥80%, timed'),
      _n('sc9', 'Biochemistry (Lehninger)', 5, 'Chemistry', 'sc5',
          'Glycolysis→ETC pathway maps drawn from memory'),
      _n('sc8', 'Physical Chemistry (Atkins)', 5, 'Chemistry', ['sc6', 'sc7', 'sc3'],
          'Thermo + QM applied to real spectra'),
      _n('sc11', 'Molecular Biology (Alberts)', 6, 'Chemistry', 'sc9',
          '3 journal-club style paper critiques'),
      // Mathematics & computation branches.
      _n('sc20', 'Computational Science: write a simulation', 5, 'Computation', 'sc7',
          'Working MD/Monte-Carlo sim + write-up of one physical result'),
      _n('sc26', 'Scientific Python & data analysis (NumPy/SciPy)', 5, 'Computation', 'sc19',
          'Reproduce the figures of one published paper from raw data'),
      // Exams (physics side).
      _n('sc21', 'GRE Physics Subject Test', 8, 'Exams', ['sc10', 'sc13'],
          'Released tests ≥900-equivalent, timed'),
      // Research crown chain — gathers every branch.
      _n('sc15', 'Thesis: original research monograph', 9, 'Research',
          ['sc8', 'sc11', 'sc14', 'sc20'], '50+ pages of original research'),
      _n('sc16', 'Defend it before domain experts', 10, 'Research', 'sc15',
          'Present to 2+ experts (forums/meetups); survive Q&A, revise'),
      _n('sc17', 'Publish in a peer-reviewed venue', 11, 'Research', 'sc16',
          'DOI exists — open-access journals accept independents'),
      _n('sc18', 'Crown: a result the field cites', 12, 'Crown', 'sc17',
          '≥1 independent citation'),
    ]),
    Skill('maths', 'Mathematics', '∑', 'Prove and Publish an Original Theorem', [
      _n('m1', 'Pre-Calculus & Trigonometry', 1, 'Foundations', null,
          'Timed exam, >90%'),
      _n('m2', 'Logic & Proofs (Velleman)', 2, 'Foundations', 'm1',
          '200 written proofs'),
      _n('m3', 'Calculus I–III (Stewart)', 2, 'Foundations', 'm1',
          'Full problem sets incl. vector calculus'),
      _n('m19', 'Problem Craft: 50 Putnam problems', 4, 'Foundations', ['m2', 'm3'],
          'Written solutions, self-graded vs official'),
      // Algebra branch.
      _n('m4', 'Linear Algebra (Axler)', 3, 'Algebra', ['m2', 'm3'],
          'Every theorem in ch. 1–7 proved unaided'),
      _n('m8', 'Abstract Algebra (Dummit & Foote I–III)', 5, 'Algebra', 'm4',
          'Groups/rings/fields exercise sets'),
      _n('m22', 'Number Theory (Ireland & Rosen)', 6, 'Algebra', 'm8',
          'Problem sets through quadratic reciprocity'),
      _n('m23', 'Galois Theory (Dummit & Foote, Part IV)', 7, 'Algebra', 'm8',
          'Prove insolvability of the quintic unaided'),
      // Analysis branch.
      _n('m7', 'Real Analysis (Rudin ch. 1–9)', 5, 'Analysis', ['m3', 'm4'],
          'All chapter exercises'),
      _n('m9', 'Complex Analysis (Ahlfors)', 6, 'Analysis', 'm7',
          'Contour-integral computations + proofs'),
      _n('m12', 'Measure & Integration (Folland)', 7, 'Analysis', ['m7', 'm10'],
          'Lebesgue theory exercises'),
      _n('m20', 'Functional Analysis (Kreyszig → Rudin)', 8, 'Analysis', 'm12',
          'Banach/Hilbert space exercises'),
      // Topology / geometry branch.
      _n('m10', 'Point-Set Topology (Munkres, Part I)', 6, 'Topology', 'm7',
          'All exercises ch. 1–4'),
      _n('m15', 'Differential Geometry (do Carmo / Lee)', 9, 'Topology', 'm10',
          'Curves→manifolds exercise sets'),
      _n('m24', 'Algebraic Topology (Hatcher)', 9, 'Topology', ['m10', 'm8'],
          'Homology & fundamental-group exercises'),
      // Probability / applied branch.
      _n('m5', 'Ordinary Differential Equations (Tenenbaum)', 3, 'Applied', 'm3',
          'Full problem sets'),
      _n('m6', 'Probability (Ross)', 4, 'Probability', 'm3', 'Full problem sets'),
      _n('m11', 'Mathematical Statistics (Casella & Berger)', 7, 'Probability', 'm6',
          'Full problem sets'),
      _n('m13', 'Partial Differential Equations (Evans, Part I)', 8, 'Applied',
          ['m5', 'm12'], 'Full problem sets'),
      _n('m14', 'Measure-Theoretic Probability (Durrett)', 8, 'Probability', ['m12', 'm6'],
          'Martingale + CLT chapters'),
      _n('m21', 'Stochastic Processes & SDEs (Øksendal)', 9, 'Probability', 'm14',
          'Itô calculus problem sets'),
      // Research crown chain.
      _n('m16', 'Qualifying Exams (3 real past quals)', 10, 'Research',
          ['m8', 'm9', 'm13', 'm20'], 'Timed, closed-book, >70%'),
      _n('m17', 'Dissertation-grade monograph', 11, 'Research', ['m15', 'm16', 'm21'],
          '60+ pages on one open corner, expert-reviewed'),
      _n('m18', 'Crown: original theorem, peer-reviewed', 12, 'Crown', 'm17',
          'DOI exists in a refereed journal'),
    ]),
    Skill('medicine', 'Medicine', '⚕', 'Chief Attending / Diagnostician', [
      _n('md1', 'Medical Terminology + BLS/CPR', 1, 'Basic Science', null,
          'Real BLS card — open to the public'),
      // Basic-science branch.
      _n('md2', 'Anatomy (Netter + Anki)', 2, 'Basic Science', 'md1',
          '2,000-card deck matured'),
      _n('md19', 'Histology & Cell Biology (Junqueira)', 3, 'Basic Science', 'md2',
          'Identify 50 slides; tissue-function essays'),
      _n('md3', 'Physiology (Guyton & Hall)', 3, 'Basic Science', 'md2',
          'System-by-system self-exams'),
      _n('md4', 'Medical Biochemistry (Lippincott)', 3, 'Basic Science', 'md1',
          'Pathway questions >80%'),
      _n('md5', 'Pathology (Robbins + Pathoma)', 4, 'Basic Science', ['md3', 'md4'],
          'Pathoma complete + Robbins MCQs'),
      _n('md6', 'Pharmacology (Katzung + Sketchy)', 4, 'Basic Science', 'md3',
          'Drug-class Anki deck matured'),
      _n('md7', 'Immunology & Micro (Sketchy + Janeway)', 4, 'Basic Science', 'md4',
          'Bug/drug chart from memory'),
      // Board-exam branch.
      _n('md8', 'First Aid for Step 1 (annotated)', 5, 'Boards', ['md5', 'md6', 'md7'],
          'Own annotated copy, 3 passes'),
      _n('md9', 'UWorld Step 1 complete', 6, 'Boards', 'md8', '≥70% cumulative'),
      _n('md10', 'NBME Free-120', 7, 'Boards', 'md9',
          '≥85% (Step 1 is pass/fail since 2022 — this is the bar)'),
      _n('md14', 'UWorld Step 2 CK complete', 9, 'Boards', ['md11', 'md12', 'md13'],
          '≥70% cumulative'),
      _n('md15', 'Step 2 CK mock ≥250', 10, 'Boards', 'md14',
          'NBME practice exam — Step 2 is still scored'),
      // Clinical-skills branch.
      _n('md11', 'Physical Examination (Bates)', 8, 'Clinical', 'md10',
          'OSCE-style checklist performed on a volunteer'),
      _n('md12', "Internal Medicine (Harrison's core)", 8, 'Clinical', 'md10',
          'Chapter self-exams'),
      // Diagnostics branch.
      _n('md13', 'ECG Interpretation (Dubin → Marriott)', 8, 'Diagnostics', 'md10',
          '100 ECGs read and checked'),
      _n('md20', 'Radiology basics (Felson + LearningRadiology)', 8, 'Diagnostics', 'md10',
          '100 films read with a systematic search pattern'),
      _n('md21', 'Laboratory medicine: interpret 50 panels', 9, 'Diagnostics', ['md13', 'md20'],
          'Build a differential from each panel, checked'),
      // Clinical-reasoning crown chain.
      _n('md16', '100 NEJM Clinical Problem-Solving cases', 11, 'Reasoning', ['md15', 'md21'],
          'Written differential before each solution; ≥60% correct'),
      _n('md17', 'MKSAP question bank (ABIM level)', 12, 'Reasoning', 'md16', '≥65%'),
      _n('md18', 'Crown: attending-level case accuracy', 13, 'Crown', 'md17',
          '30 consecutive unseen cases, blinded scoring'),
    ]),
    Skill('engineering', 'Engineering', '⚙',
        'Build Your Own Computer, OS & Distributed System', [
      _n('eg1', 'CS50 + Python', 1, 'Software', null,
          'Every problem set passing the autograder'),
      _n('eg2', 'C (K&R, every exercise)', 2, 'Software', 'eg1',
          'Exercises in a public repo'),
      _n('eg3', 'Engineering Mathematics (LinAlg + ODEs)', 2, 'Mathematics', 'eg1',
          'Problem sets'),
      // Hardware branch.
      _n('eg4', 'Digital Design & Comp. Arch. (Harris & Harris)', 3, 'Hardware', 'eg2',
          'HDL exercises'),
      _n('eg6', 'Circuit Analysis', 3, 'Hardware', 'eg3',
          'Breadboard measurements match theory'),
      _n('eg8', 'Signals & Systems (Oppenheim)', 4, 'Hardware', 'eg6',
          'Fourier problem sets + a working filter'),
      _n('eg9', 'Nand2Tetris I: CPU from NAND gates', 5, 'Hardware', 'eg4',
          'Working Hack computer in the simulator'),
      _n('eg13', 'Nand2Tetris II: compiler + OS', 7, 'Hardware', ['eg9', 'eg10'],
          'Tetris runs on your own stack'),
      // Software / theory branch.
      _n('eg5', 'Data Structures & Algorithms', 3, 'Software', 'eg2',
          'CLRS core + 150 LeetCode, timed log'),
      _n('eg19', 'Theory of Computation (Sipser)', 4, 'Theory', 'eg5',
          'Automata, reducibility, NP-completeness problem sets'),
      _n('eg20', 'Compilers (Crafting Interpreters → Dragon)', 6, 'Software', ['eg5', 'eg19'],
          'A working compiler for a small language, tests passing'),
      // Systems branch.
      _n('eg7', 'Computer Systems (CS:APP + labs)', 4, 'Systems', 'eg4',
          'Bomb lab + malloc lab complete'),
      _n('eg10', 'Operating Systems (OSTEP)', 5, 'Systems', ['eg5', 'eg7'],
          'All projects: shell, malloc, scheduler'),
      _n('eg14', 'Database Internals (CMU 15-445)', 7, 'Systems', 'eg10',
          'Buffer pool + B+tree + executor passing tests'),
      _n('eg22', 'Security: memory-safety exploits & defenses', 6, 'Systems', 'eg7',
          'Solve 20 binary-exploitation challenges; write mitigations'),
      // Networking / embedded / distributed branches.
      _n('eg11', 'Networking: sockets to HTTP server', 6, 'Networking', 'eg5',
          "Beej's guide + your server survives a load test"),
      _n('eg12', 'Embedded: bare-metal STM32', 6, 'Embedded', 'eg8',
          'Blink→UART→interrupt drivers from the datasheet'),
      _n('eg15', 'Write an RTOS in C on real hardware', 8, 'Embedded', ['eg12', 'eg13'],
          'Preemptive scheduler + mutexes demoed'),
      _n('eg21', 'Cloud & containers: a fault-tolerant service', 8, 'Distributed', 'eg11',
          'Orchestrated multi-container service + chaos test survived'),
      _n('eg16', 'Distributed Systems (DDIA + MIT 6.824)', 9, 'Distributed', ['eg11', 'eg14'],
          'Raft implementation passing the labs'),
      _n('eg17', 'Autonomous robot on ROS 2', 9, 'Robotics', 'eg15',
          'Navigates an unseen room'),
      _n('eg18', 'Crown: 3-node cluster of your kernel + KV store', 10, 'Crown',
          ['eg16', 'eg17'], 'Kill a node live — the system survives'),
    ]),
  ]),
  // ═══════════════════════════════════════════════════════════════════════
  // WISDOM
  // ═══════════════════════════════════════════════════════════════════════
  StatDomain('WIS', 'Wisdom', const Color(0xFFC084FC), [
    Skill('geography', 'Geography', '🌍', 'Global Geospatial Analyst & Forecaster', [
      _n('g1', 'Anki: 196 nations, capitals & flags', 1, 'World Knowledge', null,
          'Matured deck, 95%+ retention'),
      // World-knowledge branch.
      _n('g3', 'Blank-map mastery: 100 physical features', 2, 'World Knowledge', 'g1',
          'Rivers, ranges, straits, chokepoints placed from memory'),
      _n('g2', 'Physical Geography (Strahler)', 2, 'World Knowledge', 'g1',
          'Chapter self-exams: landforms, climate, biomes'),
      _n('g5', 'Human Geography (AP HuG)', 3, 'World Knowledge', 'g2',
          '≥4 on two released AP exams, timed'),
      _n('g6', 'iGeo past papers', 4, 'World Knowledge', ['g3', 'g5'],
          '2 full papers self-timed, ≥60%'),
      // Geopolitics branch.
      _n('g4', 'Prisoners + Revenge of Geography', 2, 'Geopolitics', 'g1',
          'One-page strategic brief per chapter'),
      _n('g8', 'Guns, Germs & Steel — with its critics', 3, 'Geopolitics', 'g4',
          '1,500-word assessment arguing both sides'),
      _n('g12', 'The Silk Roads + The Grand Chessboard', 4, 'Geopolitics', 'g8',
          'Comparative essay: geography as strategy'),
      _n('g13', 'Commodity chain: one resource end-to-end', 5, 'Geopolitics', ['g9', 'g12'],
          'Sourced map + 2,000-word report'),
      // Spatial-tech branch.
      _n('g7', 'QGIS Fundamentals', 3, 'Spatial Tech', 'g2',
          'Official training manual exercises; 3 finished maps'),
      _n('g9', 'Spatial SQL (PostGIS)', 4, 'Spatial Tech', 'g7',
          'Workshop queries + one analysis of your own'),
      _n('g17', 'Cartographic design & thematic maps', 5, 'Spatial Tech', 'g7',
          'Three publication-quality maps critiqued vs design principles'),
      _n('g10', 'Python Geospatial (GeoPandas)', 5, 'Spatial Tech', 'g9',
          'Reproduce 3 published maps from raw data'),
      _n('g11', 'Remote Sensing (Google Earth Engine)', 6, 'Spatial Tech', 'g10',
          'NDVI change-detection study of a region'),
      _n('g18', 'Climate & environmental data analysis', 6, 'Spatial Tech', 'g10',
          'Reproduce a climate trend from raw station/satellite data'),
      // Forecasting & synthesis crown.
      _n('g14', 'Forecasting: 25 scored predictions', 6, 'Forecasting', ['g6', 'g12'],
          'Good Judgment Open — beat the median Brier score'),
      _n('g15', 'Interactive global dashboard', 7, 'Synthesis', ['g11', 'g13'],
          'Public URL, 3 datasets you processed'),
      _n('g16', 'Crown: original spatial analysis, published', 8, 'Crown',
          ['g14', 'g15'], 'Write-up + data + code public, forecast record attached'),
    ]),
    Skill('history', 'History', '📜', 'Master Historian & Archival Synthesis', [
      _n('h1', 'Methods: From Reliable Sources', 1, 'Sources', null,
          'Source-critique exercise on 3 documents'),
      // Chronicle spine (the Durant heart).
      _n('h2', 'Durant I–III: Antiquity', 2, 'Chronicle', 'h1',
          'Era synthesis essay per volume'),
      _n('h6', 'SPQR (Beard)', 3, 'Chronicle', 'h2',
          "2,000-word review against Durant's Rome"),
      _n('h3', 'Durant IV–VI: Middle Ages', 3, 'Chronicle', 'h2',
          'Era synthesis essays'),
      _n('h4', 'Durant VII–XI: Modern Era', 4, 'Chronicle', 'h3',
          'Era synthesis essays'),
      // Sources branch.
      _n('h11', 'Primary sources I: analyse 10', 3, 'Sources', 'h1',
          'Avalon Project etc. — provenance-first analyses'),
      _n('h17', 'DBQ craft: 5 document-based essays', 5, 'Sources', ['h11', 'h16'],
          'Self-graded vs College Board rubrics, ≥5/7'),
      _n('h14', 'Archival project: a real digitised archive', 8, 'Sources', 'h13',
          '10 primary finds transcribed + contextualised'),
      // World / thematic branches.
      _n('h5', 'Big picture: Sapiens + Why the West Rules', 2, 'Thematic', 'h1',
          'Critical brief: where they disagree and why'),
      _n('h16', 'AP World History', 3, 'World', ['h5', 'h2'],
          '≥4 on two released exams, timed'),
      _n('h18', 'World history beyond the West', 4, 'World', 'h16',
          'Comparative essay decentering the Western narrative, 6+ sources'),
      _n('h19', 'Intellectual history: a history of ideas', 6, 'Thematic', 'h4',
          'Trace one idea across 3 eras, sourced'),
      // Military & economic branches.
      _n('h7', 'The Sleepwalkers (WWI origins)', 5, 'Military', 'h4',
          'Essay comparing 3 schools on war guilt'),
      _n('h8', 'The Second World War (Keegan)', 5, 'Military', 'h4',
          'Campaign analysis of one theatre'),
      _n('h9', 'Cold War (Gaddis)', 6, 'Military', 'h8',
          'Periodisation essay: when did it begin and end?'),
      _n('h10', 'Economic history (Clark + VSI)', 6, 'Economic', 'h4',
          'Brief: why the Industrial Revolution, why England'),
      // Synthesis crown.
      _n('h12', 'Lessons of History + write your own', 7, 'Synthesis', ['h7', 'h9', 'h10'],
          'Your own 12 lessons, each sourced'),
      _n('h13', '5,000-word era synthesis', 7, 'Synthesis', ['h17', 'h18'],
          'Your chosen era, 15+ sources, footnoted'),
      _n('h15', 'Crown: 10,000-word sourced monograph', 9, 'Crown', ['h12', 'h14', 'h19'],
          'Published online; critique from 2 knowledgeable readers'),
    ]),
    Skill('business', 'Business', '📊', 'Run Money Like an Institution', [
      // Three roots: personal capital, economics, macro.
      _n('b1', 'Personal finance: write your own IPS', 1, 'Investing', null,
          'Investment Policy Statement + automated savings, 3 months'),
      _n('b2', 'Microeconomics (Mankiw)', 1, 'Economics', null, 'Full problem sets'),
      _n('b3', 'Macroeconomics + indicator watch', 1, 'Economics', null,
          'Track CPI/rates/PMI monthly for 3 months, journaled'),
      // Accounting branch.
      _n('b4', 'Financial Accounting', 2, 'Accounting', 'b1',
          'Build 3 statements for a mock firm; parse a real 10-K'),
      _n('b7', 'Managerial Accounting', 3, 'Accounting', 'b4',
          'Costing exercise on a real product teardown'),
      // Strategy branch.
      _n('b5', 'Strategy (Porter)', 2, 'Strategy', 'b2',
          'Five-forces analysis of a real industry'),
      _n('b10', 'Operations (The Goal)', 3, 'Strategy', 'b5',
          'Map and improve a process you can observe'),
      // Quant / markets branch.
      _n('b20', 'Statistics & data for finance', 2, 'Markets', 'b3',
          'Regression + time-series exercises on real price data'),
      _n('b8', 'CFA Level 1', 4, 'Markets', ['b6', 'b7'],
          'Full-length timed mock ≥70%'),
      _n('b21', 'Fixed income & macro markets', 5, 'Markets', ['b8', 'b20'],
          'Price bonds, build a yield curve, run a rate-scenario P&L'),
      _n('b19', 'CFA Level 2', 6, 'Markets', 'b11', 'Full-length timed mock ≥65%'),
      _n('b15', 'CFA Level 3', 7, 'Markets', 'b19', 'Full-length timed mock ≥65%'),
      _n('b14', '25 10-Ks: one-page memos', 7, 'Markets', 'b13',
          'Memo book; 5 red flags found and explained'),
      // Corporate-finance / valuation branch.
      _n('b6', 'Corporate Finance (Brealey & Myers)', 3, 'Corporate Finance', ['b4', 'b3'],
          'Problem sets + WACC for a real company'),
      _n('b12', '3-statement model from scratch', 4, 'Corporate Finance', 'b6',
          'Keyboard-only build of a real company'),
      _n('b11', "Valuation (Damodaran's NYU course)", 5, 'Corporate Finance', ['b8', 'b12'],
          'All problem sets; 2 full valuations'),
      _n('b13', 'DCF + LBO models on 2 real companies', 6, 'Corporate Finance', 'b11',
          'Assumptions documented and defended'),
      // Investing crown chain.
      _n('b16', '12-month paper portfolio vs benchmark', 8, 'Investing', ['b14', 'b15', 'b21'],
          'IPS-governed, quarterly letters, every trade journaled'),
      _n('b17', '3 published equity research reports', 9, 'Investing', 'b16',
          'Public + 6-month retrospectives on each call'),
      _n('b18', 'Crown: multi-year documented track record', 10, 'Crown', 'b17',
          '24+ months benchmark-relative with honest attribution'),
    ]),
    Skill('socialSci', 'Social Sci', '🧠', 'Run a Real Behavioral Study', [
      _n('ss1', 'Intro Psychology (OpenStax + AP)', 1, 'Foundations', null,
          '≥4 on a released AP Psychology exam'),
      // Methods branch.
      _n('ss2', 'Research Methods & Statistics I', 2, 'Methods', 'ss1',
          'Design critique of 5 published studies'),
      _n('ss17', 'Statistics in practice: R or JASP', 3, 'Methods', 'ss2',
          'Reproduce the stats of 3 open-data papers (OSF)'),
      _n('ss18', 'Psychometrics & measurement', 3, 'Methods', 'ss2',
          'Build & validate a scale (reliability, factor analysis) on real data'),
      // Core-fields branch.
      _n('ss3', 'Biological Psych & Neuroscience', 2, 'Fields', 'ss1',
          'Brain-region deck matured + essay'),
      _n('ss5', 'Social Psychology — replication-aware', 3, 'Fields', 'ss1',
          '10 classic findings annotated: survived or died?'),
      _n('ss4', 'Cognitive Psychology', 4, 'Fields', 'ss3',
          'Self-exams + one experiment replication write-up'),
      _n('ss6', 'Developmental Psych', 4, 'Fields', 'ss3', 'Stage-theory comparison essay'),
      _n('ss7', 'Abnormal Psych (DSM-5-TR)', 5, 'Fields', ['ss4', 'ss6'],
          '10 case vignettes correctly formulated'),
      _n('ss11', 'Behave (Sapolsky)', 6, 'Fields', ['ss3', 'ss9'],
          'Multi-level analysis of one behaviour'),
      // Applied / philosophy branch.
      _n('ss8', 'Thinking, Fast & Slow — with corrections', 4, 'Applied', 'ss5',
          'Brief: which chapters survived replication'),
      _n('ss9', 'Influence (Cialdini) + field notes', 5, 'Applied', 'ss8',
          '20 observed persuasion instances catalogued'),
      _n('ss10', "Moral Philosophy (Sandel's Justice)", 5, 'Applied', 'ss5',
          'All lectures + 3 position essays'),
      _n('ss12', 'Applied Stoicism', 6, 'Applied', 'ss10', '30-day practice journal'),
      // Research crown chain.
      _n('ss13', 'Design + preregister a study', 7, 'Research', ['ss2', 'ss11', 'ss18'],
          'Preregistration live on OSF'),
      _n('ss14', 'Run it: collect real data', 8, 'Research', ['ss13', 'ss17'],
          'Online sample; data + analysis code public'),
      _n('ss15', 'Write it up preprint-style', 9, 'Research', 'ss14',
          'PsyArXiv-format manuscript'),
      _n('ss16', 'Crown: publish the preprint', 10, 'Crown', ['ss15', 'ss12'],
          'Posted publicly; critique from 2 researchers incorporated'),
    ]),
  ]),
  // ═══════════════════════════════════════════════════════════════════════
  // CHARISMA
  // ═══════════════════════════════════════════════════════════════════════
  StatDomain('CHA', 'Charisma', const Color(0xFFFB923C), [
    Skill('english', 'English', '🔤', 'Command the Room and the Page', [
      // Three roots: the pen, the lexicon, the roots of words.
      _n('e1', 'Elements of Style + Williams', 1, 'Writing', null,
          'Rewrite 10 bad paragraphs; before/after'),
      _n('e2', 'Vocabulary I: 500 GRE words', 1, 'Language', null,
          'Matured Anki deck, used in writing'),
      _n('e3', 'Etymology: 300 Latin & Greek roots', 1, 'Language', null,
          'Decompose 100 unfamiliar words correctly'),
      // Language branch.
      _n('e4', 'Vocabulary II: to 2,000 words + idioms', 2, 'Language', 'e2',
          'Matured deck; GRE verbal practice sets'),
      _n('e16', 'GRE Verbal', 3, 'Language', 'e4', 'ETS POWERPREP timed, ≥163'),
      // Rhetoric branch.
      _n('e5', 'Logical Fallacies & Argument', 2, 'Rhetoric', 'e1',
          '30 fallacies catalogued from real media'),
      _n('e6', 'Classical Rhetoric (Farnsworth)', 3, 'Rhetoric', ['e1', 'e3'],
          'Device notebook: 40 devices, own examples'),
      // Writing branch.
      _n('e8', 'Sense of Style (Pinker)', 4, 'Writing', 'e6',
          'Essay applying the classic-style lens'),
      _n('e17', 'Storytelling & narrative nonfiction', 5, 'Writing', 'e8',
          'Three published personal essays using scene, tension, arc'),
      _n('e10', '10 persuasive long-form essays', 5, 'Writing', ['e8', 'e5'],
          'Published; 2 revised after critique'),
      // Speaking branch.
      _n('e9', 'Speech study: 25 great speeches', 4, 'Speaking', 'e6',
          'Rhetorical breakdowns: structure, devices, delivery'),
      _n('e11', '10 recorded speeches', 5, 'Speaking', 'e9',
          'Self-scored vs Toastmasters rubrics, visible arc'),
      _n('e13', 'Impromptu: 30 table-topics drills', 6, 'Speaking', 'e11',
          'Recorded 2-min impromptus, no dead air'),
      _n('e14', '20-min keynote from memory', 7, 'Speaking', ['e10', 'e13'],
          'One continuous take, audience of 5+'),
      // Analysis branch.
      _n('e12', 'Cognitive Linguistics (Lakoff)', 6, 'Analysis', 'e8',
          'Metaphor audit of your own writing'),
      _n('e15', 'Crown: an essay that travels', 8, 'Crown', ['e14', 'e12', 'e17'],
          '1,000+ genuine readers, or printed in a venue you respect'),
    ]),
    Skill('turkish', 'Turkish', '🇹🇷', 'C1+ and Real-Time Interpretation', [
      _n('tr1', 'Phonology, vowel harmony, agglutination', 1, 'Foundations', null,
          'Transcribe/pronounce 50 words; suffix-chain drills'),
      _n('tr2', 'A1: 500 words + present tense', 2, 'Vocabulary', 'tr1',
          'Matured deck; 10 self-recorded dialogues'),
      // Grammar spine.
      _n('tr3', 'A2: 1,500 words; past/future; cases begin', 3, 'Grammar', 'tr2',
          'Timed A2 mock (TÖMER-format) ≥70%'),
      _n('tr4', 'B1: 3,000 words; full case system', 4, 'Grammar', 'tr3',
          'Timed B1 mock; first 5 conversation hours'),
      _n('tr5', 'B2 grammar: chains, conditionals, evidentiality', 5, 'Grammar', 'tr4',
          '20 corrected essays (LangCorrect)'),
      _n('tr6', 'Relative clauses & nominalisation', 6, 'Grammar', 'tr5',
          'Translate 30 complex sentences both ways'),
      // Input branch.
      _n('tr15', 'Listening A2: 20 hrs graded input', 3, 'Input', 'tr2',
          'Log + comprehension notes on 20 hrs of graded audio'),
      _n('tr9', 'Input: 60 hrs Turkish media, no subs', 5, 'Input', ['tr4', 'tr15'],
          'Log + weekly summaries written in Turkish'),
      // Speaking branch.
      _n('tr7', 'Conversation: 30 logged hours', 4, 'Speaking', 'tr3',
          'Session log; self-rated CEFR descriptors'),
      _n('tr11', 'Conversation: 100 total hours', 6, 'Speaking', 'tr7',
          '15-min recorded discussion, native-checked'),
      // Reading & writing branches.
      _n('tr16', 'Writing A2→B1: 15 corrected texts', 5, 'Writing', 'tr4',
          '15 texts corrected (LangCorrect), error log shrinking'),
      _n('tr10', 'C1 reading: a full Pamuk novel', 7, 'Reading', 'tr5',
          'Reading journal; 500-word review in Turkish'),
      _n('tr12', 'C1 writing: 10 essays, corrected', 8, 'Writing', ['tr10', 'tr16'],
          'Corrected drafts archived'),
      // Exam gates & crown.
      _n('tr8', 'B2 exam', 7, 'Exams', ['tr6', 'tr9'],
          'Full TYS-format mock, timed, ≥B2 band'),
      _n('tr13', 'C1/C2 exam', 9, 'Exams', ['tr11', 'tr12', 'tr8'],
          'Full TYS mock ≥C1 (sit the real TYS if reachable)'),
      _n('tr14', 'Crown: consecutive interpretation', 10, 'Crown', 'tr13',
          'Interpret a 10-min talk EN→TR, recorded, native-verified'),
    ]),
    Skill('japanese', 'Japanese', '🇯🇵', 'N1 + the Spoken Skill JLPT Never Tests', [
      _n('j1', 'Kana + phonetics (pitch-accent aware)', 1, 'Foundations', null,
          'Read kana at 60+ chars/min; minimal-pair quiz'),
      // Grammar spine.
      _n('j2', 'Genki I', 2, 'Grammar', 'j1', 'All workbook exercises; N5 mock ≥70%'),
      _n('j4', 'Genki II', 3, 'Grammar', 'j2', 'Workbook + N4 mock ≥70%'),
      _n('j7', 'Tobira', 5, 'Grammar', 'j6', 'All exercises; grammar log'),
      _n('j13', 'Shin Kanzen Master N2 (all 5)', 8, 'Grammar', 'j10', 'Every exercise'),
      // Kanji branch.
      _n('j3', 'Kanji I: 500', 2, 'Kanji', 'j1', 'SRS matured'),
      _n('j5', 'Kanji II: 1,000', 3, 'Kanji', 'j3', 'SRS matured'),
      _n('j8', 'Kanji III: all 2,136 jōyō', 5, 'Kanji', 'j5',
          'SRS matured; read a news article aloud'),
      // Vocabulary branch.
      _n('j6', 'Core 2k vocabulary', 4, 'Vocabulary', ['j4', 'j5'],
          'Matured deck; 20 graded-reader stories'),
      _n('j11', 'Core 6k vocabulary', 7, 'Vocabulary', 'j6', 'Matured deck'),
      // Input branch.
      _n('j9', 'Input I: 100 hrs native audio', 5, 'Input', 'j6',
          'Log + weekly summaries in Japanese'),
      _n('j12', '15 manga volumes + 1 light novel', 7, 'Input', 'j10',
          'Reading log with lookups declining'),
      // Output branch.
      _n('j19', 'Output I: 30 hrs writing + corrections', 6, 'Output', 'j7',
          '30 corrected Japanese texts; error categories tracked'),
      _n('j16', 'Speaking: 50 hours + shadowing', 10, 'Output', ['j14', 'j9', 'j19'],
          '10-min recorded conversation, native-rated B2'),
      _n('j15', 'Keigo (business honorifics)', 10, 'Output', 'j14',
          '10 role-play situations, native-checked'),
      // Exam gates & crown.
      _n('j10', 'JLPT N3', 6, 'Exams', ['j7', 'j8'],
          'Full timed mock ≥ pass line +10%'),
      _n('j14', 'JLPT N2', 9, 'Exams', ['j11', 'j12', 'j13'],
          'Official sitting if reachable, else 2 timed mocks ≥ pass +10%'),
      _n('j17', 'JLPT N1', 11, 'Exams', 'j16',
          'Official sitting if reachable, else 2 timed mocks ≥ pass +10%'),
      _n('j18', 'Crown: literature + your own voice', 12, 'Crown', ['j15', 'j17'],
          'A full literary novel finished; 30-min unscripted native conversation'),
    ]),
    Skill('khmer', 'Khmer', '🇰🇭', 'Fluency Where No Textbook Ecosystem Exists', [
      _n('kh1', 'Script I: consonants (two series) + vowels', 1, 'Script', null,
          'Read any letter; write the alphabet from memory'),
      _n('kh2', 'Script II: subscripts; length & aspiration', 2, 'Script', 'kh1',
          'Read 100 real words aloud, native-checked (Khmer has no tones)'),
      // Grammar spine.
      _n('kh3', 'A1: SVO syntax, 300 words (Aakanee)', 3, 'Grammar', 'kh2',
          'Describe 20 Aakanee scenes from memory'),
      _n('kh4', 'A2: classifiers, aspect markers, 800 words', 4, 'Grammar', 'kh3',
          '10 self-recorded dialogues'),
      _n('kh8', 'B2 grammar: serial verbs, complex sentences', 7, 'Grammar', 'kh5',
          'Translate 30 sentences both ways, checked'),
      // Vocabulary & literacy branches.
      _n('kh5', 'B1: 1,500 core words', 5, 'Vocabulary', 'kh4',
          'Matured deck; 15-min conversation attempt logged'),
      _n('kh6', 'Street literacy: signs, menus, prices', 3, 'Literacy', 'kh2',
          'Read 50 photographed real-world signs'),
      _n('kh9', 'Read native news (VOA Khmer)', 8, 'Literacy', ['kh6', 'kh8'],
          '20 articles summarised in Khmer'),
      // Input, speaking, writing branches.
      _n('kh15', 'Listening A2: 20 hrs graded audio', 5, 'Input', 'kh4',
          'Log + Khmer summaries of 20 hrs of graded audio'),
      _n('kh11', 'Input: 100 hrs media/news', 9, 'Input', ['kh9', 'kh15'],
          'Log + summaries'),
      _n('kh7', 'Conversation: 25 logged hours', 6, 'Speaking', 'kh5',
          "Session log + tutor's written assessment"),
      _n('kh12', 'Conversation: 100 total hours', 10, 'Speaking', 'kh7',
          'ILR self-assessment + native-rated interview (S-2+)'),
      _n('kh16', 'Writing: 15 corrected Khmer texts', 8, 'Writing', 'kh8',
          '15 texts hand-typed in Khmer script, native-corrected'),
      // Registers & culture branch.
      _n('kh10', 'Registers: formal, clergy & royal', 9, 'Registers', 'kh8',
          'Register-switch drill on 30 sentences'),
      _n('kh13', 'Traditional literature (Reamker excerpts)', 11, 'Registers', 'kh10',
          'Reading journal with cultural notes'),
      _n('kh14', 'Crown: interpretation + literacy', 12, 'Crown',
          ['kh11', 'kh12', 'kh13', 'kh16'],
          'Interpret a 10-min talk KM→EN, recorded, native-verified'),
    ]),
    Skill('musicTheory', 'Music Theory', '🎼', 'Compose and Hear It Performed', [
      _n('mt1', 'Notation: pitch, rhythm, clefs, metre', 1, 'Fundamentals', null,
          'ABRSM Grade 1–2 past papers ≥90%'),
      _n('mt2', 'Scales, keys & the circle of fifths', 2, 'Fundamentals', 'mt1',
          'Any key signature/scale on demand'),
      _n('mt16', 'Rhythm & metre mastery', 3, 'Fundamentals', 'mt1',
          'Sight-clap complex rhythms; conduct irregular metres'),
      _n('mt5', 'ABRSM Grade 5 Theory', 5, 'Fundamentals', ['mt4', 'mt16'],
          'Two past papers ≥ merit, timed'),
      _n('mt10', 'ABRSM Grade 8 Theory', 8, 'Fundamentals', 'mt8',
          'Two past papers ≥ merit, timed'),
      // Ear-training branch.
      _n('mt3', 'Intervals & ear training I', 3, 'Ear', 'mt2',
          'Interval dictation ≥90% (functional ear trainer)'),
      _n('mt15', 'Ear training II: dictation', 7, 'Ear', 'mt5',
          'Transcribe 20 short passages by ear'),
      // Harmony branch.
      _n('mt4', 'Triads, inversions & cadences', 4, 'Harmony', 'mt3',
          'Four-part cadence exercises'),
      _n('mt7', 'Sevenths, figured bass & Roman numerals', 6, 'Harmony', 'mt5',
          'Analyse 10 Bach chorales'),
      _n('mt8', 'Four-part harmony (chorale writing)', 7, 'Harmony', 'mt7',
          'Harmonise 20 melodies; check vs Bach'),
      _n('mt9', 'Species Counterpoint (Fux)', 8, 'Harmony', 'mt8',
          'All five species, two then three voices'),
      _n('mt17', 'Twentieth-century harmony (modes, jazz, atonality)', 9, 'Harmony', 'mt8',
          'Analyse & pastiche a jazz standard and a modal piece'),
      // Analysis branch.
      _n('mt11', 'Form & analysis: sonata and fugue', 9, 'Analysis', 'mt10',
          'Full analyses of 6 scores (2 fugues)'),
      // Composition crown chain.
      _n('mt12', 'Orchestration (Adler) + MuseScore', 10, 'Composition', 'mt11',
          'Orchestrate a piano piece for 12+ instruments'),
      _n('mt13', 'Portfolio I: song + quartet movement', 11, 'Composition', ['mt9', 'mt11', 'mt15'],
          'Scores + rendered audio, published'),
      _n('mt14', 'Crown: a 10-minute multi-movement work', 12, 'Crown',
          ['mt12', 'mt13', 'mt17'],
          'Full score + performance or convincing render, released'),
    ]),
    Skill('piano', 'Piano', '🎹', 'The One-Hour Memorised Recital', [
      _n('p1', 'Setup: posture, hand shape, first pieces', 1, 'Technique', null,
          'Video self-check vs reference; 5 beginner pieces'),
      // Technique branch.
      _n('p3', 'Major scales & arpeggios (2 octaves)', 2, 'Technique', 'p1',
          'Metronome video, all 12 keys, hands together'),
      _n('p4', 'Minor scales & arpeggios', 3, 'Technique', 'p3', 'Metronome video'),
      _n('p5', 'Technique I: Hanon 1–20 / Czerny 599', 3, 'Technique', 'p3',
          'Clean at marked tempi, video'),
      _n('p8', 'Pedalling: legato, syncopated, una corda', 6, 'Technique', 'p5',
          'Before/after recordings of 3 pieces'),
      _n('p9', 'Technique II: Czerny School of Velocity', 6, 'Technique', 'p5',
          'Four studies at tempo, video'),
      _n('p12', 'Polyrhythm & independence studies', 12, 'Technique', 'p9',
          '3:2 and 4:3 études at tempo'),
      // Reading branch.
      _n('p2', 'Reading I: grand staff fluency', 2, 'Reading', 'p1',
          'Sight-read Grade 1 pieces at tempo'),
      _n('p13', 'Reading II: daily sight-reading to Grade 6', 8, 'Reading', 'p2',
          '8-week log; unseen piece test'),
      // Musicianship branch.
      _n('p7', 'Harmonisation & lead sheets', 5, 'Musicianship', 'p2',
          'Play 10 songs from chords alone'),
      _n('p20', 'Improvisation & accompaniment', 8, 'Musicianship', 'p7',
          'Improvise over a blues/jazz progression; accompany a singer live'),
      // Repertoire branch.
      _n('p6', 'Bach: three Two-Part Inventions', 5, 'Repertoire', 'p18',
          'One continuous video take each'),
      _n('p10', 'Classical: full Mozart/Haydn sonata', 8, 'Repertoire', 'p19',
          'One-take video, memorised'),
      _n('p11', 'Romantic: Chopin nocturne + waltz', 9, 'Repertoire', ['p10', 'p9'],
          'One-take videos'),
      _n('p15', 'Impressionist: Debussy/Ravel work', 11, 'Repertoire', 'p14',
          'One-take video'),
      // Performance / exam gates.
      _n('p18', 'ABRSM Grade 3 Performance', 4, 'Performance', ['p2', 'p4'],
          'Video submission (real cert) or mock to its criteria'),
      _n('p19', 'ABRSM Grade 5 Performance', 7, 'Performance', ['p6', 'p8'],
          'Video submission or mock'),
      _n('p14', 'ABRSM Grade 8 Performance', 10, 'Performance', ['p11', 'p13'],
          'Video submission (real cert) or mock to its criteria'),
      _n('p16', 'Crown: 60-minute memorised recital', 13, 'Crown', ['p15', 'p12', 'p7', 'p20'],
          'Single continuous recording, 4+ eras, published'),
    ]),
    Skill('singing', 'Singing', '🎤', 'Release an EP and Sing It Live', [
      _n('v1', 'Breath: diaphragmatic support', 1, 'Technique', null,
          '20-sec sustained tone, steady dB, video'),
      // Ear branch.
      _n('v2', 'Pitch matching & ear', 2, 'Ear', 'v1',
          '≤10-cent average error across 2 octaves (pitch app)'),
      _n('v17', 'Rhythm & timing (singing in the pocket)', 4, 'Ear', 'v2',
          'Sing to a click across styles; syncopation drills recorded'),
      // Technique branch.
      _n('v3', 'Chest voice development', 3, 'Technique', 'v2',
          'Recorded scale ladder, no strain, vs rubric'),
      _n('v4', 'Head voice & falsetto', 3, 'Technique', 'v2',
          'Recorded sirens through the break'),
      _n('v5', 'Diction & vowel modification', 4, 'Technique', 'v3',
          'Same phrase in 5 vowels, spectrogram compare'),
      _n('v6', 'Mix voice through the passaggio', 5, 'Technique', ['v3', 'v4'],
          'Recorded bridging, no flip, month-apart comparisons'),
      _n('v7', 'Vibrato', 6, 'Technique', 'v6',
          'Straight tone → 5–7 Hz vibrato on demand'),
      _n('v8', 'Agility & runs', 7, 'Technique', 'v6',
          'Pentatonic run drills at 120 bpm, clean'),
      _n('v9', 'Dynamics (messa di voce)', 8, 'Technique', 'v7',
          'Crescendo–decrescendo on one breath, recorded'),
      // Repertoire branch.
      _n('v16', 'Repertoire I: 10 songs performed clean', 6, 'Repertoire', ['v5', 'v6'],
          'Full-take recordings + honest self-review'),
      _n('v10', 'Style versatility: 3 genres × 3 songs', 9, 'Repertoire', ['v16', 'v8', 'v17'],
          'Recordings judged against genre references'),
      // Production branch.
      _n('v11', 'Home recording craft', 10, 'Production', 'v9',
          'One polished vocal track (Reaper/Audacity)'),
      _n('v18', 'Songwriting & arrangement', 11, 'Production', 'v10',
          'Write & arrange 5 songs; lead sheets + demos'),
      _n('v14', 'Produce an EP: 5 tracks', 12, 'Production', ['v11', 'v18'],
          'Released on streaming platforms'),
      // Performance crown.
      _n('v13', 'Perform live: 5 open-mic sets', 11, 'Performance', 'v10',
          'Filmed performances'),
      _n('v15', 'Crown: live set of your EP', 13, 'Crown', ['v13', 'v14'],
          '20+ min filmed live; critique from 2 musicians'),
    ]),
  ]),
  // ═══════════════════════════════════════════════════════════════════════
  // DEXTERITY
  // ═══════════════════════════════════════════════════════════════════════
  StatDomain('DEX', 'Dexterity', const Color(0xFF4ADE80), [
    Skill('drawing', 'Drawing', '✏️', 'A Body of Work Worth Exhibiting', [
      _n('d1', 'Drawabox: lines, ghosting, 250 boxes', 1, 'Fundamentals', null,
          'Completed homework, posted for critique'),
      // Fundamentals branch.
      _n('d2', 'Shape, proportion & measuring', 2, 'Fundamentals', 'd1',
          '20 still-life studies with measured comparisons'),
      _n('d3', 'Form: boxes, cylinders, ellipses in space', 3, 'Fundamentals', 'd2',
          'Drawabox lessons 2–3 homework'),
      _n('d4', 'Perspective I: 1 & 2 point', 4, 'Fundamentals', 'd3',
          'A real interior drawn twice, plotted'),
      _n('d7', 'Perspective II: 3-point + foreshortening', 6, 'Fundamentals', 'd4',
          'Worm/bird-eye city scene, plotted'),
      // Value & colour branch.
      _n('d5', 'Value: light logic + 10-step scales', 4, 'Value', 'd3',
          'Sphere/cube/cylinder under 3 light setups'),
      _n('d17', 'Bargue plates: 10 copies', 5, 'Value', 'd5',
          'Side-by-side comparisons, flaws annotated'),
      _n('d9', 'Color theory (Gurney)', 7, 'Value', 'd5',
          '12 limited-palette studies'),
      _n('d18', 'Digital painting workflow (Krita/Photoshop)', 7, 'Rendering', 'd5',
          '10 digital studies; value-first workflow, custom brushes'),
      // Figure & anatomy branch.
      _n('d6', 'Gesture: 500 timed figure poses', 5, 'Figure', 'd3',
          'Dated sketchbook pages, 30s–2min poses'),
      _n('d8', 'Anatomy I: skeleton (Proko)', 6, 'Figure', 'd6',
          'Skeleton from imagination, 3 angles'),
      _n('d10', 'Anatomy II: muscles', 8, 'Figure', 'd8',
          'Écorché studies over 10 gesture drawings'),
      _n('d11', 'Anatomy III: hands, feet, portrait', 9, 'Figure', 'd10',
          '100 hands, 50 feet, 20 portraits'),
      // Rendering & composition crown chain.
      _n('d12', 'Material rendering', 10, 'Rendering', ['d9', 'd7'],
          'Metal, glass, cloth, skin — one still life each'),
      _n('d13', 'Composition & storytelling', 11, 'Composition', ['d12', 'd18'],
          '10 thumbnails/day for 30 days; 3 narrative pieces'),
      _n('d14', 'Portfolio: 20 finished works', 12, 'Composition', ['d11', 'd13'],
          'Curated, unified voice + artist statement'),
      _n('d16', 'Crown: exhibit', 13, 'Crown', 'd14',
          'A real show (café/library/gallery/online curated), documented reach'),
    ]),
    Skill('writing', 'Writing', '🖊', 'A Published Novel', [
      _n('w1', 'Grammar & mechanics cold', 1, 'Craft', null,
          'Error-free 1,000-word sample; style-guide quiz'),
      // Craft branch.
      _n('w2', 'Read like a writer: 30 classics', 2, 'Craft', 'w1',
          'Reading journal: one craft lesson per book'),
      _n('w17', 'Voice & style: pastiche 10 authors', 3, 'Craft', 'w2',
          'Ten passages imitating distinct authorial voices, annotated'),
      _n('w18', 'Scene craft: dialogue, tension, POV', 5, 'Craft', ['w4', 'w17'],
          'Five scenes drilling dialogue, subtext, POV discipline'),
      _n('w6', 'On Writing (King) + Bird by Bird', 6, 'Craft', 'w5',
          'Revision philosophy memo'),
      _n('w9', 'Prose craft (Zinsser + line edits)', 9, 'Craft', 'w8',
          '3 chapters before/after'),
      // Structure branch.
      _n('w4', 'Story structure (McKee + Save the Cat)', 4, 'Structure', 'w3',
          'Beat-sheet 5 favourite novels/films'),
      // Output branch.
      _n('w3', '12 short stories (one a month)', 3, 'Output', 'w2',
          'Finished drafts — quantity before quality'),
      _n('w5', 'NaNoWriMo: 50,000-word draft', 5, 'Output', 'w4',
          "Winner's word-count export"),
      _n('w7', 'The novel: 90,000-word complete draft', 7, 'Output', ['w6', 'w18'],
          'Full manuscript, beginning–middle–end'),
      // Community & revision branch.
      _n('w16', 'Critique circle membership', 4, 'Community', 'w3',
          '20 critiques given, 5 received (Scribophile/Critters)'),
      _n('w8', 'Developmental revision (macro edit)', 8, 'Revision', ['w7', 'w16'],
          'Revision map: what changed and why'),
      _n('w11', 'Beta cycle: 5 readers', 10, 'Revision', 'w9',
          'Feedback grid + acted-on list'),
      // Publishing crown chain.
      _n('w10', 'Submission craft: query + synopsis', 11, 'Publishing', 'w11',
          'Package critiqued in a query workshop'),
      _n('w12', 'Enter the arena: 20 submissions', 12, 'Publishing', 'w10',
          'Log — 3 personal responses OR 1 acceptance'),
      _n('w14', 'Crown: publish', 13, 'Crown', 'w12',
          'Traditional deal OR professional self-release, 50+ verified readers'),
    ]),
    Skill('cooking', 'Cooking', '🍳', 'Chef of Your Own Table', [
      _n('c1', 'Food safety', 1, 'Fundamentals', null,
          'ServSafe Food Handler — real cert, online'),
      // Fundamentals branch.
      _n('c2', 'Knife skills', 2, 'Fundamentals', 'c1',
          'Uniformity test videos: julienne, brunoise, chiffonade'),
      _n('c3', 'Eggs & heat control', 3, 'Fundamentals', 'c2',
          '8 egg preparations photographed at standard'),
      _n('c4', 'Salt Fat Acid Heat (framework cooking)', 4, 'Fundamentals', 'c3',
          '12 dishes tagged by which lever fixed them'),
      _n('c17', 'Palate training & seasoning discipline', 5, 'Fundamentals', 'c4',
          'Blind-taste and correct 15 dishes for salt/acid/fat balance'),
      // Stocks & sauces branch.
      _n('c5', 'Stocks: white, brown, vegetable', 3, 'Stocks & Sauces', 'c2',
          'Gel-set photos + reduction tasting notes'),
      _n('c6', 'The five mother sauces + derivatives', 5, 'Stocks & Sauces', ['c4', 'c5'],
          'All five + 2 derivatives each, documented'),
      _n('c10', 'Emulsions & dressings', 6, 'Stocks & Sauces', 'c6',
          'Mayo, hollandaise, 5 vinaigrettes from memory'),
      // Baking branch.
      _n('c7', 'Baking ratios (Ruhlman) + bread', 5, 'Baking', 'c4',
          'Baguette, loaf, pizza — crumb shots'),
      _n('c18', 'Pastry & dessert fundamentals', 7, 'Baking', 'c7',
          'Custards, laminated dough, one plated dessert to standard'),
      // Proteins & vegetables branch.
      _n('c8', 'Vegetables: roast, braise, blanch, pickle', 6, 'Proteins', 'c4',
          'Seasonal menu using 8 techniques'),
      _n('c9', 'Proteins: butchery + temperature mastery', 6, 'Proteins', 'c6',
          'Whole chicken broken down; temp log for 3 proteins'),
      _n('c11', 'Fermentation & preservation', 7, 'Proteins', 'c9',
          'Kraut, yogurt, pickles + one long ferment'),
      // Cuisine & creativity crown chain.
      _n('c16', 'World techniques: 5 dishes × 4 cuisines', 7, 'Cuisine', ['c8', 'c10'],
          'Cook-throughs with authenticity notes'),
      _n('c12', 'Replicate 3 Michelin-book recipes', 8, 'Cuisine', ['c11', 'c16'],
          'Full process documented, plating compared'),
      _n('c13', 'Develop 10 original recipes', 9, 'Cuisine', ['c12', 'c18', 'c17'],
          'Written recipes tested by someone else from the page'),
      _n('c15', 'Crown: 8-course tasting menu for 8', 10, 'Crown', 'c13',
          'Menu design → prep schedule → solo execution → guest feedback'),
    ]),
    Skill('mechanics', 'Mechanics', '🔧', 'Rebuild It Yourself', [
      _n('m1', 'Shop safety + tool literacy', 1, 'Foundations', null,
          'Tool ID quiz; torque practice; jack-stand discipline video'),
      // Automotive branch.
      _n('m2', 'Auto basics: fluids, filters, battery, tyres', 2, 'Auto', 'm1',
          'Perform + document all on a real car'),
      _n('m4', 'Auto: brakes & suspension', 3, 'Auto', 'm2',
          'Pad/rotor change documented; ASE A5 practice ≥80%'),
      _n('m6', 'Auto: electrics + OBD-II diagnostics', 4, 'Auto', 'm4',
          '3 real faults chased with multimeter + scanner log'),
      _n('m8', 'Small-engine teardown: rebuild to running', 5, 'Auto', 'm6',
          'Junkyard/lawnmower engine — video of first start'),
      _n('m10', 'Motorcycle/car engine rebuild', 6, 'Auto', 'm8',
          'Compression numbers before/after'),
      _n('m12', 'ASE knowledge gauntlet', 7, 'Auto', 'm10',
          'A1–A8 practice exams, all ≥80%'),
      // Home / building branch.
      _n('m3', 'Home basics: drywall, painting, patching', 2, 'Home', 'm1',
          'Repair a wall section, document the finish'),
      _n('m5', 'Home: plumbing fundamentals', 3, 'Home', 'm3',
          'Replace a trap/valve; sweat or press one joint'),
      _n('m7', 'Home: electrical theory + code literacy', 4, 'Home', 'm5',
          'Practice board wired (dead circuits); code quiz ≥80%'),
      _n('m9', 'Home: framing & structural basics', 5, 'Home', 'm7',
          'Stud wall or shed section, square + plumb'),
      _n('m11', 'Home: full room renovation', 6, 'Home', 'm9',
          'Before/after with process log'),
      _n('m15', 'EPA 608 (refrigerant handling)', 7, 'Home', 'm7',
          'The real certificate — publicly bookable'),
      // Fabrication branch.
      _n('m16', 'Welding & metal fabrication (MIG)', 4, 'Fabrication', 'm1',
          'Sound MIG beads; fabricate a bracket/frame, inspected'),
      _n('m17', 'Auto bodywork & paint', 6, 'Fabrication', ['m8', 'm16'],
          'Repair, prime and paint a panel to a blendable finish'),
      _n('m14', 'Crown: one machine + one room, end to end', 8, 'Crown',
          ['m12', 'm11', 'm15', 'm17'],
          'A vehicle you rebuilt driving; a room you transformed'),
    ]),
    Skill('memory', 'Memory', '🧩', 'Compete Among the Best from Your Desk', [
      _n('mem1', 'SRS habit: 180-day Anki streak', 1, 'Systems', null, 'Stats export'),
      // Systems branch.
      _n('mem2', 'Link & story method', 2, 'Systems', 'mem1',
          'Memorise 20-item lists reliably'),
      _n('mem4', 'Major system 00–99', 4, 'Systems', 'mem3',
          'Full table from memory; 40 digits in 2 min'),
      _n('mem14', 'Speed encoding drills & review discipline', 6, 'Systems', 'mem5',
          'Timed encoding sets; a rotation schedule that prevents ghosting'),
      // Palaces branch.
      _n('mem3', 'Memory palaces: 5 palaces, 100 loci', 3, 'Palaces', 'mem2',
          'Palace maps; 50-item recall demo'),
      _n('mem6', 'Palace network: 20 palaces, 500 loci', 6, 'Palaces', 'mem3',
          'Index + rotation schedule'),
      // Numbers & cards branch.
      _n('mem5', 'PAO system', 5, 'Numbers', 'mem4',
          'Full PAO table; 80 digits in 5 min'),
      _n('mem9', 'Numbers discipline', 7, 'Numbers', 'mem5',
          'Memory League 80-digit level, or 200 digits in 5 min'),
      _n('mem8', 'Cards: one deck under 3 minutes', 8, 'Numbers', ['mem5', 'mem6'],
          'On-camera single take'),
      _n('mem10', 'Cards: under 90 seconds', 9, 'Numbers', ['mem8', 'mem14'],
          'On-camera single take'),
      // Names & words branch.
      _n('mem7', 'Names & faces', 7, 'Words', 'mem6',
          'Memory League: 15+ names/min level'),
      _n('mem11', 'Images & words events', 9, 'Words', 'mem9',
          'Memory League level 60+ in both'),
      // Competition crown chain.
      _n('mem12', 'A full Memory League season', 10, 'Competition',
          ['mem7', 'mem10', 'mem11'], 'Season completed; W/L recorded'),
      _n('mem13', 'Crown: ranked competitor', 11, 'Crown', 'mem12',
          'Memory League top-100, or an official IAM event completed'),
    ]),
    Skill('karate', 'Karate', '🥋', 'Shodan and Beyond, Honestly Earned', [
      _n('k1', 'Foundations: etiquette, stances, tai sabaki', 1, 'Kihon', null,
          'Stance-hold times; video vs JKA reference'),
      _n('k2', 'Kihon: 9th–7th kyu syllabus', 2, 'Kihon', 'k1',
          'Full syllabus on video, self-scored vs standard'),
      _n('k16', 'Kihon combinations & renraku-waza', 4, 'Kihon', 'k2',
          'Combination drills on video vs JKA reference'),
      // Kata branch.
      _n('k3', 'Heian Shodan–Sandan', 3, 'Kata', 'k2',
          'Each kata one-take video, compared move-by-move'),
      _n('k5', 'Heian Yondan–Godan + Tekki Shodan', 5, 'Kata', 'k3',
          'One-take videos + bunkai notes'),
      _n('k7', 'Advanced kata: Bassai Dai, Jion, Enpi', 7, 'Kata', 'k5',
          'One-take videos vs JKA reference'),
      _n('k8', 'Bunkai: applications of every kata', 8, 'Kata', 'k7',
          'Partner demo video, 3 applications per kata'),
      // Kumite branch.
      _n('k4', 'Partner work: gohon/sanbon kumite', 3, 'Kumite', 'k2',
          'Logged dojo sessions'),
      _n('k17', 'Kihon-ippon kumite: one-step sparring', 4, 'Kumite', 'k4',
          'One-step sparring, both sides, video-scored'),
      _n('k6', 'Jiyu kumite: 50 free-sparring rounds', 6, 'Kumite', ['k4', 'k17'],
          'Dojo log; 5 rounds on video, reviewed'),
      _n('k9', 'Kumite depth: 150 rounds + shiai', 9, 'Kumite', ['k6', 'k15'],
          'Log; one tournament or in-dojo shiai'),
      // Conditioning branch.
      _n('k15', 'Conditioning: strength & mobility', 3, 'Conditioning', 'k2',
          '12-week program log; belt-height kicks held 10s'),
      // Grading crown chain.
      _n('k10', 'Shodan grading', 10, 'Grading', ['k8', 'k9', 'k16'],
          'The real grading at your dojo/organisation'),
      _n('k11', 'Sempai: assist teaching, 6 months', 11, 'Grading', 'k10',
          "Instructor's written confirmation"),
      _n('k12', 'Nidan → Sandan gradings', 12, 'Grading', 'k11',
          'Real gradings — multi-year, as intended'),
      _n('k14', 'Crown: Sandan + your own study group', 13, 'Crown', 'k12',
          '3rd dan certificate; a regular group you lead'),
    ]),
  ]),
];

StatDomain statById(String id) => catalog.firstWhere((s) => s.id == id);

Skill skillById(String id) =>
    catalog.expand((s) => s.skills).firstWhere((sk) => sk.id == id);

/// Total node count across every constellation (the "lifetime mastery" count).
final int totalNodeCount = catalog.fold(
    0, (sum, s) => sum + s.skills.fold(0, (x, sk) => x + sk.tree.length));
