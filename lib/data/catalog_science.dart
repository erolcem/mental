// data/catalog_science.dart — the science constellation.
// Part of skill_data.dart: one Skill tree, governed by the catalog
// laws (see skill_data.dart + test/skill_data_test.dart). Every star:
// id, label, tier, requires, proof (completion standard), hours
// (researched effort), branch, guide (the exact work, step by step).
part of 'skill_data.dart';

final Skill scienceTree = Skill('science', 'Physics & Chem', '⚗', 'Publish an Original Scientific Result', [
      _n('sc1', 'Foundations: AP Physics C & AP Chemistry', 1, null,
          '≥4-equivalent on released AP exams, self-timed', 400, 'Foundations',
          'Work Halliday/Resnick + Zumdahl alongside the free AP Physics C and '
              'AP Chemistry courses on Khan Academy. Daily: one topic + every '
              'end-of-section problem on paper. Finish with two released AP '
              'exams each, full exam conditions, self-scored.'),
      // — Physics —
      _n('sc2', 'Classical Mechanics (Taylor)', 2, 'sc1',
          '150+ worked problems incl. the Lagrangian chapter', 350, 'Physics',
          'Read Taylor ch. 1–13 with a problems-first rule: attempt before '
              'reading the section\'s examples. Keep every solution in one '
              'numbered notebook; redo any problem you needed the solution '
              'manual for one week later, cold.'),
      _n('sc4', 'Electromagnetism (Griffiths)', 3, ['sc2', 'sc19'],
          'All in-chapter problems through ch. 9', 350, 'Physics',
          'Griffiths Electrodynamics ch. 1–9. Do every in-chapter problem the '
              'day you read the section. Derive the boundary conditions and '
              'wave equation yourself before each chapter summary; MIT OCW '
              '8.02/8.07 problem sets are the free check.'),
      _n('sc7', 'Quantum Mechanics (Griffiths QM)', 4, 'sc4',
          'Derive the hydrogen atom start-to-finish unaided', 350, 'Physics',
          'Griffiths QM ch. 1–7: read with pen down only for the historical '
              'asides. After each chapter, close the book and rebuild its main '
              'derivation from a blank page. MIT OCW 8.04/8.05 exams are the '
              'external test.'),
      _n('sc6', 'Thermal & Statistical Physics (Schroeder)', 4, 'sc2',
          'Full problem sets, then Kittel & Kroemer', 250, 'Physics',
          'Schroeder front to back, every problem in ch. 1–7; then the first '
              'four chapters of Kittel & Kroemer as the harder second pass. '
              'Keep a one-page "which ensemble when" sheet you rewrite from '
              'memory at the end.'),
      _n('sc10', 'Advanced QM (Sakurai)', 6, 'sc7',
          'Perturbation theory + scattering problem sets', 300, 'Physics',
          'Sakurai Modern QM: ch. 1–5 plus the scattering chapter. Alternate '
              'each section with the corresponding MIT 8.05/8.06 problem set. '
              'Write a 2-page summary per chapter as if teaching it.'),
      _n('sc13', 'Classical Electrodynamics (Jackson)', 7, 'sc4',
          'The gauntlet: 60+ Jackson problems', 400, 'Physics',
          'Jackson ch. 1–7 + 9. Pick 8–10 problems per chapter (the classic '
              'quals list circulating online) and grind them honestly — hours '
              'per problem is normal. Compare against posted graduate '
              'solutions only after your full attempt.'),
      _n('sc12', 'General Relativity (Carroll)', 7, 'sc10',
          'Derive the Schwarzschild solution unaided', 300, 'Physics',
          'Carroll Spacetime and Geometry ch. 1–5 + black holes, with his free '
              'lecture notes (arXiv gr-qc/9712019). Do the tensor gymnastics '
              'by hand; finish by deriving Schwarzschild and the perihelion '
              'shift on a blank pad.'),
      _n('sc21', 'GRE Physics Subject Test', 8, ['sc10', 'sc13'],
          'Released tests ≥900-equivalent, timed', 100, 'Physics',
          'Drill all five released ETS physics GREs under exact timing (100 '
              'min, no calculator). Keep an error log by topic; between tests, '
              'grind your two weakest topics with Conquering the Physics GRE.'),
      _n('sc14', 'Quantum Field Theory (Peskin, Part I)', 8, ['sc10', 'sc13'],
          'Compute a tree-level cross-section start-to-finish', 350, 'Physics',
          'Peskin & Schroeder Part I alongside Tong\'s free QFT lecture notes. '
              'Derive the Feynman rules for φ⁴ and QED yourself, then compute '
              'e⁺e⁻→μ⁺μ⁻ start to finish, every index and factor accounted '
              'for, written up in LaTeX.'),
      // — Chemistry —
      _n('sc3', 'General Chemistry (Zumdahl)', 2, 'sc1',
          'Full problem sets; home titration & equilibrium labs', 300, 'Chemistry',
          'Zumdahl front to back, every blue-numbered problem. Pair each unit '
              'with a kitchen-safe lab (vinegar titration with a burette kit, '
              'Le Chatelier with CoCl₂ substitute demos). Log all data in a '
              'bound lab notebook, error bars included.'),
      _n('sc29', 'Wet-Lab Technique & Safety', 3, 'sc3',
          'Titration to ±0.5%; SDS quiz written for 10 chemicals; a written '
              'safety protocol for your bench', 50, 'Chemistry',
          'Set up a real home bench: goggles, gloves, spill plan, fire plan. '
              'Read the SDS for the 10 chemicals you own and write a one-line '
              'hazard + response card for each. Practice burette and pipette '
              'technique until triplicate titrations agree within ±0.5%.'),
      _n('sc5', 'Organic Chemistry I–II (Clayden)', 3, 'sc3',
          '500 mechanisms drawn from memory', 400, 'Chemistry',
          'Clayden with a mechanism notebook: every named reaction drawn '
              'with full arrow-pushing, no peeking, checked, redrawn a week '
              'later. Use Anki for reagents (a shared deck is fine); the 500 '
              'mechanisms are yours alone.'),
      _n('sc9', 'Biochemistry (Lehninger)', 5, 'sc5',
          'Glycolysis→ETC pathway maps drawn from memory', 300, 'Chemistry',
          'Lehninger core chapters (structure, enzymes, metabolism). Each '
              'weekend, redraw the full central-metabolism wall chart from '
              'memory — substrates, enzymes, regulation points — until it '
              'takes under 30 minutes with no gaps.'),
      _n('sc8', 'Physical Chemistry (Atkins)', 5, ['sc6', 'sc7', 'sc3'],
          'Thermo + QM applied to real spectra', 300, 'Chemistry',
          'Atkins: thermodynamics, kinetics and spectroscopy chapters with '
              'full exercise sets. Finish by assigning a real IR and a real '
              'NMR spectrum (free SDBS database) from first principles, '
              'written up like a lab report.'),
      _n('sc22', 'ACS Chemistry Exams (Gen + Organic)', 5, 'sc5',
          'Practice exams ≥80%, timed', 80, 'Chemistry',
          'Buy the official ACS study guides (Gen Chem + Organic). Take their '
              'practice exams under the real 110-minute clock, ≥80% on each; '
              'every miss becomes a flashcard, retired only after two correct '
              'recalls a week apart.'),
      _n('sc32', 'Inorganic Chemistry (Miessler)', 6, 'sc8',
          'Point-group assignment + MO diagrams for 10 real complexes', 200, 'Chemistry',
          'Miessler, Fischer & Tarr: symmetry, MO theory, coordination '
              'chemistry chapters with problem sets. For 10 real complexes, '
              'assign the point group and build the MO diagram unaided; check '
              'against literature.'),
      _n('sc11', 'Molecular Biology (Alberts)', 6, 'sc9',
          '3 journal-club style paper critiques', 250, 'Chemistry',
          'Alberts core chapters (DNA→RNA→protein, signalling, the cell '
              'cycle). Then pick three landmark papers (e.g. Meselson–Stahl '
              'and two modern), and write journal-club critiques: methods, '
              'controls, what would falsify the claim.'),
      // — Mathematical & computational methods —
      _n('sc19', 'Mathematical Methods (Boas)', 2, 'sc1',
          'Vector calc, ODE/PDE and linear algebra chapters worked', 300, 'Methods',
          'Boas ch. 1–13: the physicist\'s toolkit. One chapter per 1–2 '
              'weeks, every third problem of each section (they repeat by '
              'design). Keep a formula sheet you rewrite from memory at each '
              'chapter\'s end.'),
      _n('sc28', 'Fermi Estimation & Dimensional Analysis', 2, 'sc1',
          '30 Fermi problems within one order of magnitude; 10 results '
              'checked by dimensional analysis alone', 40, 'Methods',
          'Work through Weinstein\'s Guesstimation plus 30 problems of your '
              'own devising (energy in a hurricane, piano tuners, cells in '
              'your body). Answer first, look up after, log the error factor. '
              'Derive 10 known formulas by dimensions alone.'),
      _n('sc31', 'Scientific Python: data & plots', 4, 'sc19',
          'Five published figures reproduced from raw data with NumPy/'
              'Matplotlib, code public', 80, 'Methods',
          'Learn NumPy, Matplotlib and pandas via the free Scientific Python '
              'Lectures. Then find five published figures with open data '
              '(arXiv/Zenodo) and reproduce each — axes, fits, error bars — '
              'pushing the notebooks to a public repo.'),
      _n('sc20', 'Computational Science: write a simulation', 5,
          ['sc6', 'sc31'],
          'Working MD/Monte-Carlo sim + write-up of one physical result', 120, 'Methods',
          'Build an Ising-model Monte Carlo or a Lennard-Jones MD from '
              'scratch (no libraries beyond NumPy). Verify against a known '
              'result — the critical temperature or the pair-correlation '
              'peak — and write it up with plots and error analysis.'),
      // — Experimental craft —
      _n('sc24', 'Home Lab I: instruments & measurement', 2, 'sc1',
          'Multimeter, calipers, thermometer: 10 measurements with '
              'uncertainty budgets', 40, 'Lab Craft',
          'Buy a multimeter, calipers and a decent thermometer. Measure 10 '
              'everyday quantities (battery EMF, wire gauge, boiling point at '
              'your altitude) five times each; compute mean, standard error '
              'and a full uncertainty budget per measurement in a bound '
              'notebook.'),
      _n('sc30', 'Astronomy: the observing log', 3, 'sc24',
          '20 Messier objects logged with sketches; Jupiter\'s moons tracked '
              'across one week', 60, 'Lab Craft',
          'With binoculars or any small telescope and a free chart app, find '
              'and sketch 20 Messier objects across the seasons. Track '
              'Jupiter\'s moons nightly for a week and recover their periods '
              'from your own sketches — Galileo\'s actual experiment.'),
      _n('sc23', 'Error Analysis & Experiment Design (Taylor)', 3,
          ['sc24', 'sc19', 'sc28'],
          'Propagation-of-error problem sets; one designed experiment '
              'critiqued', 80, 'Lab Craft',
          'Taylor\'s Introduction to Error Analysis, all exercises in ch. '
              '1–8. Then design one experiment end-to-end (question, '
              'apparatus, systematics, sample size) and write a one-page '
              'critique of where it would fail.'),
      _n('sc25', 'Replicate classic experiments', 4, ['sc23', 'sc29', 'sc30'],
          "3 classics with error bars: measure g, laser diffraction, "
              'calorimetry', 60, 'Lab Craft',
          'Measure g with a pendulum (aim ±1%), the wavelength of a laser '
              'pointer with a diffraction grating, and a heat of reaction by '
              'coffee-cup calorimetry. Full uncertainty budgets; compare to '
              'accepted values and explain every discrepancy.'),
      _n('sc26', 'Scientific Writing & LaTeX', 6, 'sc25',
          'Two lab reports typeset in LaTeX, structured like journal papers',
          50, 'Lab Craft',
          'Learn LaTeX with Overleaf\'s free course. Rewrite your two best '
              'lab reports as journal-style papers: abstract, methods, '
              'results with proper figures, discussion, references in BibTeX. '
              'Get one outside reader to mark every unclear sentence.'),
      _n('sc27', 'Journal club: 20 arXiv papers', 7, 'sc26',
          '20 paper summaries; 3 full critiques posted for discussion', 100, 'Lab Craft',
          'Every week for 20 weeks: one arXiv paper in your target subfield. '
              'Write a half-page summary — claim, method, evidence, doubt. '
              'For three of them, write full critiques and post to a physics '
              'forum or blog where someone can push back.'),
      // — Convergence: the research chain —
      _n('sc15', 'Thesis: original research monograph', 9,
          ['sc32', 'sc11', 'sc12', 'sc14', 'sc20', 'sc21', 'sc22', 'sc27'],
          '50+ pages of original research', 700, 'Research',
          'Pick one narrow open question your journal-club reading surfaced. '
              'Spend ~6 months: reproduce the field\'s baseline result, then '
              'push one variable beyond it (new simulation regime, new '
              'analysis of open data, new derivation). Write 50+ LaTeX pages '
              'with honest negative results included.'),
      _n('sc16', 'Defend it before domain experts', 10, 'sc15',
          'Present to 2+ experts (forums/meetups); survive Q&A, revise', 60, 'Research',
          'Turn the monograph into a 25-minute talk. Present it where experts '
              'actually are: a university seminar you ask to join, a physics '
              'meetup, or a recorded talk sent to two researchers with a '
              'request for brutal comments. Revise the monograph from their '
              'objections.'),
      _n('sc17', 'Publish in a peer-reviewed venue', 11, 'sc16',
          'DOI exists — open-access journals accept independents', 120, 'Research',
          'Condense to a journal article. Submit to a legitimate open venue '
              'that takes independents (SciPost, PRE/PRA if in scope, or a '
              'respected field journal). Answer every referee point in a '
              'numbered response letter; resubmit until the DOI exists.'),
      _n('sc18', 'Crown: a result the field cites', 12, 'sc17',
          'Another researcher builds on your work — ≥1 independent citation',
          40, 'Research',
          'Make the work findable and usable: post the preprint, release '
              'code and data, email the three groups closest to the topic. '
              'Keep a Google Scholar alert on yourself; the crown ignites '
              'when an independent paper cites and uses your result.'),
]);
