import { useState, useEffect, useRef, useMemo } from 'react';

const T = (id, label, tier, progress, req) => ({
  id,
  label,
  tier,
  progress,
  requires: Array.isArray(req) ? req : req ? [req] : [],
});

const DATA = {
  INT: {
    label: 'Intelligence',
    color: '#00d4ff',
    skills: {
      science: {
        label: 'Physics & Chem',
        icon: '⚗',
        goal: 'Nobel-Level Paradigm Shift',
        tree: [
          T('sc1', 'AP Physics & Chem', 1, 0),
          T('sc2', 'Classical Mechanics (Taylor)', 2, 0, 'sc1'),
          T('sc3', 'General Chemistry (Zumdahl)', 2, 0, 'sc1'),
          T('sc4', 'Electromagnetism (Griffiths)', 3, 0, 'sc2'),
          T('sc5', 'Organic Chem I & II (Clayden)', 3, 0, 'sc3'),
          T('sc6', 'Thermodynamics (Kittel)', 4, 0, 'sc4'),
          T('sc7', 'Quantum Mechanics (Griffiths)', 4, 0, 'sc4'),
          T('sc8', 'Physical Chem (Atkins)', 5, 0, ['sc5', 'sc6']),
          T('sc9', 'Biochemistry (Lehninger)', 5, 0, 'sc5'),
          T('sc10', 'Adv Quantum Mechanics (Sakurai)', 6, 0, 'sc7'),
          T('sc11', 'Molecular Biology (Alberts)', 6, 0, 'sc9'),
          T('sc12', 'Relativity & Spacetime (Carroll)', 7, 0, 'sc10'),
          T('sc13', 'Classical Electrodynamics (Jackson)', 7, 0, 'sc4'),
          T('sc14', 'Quantum Field Theory (Peskin)', 8, 0, ['sc10', 'sc12']),
          T('sc15', 'PhD Defense: Novel Physics/Chem Thesis', 9, 0, [
            'sc13',
            'sc8',
            'sc11',
          ]),
          T('sc16', 'Post-Doc Research Fellowship', 10, 0, 'sc15'),
          T('sc17', 'Principal Investigator & Grant Winner', 11, 0, 'sc16'),
          T('sc18', 'Publish Paradigm-Shifting Discovery', 12, 0, 'sc17'),
        ],
      },
      maths: {
        label: 'Mathematics',
        icon: '∑',
        goal: 'Fields Medal / Proof Mastery',
        tree: [
          T('m1', 'Pre-Calculus & Trigonometry', 1, 0),
          T('m2', 'Logic & Proofs (Velleman)', 2, 0, 'm1'),
          T('m3', 'Calculus I-III (Stewart)', 2, 0, 'm1'),
          T('m4', 'Linear Algebra (Axler)', 3, 0, ['m2', 'm3']),
          T('m5', 'Differential Equations', 3, 0, 'm3'),
          T('m6', 'Intro Probability (Ross)', 4, 0, 'm3'),
          T('m7', 'Real Analysis I (Baby Rudin)', 5, 0, ['m3', 'm4']),
          T('m8', 'Abstract Algebra (Dummit)', 5, 0, 'm4'),
          T('m9', 'Complex Analysis (Ahlfors)', 6, 0, 'm7'),
          T('m10', 'Point-Set Topology (Munkres)', 6, 0, 'm7'),
          T('m11', 'Mathematical Statistics (Casella)', 7, 0, 'm6'),
          T('m12', 'Measure Theory & Integration', 7, 0, 'm10'),
          T('m13', 'Stochastic Processes', 8, 0, ['m11', 'm5']),
          T('m14', 'Measure-Theoretic Probability', 8, 0, 'm12'),
          T('m15', 'Differential Geometry', 9, 0, 'm10'),
          T('m16', 'Pass PhD Qualifying Exams', 10, 0, [
            'm9',
            'm8',
            'm14',
            'm15',
          ]),
          T('m17', 'Defend PhD Dissertation', 11, 0, 'm16'),
          T('m18', 'Publish Original Theorem (Annals of Math)', 12, 0, 'm17'),
        ],
      },
      medicine: {
        label: 'Medicine',
        icon: '⚕',
        goal: 'Chief Attending / Diagnostician',
        tree: [
          T('md1', 'Medical Terminology & CPR', 1, 0),
          T('md2', 'Anatomy Flashcards (Netter)', 2, 0, 'md1'),
          T('md3', 'Physiology (Guyton & Hall)', 3, 0, 'md2'),
          T('md4', 'Medical Biochemistry', 3, 0, 'md1'),
          T('md5', 'Pathology (Robbins Basic)', 4, 0, ['md3', 'md4']),
          T('md6', 'Pharmacology (Katzung)', 4, 0, 'md3'),
          T('md7', 'Immunology & Microbio', 4, 0, 'md4'),
          T('md8', 'First Aid USMLE Step 1', 5, 0, ['md5', 'md6', 'md7']),
          T('md9', 'UWorld Step 1 (3000+ Qs)', 6, 0, 'md8'),
          T('md10', 'Pass Step 1 Mock (>240)', 7, 0, 'md9'),
          T('md11', 'Physical Exam (Bates)', 8, 0, 'md10'),
          T('md12', "Internal Medicine (Harrison's)", 8, 0, 'md10'),
          T('md13', 'ECG Interpretation (Dubin)', 8, 0, 'md10'),
          T('md14', 'UWorld Step 2 CK Complete', 9, 0, [
            'md11',
            'md12',
            'md13',
          ]),
          T('md15', 'Pass Step 2 Mock (>250)', 10, 0, 'md14'),
          T('md16', 'Diagnose 100 NEJM Clinical Cases', 11, 0, 'md15'),
          T('md17', 'Board Certification (Mock)', 12, 0, 'md16'),
          T('md18', 'Chief Attending Clinical Acumen', 13, 0, 'md17'),
        ],
      },
      engineering: {
        label: 'Engineering',
        icon: '⚙',
        goal: 'Principal Architect / OS Dev',
        tree: [
          T('eg1', 'CS50 & Python Basics', 1, 0),
          T('eg2', 'C Programming (K&R)', 2, 0, 'eg1'),
          T('eg3', 'Engineering Math (LinAlg/DiffEq)', 2, 0, 'eg1'),
          T('eg4', 'Digital Logic & Comp Arch', 3, 0, 'eg2'),
          T('eg5', 'Data Structures & Algos', 3, 0, 'eg2'),
          T('eg6', 'Circuit Analysis (KVL/KCL)', 3, 0, 'eg3'),
          T('eg7', 'Computer Systems (CS:APP)', 4, 0, 'eg4'),
          T('eg8', 'Signals & Systems', 4, 0, 'eg6'),
          T('eg9', 'Nand to Tetris Part 1', 5, 0, 'eg7'),
          T('eg10', 'Operating Systems Concepts', 5, 0, ['eg5', 'eg7']),
          T('eg11', 'Networking Protocols', 6, 0, 'eg5'),
          T('eg12', 'Embedded MCU (C++)', 6, 0, 'eg8'),
          T('eg13', 'Nand to Tetris Part 2', 7, 0, ['eg9', 'eg10']),
          T('eg14', 'Database Internals', 7, 0, 'eg10'),
          T('eg15', 'Code Custom RTOS in C', 8, 0, ['eg12', 'eg13']),
          T('eg16', 'Distributed Systems (DDIA)', 9, 0, ['eg11', 'eg14']),
          T('eg17', 'Build Autonomous Robot (ROS2)', 9, 0, 'eg15'),
          T('eg18', 'Deploy Custom Full-Stack Dist. OS', 10, 0, [
            'eg16',
            'eg17',
          ]),
        ],
      },
    },
  },
  WIS: {
    label: 'Wisdom',
    color: '#c084fc',
    skills: {
      geography: {
        label: 'Geography',
        icon: '🌍',
        goal: 'Global Spatial Data Scientist',
        tree: [
          T('g1', 'Anki: 196 Nations & Capitals', 1, 0),
          T('g2', 'Anki: 196 Flags & Rivers', 2, 0, 'g1'),
          T('g3', 'Physical Geography', 2, 0, 'g1'),
          T('g4', 'Prisoners of Geography', 3, 0, 'g1'),
          T('g5', 'Human Demographics', 3, 0, 'g3'),
          T('g6', 'QGIS & ArcMap Basics', 4, 0, ['g3', 'g5']),
          T('g7', 'Guns, Germs, and Steel', 4, 0, 'g4'),
          T('g8', 'Spatial SQL & PostGIS', 5, 0, 'g6'),
          T('g9', 'The Silk Roads', 5, 0, 'g7'),
          T('g10', "Dictator's Handbook", 5, 0, 'g4'),
          T('g11', 'Python for Geospatial Data', 6, 0, 'g8'),
          T('g12', 'Global Supply Chain Mapping', 6, 0, ['g8', 'g5']),
          T('g13', 'The Grand Chessboard', 7, 0, ['g9', 'g10']),
          T('g14', 'Revenge of Geography', 7, 0, 'g13'),
          T('g15', 'Remote Sensing & Satellite Imagery', 8, 0, 'g11'),
          T('g16', 'Publish Geopolitical Forecast Model', 9, 0, ['g12', 'g14']),
          T('g17', 'Create Global Trade Data Dashboard', 10, 0, 'g15'),
        ],
      },
      history: {
        label: 'History',
        icon: '📜',
        goal: 'Master Historian & Archival Synthesis',
        tree: [
          T('h1', 'Historiography Methods', 1, 0),
          T('h2', 'Durant: Antiquity (Vol 1-3)', 2, 0, 'h1'),
          T('h3', 'Durant: Middle Ages (Vol 4-6)', 3, 0, 'h2'),
          T('h4', 'Durant: Modern Era (Vol 7-11)', 4, 0, 'h3'),
          T('h5', 'Sapiens (Harari)', 2, 0, 'h1'),
          T('h6', 'SPQR (Rome)', 3, 0, 'h2'),
          T('h7', 'The Sleepwalkers (WW1)', 5, 0, 'h4'),
          T('h8', 'The Second World War (Keegan)', 5, 0, 'h4'),
          T('h9', 'Cold War (Gaddis)', 6, 0, 'h8'),
          T('h10', 'A Farewell to Alms (Econ Hist)', 6, 0, 'h4'),
          T('h11', 'Extract/Translate 10 Primary Sources', 7, 0, 'h1'),
          T('h12', 'Lessons of History (Durant)', 8, 0, ['h7', 'h9', 'h10']),
          T('h13', 'Write 5,000-word Era Synthesis', 9, 0, 'h11'),
          T('h14', 'Master of Archival Research', 10, 0, 'h13'),
          T('h15', 'Publish 10,000-word Sourced Monograph', 11, 0, [
            'h12',
            'h14',
          ]),
        ],
      },
      business: {
        label: 'Business',
        icon: '📊',
        goal: 'Institutional Hedge Fund Modeler',
        tree: [
          T('b1', 'Personal Finance (FIRE)', 1, 0),
          T('b2', 'Microeconomics (Mankiw)', 2, 0),
          T('b3', 'Macroeconomics', 2, 0),
          T('b4', 'Financial Accounting', 3, 0, 'b1'),
          T('b5', 'Marketing Principles', 3, 0, 'b2'),
          T('b6', 'Corporate Finance', 4, 0, ['b4', 'b2', 'b3']),
          T('b7', 'Managerial Accounting', 4, 0, 'b4'),
          T('b8', 'CFA Level 1 Curriculum', 5, 0, 'b6'),
          T('b9', 'Competitive Strategy (Porter)', 5, 0, 'b5'),
          T('b10', 'Operations Management', 5, 0, 'b2'),
          T('b11', 'CFA Level 2 (Valuation)', 6, 0, 'b8'),
          T('b12', 'Adv Excel & VBA for Finance', 7, 0, 'b11'),
          T('b13', 'Build 3-Statement Model', 8, 0, 'b12'),
          T('b14', 'Build DCF & LBO Models', 9, 0, 'b13'),
          T('b15', 'CFA Level 3 (Portfolio Mgmt)', 10, 0, 'b11'),
          T('b16', 'Analyze 50 10-K Reports', 11, 0, 'b14'),
          T('b17', 'Manage $1M+ Simulated Portfolio', 12, 0, ['b15', 'b16']),
          T('b18', 'Write 3 Institutional Equity Reports', 13, 0, 'b17'),
        ],
      },
      socialSci: {
        label: 'Social Sci',
        icon: '🧠',
        goal: 'Behavioral Economics Pioneer',
        tree: [
          T('ss1', 'Intro to Psych & Sociology', 1, 0),
          T('ss2', 'Research Methods & Stats', 2, 0, 'ss1'),
          T('ss3', 'Biological Psych & Neuro', 3, 0, 'ss1'),
          T('ss4', 'Cognitive Psychology', 4, 0, 'ss3'),
          T('ss5', 'Social Psychology', 4, 0, 'ss1'),
          T('ss6', 'Developmental Psych', 4, 0, 'ss3'),
          T('ss7', 'Abnormal Psych (DSM-5)', 5, 0, ['ss4', 'ss6']),
          T('ss8', 'Thinking, Fast & Slow', 5, 0, 'ss5'),
          T('ss9', 'Influence (Cialdini)', 6, 0, 'ss8'),
          T('ss10', 'Moral Philosophy & Ethics', 6, 0, 'ss5'),
          T('ss11', 'Behave (Sapolsky)', 7, 0, ['ss3', 'ss9']),
          T('ss12', 'Applied Stoicism (Meditations)', 7, 0, 'ss10'),
          T('ss13', 'Design Behavioral Trial', 8, 0, ['ss2', 'ss11']),
          T('ss14', 'Data Analysis (SPSS/R)', 9, 0, 'ss13'),
          T('ss15', 'Write PhD-Level Psych Thesis', 10, 0, 'ss14'),
          T('ss16', 'Publish Paradigm-Shifting Behavioral Theory', 11, 0, [
            'ss12',
            'ss15',
          ]),
        ],
      },
    },
  },
  CHA: {
    label: 'Charisma',
    color: '#fb923c',
    skills: {
      english: {
        label: 'English',
        icon: '🔤',
        goal: 'Virtuoso Orator & Lexicographer',
        tree: [
          T('e1', 'Elements of Style', 1, 0),
          T('e2', 'Anki: 500 High-Freq GRE Words', 2, 0),
          T('e3', 'Latin & Greek Etymology', 2, 0),
          T('e4', 'Anki: Words 501-1000', 3, 0, 'e2'),
          T('e5', 'Logical Fallacies Mastery', 3, 0, 'e1'),
          T('e6', 'Classical Rhetoric (Farnsworth)', 4, 0, ['e1', 'e3']),
          T('e7', 'Anki: Words 1001-2000 (Adv/Idioms)', 4, 0, 'e4'),
          T('e8', 'Sense of Style (Pinker)', 5, 0, 'e6'),
          T('e9', 'Analyze 50 Historical Speeches', 6, 0, 'e6'),
          T('e10', 'Write 10 Persuasive Long-form Essays', 7, 0, [
            'e7',
            'e8',
            'e5',
          ]),
          T('e11', 'Toastmasters Competent Communicator', 8, 0, 'e9'),
          T('e12', 'Cognitive Linguistics', 9, 0, 'e7'),
          T('e13', 'Impromptu Speaking Mastery', 9, 0, 'e11'),
          T('e14', 'Deliver 20-Min Keynote (No Notes)', 10, 0, ['e10', 'e13']),
          T('e15', 'Publish Critically Acclaimed Essay', 11, 0, 'e12'),
        ],
      },
      turkish: {
        label: 'Turkish',
        icon: '🇹🇷',
        goal: 'C2 Simultaneous Interpretation',
        tree: [
          T('tr1', 'Phonology & Vowel Harmony', 1, 0),
          T('tr2', 'A1: Core 500 Words & Present Tense', 2, 0, 'tr1'),
          T('tr3', 'A2: 1000 Words & Past/Future', 3, 0, 'tr2'),
          T('tr4', 'B1: 2500 Words & Noun Cases', 4, 0, 'tr3'),
          T('tr5', 'B2: Suffix Chains & Conditionals', 5, 0, 'tr4'),
          T('tr6', 'Relative Clauses Mastery', 6, 0, 'tr5'),
          T('tr7', 'iTalki: 20 Hrs 1-on-1 Practice', 7, 0, 'tr4'),
          T('tr8', 'VCE Exams: Pass 5 Papers (>85%)', 8, 0, 'tr6'),
          T('tr9', 'Consume 50 Hrs Turkish Media (No Subs)', 8, 0, 'tr5'),
          T('tr10', 'C1: Read Orhan Pamuk Natively', 9, 0, ['tr8', 'tr9']),
          T('tr11', 'iTalki: 100 Hrs Conversation', 10, 0, 'tr7'),
          T('tr12', 'Write 10 C1-Level Essays', 10, 0, 'tr10'),
          T('tr13', 'C2 Official Certification', 11, 0, ['tr11', 'tr12']),
          T('tr14', 'Real-time Simultaneous Interpretation', 12, 0, 'tr13'),
        ],
      },
      japanese: {
        label: 'Japanese',
        icon: '🇯🇵',
        goal: 'JLPT N1 & Keigo Mastery',
        tree: [
          T('j1', 'Perfect Kana Pronunciation', 1, 0),
          T('j2', 'Genki I Grammar', 2, 0, 'j1'),
          T('j3', 'RTK: Kanji 1-500', 2, 0, 'j1'),
          T('j4', 'Genki II Grammar', 3, 0, 'j2'),
          T('j5', 'RTK: Kanji 501-1000', 3, 0, 'j3'),
          T('j6', 'Pass JLPT N4 Mock Exam', 4, 0, ['j4', 'j5']),
          T('j7', 'Tobira (Advanced Gateway)', 5, 0, 'j6'),
          T('j8', 'RTK: All 2200 Joyo Kanji', 5, 0, 'j5'),
          T('j9', 'Anki: Core 2k Vocab', 5, 0, 'j6'),
          T('j10', 'Pass JLPT N3 Mock Exam', 6, 0, ['j7', 'j8', 'j9']),
          T('j11', 'Anki: Core 6k Vocab', 7, 0, 'j9'),
          T('j12', 'Read 10 Manga Volumes', 7, 0, 'j10'),
          T('j13', 'Shin Kanzen Master N2', 8, 0, 'j10'),
          T('j14', 'Pass JLPT N2 Official', 9, 0, ['j11', 'j12', 'j13']),
          T('j15', 'Business Honorifics (Keigo)', 10, 0, 'j14'),
          T('j16', '100 Hrs Native Shadowing/Speaking', 10, 0, 'j14'),
          T('j17', 'Pass JLPT N1 Official', 11, 0, 'j16'),
          T('j18', 'Native Literary & Classical Comprehension', 12, 0, [
            'j15',
            'j17',
          ]),
        ],
      },
      khmer: {
        label: 'Khmer',
        icon: '🇰🇭',
        goal: 'C2 Literary & Conversational Fluency',
        tree: [
          T('kh1', 'Alphabet & Dependent Vowels', 1, 0),
          T('kh2', 'Subscript Consonants & Tones', 2, 0, 'kh1'),
          T('kh3', 'A1: SVO Syntax & 300 Words', 3, 0, 'kh2'),
          T('kh4', 'A2: Classifiers & Tense Markers', 4, 0, 'kh3'),
          T('kh5', 'B1: 1500 Core Words', 5, 0, 'kh4'),
          T('kh6', 'Read Basic Signs & Menus', 5, 0, 'kh2'),
          T('kh7', 'iTalki: 20 Hrs Tutor Practice', 6, 0, 'kh5'),
          T('kh8', 'B2: Complex Sentence Structures', 7, 0, 'kh5'),
          T('kh9', 'Read Native News Articles', 8, 0, ['kh6', 'kh8']),
          T('kh10', 'Formal & Royal Register', 9, 0, 'kh8'),
          T('kh11', '100 Hrs Media/News Consumption', 9, 0, 'kh9'),
          T('kh12', 'iTalki: 100 Hrs Fluency Practice', 10, 0, 'kh7'),
          T('kh13', 'Read Traditional Literature', 11, 0, 'kh10'),
          T('kh14', 'C2 Real-Time Interpretation', 12, 0, [
            'kh11',
            'kh12',
            'kh13',
          ]),
        ],
      },
      musicTheory: {
        label: 'Music Theory',
        icon: '🎼',
        goal: 'Symphonic Composer',
        tree: [
          T('mt1', 'Pitch, Rhythm, Clefs', 1, 0),
          T('mt2', 'Major & Minor Scales', 2, 0, 'mt1'),
          T('mt3', 'Intervals (Simple/Compound)', 3, 0, 'mt2'),
          T('mt4', 'Triads & Inversions', 4, 0, 'mt3'),
          T('mt5', 'ABRSM Grade 5 Prep (Cadences/Transposition)', 5, 0, 'mt4'),
          T('mt6', 'Pass ABRSM Grade 5 Theory', 6, 0, 'mt5'),
          T('mt7', 'Seventh Chords & Figured Bass', 7, 0, 'mt6'),
          T('mt8', 'Advanced Harmony (Chorale)', 8, 0, 'mt7'),
          T('mt9', 'Species Counterpoint (Fux)', 9, 0, 'mt8'),
          T('mt10', 'Pass ABRSM Grade 8 Theory', 10, 0, 'mt8'),
          T('mt11', 'Sonata & Fugue Form Analysis', 11, 0, 'mt9'),
          T('mt12', 'Orchestration (Adler)', 12, 0, 'mt11'),
          T('mt13', 'Compose Original String Quartet', 13, 0, 'mt11'),
          T('mt14', 'Compose & Premiere Full Symphony', 14, 0, [
            'mt12',
            'mt13',
          ]),
        ],
      },
      piano: {
        label: 'Piano',
        icon: '🎹',
        goal: 'Virtuoso Concerto Soloist',
        tree: [
          T('p1', 'Ergonomics & Hand Shape', 1, 0),
          T('p2', 'Sight Reading Level 1', 2, 0, 'p1'),
          T('p3', 'Major Scales (2 Octaves)', 3, 0, 'p1'),
          T('p4', 'Minor Scales & Arpeggios', 4, 0, 'p3'),
          T('p5', 'Hanon: Exercises 1-20', 4, 0, 'p3'),
          T('p6', 'Bach: 3 Two-Part Inventions', 5, 0, 'p4'),
          T('p7', 'Seventh Chords & Voicings', 5, 0, 'p2'),
          T('p8', 'Pedaling (Syncopated/Una Corda)', 6, 0, 'p5'),
          T('p9', 'Czerny: School of Velocity', 6, 0, 'p5'),
          T('p10', 'Classical: Full Mozart/Haydn Sonata', 7, 0, ['p6', 'p7']),
          T('p11', 'Romantic: Chopin Nocturne/Waltz', 8, 0, ['p8', 'p10']),
          T('p12', 'Polyrhythms & Independence', 9, 0, 'p9'),
          T('p13', 'ABRSM Grade 8 Sight Reading', 10, 0, 'p2'),
          T('p14', 'Pass ABRSM Grade 8 Practical', 11, 0, ['p11', 'p13']),
          T('p15', 'Impressionist: Ravel/Debussy', 12, 0, 'p14'),
          T('p16', '1-Hour Memorized Solo Recital', 13, 0, 'p15'),
          T('p17', 'Perform Concerto with Live Orchestra', 14, 0, [
            'p12',
            'p16',
          ]),
        ],
      },
      singing: {
        label: 'Singing',
        icon: '🎤',
        goal: 'Grammy-Level Vocal Master',
        tree: [
          T('v1', 'Diaphragmatic Breathing', 1, 0),
          T('v2', 'Perfect Pitch Matching', 2, 0, 'v1'),
          T('v3', 'Chest Voice Support', 3, 0, 'v2'),
          T('v4', 'Head Voice & Falsetto', 3, 0, 'v2'),
          T('v5', 'Diction & Vowel Modification', 4, 0, 'v3'),
          T('v6', 'Find the Mixed Voice (Passaggio)', 5, 0, ['v3', 'v4']),
          T('v7', 'Vibrato Development', 6, 0, 'v6'),
          T('v8', 'Vocal Agility & Melisma', 7, 0, 'v6'),
          T('v9', 'Dynamic Control (Messa di Voce)', 8, 0, 'v7'),
          T('v10', 'Genre Versatility (Opera/Pop/Jazz)', 9, 0, ['v5', 'v8']),
          T('v11', 'Studio Mic Tech & Production', 10, 0, 'v9'),
          T('v12', 'Teach 5 Students to Mix', 11, 0, 'v6'),
          T('v13', 'Lead Role in Major Musical/Opera', 12, 0, 'v10'),
          T('v14', 'Produce 10 Original Studio Tracks', 13, 0, 'v11'),
          T('v15', 'World-Class/Grammy-Caliber Acclaim', 14, 0, [
            'v12',
            'v13',
            'v14',
          ]),
        ],
      },
    },
  },
  DEX: {
    label: 'Dexterity',
    color: '#4ade80',
    skills: {
      drawing: {
        label: 'Drawing',
        icon: '✏️',
        goal: 'Solo Gallery Exhibition',
        tree: [
          T('d1', 'Drawabox: Line & Ghosting', 1, 0),
          T('d2', '2D Shapes & Proportion', 2, 0, 'd1'),
          T('d3', '3D Forms (Boxes/Cylinders)', 3, 0, 'd2'),
          T('d4', '1 & 2 Point Perspective', 4, 0, 'd3'),
          T('d5', 'Value Scales & Light Logic', 4, 0, 'd3'),
          T('d6', 'Figure Gesture (30s Poses)', 5, 0, 'd3'),
          T('d7', '3-Point Persp & Foreshortening', 6, 0, 'd4'),
          T('d8', 'Proko Anatomy 1 (Skeleton)', 6, 0, 'd6'),
          T('d9', 'Color Theory (Gurney)', 7, 0, 'd5'),
          T('d10', 'Proko Anatomy 2 (Muscles)', 8, 0, 'd8'),
          T('d11', 'Anatomy 3 (Hands/Feet/Faces)', 9, 0, 'd10'),
          T('d12', 'Material Rendering', 10, 0, ['d9', 'd7']),
          T('d13', 'Master Composition & Storytelling', 11, 0, 'd12'),
          T('d14', 'Create 20-Piece Portfolio', 12, 0, ['d11', 'd13']),
          T('d15', 'Work as Professional Art Director', 13, 0, 'd14'),
          T('d16', 'Host Solo Gallery Original Exhibition', 14, 0, 'd15'),
        ],
      },
      writing: {
        label: 'Writing',
        icon: '🖊',
        goal: 'NYT Bestselling Novelist',
        tree: [
          T('w1', 'Grammar & Punctuation', 1, 0),
          T('w2', 'Read 50 Masterpieces', 2, 0, 'w1'),
          T('w3', 'Write 10 Short Stories', 3, 0, 'w2'),
          T('w4', 'Narrative Design (Save the Cat)', 4, 0, 'w3'),
          T('w5', 'Draft: 50,000 Words (NaNoWriMo)', 5, 0, 'w4'),
          T('w6', 'On Writing (King)', 6, 0, 'w5'),
          T('w7', 'Draft: 100,000 Word Epic', 7, 0, 'w6'),
          T('w8', 'Developmental Editing', 8, 0, 'w7'),
          T('w9', 'On Writing Well (Zinsser)', 9, 0, 'w8'),
          T('w10', 'Line Editing & Prose Polish', 10, 0, 'w9'),
          T('w11', 'Beta Reader Feedback Revisions', 11, 0, 'w10'),
          T('w12', 'Write Query Letter & Synopsis', 12, 0, 'w11'),
          T('w13', 'Secure Traditional Literary Agent', 13, 0, 'w12'),
          T('w14', 'Publish via Major Publishing House', 14, 0, 'w13'),
          T('w15', 'Achieve NYT Bestseller Status', 15, 0, 'w14'),
        ],
      },
      cooking: {
        label: 'Cooking',
        icon: '🍳',
        goal: 'Michelin-Star Exec Chef',
        tree: [
          T('c1', 'Food Safety (ServSafe)', 1, 0),
          T('c2', 'Knife Skills (Julienne/Brunoise)', 2, 0, 'c1'),
          T('c3', 'Heat Control (Maillard)', 3, 0, 'c2'),
          T('c4', 'Flavor Balance (Salt, Fat, Acid, Heat)', 4, 0, 'c3'),
          T('c5', 'Stocks (White/Brown/Veg)', 5, 0, 'c2'),
          T('c6', 'The 5 French Mother Sauces', 6, 0, ['c4', 'c5']),
          T('c7', 'Baking Basics (Hydration/Yeast)', 6, 0, 'c4'),
          T('c8', 'Vegetable Techniques (Roast/Braise)', 7, 0, 'c4'),
          T('c9', 'Protein Fabrication & Cooking', 8, 0, 'c6'),
          T('c10', 'Emulsions & Vinaigrettes', 8, 0, 'c6'),
          T('c11', 'Modernist (Sous-vide/Ferment)', 9, 0, 'c9'),
          T('c12', 'Develop 20 Signature Dishes', 10, 0, ['c8', 'c10', 'c11']),
          T('c13', 'Design 10-Course Tasting Menu', 11, 0, 'c12'),
          T('c14', 'Lead High-Volume Restaurant Line', 12, 0, 'c13'),
          T('c15', 'Exec Chef at Michelin-Caliber Kitchen', 13, 0, 'c14'),
        ],
      },
      mechanics: {
        label: 'Mechanics',
        icon: '🔧',
        goal: 'ASE Master & GC Builder',
        tree: [
          T('m1', 'OSHA Safety & Tool ID', 1, 0),
          T('m2', 'Auto: Fluids, Filters, Batteries', 2, 0, 'm1'),
          T('m3', 'Home: Drywall & Painting', 2, 0, 'm1'),
          T('m4', 'Auto: Brakes & Suspension', 3, 0, 'm2'),
          T('m5', 'Home: Plumbing Code (Rough-in)', 3, 0, 'm3'),
          T('m6', 'Auto: OBD2 & Sensor Diagnostics', 4, 0, 'm4'),
          T('m7', 'Home: Electrical Code (Panels)', 4, 0, 'm5'),
          T('m8', 'Auto: Timing Belts & Cooling', 5, 0, 'm6'),
          T('m9', 'Home: Framing & Foundation', 5, 0, 'm7'),
          T('m10', 'Auto: Full Engine/Trans Rebuild', 6, 0, 'm8'),
          T('m11', 'Home: Full Room Gut & Reno', 6, 0, 'm9'),
          T('m12', 'Auto: Pass ASE Master Tech Exam', 7, 0, 'm10'),
          T('m13', 'Home: Pass GC License Exam', 7, 0, 'm11'),
          T('m14', 'Build Code-Compliant House from Scratch', 8, 0, [
            'm12',
            'm13',
          ]),
        ],
      },
      memory: {
        label: 'Memory',
        icon: '🧩',
        goal: 'Int. Grandmaster of Memory',
        tree: [
          T('mem1', 'Spaced Repetition (Anki 365 Days)', 1, 0),
          T('mem2', 'Linking & Story Method', 2, 0, 'mem1'),
          T('mem3', 'Build 5 Memory Palaces (100 loci)', 3, 0, 'mem2'),
          T('mem4', 'Master Major System (00-99)', 4, 0, 'mem3'),
          T('mem5', 'Build PAO System', 5, 0, 'mem4'),
          T('mem6', 'Expand to 20 Palaces (500 loci)', 6, 0, 'mem3'),
          T('mem7', 'Names & Faces (50 in 15m)', 7, 0, 'mem6'),
          T('mem8', 'Cards: 1 Deck in <3 mins', 8, 0, ['mem5', 'mem6']),
          T('mem9', 'Numbers: 500 Digits in 1 Hr', 9, 0, 'mem5'),
          T('mem10', 'Cards: 10 Decks in 1 Hr', 10, 0, 'mem8'),
          T('mem11', 'Abstract Images & Binary Drills', 11, 0, 'mem9'),
          T('mem12', 'Compete in Official IAM Event', 12, 0, [
            'mem7',
            'mem10',
            'mem11',
          ]),
          T('mem13', 'Achieve Int. Grandmaster of Memory', 13, 0, 'mem12'),
        ],
      },
      karate: {
        label: 'Karate',
        icon: '🥋',
        goal: 'Godan (5th Dan) Founder',
        tree: [
          T('k1', 'Dojo Etiquette & Basic Stances', 1, 0),
          T('k2', 'Kihon: Punches, Kicks, Blocks', 2, 0, 'k1'),
          T('k3', 'Heian Katas 1-3', 3, 0, 'k2'),
          T('k4', 'Yakusoku Kumite (Pre-arranged)', 4, 0, 'k2'),
          T('k5', 'Heian Katas 4-5 & Tekki Shodan', 5, 0, 'k3'),
          T('k6', 'Jiyu Kumite (Free Sparring)', 6, 0, 'k4'),
          T('k7', 'Adv Kata (Bassai Dai, Jion)', 7, 0, 'k5'),
          T('k8', 'Bunkai (Practical App)', 8, 0, 'k7'),
          T('k9', '100+ Kumite Matches Won', 9, 0, 'k6'),
          T('k10', 'Pass Shodan (1st Dan) Grading', 10, 0, ['k8', 'k9']),
          T('k11', 'Teach Kohai (Sempai Status)', 11, 0, 'k10'),
          T('k12', 'Pass Sandan (3rd Dan)', 12, 0, 'k11'),
          T('k13', 'Master Weapons (Bo/Sai)', 13, 0, 'k12'),
          T('k14', 'Achieve Godan (5th Dan) & Open Dojo', 14, 0, 'k13'),
        ],
      },
    },
  },
};

function layoutNodes(nodes) {
  const tiers = {};
  let maxTier = 1;
  nodes.forEach((n) => {
    if (!tiers[n.tier]) tiers[n.tier] = [];
    tiers[n.tier].push(n);
    if (n.tier > maxTier) maxTier = n.tier;
  });
  const positioned = {};
  Object.entries(tiers).forEach(([tier, tNodes]) => {
    const t = Number(tier),
      count = tNodes.length;
    const baseY = maxTier === 1 ? 0.5 : 0.08 + ((t - 1) / (maxTier - 1)) * 0.84;
    tNodes.forEach((n, i) => {
      const xSpread = Math.min(0.85, 0.25 + count * 0.12),
        xStart = (1 - xSpread) / 2;
      positioned[n.id] = {
        ...n,
        x: count === 1 ? 0.5 : xStart + (i / (count - 1)) * xSpread,
        y: baseY,
      };
    });
  });
  return Object.values(positioned);
}

function Stars({ count = 250 }) {
  const s = useRef(
    Array.from({ length: count }, () => ({
      x: Math.random() * 100,
      y: Math.random() * 100,
      sz: Math.random() * 1.8 + 0.2,
      o: Math.random() * 0.6 + 0.1,
      d: Math.random() * 5 + 2,
      dl: Math.random() * 5,
      h: Math.random() > 0.93 ? (Math.random() > 0.5 ? 210 : 35) : 0,
    }))
  ).current;
  return (
    <div
      style={{
        position: 'absolute',
        inset: 0,
        overflow: 'hidden',
        pointerEvents: 'none',
      }}
    >
      {s.map((st, i) => (
        <div
          key={i}
          style={{
            position: 'absolute',
            left: `${st.x}%`,
            top: `${st.y}%`,
            width: st.sz,
            height: st.sz,
            borderRadius: '50%',
            background: st.h ? `hsl(${st.h},80%,82%)` : '#fff',
            opacity: st.o,
            animation: `tw ${st.d}s ease-in-out ${st.dl}s infinite alternate`,
            boxShadow:
              st.sz > 1.4
                ? `0 0 ${st.sz * 3}px ${
                    st.h ? `hsl(${st.h},70%,65%)` : '#fff3'
                  }`
                : 'none',
          }}
        />
      ))}
    </div>
  );
}

function Ring({ p, color, size, sw = 2 }) {
  const r = (size - sw) / 2,
    c = 2 * Math.PI * r;
  return (
    <svg
      width={size}
      height={size}
      style={{ position: 'absolute', top: 0, left: 0 }}
    >
      <circle
        cx={size / 2}
        cy={size / 2}
        r={r}
        fill="none"
        stroke={color + '18'}
        strokeWidth={sw}
      />
      <circle
        cx={size / 2}
        cy={size / 2}
        r={r}
        fill="none"
        stroke={color}
        strokeWidth={sw}
        strokeDasharray={c}
        strokeDashoffset={c * (1 - p)}
        strokeLinecap="round"
        transform={`rotate(-90 ${size / 2} ${size / 2})`}
        style={{ transition: 'stroke-dashoffset 0.8s' }}
      />
    </svg>
  );
}

function ConstellationSubTree({
  skill,
  color,
  progressState,
  onToggleNode,
  onBack,
  dims,
}) {
  const [hovered, setHovered] = useState(null);
  const nodes = useMemo(
    () =>
      layoutNodes(skill.tree).map((n) => ({
        ...n,
        progress:
          progressState[n.id] !== undefined ? progressState[n.id] : n.progress,
      })),
    [skill, progressState]
  );
  const avg = nodes.reduce((s, n) => s + n.progress, 0) / nodes.length;
  const nodeMap = {};
  nodes.forEach((n) => (nodeMap[n.id] = n));
  const maxTier = Math.max(...nodes.map((n) => n.tier));
  const containerHeight = Math.max(dims.h, maxTier * 120 + 100);
  const dynamicTiers = Array.from({ length: maxTier }, (_, i) => ({
    t: i + 1,
    y: maxTier === 1 ? 0.5 : 0.08 + (i / (maxTier - 1)) * 0.84,
    l: `TIER ${i + 1}`,
  }));
  const nodeSize = dims.w < 500 ? 20 : 26;
  const pad = { x: 50, y: 60 };
  const areaW = dims.w - pad.x * 2;
  const areaH = containerHeight - pad.y * 2;

  return (
    <div
      style={{
        position: 'absolute',
        inset: 0,
        overflow: 'hidden',
        display: 'flex',
        flexDirection: 'column',
      }}
    >
      <div
        style={{
          padding: '12px 18px',
          display: 'flex',
          alignItems: 'center',
          gap: 10,
          zIndex: 100,
          background: `linear-gradient(to bottom, #080b20ee, #080b20cc)`,
          borderBottom: `1px solid ${color}33`,
        }}
      >
        <button
          onClick={onBack}
          style={{
            background: 'none',
            border: `1px solid ${color}44`,
            color,
            cursor: 'pointer',
            padding: '4px 12px',
            borderRadius: 6,
            fontFamily: "'Cinzel',serif",
            fontSize: 11,
          }}
        >
          ← Back
        </button>
        <span style={{ fontSize: 22 }}>{skill.icon}</span>
        <div style={{ flex: 1 }}>
          <div
            style={{
              color,
              fontFamily: "'Cinzel',serif",
              fontSize: 16,
              fontWeight: 600,
            }}
          >
            {skill.label}
          </div>
          <div
            style={{
              fontSize: 10,
              color: '#fff7',
              fontFamily: "'Raleway',sans-serif",
            }}
          >
            {skill.goal}
          </div>
        </div>
        <div style={{ textAlign: 'right' }}>
          <div
            style={{
              fontSize: 8,
              color: '#fff4',
              fontFamily: "'Raleway',sans-serif",
              letterSpacing: 1.5,
            }}
          >
            MASTERY
          </div>
          <div
            style={{
              fontSize: 20,
              color,
              fontWeight: 700,
              fontFamily: "'Cinzel',serif",
            }}
          >
            {Math.round(avg * 100)}%
          </div>
        </div>
      </div>
      <div
        style={{
          flex: 1,
          overflowY: 'auto',
          overflowX: 'hidden',
          scrollbarWidth: 'none',
          position: 'relative',
        }}
      >
        <div
          style={{
            position: 'relative',
            width: '100%',
            height: containerHeight,
          }}
        >
          {dynamicTiers.map((t) => (
            <div
              key={t.t}
              style={{
                position: 'absolute',
                left: 12,
                top: pad.y + t.y * areaH - 6,
                fontSize: 9,
                color: `${color}22`,
                fontFamily: "'Raleway',sans-serif",
                letterSpacing: 3,
                writingMode: 'vertical-rl',
                transform: 'rotate(180deg)',
              }}
            >
              {t.l}
            </div>
          ))}
          <svg
            style={{
              position: 'absolute',
              inset: 0,
              width: '100%',
              height: '100%',
              pointerEvents: 'none',
              zIndex: 2,
            }}
          >
            <defs>
              <filter id="glow">
                <feGaussianBlur stdDeviation="2" result="g" />
                <feMerge>
                  <feMergeNode in="g" />
                  <feMergeNode in="SourceGraphic" />
                </feMerge>
              </filter>
            </defs>
            {nodes.flatMap((n) =>
              n.requires.map((reqId) => {
                const parent = nodeMap[reqId];
                if (!parent) return null;
                const x1 = pad.x + parent.x * areaW,
                  y1 = pad.y + parent.y * areaH,
                  x2 = pad.x + n.x * areaW,
                  y2 = pad.y + n.y * areaH;
                const active = parent.progress > 0 || n.progress > 0,
                  hov = hovered === n.id || hovered === reqId;
                const cpY = y1 + (y2 - y1) / 2;
                const pathData = `M ${x1} ${y1} C ${x1} ${cpY}, ${x2} ${cpY}, ${x2} ${y2}`;
                return (
                  <path
                    key={`${reqId}-${n.id}`}
                    d={pathData}
                    fill="none"
                    stroke={color}
                    strokeWidth={hov ? 2.5 : 1.2}
                    opacity={hov ? 0.6 : active ? 0.35 : 0.08}
                    strokeDasharray={active ? 'none' : '4 6'}
                    filter={hov ? 'url(#glow)' : 'none'}
                    style={{ transition: 'all 0.3s' }}
                  />
                );
              })
            )}
          </svg>
          {nodes.map((n) => {
            const x = pad.x + n.x * areaW - nodeSize / 2,
              y = pad.y + n.y * areaH - nodeSize / 2;
            const locked = n.requires.some(
              (reqId) => (nodeMap[reqId]?.progress || 0) < 0.3
            );
            const hov = hovered === n.id,
              complete = n.progress >= 1,
              isActivelyWorking = !locked && !complete;
            return (
              <div
                key={n.id}
                onMouseEnter={() => setHovered(n.id)}
                onMouseLeave={() => setHovered(null)}
                onClick={() => onToggleNode(n.id, n.requires)}
                style={{
                  position: 'absolute',
                  left: x,
                  top: y,
                  width: nodeSize,
                  height: nodeSize,
                  zIndex: hov ? 20 : 10,
                  cursor: locked ? 'not-allowed' : 'pointer',
                  opacity: locked ? 0.25 : 1,
                  transition: 'all 0.3s',
                  transform: hov ? 'scale(1.4)' : 'scale(1)',
                }}
              >
                {isActivelyWorking && (
                  <div
                    style={{
                      position: 'absolute',
                      inset: -4,
                      borderRadius: '50%',
                      background: `radial-gradient(circle, ${color}44, transparent)`,
                      animation: 'pulse 2s infinite alternate',
                      zIndex: 0,
                      pointerEvents: 'none',
                    }}
                  />
                )}
                <Ring
                  p={n.progress}
                  color={color}
                  size={nodeSize}
                  sw={nodeSize < 24 ? 1.5 : 2}
                />
                <div
                  style={{
                    position: 'absolute',
                    inset: nodeSize < 24 ? 2 : 3,
                    borderRadius: '50%',
                    zIndex: 2,
                    background: complete
                      ? `radial-gradient(circle, ${color}88, ${color}33)`
                      : isActivelyWorking
                      ? `radial-gradient(circle, ${color}33, ${color}0a)`
                      : `radial-gradient(circle, #ffffff0d, #ffffff05)`,
                    border: `1px solid ${color}${
                      complete ? 'aa' : isActivelyWorking ? '66' : '18'
                    }`,
                    boxShadow: hov
                      ? `0 0 20px ${color}55, 0 0 40px ${color}22`
                      : complete
                      ? `0 0 15px ${color}55`
                      : isActivelyWorking
                      ? `0 0 8px ${color}33`
                      : 'none',
                    transition: 'all 0.3s',
                  }}
                >
                  {complete && (
                    <div
                      style={{
                        position: 'absolute',
                        inset: 0,
                        display: 'flex',
                        alignItems: 'center',
                        justifyContent: 'center',
                        fontSize: nodeSize < 24 ? 8 : 12,
                        color: '#fff',
                        textShadow: `0 0 5px ${color}`,
                      }}
                    >
                      ✦
                    </div>
                  )}
                </div>
                <div
                  style={{
                    position: 'absolute',
                    top: nodeSize + 6,
                    left: '50%',
                    transform: 'translateX(-50%)',
                    fontSize: hov ? 11 : 9,
                    color: hov
                      ? '#ffffff'
                      : locked
                      ? '#fff4'
                      : isActivelyWorking
                      ? '#fff'
                      : '#ffffffaa',
                    fontFamily: "'Raleway',sans-serif",
                    fontWeight: hov || isActivelyWorking ? 600 : 400,
                    textShadow:
                      hov || isActivelyWorking ? `0 0 8px ${color}aa` : 'none',
                    transition: 'all 0.3s',
                    maxWidth: 180,
                    textAlign: 'center',
                    lineHeight: 1.2,
                    pointerEvents: 'none',
                  }}
                >
                  {locked ? '🔒 ' : ''}
                  {n.label}
                </div>
                {hov && (
                  <div
                    style={{
                      position: 'absolute',
                      bottom: nodeSize + 10,
                      left: '50%',
                      transform: 'translateX(-50%)',
                      background: '#0d0f1aee',
                      border: `1px solid ${color}66`,
                      borderRadius: 8,
                      padding: '8px 12px',
                      whiteSpace: 'nowrap',
                      zIndex: 100,
                      boxShadow: `0 0 25px ${color}22, 0 4px 16px #00000088`,
                      backdropFilter: 'blur(12px)',
                      pointerEvents: 'none',
                    }}
                  >
                    <div
                      style={{ display: 'flex', gap: 8, alignItems: 'center' }}
                    >
                      <span
                        style={{
                          fontSize: 11,
                          color,
                          fontWeight: 600,
                          fontFamily: "'Cinzel',serif",
                        }}
                      >
                        {Math.round(n.progress * 100)}%
                      </span>
                      <div
                        style={{
                          width: 60,
                          height: 3,
                          background: '#fff1',
                          borderRadius: 2,
                        }}
                      >
                        <div
                          style={{
                            width: `${n.progress * 100}%`,
                            height: '100%',
                            background: color,
                            borderRadius: 2,
                            boxShadow: `0 0 5px ${color}`,
                          }}
                        />
                      </div>
                    </div>
                    {n.requires.length > 0 && (
                      <div
                        style={{
                          fontSize: 8,
                          color: '#fff6',
                          marginTop: 4,
                          fontFamily: "'Raleway',sans-serif",
                        }}
                      >
                        Requires:{' '}
                        {n.requires
                          .map(
                            (reqId) =>
                              nodeMap[reqId]?.label.substring(0, 25) + '...'
                          )
                          .join(' & ')}
                      </div>
                    )}
                    {locked && (
                      <div
                        style={{
                          fontSize: 8,
                          color: '#ef4444',
                          marginTop: 3,
                          fontFamily: "'Raleway',sans-serif",
                        }}
                      >
                        Complete prerequisites to unlock.
                      </div>
                    )}
                  </div>
                )}
              </div>
            );
          })}
        </div>
      </div>
    </div>
  );
}

export default function App() {
  const ref = useRef(null),
    fileInputRef = useRef(null);
  const [dims, setDims] = useState({ w: 900, h: 700 }),
    [view, setView] = useState('galaxy'),
    [activeStat, setActiveStat] = useState(null),
    [activeSkill, setActiveSkill] = useState(null),
    [hovered, setHovered] = useState(null),
    [menuOpen, setMenuOpen] = useState(false);

  const [progressState, setProgressState] = useState(() => {
    try {
      const saved = localStorage.getItem('autodidactProgress');
      if (saved) return JSON.parse(saved);
    } catch (e) {}
    const init = {};
    Object.values(DATA).forEach((s) =>
      Object.values(s.skills).forEach((sk) =>
        sk.tree.forEach((n) => (init[n.id] = n.progress))
      )
    );
    return init;
  });

  useEffect(() => {
    localStorage.setItem('autodidactProgress', JSON.stringify(progressState));
  }, [progressState]);

  const exportData = () => {
    const a = document.createElement('a');
    a.href = URL.createObjectURL(
      new Blob([JSON.stringify(progressState, null, 2)], {
        type: 'application/json',
      })
    );
    a.download = `Autodidact_Save_${
      new Date().toISOString().split('T')[0]
    }.json`;
    a.click();
    setMenuOpen(false);
  };
  const importData = (e) => {
    const file = e.target.files[0];
    if (!file) return;
    const reader = new FileReader();
    reader.onload = (e) => {
      try {
        setProgressState(JSON.parse(e.target.result));
        alert('Imported!');
      } catch {
        alert('Invalid file.');
      }
    };
    reader.readAsText(file);
    setMenuOpen(false);
  };
  const clearData = () => {
    if (window.confirm('Wipe progress?')) {
      const r = {};
      Object.keys(progressState).forEach((k) => (r[k] = 0));
      setProgressState(r);
      setMenuOpen(false);
    }
  };
  const handleToggleNode = (id, reqs) => {
    if (!reqs.some((r) => (progressState[r] || 0) < 0.3))
      setProgressState((p) => ({ ...p, [id]: p[id] >= 1 ? 0 : 1 }));
  };

  useEffect(() => {
    const obs = new ResizeObserver((e) => {
      setDims({
        w: e[0].contentRect.width,
        h: Math.max(e[0].contentRect.height, 500),
      });
    });
    if (ref.current) obs.observe(ref.current);
    return () => obs.disconnect();
  }, []);

  const totalNodes = useMemo(() => {
    let c = 0;
    Object.values(DATA).forEach((s) =>
      Object.values(s.skills).forEach((sk) => (c += sk.tree.length))
    );
    return c;
  }, []);
  const totalProgress = useMemo(() => {
    let sum = 0,
      n = 0;
    Object.values(DATA).forEach((s) =>
      Object.values(s.skills).forEach((sk) =>
        sk.tree.forEach((nd) => {
          sum += progressState[nd.id] !== undefined ? progressState[nd.id] : 0;
          n++;
        })
      )
    );
    return n ? sum / n : 0;
  }, [progressState]);
  const level = Math.floor(totalProgress * 99) + 1,
    statPos = {
      INT: { x: 0.73, y: 0.3 },
      WIS: { x: 0.27, y: 0.3 },
      CHA: { x: 0.27, y: 0.7 },
      DEX: { x: 0.73, y: 0.7 },
    };
  const getSkillPos = (sk) => {
    const skills = Object.keys(DATA[sk].skills),
      cx = statPos[sk].x,
      cy = statPos[sk].y,
      r = 0.16;
    return skills.map((s, i) => {
      const a = (i / skills.length) * Math.PI * 2 - Math.PI / 2;
      return {
        key: s,
        x: cx + Math.cos(a) * r,
        y: cy + Math.sin(a) * r * 0.85,
      };
    });
  };

  if (view === 'skill' && activeStat && activeSkill) {
    const stat = DATA[activeStat],
      skill = stat.skills[activeSkill];
    return (
      <div
        ref={ref}
        style={{
          position: 'relative',
          width: '100%',
          height: '100vh',
          minHeight: 500,
          background:
            'radial-gradient(ellipse at 40% 30%, #0f1855 0%, #080b20 40%, #050712 100%)',
          fontFamily: "'Cinzel',serif",
          overflow: 'hidden',
        }}
      >
        <link
          href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;600;700&family=Raleway:wght@300;400;500;600&display=swap"
          rel="stylesheet"
        />
        <style>{`@keyframes tw{0%{opacity:0.08}100%{opacity:0.9}} @keyframes fadeIn{from{opacity:0;transform:scale(0.95)}to{opacity:1;transform:scale(1)}} @keyframes pulse{0%{box-shadow: 0 0 0 0px ${stat.color}44} 100%{box-shadow: 0 0 0 15px transparent}}`}</style>
        <Stars count={200} />
        <div
          style={{
            position: 'absolute',
            width: 300,
            height: 300,
            borderRadius: '50%',
            pointerEvents: 'none',
            background: `radial-gradient(circle,${stat.color}08 0%,transparent 70%)`,
            left: '50%',
            top: '45%',
            transform: 'translate(-50%,-50%)',
            filter: 'blur(8px)',
          }}
        />
        <div
          style={{
            animation: 'fadeIn 0.4s ease',
            width: '100%',
            height: '100%',
          }}
        >
          <ConstellationSubTree
            skill={skill}
            color={stat.color}
            progressState={progressState}
            onToggleNode={handleToggleNode}
            onBack={() => {
              setView('galaxy');
              setActiveSkill(null);
            }}
            dims={dims}
          />
        </div>
      </div>
    );
  }

  const showingStat = view === 'stat' && activeStat;
  return (
    <div
      ref={ref}
      onClick={() => {
        if (view === 'stat') {
          setView('galaxy');
          setActiveStat(null);
        }
      }}
      style={{
        position: 'relative',
        width: '100%',
        height: '100vh',
        minHeight: 500,
        background:
          'radial-gradient(ellipse at 25% 15%, #0f1855 0%, #080b20 35%, #050712 100%)',
        overflow: 'hidden',
        fontFamily: "'Cinzel',serif",
        cursor: 'default',
        userSelect: 'none',
      }}
    >
      <link
        href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;600;700&family=Raleway:wght@300;400;500;600&display=swap"
        rel="stylesheet"
      />
      <style>{`@keyframes tw{0%{opacity:0.08}100%{opacity:0.9}} @keyframes statPulse{0%,100%{filter:brightness(1)}50%{filter:brightness(1.3)}} @keyframes shoot{0%{transform:translateX(0) translateY(0) rotate(-35deg);opacity:1}100%{transform:translateX(300px) translateY(180px) rotate(-35deg);opacity:0}}`}</style>
      <Stars count={400} />
      <div
        style={{
          position: 'absolute',
          top: '8%',
          left: '15%',
          width: 80,
          height: 1,
          background:
            'linear-gradient(to right,transparent,#fff8,#fff,transparent)',
          animation: 'shoot 4s ease-in 6s infinite',
          opacity: 0,
          pointerEvents: 'none',
        }}
      />
      <div
        style={{
          position: 'absolute',
          top: '62%',
          left: '55%',
          width: 50,
          height: 1,
          background:
            'linear-gradient(to right,transparent,#fff6,#fffc,transparent)',
          animation: 'shoot 3s ease-in 15s infinite',
          opacity: 0,
          pointerEvents: 'none',
        }}
      />
      {Object.entries(DATA).map(([k, s]) => {
        const p = statPos[k];
        return (
          <div
            key={k + 'n'}
            style={{
              position: 'absolute',
              width: 380,
              height: 380,
              borderRadius: '50%',
              pointerEvents: 'none',
              background: `radial-gradient(circle,${s.color}${
                showingStat && activeStat !== k ? '02' : '07'
              } 0%,transparent 70%)`,
              left: `${p.x * 100}%`,
              top: `${p.y * 100}%`,
              transform: 'translate(-50%,-50%)',
              transition: 'opacity 0.6s',
              filter: 'blur(4px)',
            }}
          />
        );
      })}

      <div
        style={{
          position: 'absolute',
          top: 0,
          left: 0,
          right: 0,
          padding: '14px 20px',
          display: 'flex',
          justifyContent: 'space-between',
          alignItems: 'center',
          zIndex: 50,
          background: 'linear-gradient(to bottom,#080b20dd,transparent)',
        }}
      >
        <div>
          <h1
            style={{
              margin: 0,
              fontSize: 17,
              color: '#ffffffcc',
              letterSpacing: 4,
              fontWeight: 600,
            }}
          >
            ✦ CONSTELLATION
          </h1>
          <p
            style={{
              margin: 0,
              fontSize: 9,
              color: '#ffffff44',
              fontFamily: "'Raleway',sans-serif",
              letterSpacing: 2.5,
              marginTop: 2,
            }}
          >
            {totalNodes} LIFETIME MASTERY NODES
          </p>
        </div>
        <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
          <div style={{ position: 'relative' }}>
            <button
              onClick={(e) => {
                e.stopPropagation();
                setMenuOpen(!menuOpen);
              }}
              style={{
                background: 'none',
                border: '1px solid #fff3',
                color: '#fff8',
                cursor: 'pointer',
                padding: '4px 10px',
                borderRadius: 6,
                fontFamily: "'Raleway',sans-serif",
                fontSize: 10,
              }}
            >
              Data ▾
            </button>
            {menuOpen && (
              <div
                style={{
                  position: 'absolute',
                  top: '100%',
                  right: 0,
                  marginTop: 8,
                  background: '#0d0f1aee',
                  border: '1px solid #fff3',
                  borderRadius: 8,
                  padding: 8,
                  display: 'flex',
                  flexDirection: 'column',
                  gap: 6,
                  backdropFilter: 'blur(10px)',
                  zIndex: 200,
                }}
              >
                <button
                  onClick={exportData}
                  style={{
                    background: '#ffffff11',
                    border: 'none',
                    color: '#fff',
                    padding: '6px 12px',
                    borderRadius: 4,
                    cursor: 'pointer',
                    fontSize: 10,
                    fontFamily: "'Raleway',sans-serif",
                    textAlign: 'left',
                  }}
                >
                  Export Backup (JSON)
                </button>
                <button
                  onClick={() => fileInputRef.current.click()}
                  style={{
                    background: '#ffffff11',
                    border: 'none',
                    color: '#fff',
                    padding: '6px 12px',
                    borderRadius: 4,
                    cursor: 'pointer',
                    fontSize: 10,
                    fontFamily: "'Raleway',sans-serif",
                    textAlign: 'left',
                  }}
                >
                  Import Backup
                </button>
                <input
                  type="file"
                  ref={fileInputRef}
                  onChange={importData}
                  accept=".json"
                  style={{ display: 'none' }}
                />
                <button
                  onClick={clearData}
                  style={{
                    background: '#ef444444',
                    border: 'none',
                    color: '#ff8888',
                    padding: '6px 12px',
                    borderRadius: 4,
                    cursor: 'pointer',
                    fontSize: 10,
                    fontFamily: "'Raleway',sans-serif",
                    textAlign: 'left',
                  }}
                >
                  Wipe Data
                </button>
              </div>
            )}
          </div>
          {showingStat && (
            <button
              onClick={(e) => {
                e.stopPropagation();
                setView('galaxy');
                setActiveStat(null);
              }}
              style={{
                background: 'none',
                border: '1px solid #fff3',
                color: '#fff8',
                cursor: 'pointer',
                padding: '4px 14px',
                borderRadius: 6,
                fontFamily: "'Cinzel',serif",
                fontSize: 10,
              }}
            >
              ← Galaxy
            </button>
          )}
          <div style={{ textAlign: 'right' }}>
            <div
              style={{
                fontSize: 8,
                color: '#ffffff44',
                fontFamily: "'Raleway',sans-serif",
                letterSpacing: 1.5,
              }}
            >
              LEVEL
            </div>
            <div style={{ fontSize: 20, color: '#fbbf24', fontWeight: 700 }}>
              {level}
            </div>
          </div>
          <div style={{ width: 38, height: 38, position: 'relative' }}>
            <Ring p={totalProgress} color="#fbbf24" size={38} sw={2.5} />
            <div
              style={{
                position: 'absolute',
                inset: 0,
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                fontSize: 8,
                color: '#fbbf24',
                fontFamily: "'Raleway',sans-serif",
              }}
            >
              {Math.round(totalProgress * 100)}%
            </div>
          </div>
        </div>
      </div>

      <svg
        style={{
          position: 'absolute',
          inset: 0,
          width: '100%',
          height: '100%',
          pointerEvents: 'none',
          zIndex: 1,
        }}
      >
        <defs>
          {Object.entries(DATA).map(([k, s]) => (
            <linearGradient key={k + 'g'} id={`g-${k}`}>
              <stop offset="0%" stopColor={s.color} stopOpacity="0.4" />
              <stop offset="100%" stopColor={s.color} stopOpacity="0.08" />
            </linearGradient>
          ))}
        </defs>
        {Object.entries(DATA).map(([sk, stat]) => {
          const sp = statPos[sk];
          const dimmed = showingStat && activeStat !== sk;
          return getSkillPos(sk).map((s) => (
            <line
              key={`${sk}-${s.key}`}
              x1={sp.x * dims.w}
              y1={sp.y * dims.h}
              x2={s.x * dims.w}
              y2={s.y * dims.h}
              stroke={`url(#g-${sk})`}
              strokeWidth={1.5}
              opacity={dimmed ? 0.04 : 0.35}
              strokeDasharray="3 5"
              style={{ transition: 'opacity 0.5s' }}
            />
          ));
        })}
      </svg>

      {Object.entries(DATA).map(([key, stat]) => {
        const p = statPos[key],
          dimmed = showingStat && activeStat !== key,
          active = activeStat === key,
          skills = Object.values(stat.skills);
        const avg =
            skills.reduce(
              (s, sk) =>
                s +
                sk.tree.reduce((ss, n) => ss + (progressState[n.id] || 0), 0) /
                  sk.tree.length,
              0
            ) / skills.length,
          nc = skills.reduce((s, sk) => s + sk.tree.length, 0);
        return (
          <div
            key={key}
            onClick={(e) => {
              e.stopPropagation();
              setView('stat');
              setActiveStat(key);
            }}
            style={{
              position: 'absolute',
              left: p.x * dims.w - 30,
              top: p.y * dims.h - 30,
              width: 60,
              height: 60,
              cursor: 'pointer',
              zIndex: 10,
              opacity: dimmed ? 0.12 : 1,
              transition: 'all 0.6s',
              animation: active ? 'statPulse 3s ease-in-out infinite' : 'none',
            }}
          >
            <Ring p={avg} color={stat.color} size={60} sw={3} />
            <div
              style={{
                position: 'absolute',
                inset: 5,
                borderRadius: '50%',
                background: `radial-gradient(circle at 35% 30%,${stat.color}55,${stat.color}15)`,
                border: `1.5px solid ${stat.color}77`,
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                boxShadow: active
                  ? `0 0 35px ${stat.color}44,inset 0 0 15px ${stat.color}11`
                  : `0 0 18px ${stat.color}22`,
                transition: 'box-shadow 0.5s',
              }}
            >
              <span
                style={{
                  fontSize: 14,
                  fontWeight: 700,
                  color: stat.color,
                  letterSpacing: 1.5,
                }}
              >
                {key}
              </span>
            </div>
            <div
              style={{
                position: 'absolute',
                top: 64,
                left: '50%',
                transform: 'translateX(-50%)',
                textAlign: 'center',
                whiteSpace: 'nowrap',
              }}
            >
              <div
                style={{
                  fontSize: 9,
                  color: stat.color + 'bb',
                  letterSpacing: 1.5,
                }}
              >
                {stat.label}
              </div>
              <div
                style={{
                  fontSize: 8,
                  color: '#fff3',
                  fontFamily: "'Raleway',sans-serif",
                  marginTop: 1,
                }}
              >
                {nc} milestones
              </div>
            </div>
          </div>
        );
      })}

      {Object.entries(DATA).map(([sk, stat]) => {
        const dimmed = showingStat && activeStat !== sk;
        return getSkillPos(sk).map((sp) => {
          const skill = stat.skills[sp.key],
            avg =
              skill.tree.reduce((s, n) => s + (progressState[n.id] || 0), 0) /
              skill.tree.length,
            hov = hovered === `${sk}-${sp.key}`;
          return (
            <div
              key={`${sk}-${sp.key}`}
              onClick={(e) => {
                e.stopPropagation();
                setActiveStat(sk);
                setActiveSkill(sp.key);
                setView('skill');
              }}
              onMouseEnter={() => setHovered(`${sk}-${sp.key}`)}
              onMouseLeave={() => setHovered(null)}
              style={{
                position: 'absolute',
                left: sp.x * dims.w - 18,
                top: sp.y * dims.h - 18,
                width: 36,
                height: 36,
                cursor: 'pointer',
                zIndex: 8,
                opacity: dimmed ? 0.06 : 1,
                transition: 'all 0.5s',
                transform: hov ? 'scale(1.3)' : 'scale(1)',
              }}
            >
              <Ring p={avg} color={stat.color} size={36} sw={2} />
              <div
                style={{
                  position: 'absolute',
                  inset: 3,
                  borderRadius: '50%',
                  background:
                    avg > 0.3
                      ? `radial-gradient(circle,${stat.color}33,${stat.color}11)`
                      : '#ffffff08',
                  border: `1px solid ${stat.color}${avg > 0.15 ? '44' : '22'}`,
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                  boxShadow: hov ? `0 0 18px ${stat.color}44` : 'none',
                  transition: 'box-shadow 0.3s',
                }}
              >
                <span style={{ fontSize: 13 }}>{skill.icon}</span>
              </div>
              <div
                style={{
                  position: 'absolute',
                  top: 40,
                  left: '50%',
                  transform: 'translateX(-50%)',
                  fontSize: 9,
                  color: hov ? '#ffffffcc' : '#ffffffaa',
                  whiteSpace: 'nowrap',
                  fontFamily: "'Raleway',sans-serif",
                  fontWeight: skill.special ? 600 : 400,
                  textShadow: skill.special
                    ? `0 0 8px ${stat.color}55`
                    : 'none',
                  transition: 'color 0.3s',
                }}
              >
                {skill.label}
              </div>
            </div>
          );
        });
      })}
      {view === 'galaxy' && (
        <div
          style={{
            position: 'absolute',
            top: '50%',
            left: '50%',
            transform: 'translate(-50%,-50%)',
            textAlign: 'center',
            pointerEvents: 'none',
            zIndex: 2,
          }}
        >
          <div
            style={{
              fontSize: 10,
              color: '#ffffff12',
              fontFamily: "'Raleway',sans-serif",
              letterSpacing: 3,
              lineHeight: 2.5,
            }}
          >
            CLICK A CONSTELLATION TO EXPLORE
          </div>
        </div>
      )}
    </div>
  );
}
