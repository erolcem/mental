// data/skill_data.dart — the full mastery catalog: 4 stats → 21 skills → 332
// nodes, ported 1:1 from the original React prototype (Wisdom/src/App.jsx).
// Content is PROVISIONAL — node choices are subject to a later curriculum
// review with Erol; keep this file trivially editable (flat literals only).
//
// Node ids are unique per tree but NOT globally (maths and mechanics both use
// m1..); all persistence therefore keys progress by `skillId.nodeId` — see
// [progressKey].
import 'dart:ui' show Color;

class SkillNode {
  final String id;
  final String label;

  /// 1-based depth band. Tier 1 sits at the constellation's base; the final
  /// tier is the mastery star at its crown.
  final int tier;

  /// Ids (within the same tree) that must be complete before this unlocks.
  final List<String> requires;
  const SkillNode(this.id, this.label, this.tier,
      [this.requires = const []]);
}

class Skill {
  final String id;
  final String label;
  final String icon;

  /// The endgame this constellation represents — shown under the title.
  final String goal;
  final List<SkillNode> tree;
  const Skill(this.id, this.label, this.icon, this.goal, this.tree);

  int get maxTier =>
      tree.fold(1, (m, n) => n.tier > m ? n.tier : m);
  SkillNode nodeById(String id) => tree.firstWhere((n) => n.id == id);
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

SkillNode _n(String id, String label, int tier, [Object? req]) => SkillNode(
    id,
    label,
    tier,
    req == null
        ? const []
        : req is String
            ? [req]
            : List<String>.from(req as List));

final List<StatDomain> catalog = [
  StatDomain('INT', 'Intelligence', const Color(0xFF00D4FF), [
    Skill('science', 'Physics & Chem', '⚗', 'Nobel-Level Paradigm Shift', [
      _n('sc1', 'AP Physics & Chem', 1),
      _n('sc2', 'Classical Mechanics (Taylor)', 2, 'sc1'),
      _n('sc3', 'General Chemistry (Zumdahl)', 2, 'sc1'),
      _n('sc4', 'Electromagnetism (Griffiths)', 3, 'sc2'),
      _n('sc5', 'Organic Chem I & II (Clayden)', 3, 'sc3'),
      _n('sc6', 'Thermodynamics (Kittel)', 4, 'sc4'),
      _n('sc7', 'Quantum Mechanics (Griffiths)', 4, 'sc4'),
      _n('sc8', 'Physical Chem (Atkins)', 5, ['sc5', 'sc6']),
      _n('sc9', 'Biochemistry (Lehninger)', 5, 'sc5'),
      _n('sc10', 'Adv Quantum Mechanics (Sakurai)', 6, 'sc7'),
      _n('sc11', 'Molecular Biology (Alberts)', 6, 'sc9'),
      _n('sc12', 'Relativity & Spacetime (Carroll)', 7, 'sc10'),
      _n('sc13', 'Classical Electrodynamics (Jackson)', 7, 'sc4'),
      _n('sc14', 'Quantum Field Theory (Peskin)', 8, ['sc10', 'sc12']),
      _n('sc15', 'PhD Defense: Novel Physics/Chem Thesis', 9,
          ['sc13', 'sc8', 'sc11']),
      _n('sc16', 'Post-Doc Research Fellowship', 10, 'sc15'),
      _n('sc17', 'Principal Investigator & Grant Winner', 11, 'sc16'),
      _n('sc18', 'Publish Paradigm-Shifting Discovery', 12, 'sc17'),
    ]),
    Skill('maths', 'Mathematics', '∑', 'Fields Medal / Proof Mastery', [
      _n('m1', 'Pre-Calculus & Trigonometry', 1),
      _n('m2', 'Logic & Proofs (Velleman)', 2, 'm1'),
      _n('m3', 'Calculus I-III (Stewart)', 2, 'm1'),
      _n('m4', 'Linear Algebra (Axler)', 3, ['m2', 'm3']),
      _n('m5', 'Differential Equations', 3, 'm3'),
      _n('m6', 'Intro Probability (Ross)', 4, 'm3'),
      _n('m7', 'Real Analysis I (Baby Rudin)', 5, ['m3', 'm4']),
      _n('m8', 'Abstract Algebra (Dummit)', 5, 'm4'),
      _n('m9', 'Complex Analysis (Ahlfors)', 6, 'm7'),
      _n('m10', 'Point-Set Topology (Munkres)', 6, 'm7'),
      _n('m11', 'Mathematical Statistics (Casella)', 7, 'm6'),
      _n('m12', 'Measure Theory & Integration', 7, 'm10'),
      _n('m13', 'Stochastic Processes', 8, ['m11', 'm5']),
      _n('m14', 'Measure-Theoretic Probability', 8, 'm12'),
      _n('m15', 'Differential Geometry', 9, 'm10'),
      _n('m16', 'Pass PhD Qualifying Exams', 10, ['m9', 'm8', 'm14', 'm15']),
      _n('m17', 'Defend PhD Dissertation', 11, 'm16'),
      _n('m18', 'Publish Original Theorem (Annals of Math)', 12, 'm17'),
    ]),
    Skill('medicine', 'Medicine', '⚕', 'Chief Attending / Diagnostician', [
      _n('md1', 'Medical Terminology & CPR', 1),
      _n('md2', 'Anatomy Flashcards (Netter)', 2, 'md1'),
      _n('md3', 'Physiology (Guyton & Hall)', 3, 'md2'),
      _n('md4', 'Medical Biochemistry', 3, 'md1'),
      _n('md5', 'Pathology (Robbins Basic)', 4, ['md3', 'md4']),
      _n('md6', 'Pharmacology (Katzung)', 4, 'md3'),
      _n('md7', 'Immunology & Microbio', 4, 'md4'),
      _n('md8', 'First Aid USMLE Step 1', 5, ['md5', 'md6', 'md7']),
      _n('md9', 'UWorld Step 1 (3000+ Qs)', 6, 'md8'),
      _n('md10', 'Pass Step 1 Mock (>240)', 7, 'md9'),
      _n('md11', 'Physical Exam (Bates)', 8, 'md10'),
      _n('md12', "Internal Medicine (Harrison's)", 8, 'md10'),
      _n('md13', 'ECG Interpretation (Dubin)', 8, 'md10'),
      _n('md14', 'UWorld Step 2 CK Complete', 9, ['md11', 'md12', 'md13']),
      _n('md15', 'Pass Step 2 Mock (>250)', 10, 'md14'),
      _n('md16', 'Diagnose 100 NEJM Clinical Cases', 11, 'md15'),
      _n('md17', 'Board Certification (Mock)', 12, 'md16'),
      _n('md18', 'Chief Attending Clinical Acumen', 13, 'md17'),
    ]),
    Skill('engineering', 'Engineering', '⚙', 'Principal Architect / OS Dev', [
      _n('eg1', 'CS50 & Python Basics', 1),
      _n('eg2', 'C Programming (K&R)', 2, 'eg1'),
      _n('eg3', 'Engineering Math (LinAlg/DiffEq)', 2, 'eg1'),
      _n('eg4', 'Digital Logic & Comp Arch', 3, 'eg2'),
      _n('eg5', 'Data Structures & Algos', 3, 'eg2'),
      _n('eg6', 'Circuit Analysis (KVL/KCL)', 3, 'eg3'),
      _n('eg7', 'Computer Systems (CS:APP)', 4, 'eg4'),
      _n('eg8', 'Signals & Systems', 4, 'eg6'),
      _n('eg9', 'Nand to Tetris Part 1', 5, 'eg7'),
      _n('eg10', 'Operating Systems Concepts', 5, ['eg5', 'eg7']),
      _n('eg11', 'Networking Protocols', 6, 'eg5'),
      _n('eg12', 'Embedded MCU (C++)', 6, 'eg8'),
      _n('eg13', 'Nand to Tetris Part 2', 7, ['eg9', 'eg10']),
      _n('eg14', 'Database Internals', 7, 'eg10'),
      _n('eg15', 'Code Custom RTOS in C', 8, ['eg12', 'eg13']),
      _n('eg16', 'Distributed Systems (DDIA)', 9, ['eg11', 'eg14']),
      _n('eg17', 'Build Autonomous Robot (ROS2)', 9, 'eg15'),
      _n('eg18', 'Deploy Custom Full-Stack Dist. OS', 10, ['eg16', 'eg17']),
    ]),
  ]),
  StatDomain('WIS', 'Wisdom', const Color(0xFFC084FC), [
    Skill('geography', 'Geography', '🌍', 'Global Spatial Data Scientist', [
      _n('g1', 'Anki: 196 Nations & Capitals', 1),
      _n('g2', 'Anki: 196 Flags & Rivers', 2, 'g1'),
      _n('g3', 'Physical Geography', 2, 'g1'),
      _n('g4', 'Prisoners of Geography', 3, 'g1'),
      _n('g5', 'Human Demographics', 3, 'g3'),
      _n('g6', 'QGIS & ArcMap Basics', 4, ['g3', 'g5']),
      _n('g7', 'Guns, Germs, and Steel', 4, 'g4'),
      _n('g8', 'Spatial SQL & PostGIS', 5, 'g6'),
      _n('g9', 'The Silk Roads', 5, 'g7'),
      _n('g10', "Dictator's Handbook", 5, 'g4'),
      _n('g11', 'Python for Geospatial Data', 6, 'g8'),
      _n('g12', 'Global Supply Chain Mapping', 6, ['g8', 'g5']),
      _n('g13', 'The Grand Chessboard', 7, ['g9', 'g10']),
      _n('g14', 'Revenge of Geography', 7, 'g13'),
      _n('g15', 'Remote Sensing & Satellite Imagery', 8, 'g11'),
      _n('g16', 'Publish Geopolitical Forecast Model', 9, ['g12', 'g14']),
      _n('g17', 'Create Global Trade Data Dashboard', 10, 'g15'),
    ]),
    Skill('history', 'History', '📜', 'Master Historian & Archival Synthesis', [
      _n('h1', 'Historiography Methods', 1),
      _n('h2', 'Durant: Antiquity (Vol 1-3)', 2, 'h1'),
      _n('h3', 'Durant: Middle Ages (Vol 4-6)', 3, 'h2'),
      _n('h4', 'Durant: Modern Era (Vol 7-11)', 4, 'h3'),
      _n('h5', 'Sapiens (Harari)', 2, 'h1'),
      _n('h6', 'SPQR (Rome)', 3, 'h2'),
      _n('h7', 'The Sleepwalkers (WW1)', 5, 'h4'),
      _n('h8', 'The Second World War (Keegan)', 5, 'h4'),
      _n('h9', 'Cold War (Gaddis)', 6, 'h8'),
      _n('h10', 'A Farewell to Alms (Econ Hist)', 6, 'h4'),
      _n('h11', 'Extract/Translate 10 Primary Sources', 7, 'h1'),
      _n('h12', 'Lessons of History (Durant)', 8, ['h7', 'h9', 'h10']),
      _n('h13', 'Write 5,000-word Era Synthesis', 9, 'h11'),
      _n('h14', 'Master of Archival Research', 10, 'h13'),
      _n('h15', 'Publish 10,000-word Sourced Monograph', 11, ['h12', 'h14']),
    ]),
    Skill('business', 'Business', '📊', 'Institutional Hedge Fund Modeler', [
      _n('b1', 'Personal Finance (FIRE)', 1),
      _n('b2', 'Microeconomics (Mankiw)', 2),
      _n('b3', 'Macroeconomics', 2),
      _n('b4', 'Financial Accounting', 3, 'b1'),
      _n('b5', 'Marketing Principles', 3, 'b2'),
      _n('b6', 'Corporate Finance', 4, ['b4', 'b2', 'b3']),
      _n('b7', 'Managerial Accounting', 4, 'b4'),
      _n('b8', 'CFA Level 1 Curriculum', 5, 'b6'),
      _n('b9', 'Competitive Strategy (Porter)', 5, 'b5'),
      _n('b10', 'Operations Management', 5, 'b2'),
      _n('b11', 'CFA Level 2 (Valuation)', 6, 'b8'),
      _n('b12', 'Adv Excel & VBA for Finance', 7, 'b11'),
      _n('b13', 'Build 3-Statement Model', 8, 'b12'),
      _n('b14', 'Build DCF & LBO Models', 9, 'b13'),
      _n('b15', 'CFA Level 3 (Portfolio Mgmt)', 10, 'b11'),
      _n('b16', 'Analyze 50 10-K Reports', 11, 'b14'),
      _n('b17', 'Manage \$1M+ Simulated Portfolio', 12, ['b15', 'b16']),
      _n('b18', 'Write 3 Institutional Equity Reports', 13, 'b17'),
    ]),
    Skill('socialSci', 'Social Sci', '🧠', 'Behavioral Economics Pioneer', [
      _n('ss1', 'Intro to Psych & Sociology', 1),
      _n('ss2', 'Research Methods & Stats', 2, 'ss1'),
      _n('ss3', 'Biological Psych & Neuro', 3, 'ss1'),
      _n('ss4', 'Cognitive Psychology', 4, 'ss3'),
      _n('ss5', 'Social Psychology', 4, 'ss1'),
      _n('ss6', 'Developmental Psych', 4, 'ss3'),
      _n('ss7', 'Abnormal Psych (DSM-5)', 5, ['ss4', 'ss6']),
      _n('ss8', 'Thinking, Fast & Slow', 5, 'ss5'),
      _n('ss9', 'Influence (Cialdini)', 6, 'ss8'),
      _n('ss10', 'Moral Philosophy & Ethics', 6, 'ss5'),
      _n('ss11', 'Behave (Sapolsky)', 7, ['ss3', 'ss9']),
      _n('ss12', 'Applied Stoicism (Meditations)', 7, 'ss10'),
      _n('ss13', 'Design Behavioral Trial', 8, ['ss2', 'ss11']),
      _n('ss14', 'Data Analysis (SPSS/R)', 9, 'ss13'),
      _n('ss15', 'Write PhD-Level Psych Thesis', 10, 'ss14'),
      _n('ss16', 'Publish Paradigm-Shifting Behavioral Theory', 11,
          ['ss12', 'ss15']),
    ]),
  ]),
  StatDomain('CHA', 'Charisma', const Color(0xFFFB923C), [
    Skill('english', 'English', '🔤', 'Virtuoso Orator & Lexicographer', [
      _n('e1', 'Elements of Style', 1),
      _n('e2', 'Anki: 500 High-Freq GRE Words', 2),
      _n('e3', 'Latin & Greek Etymology', 2),
      _n('e4', 'Anki: Words 501-1000', 3, 'e2'),
      _n('e5', 'Logical Fallacies Mastery', 3, 'e1'),
      _n('e6', 'Classical Rhetoric (Farnsworth)', 4, ['e1', 'e3']),
      _n('e7', 'Anki: Words 1001-2000 (Adv/Idioms)', 4, 'e4'),
      _n('e8', 'Sense of Style (Pinker)', 5, 'e6'),
      _n('e9', 'Analyze 50 Historical Speeches', 6, 'e6'),
      _n('e10', 'Write 10 Persuasive Long-form Essays', 7, ['e7', 'e8', 'e5']),
      _n('e11', 'Toastmasters Competent Communicator', 8, 'e9'),
      _n('e12', 'Cognitive Linguistics', 9, 'e7'),
      _n('e13', 'Impromptu Speaking Mastery', 9, 'e11'),
      _n('e14', 'Deliver 20-Min Keynote (No Notes)', 10, ['e10', 'e13']),
      _n('e15', 'Publish Critically Acclaimed Essay', 11, 'e12'),
    ]),
    Skill('turkish', 'Turkish', '🇹🇷', 'C2 Simultaneous Interpretation', [
      _n('tr1', 'Phonology & Vowel Harmony', 1),
      _n('tr2', 'A1: Core 500 Words & Present Tense', 2, 'tr1'),
      _n('tr3', 'A2: 1000 Words & Past/Future', 3, 'tr2'),
      _n('tr4', 'B1: 2500 Words & Noun Cases', 4, 'tr3'),
      _n('tr5', 'B2: Suffix Chains & Conditionals', 5, 'tr4'),
      _n('tr6', 'Relative Clauses Mastery', 6, 'tr5'),
      _n('tr7', 'iTalki: 20 Hrs 1-on-1 Practice', 7, 'tr4'),
      _n('tr8', 'VCE Exams: Pass 5 Papers (>85%)', 8, 'tr6'),
      _n('tr9', 'Consume 50 Hrs Turkish Media (No Subs)', 8, 'tr5'),
      _n('tr10', 'C1: Read Orhan Pamuk Natively', 9, ['tr8', 'tr9']),
      _n('tr11', 'iTalki: 100 Hrs Conversation', 10, 'tr7'),
      _n('tr12', 'Write 10 C1-Level Essays', 10, 'tr10'),
      _n('tr13', 'C2 Official Certification', 11, ['tr11', 'tr12']),
      _n('tr14', 'Real-time Simultaneous Interpretation', 12, 'tr13'),
    ]),
    Skill('japanese', 'Japanese', '🇯🇵', 'JLPT N1 & Keigo Mastery', [
      _n('j1', 'Perfect Kana Pronunciation', 1),
      _n('j2', 'Genki I Grammar', 2, 'j1'),
      _n('j3', 'RTK: Kanji 1-500', 2, 'j1'),
      _n('j4', 'Genki II Grammar', 3, 'j2'),
      _n('j5', 'RTK: Kanji 501-1000', 3, 'j3'),
      _n('j6', 'Pass JLPT N4 Mock Exam', 4, ['j4', 'j5']),
      _n('j7', 'Tobira (Advanced Gateway)', 5, 'j6'),
      _n('j8', 'RTK: All 2200 Joyo Kanji', 5, 'j5'),
      _n('j9', 'Anki: Core 2k Vocab', 5, 'j6'),
      _n('j10', 'Pass JLPT N3 Mock Exam', 6, ['j7', 'j8', 'j9']),
      _n('j11', 'Anki: Core 6k Vocab', 7, 'j9'),
      _n('j12', 'Read 10 Manga Volumes', 7, 'j10'),
      _n('j13', 'Shin Kanzen Master N2', 8, 'j10'),
      _n('j14', 'Pass JLPT N2 Official', 9, ['j11', 'j12', 'j13']),
      _n('j15', 'Business Honorifics (Keigo)', 10, 'j14'),
      _n('j16', '100 Hrs Native Shadowing/Speaking', 10, 'j14'),
      _n('j17', 'Pass JLPT N1 Official', 11, 'j16'),
      _n('j18', 'Native Literary & Classical Comprehension', 12,
          ['j15', 'j17']),
    ]),
    Skill('khmer', 'Khmer', '🇰🇭', 'C2 Literary & Conversational Fluency', [
      _n('kh1', 'Alphabet & Dependent Vowels', 1),
      _n('kh2', 'Subscript Consonants & Tones', 2, 'kh1'),
      _n('kh3', 'A1: SVO Syntax & 300 Words', 3, 'kh2'),
      _n('kh4', 'A2: Classifiers & Tense Markers', 4, 'kh3'),
      _n('kh5', 'B1: 1500 Core Words', 5, 'kh4'),
      _n('kh6', 'Read Basic Signs & Menus', 5, 'kh2'),
      _n('kh7', 'iTalki: 20 Hrs Tutor Practice', 6, 'kh5'),
      _n('kh8', 'B2: Complex Sentence Structures', 7, 'kh5'),
      _n('kh9', 'Read Native News Articles', 8, ['kh6', 'kh8']),
      _n('kh10', 'Formal & Royal Register', 9, 'kh8'),
      _n('kh11', '100 Hrs Media/News Consumption', 9, 'kh9'),
      _n('kh12', 'iTalki: 100 Hrs Fluency Practice', 10, 'kh7'),
      _n('kh13', 'Read Traditional Literature', 11, 'kh10'),
      _n('kh14', 'C2 Real-Time Interpretation', 12, ['kh11', 'kh12', 'kh13']),
    ]),
    Skill('musicTheory', 'Music Theory', '🎼', 'Symphonic Composer', [
      _n('mt1', 'Pitch, Rhythm, Clefs', 1),
      _n('mt2', 'Major & Minor Scales', 2, 'mt1'),
      _n('mt3', 'Intervals (Simple/Compound)', 3, 'mt2'),
      _n('mt4', 'Triads & Inversions', 4, 'mt3'),
      _n('mt5', 'ABRSM Grade 5 Prep (Cadences/Transposition)', 5, 'mt4'),
      _n('mt6', 'Pass ABRSM Grade 5 Theory', 6, 'mt5'),
      _n('mt7', 'Seventh Chords & Figured Bass', 7, 'mt6'),
      _n('mt8', 'Advanced Harmony (Chorale)', 8, 'mt7'),
      _n('mt9', 'Species Counterpoint (Fux)', 9, 'mt8'),
      _n('mt10', 'Pass ABRSM Grade 8 Theory', 10, 'mt8'),
      _n('mt11', 'Sonata & Fugue Form Analysis', 11, 'mt9'),
      _n('mt12', 'Orchestration (Adler)', 12, 'mt11'),
      _n('mt13', 'Compose Original String Quartet', 13, 'mt11'),
      _n('mt14', 'Compose & Premiere Full Symphony', 14, ['mt12', 'mt13']),
    ]),
    Skill('piano', 'Piano', '🎹', 'Virtuoso Concerto Soloist', [
      _n('p1', 'Ergonomics & Hand Shape', 1),
      _n('p2', 'Sight Reading Level 1', 2, 'p1'),
      _n('p3', 'Major Scales (2 Octaves)', 3, 'p1'),
      _n('p4', 'Minor Scales & Arpeggios', 4, 'p3'),
      _n('p5', 'Hanon: Exercises 1-20', 4, 'p3'),
      _n('p6', 'Bach: 3 Two-Part Inventions', 5, 'p4'),
      _n('p7', 'Seventh Chords & Voicings', 5, 'p2'),
      _n('p8', 'Pedaling (Syncopated/Una Corda)', 6, 'p5'),
      _n('p9', 'Czerny: School of Velocity', 6, 'p5'),
      _n('p10', 'Classical: Full Mozart/Haydn Sonata', 7, ['p6', 'p7']),
      _n('p11', 'Romantic: Chopin Nocturne/Waltz', 8, ['p8', 'p10']),
      _n('p12', 'Polyrhythms & Independence', 9, 'p9'),
      _n('p13', 'ABRSM Grade 8 Sight Reading', 10, 'p2'),
      _n('p14', 'Pass ABRSM Grade 8 Practical', 11, ['p11', 'p13']),
      _n('p15', 'Impressionist: Ravel/Debussy', 12, 'p14'),
      _n('p16', '1-Hour Memorized Solo Recital', 13, 'p15'),
      _n('p17', 'Perform Concerto with Live Orchestra', 14, ['p12', 'p16']),
    ]),
    Skill('singing', 'Singing', '🎤', 'Grammy-Level Vocal Master', [
      _n('v1', 'Diaphragmatic Breathing', 1),
      _n('v2', 'Perfect Pitch Matching', 2, 'v1'),
      _n('v3', 'Chest Voice Support', 3, 'v2'),
      _n('v4', 'Head Voice & Falsetto', 3, 'v2'),
      _n('v5', 'Diction & Vowel Modification', 4, 'v3'),
      _n('v6', 'Find the Mixed Voice (Passaggio)', 5, ['v3', 'v4']),
      _n('v7', 'Vibrato Development', 6, 'v6'),
      _n('v8', 'Vocal Agility & Melisma', 7, 'v6'),
      _n('v9', 'Dynamic Control (Messa di Voce)', 8, 'v7'),
      _n('v10', 'Genre Versatility (Opera/Pop/Jazz)', 9, ['v5', 'v8']),
      _n('v11', 'Studio Mic Tech & Production', 10, 'v9'),
      _n('v12', 'Teach 5 Students to Mix', 11, 'v6'),
      _n('v13', 'Lead Role in Major Musical/Opera', 12, 'v10'),
      _n('v14', 'Produce 10 Original Studio Tracks', 13, 'v11'),
      _n('v15', 'World-Class/Grammy-Caliber Acclaim', 14,
          ['v12', 'v13', 'v14']),
    ]),
  ]),
  StatDomain('DEX', 'Dexterity', const Color(0xFF4ADE80), [
    Skill('drawing', 'Drawing', '✏️', 'Solo Gallery Exhibition', [
      _n('d1', 'Drawabox: Line & Ghosting', 1),
      _n('d2', '2D Shapes & Proportion', 2, 'd1'),
      _n('d3', '3D Forms (Boxes/Cylinders)', 3, 'd2'),
      _n('d4', '1 & 2 Point Perspective', 4, 'd3'),
      _n('d5', 'Value Scales & Light Logic', 4, 'd3'),
      _n('d6', 'Figure Gesture (30s Poses)', 5, 'd3'),
      _n('d7', '3-Point Persp & Foreshortening', 6, 'd4'),
      _n('d8', 'Proko Anatomy 1 (Skeleton)', 6, 'd6'),
      _n('d9', 'Color Theory (Gurney)', 7, 'd5'),
      _n('d10', 'Proko Anatomy 2 (Muscles)', 8, 'd8'),
      _n('d11', 'Anatomy 3 (Hands/Feet/Faces)', 9, 'd10'),
      _n('d12', 'Material Rendering', 10, ['d9', 'd7']),
      _n('d13', 'Master Composition & Storytelling', 11, 'd12'),
      _n('d14', 'Create 20-Piece Portfolio', 12, ['d11', 'd13']),
      _n('d15', 'Work as Professional Art Director', 13, 'd14'),
      _n('d16', 'Host Solo Gallery Original Exhibition', 14, 'd15'),
    ]),
    Skill('writing', 'Writing', '🖊', 'NYT Bestselling Novelist', [
      _n('w1', 'Grammar & Punctuation', 1),
      _n('w2', 'Read 50 Masterpieces', 2, 'w1'),
      _n('w3', 'Write 10 Short Stories', 3, 'w2'),
      _n('w4', 'Narrative Design (Save the Cat)', 4, 'w3'),
      _n('w5', 'Draft: 50,000 Words (NaNoWriMo)', 5, 'w4'),
      _n('w6', 'On Writing (King)', 6, 'w5'),
      _n('w7', 'Draft: 100,000 Word Epic', 7, 'w6'),
      _n('w8', 'Developmental Editing', 8, 'w7'),
      _n('w9', 'On Writing Well (Zinsser)', 9, 'w8'),
      _n('w10', 'Line Editing & Prose Polish', 10, 'w9'),
      _n('w11', 'Beta Reader Feedback Revisions', 11, 'w10'),
      _n('w12', 'Write Query Letter & Synopsis', 12, 'w11'),
      _n('w13', 'Secure Traditional Literary Agent', 13, 'w12'),
      _n('w14', 'Publish via Major Publishing House', 14, 'w13'),
      _n('w15', 'Achieve NYT Bestseller Status', 15, 'w14'),
    ]),
    Skill('cooking', 'Cooking', '🍳', 'Michelin-Star Exec Chef', [
      _n('c1', 'Food Safety (ServSafe)', 1),
      _n('c2', 'Knife Skills (Julienne/Brunoise)', 2, 'c1'),
      _n('c3', 'Heat Control (Maillard)', 3, 'c2'),
      _n('c4', 'Flavor Balance (Salt, Fat, Acid, Heat)', 4, 'c3'),
      _n('c5', 'Stocks (White/Brown/Veg)', 5, 'c2'),
      _n('c6', 'The 5 French Mother Sauces', 6, ['c4', 'c5']),
      _n('c7', 'Baking Basics (Hydration/Yeast)', 6, 'c4'),
      _n('c8', 'Vegetable Techniques (Roast/Braise)', 7, 'c4'),
      _n('c9', 'Protein Fabrication & Cooking', 8, 'c6'),
      _n('c10', 'Emulsions & Vinaigrettes', 8, 'c6'),
      _n('c11', 'Modernist (Sous-vide/Ferment)', 9, 'c9'),
      _n('c12', 'Develop 20 Signature Dishes', 10, ['c8', 'c10', 'c11']),
      _n('c13', 'Design 10-Course Tasting Menu', 11, 'c12'),
      _n('c14', 'Lead High-Volume Restaurant Line', 12, 'c13'),
      _n('c15', 'Exec Chef at Michelin-Caliber Kitchen', 13, 'c14'),
    ]),
    Skill('mechanics', 'Mechanics', '🔧', 'ASE Master & GC Builder', [
      _n('m1', 'OSHA Safety & Tool ID', 1),
      _n('m2', 'Auto: Fluids, Filters, Batteries', 2, 'm1'),
      _n('m3', 'Home: Drywall & Painting', 2, 'm1'),
      _n('m4', 'Auto: Brakes & Suspension', 3, 'm2'),
      _n('m5', 'Home: Plumbing Code (Rough-in)', 3, 'm3'),
      _n('m6', 'Auto: OBD2 & Sensor Diagnostics', 4, 'm4'),
      _n('m7', 'Home: Electrical Code (Panels)', 4, 'm5'),
      _n('m8', 'Auto: Timing Belts & Cooling', 5, 'm6'),
      _n('m9', 'Home: Framing & Foundation', 5, 'm7'),
      _n('m10', 'Auto: Full Engine/Trans Rebuild', 6, 'm8'),
      _n('m11', 'Home: Full Room Gut & Reno', 6, 'm9'),
      _n('m12', 'Auto: Pass ASE Master Tech Exam', 7, 'm10'),
      _n('m13', 'Home: Pass GC License Exam', 7, 'm11'),
      _n('m14', 'Build Code-Compliant House from Scratch', 8, ['m12', 'm13']),
    ]),
    Skill('memory', 'Memory', '🧩', 'Int. Grandmaster of Memory', [
      _n('mem1', 'Spaced Repetition (Anki 365 Days)', 1),
      _n('mem2', 'Linking & Story Method', 2, 'mem1'),
      _n('mem3', 'Build 5 Memory Palaces (100 loci)', 3, 'mem2'),
      _n('mem4', 'Master Major System (00-99)', 4, 'mem3'),
      _n('mem5', 'Build PAO System', 5, 'mem4'),
      _n('mem6', 'Expand to 20 Palaces (500 loci)', 6, 'mem3'),
      _n('mem7', 'Names & Faces (50 in 15m)', 7, 'mem6'),
      _n('mem8', 'Cards: 1 Deck in <3 mins', 8, ['mem5', 'mem6']),
      _n('mem9', 'Numbers: 500 Digits in 1 Hr', 9, 'mem5'),
      _n('mem10', 'Cards: 10 Decks in 1 Hr', 10, 'mem8'),
      _n('mem11', 'Abstract Images & Binary Drills', 11, 'mem9'),
      _n('mem12', 'Compete in Official IAM Event', 12,
          ['mem7', 'mem10', 'mem11']),
      _n('mem13', 'Achieve Int. Grandmaster of Memory', 13, 'mem12'),
    ]),
    Skill('karate', 'Karate', '🥋', 'Godan (5th Dan) Founder', [
      _n('k1', 'Dojo Etiquette & Basic Stances', 1),
      _n('k2', 'Kihon: Punches, Kicks, Blocks', 2, 'k1'),
      _n('k3', 'Heian Katas 1-3', 3, 'k2'),
      _n('k4', 'Yakusoku Kumite (Pre-arranged)', 4, 'k2'),
      _n('k5', 'Heian Katas 4-5 & Tekki Shodan', 5, 'k3'),
      _n('k6', 'Jiyu Kumite (Free Sparring)', 6, 'k4'),
      _n('k7', 'Adv Kata (Bassai Dai, Jion)', 7, 'k5'),
      _n('k8', 'Bunkai (Practical App)', 8, 'k7'),
      _n('k9', '100+ Kumite Matches Won', 9, 'k6'),
      _n('k10', 'Pass Shodan (1st Dan) Grading', 10, ['k8', 'k9']),
      _n('k11', 'Teach Kohai (Sempai Status)', 11, 'k10'),
      _n('k12', 'Pass Sandan (3rd Dan)', 12, 'k11'),
      _n('k13', 'Master Weapons (Bo/Sai)', 13, 'k12'),
      _n('k14', 'Achieve Godan (5th Dan) & Open Dojo', 14, 'k13'),
    ]),
  ]),
];

StatDomain statById(String id) => catalog.firstWhere((s) => s.id == id);

Skill skillById(String id) => catalog
    .expand((s) => s.skills)
    .firstWhere((sk) => sk.id == id);

/// Total node count across every constellation (the "lifetime mastery" count).
final int totalNodeCount =
    catalog.fold(0, (sum, s) => sum + s.skills.fold(0, (x, sk) => x + sk.tree.length));
