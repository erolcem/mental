// data/catalog_medicine.dart — the medicine constellation.
// Part of skill_data.dart: one Skill tree, governed by the catalog
// laws (see skill_data.dart + test/skill_data_test.dart). Every star:
// id, label, tier, requires, proof (completion standard), hours
// (researched effort), branch, guide (the exact work, step by step).
part of 'skill_data.dart';

final Skill medicineTree = Skill('medicine', 'Medicine', '⚕', 'Chief Attending / Diagnostician', [
      _n('md1', 'Medical Terminology + BLS/CPR', 1, null,
          'Real BLS card — open to the public', 60, 'Foundations',
          'Take an in-person American Heart Association (or Red Cross) BLS '
              'course — they are open to everyone — and drill terminology '
              'with the free Des Moines University course + a 500-card Anki '
              'deck of roots, prefixes and suffixes until 95% mature.'),
      // — Basic science spine —
      _n('md2', 'Anatomy (Netter + Anki)', 2, 'md1',
          '2,000-card Netter deck matured; limb and thorax drawn from memory',
          350, 'Basic Science',
          'Netter\'s Atlas + the free Anking anatomy subset (or Netter '
              'flashcards): 30 new cards/day with reviews until 2,000 are '
              'mature. Weekly, draw one region schematically from memory — '
              'brachial plexus, mediastinum, inguinal canal — and check.'),
      _n('md3', 'Physiology (Guyton & Hall)', 3, 'md2',
          'Self-exams per system; cardiac, renal and endocrine loops drawn '
              'from memory', 300, 'Basic Science',
          'Guyton & Hall system by system, paired with Costanzo\'s BRS for '
              'self-exams (≥80% each). After each system, draw its control '
              'loop from memory: pressure-natriuresis, RAAS, HPA axis, the '
              'cardiac cycle with pressures labelled.'),
      _n('md4', 'Medical Biochemistry (Lippincott)', 3, 'md1',
          'Pathway questions >80%; fed-vs-fasted switching explained unaided',
          200, 'Basic Science',
          'Lippincott Illustrated Biochemistry with its end-of-chapter '
              'questions >80%. Whiteboard ritual: the fed→fasted→starvation '
              'switch across liver, muscle and adipose, drawn and narrated '
              'from memory in under 15 minutes.'),
      _n('md5', 'Pathology (Robbins + Pathoma)', 4, ['md3', 'md4'],
          'Pathoma complete + Robbins MCQs', 350, 'Basic Science',
          'Sattar\'s Pathoma videos with the workbook (twice for ch. 1–3), '
              'then Robbins & Cotran review MCQs per organ system ≥75%. Keep '
              'a mechanism journal: every disease as insult → response → '
              'morphology → clinical sign.'),
      _n('md6', 'Pharmacology (Katzung + Sketchy)', 4, 'md3',
          'Drug-class Anki deck matured', 250, 'Basic Science',
          'SketchyPharm for the memory hooks + Katzung Board Review for the '
              'mechanism truth. Build/adopt a by-class Anki deck (target '
              '~1,500 mature cards): mechanism, uses, toxicities, '
              'interactions. First Aid\'s pharm section is the index.'),
      _n('md7', 'Immunology & Micro (Sketchy + Janeway)', 4, 'md4',
          'Bug/drug chart from memory', 200, 'Basic Science',
          'SketchyMicro for organisms; Janeway\'s first eight chapters for '
              'real immunology. Reproduce the classic bug↔drug wall chart '
              'from memory monthly, and explain MHC I vs II presentation '
              'unaided.'),
      _n('md8', 'First Aid for Step 1 (annotated)', 5, ['md5', 'md6', 'md7'],
          'Own annotated copy, 3 passes', 250, 'Basic Science',
          'Three full passes of First Aid, each with a different pen colour, '
              'annotating from your Pathoma/Sketchy/physiology notes. The '
              'book should end up unsellable — margins full, cross-references '
              'everywhere. Pass 3 must take under 3 weeks.'),
      _n('md9', 'UWorld Step 1 complete', 6, 'md8',
          '≥70% cumulative; every miss fed into an error deck and retired',
          400, 'Basic Science',
          '40 random-timed UWorld questions daily. Every wrong answer: read '
              'the full explanation, write one line of "why I missed it", '
              'make one Anki card. The bank is done when cumulative ≥70% and '
              'the error deck is retired.'),
      _n('md10', 'NBME Free-120', 7, 'md9',
          '≥85% (Step 1 is pass/fail since 2022 — this is the bar)', 30, 'Basic Science',
          'Sit the free NBME 120 under exact exam blocks (3×40, breaks '
              'timed). Score ≥85%. Below that: two weeks on your two worst '
              'systems with UWorld incorrects, then a purchased NBME self-'
              'assessment as the confirmatory.'),
      // — Emergency response: real certificates, open to the public —
      _n('md19', 'First Aid + Stop the Bleed', 2, 'md1',
          'Red Cross First Aid + Stop the Bleed certificates; drills logged',
          20, 'Emergency',
          'Book the Red Cross First Aid course and a Stop the Bleed session '
              '(both public, ~half a day each). Then run monthly 10-minute '
              'home drills: tourniquet on a pool noodle, recovery position '
              'on a family member, choking response sequence — logged.'),
      _n('md20', 'Wilderness First Aid (16-hr course)', 3, 'md19',
          'Certificate from a publicly bookable WFA course; scenario notes',
          20, 'Emergency',
          'Take a 16-hour NOLS/SOLO/Red Cross Wilderness First Aid weekend '
              '(open enrolment). Write up every scenario you ran — MOI, '
              'assessment, treatment, evac decision — and redo the patient-'
              'assessment sequence from memory a month later.'),
      _n('md25', 'EMT-B curriculum (self-study)', 4, 'md20',
          'Emergency Care textbook worked; 3 NREMT practice exams ≥85%; 20 '
              'scenario run-throughs logged', 150, 'Emergency',
          'Work Emergency Care (Limmer) cover to cover with the free EMT '
              'crash-course videos. Drill NREMT-style question banks to ≥85% '
              'on three full practice exams, and run 20 tabletop scenarios '
              'aloud: scene size-up → primary survey → treatment → handoff.'),
      // — Evidence & epidemiology —
      _n('md21', 'Epidemiology & Biostatistics I', 2, 'md1',
          'OpenIntro biostats problem sets; 20 abstracts: design + bias named',
          100, 'Evidence',
          'OpenIntro Biostatistics (free) with all problem sets, plus '
              'Gordis Epidemiology core chapters. Then read 20 PubMed '
              'abstracts and for each name the design, the headline measure '
              '(RR/OR/NNT) and the most dangerous bias.'),
      _n('md24', 'Nutrition & Lifestyle Medicine', 3, 'md21',
          '10 popular diet claims appraised against trials; your own 4-week '
              'n-of-1 logged', 80, 'Evidence',
          'Read a real nutrition text (Gropper\'s Advanced Nutrition, core '
              'chapters) — not influencers. Appraise 10 popular claims '
              '(keto, fasting, seed oils...) against actual RCTs/meta-'
              'analyses in writing. Run one honest 4-week n-of-1 on sleep or '
              'diet with pre-registered outcome.'),
      _n('md22', 'Critical appraisal: 10 RCTs + 5 meta-analyses', 4, 'md24',
          "CASP-checklist appraisals written; JAMA Users' Guides applied",
          60, 'Evidence',
          'Take 10 landmark RCTs (SPRINT, RECOVERY, EMPA-REG...) and 5 '
              'Cochrane meta-analyses; write a CASP-checklist appraisal for '
              'each: randomisation, blinding, ITT, fragility, funding. '
              'Conclude each with "would this change my practice?"'),
      _n('md26', 'Ethics & the hard conversation', 5, 'md22',
          'SPIKES run on 5 role-played scenarios, filmed; 10 classic ethics '
              'cases written up against the four principles', 60, 'Evidence',
          'Read Jonsen\'s Clinical Ethics and learn the SPIKES protocol for '
              'breaking bad news. Write up 10 classic cases (capacity, '
              'consent, end-of-life, resource triage) with the four-'
              'principles framework, and film yourself running SPIKES on '
              'five role-played scenarios with a friend.'),
      // — Clinical craft —
      _n('md11', 'Physical Examination (Bates)', 8, ['md10', 'md25'],
          'OSCE-style checklist performed on a volunteer', 80, 'Clinical',
          'Bates\' Guide system by system with Stanford Medicine 25 videos. '
              'Practice each exam on a willing adult until you can run a '
              'full head-to-toe in 40 minutes against an OSCE checklist '
              'without missing a step — filmed, reviewed, repeated.'),
      _n('md12', "Internal Medicine (Harrison's core)", 8, 'md10',
          'Core chapters + self-exams; a one-page schema per organ system',
          300, 'Clinical',
          'Harrison\'s Principles: the cardiology, pulmonology, GI, renal, '
              'endocrine, ID and heme/onc sections. After each: a one-page '
              'schema (chief complaints → workup trees) and the Harrison\'s '
              'self-assessment questions ≥70%.'),
      _n('md13', 'ECG Interpretation (Dubin → Marriott)', 8, 'md10',
          '100 ECGs read and checked', 80, 'Clinical',
          'Dubin\'s Rapid Interpretation twice (it is designed for two '
              'passes), then 100 real ECGs from Wave-Maven (free, answers '
              'included): systematic read aloud — rate, rhythm, axis, '
              'intervals, morphology — before checking each answer.'),
      _n('md23', 'Imaging: chest X-ray + CT basics', 8, 'md10',
          '100 CXRs read vs reports (free teaching files); Radiopaedia course',
          80, 'Clinical',
          'Radiopaedia\'s free CXR course + Felson\'s Principles. Read 100 '
              'teaching-file chest films with the ABCDE system, writing your '
              'impression BEFORE opening the report; log discrepancies and '
              'review the 10 worst monthly.'),
      _n('md27', 'Psychiatry & the Mental Status Exam', 8, 'md10',
          'MSE performed and written for 10 filmed interviews; DSM-5 criteria '
              'for 12 major disorders from memory', 120, 'Clinical',
          'First Aid for Psychiatry + the DSM-5 criteria for the 12 highest-'
              'prevalence disorders (memorised, tested by self-quiz). Watch '
              '10 published patient interviews (university teaching films) '
              'and write a full mental status exam for each.'),
      _n('md14', 'UWorld Step 2 CK complete', 9,
          ['md11', 'md12', 'md13', 'md27'],
          '≥70% cumulative; weakest three systems re-drilled to green',
          350, 'Clinical',
          'The Step 2 CK UWorld bank, 40/day timed-random, management focus: '
              'for every question write the next best step before looking. '
              'Finish ≥70% cumulative, then re-drill your three weakest '
              'systems until their blocks run green.'),
      _n('md28', 'OB/GYN + Pediatrics core', 9, 'md12',
          'Blueprints/BRS self-exams ≥75%; growth charts, milestones and the '
              'obstetric emergencies from memory', 200, 'Clinical',
          'Blueprints OB/GYN + BRS Pediatrics with every self-exam ≥75%. '
              'From memory: developmental milestones to age 5, vaccine '
              'schedule shape, the six obstetric emergencies with first '
              'moves. UWorld\'s shelf subsets as the final check.'),
      _n('md15', 'Step 2 CK mock ≥250', 10, ['md14', 'md28'],
          'NBME practice exam — Step 2 is still scored', 30, 'Clinical',
          'Sit a purchased NBME CCSSA form under full exam timing in one '
              'day. ≥250-equivalent is the bar. Under it: two weeks of '
              'incorrects-only UWorld plus your error deck, then the second '
              'NBME form — do not burn forms without fixing anything.'),
      // — Convergence: the diagnostician chain —
      _n('md16', '100 NEJM Clinical Problem-Solving cases', 11,
          ['md15', 'md26', 'md23'],
          'Written differential before each solution; ≥60% correct', 150, 'Diagnosis',
          'Work 100 NEJM CPS / JAMA Clinical Challenge cases: read the '
              'presentation, WRITE a ranked differential and next test, then '
              'read the discussion. Score yourself honestly; keep a "missed '
              'diagnosis" log organised by failure type (anchoring, rare '
              'disease, bad Bayes).'),
      _n('md17', 'MKSAP question bank (ABIM level)', 12, 'md16',
          '≥65% across the bank; every miss logged and re-answered a week on',
          250, 'Diagnosis',
          'The full MKSAP bank (ACP sells it to anyone), 20 questions/day '
              'by system. Every miss: one-line reason + re-answer after 7 '
              'days. ≥65% overall matches the passing standard of practicing '
              'internists\' recertification.'),
      _n('md18', 'Crown: attending-level case accuracy', 13, 'md17',
          '30 consecutive unseen cases, blinded scoring', 60, 'Diagnosis',
          'Have a friend pre-select 30 unseen NEJM/JAMA cases and strip the '
              'answers. Solve all 30 cold over two weeks — written ddx, '
              'tests, final diagnosis — and have them score you blind. '
              'Attending-level is ≥70% final-diagnosis accuracy.'),
]);
