// data/catalog_int.dart — the INT constellations.
// Part of skill_data.dart: same library, same laws (see the five
// laws there and test/skill_data_test.dart). Every node: id, label,
// tier, requires, proof (completion standard), hours (researched
// effort), branch, guide (the exact work, spelled out).
part of 'skill_data.dart';

final StatDomain intDomain = StatDomain('INT', 'Intelligence', 0xFF00D4FF, [
    // Branches: Physics · Chemistry · Methods · Lab Craft — all converge at
    // the thesis gate (sc15) and the research chain to the citation crown.
    Skill('science', 'Physics & Chem', '⚗', 'Publish an Original Scientific Result', [
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
    ]),
    // Branches: Analysis · Algebra & Discrete · Probability & Applied ·
    // Problem Craft & Exposition — converging at the monograph (m17).
    Skill('maths', 'Mathematics', '∑', 'Prove and Publish an Original Theorem', [
      _n('m1', 'Pre-Calculus & Trigonometry', 1, null,
          'A released final, timed, >90%; the unit circle drawn from memory',
          120, 'Foundations',
          'Khan Academy Precalculus start to finish (or Stewart\'s '
              'Precalculus). Every exercise set to mastery, then a released '
              'university precalc final under time. Rebuild the unit circle '
              'and all identities from a blank page weekly until automatic.'),
      _n('m2', 'Logic & Proofs (Velleman)', 2, 'm1',
          '200 written proofs; induction, contradiction and contrapositive '
              'at will', 150, 'Foundations',
          'Velleman\'s How To Prove It, every exercise, written out longhand '
              '— proofs are handwriting-first. Keep a tally: you are done at '
              '200 complete proofs. Weekly, re-prove two old ones cold to '
              'check the muscle is real.'),
      _n('m3', 'Calculus I–III (Stewart)', 2, 'm1',
          'Full problem sets incl. vector calculus', 400, 'Foundations',
          'Stewart (any edition) ch. 1–16: single variable, series, then '
              'multivariable through Stokes. Odd-numbered problems of every '
              'section (answers in back). MIT OCW 18.01/18.02 exams as '
              'external checkpoints, timed.'),
      _n('m27', 'Euclidean Geometry: proofs & constructions', 2, 'm1',
          '40 propositions proved; 15 compass-and-straightedge constructions '
              'performed and justified', 150, 'Foundations',
          'Work Euclid Book I–IV (Byrne/Heath free online) or Kiselev\'s '
              'Geometry. Prove 40 propositions in your own words and perform '
              '15 constructions with real compass and straightedge, each with '
              'its proof of correctness beneath the figure.'),
      // — Analysis —
      _n('m4', 'Linear Algebra (Axler)', 3, ['m2', 'm3'],
          'Every theorem in ch. 1–7 proved unaided', 250, 'Analysis',
          'Axler\'s Linear Algebra Done Right ch. 1–7. For every theorem: '
              'close the book after reading the statement and prove it '
              'yourself first; compare after. All exercises. 3Blue1Brown\'s '
              'Essence of Linear Algebra as the geometric chaser.'),
      _n('m28', 'Set Theory & Foundations', 3, 'm2',
          'Halmos worked cover to cover; Zorn ⇔ AC ⇔ well-ordering proved '
              'unaided', 120, 'Analysis',
          'Halmos\'s Naive Set Theory, every exercise (it has no answers — '
              'that is the point). Build to proving the equivalence of the '
              'axiom of choice, Zorn\'s lemma and well-ordering on your own '
              'paper, then explain cardinal vs ordinal to a friend.'),
      _n('m7', 'Real Analysis (Rudin ch. 1–9)', 5, 'm4',
          'All chapter exercises; ε–δ and compactness arguments on demand',
          350, 'Analysis',
          'Baby Rudin ch. 1–9. Rule: 30 honest minutes per exercise before '
              'any hint (Abbott\'s Understanding Analysis is the mercy text '
              'when stuck). Maintain a "counterexample zoo" notebook — it is '
              'worth more than the theorems.'),
      _n('m9', 'Complex Analysis (Ahlfors)', 6, 'm7',
          'Contour-integral computations + proofs', 250, 'Analysis',
          'Ahlfors (or Stein & Shakarchi II) through the residue theorem and '
              'conformal mapping. Compute 30 real integrals by contour; prove '
              'Liouville and the fundamental theorem of algebra from scratch '
              'on demand.'),
      _n('m10', 'Point-Set Topology (Munkres, Part I)', 6, ['m7', 'm28'],
          'All exercises ch. 1–4; compactness vs connectedness explained cold',
          200, 'Analysis',
          'Munkres Part I, all exercises in ch. 1–4. Keep a running table of '
              'spaces vs properties (Hausdorff, compact, connected, '
              'metrizable) and fill a counterexample into every empty cell — '
              'Steen & Seebach\'s Counterexamples as the reference.'),
      _n('m12', 'Measure & Integration (Folland)', 7, 'm10',
          'Lebesgue theory exercises', 300, 'Analysis',
          'Folland ch. 1–3 + 6 (or Stein & Shakarchi III). Prove the '
              'convergence theorems unaided after reading; do 15 exercises '
              'per chapter. Finish by writing a 3-page "why Riemann fails" '
              'essay with the standard pathologies.'),
      _n('m15', 'Differential Geometry (do Carmo / Lee)', 9, 'm10',
          'Curves→manifolds exercise sets', 300, 'Analysis',
          'do Carmo\'s Curves and Surfaces first half, then Lee\'s Smooth '
              'Manifolds ch. 1–5. Compute curvature of five real surfaces by '
              'hand; prove the easy Gauss–Bonnet cases; keep every chart '
              'computation in a dedicated notebook.'),
      _n('m20', 'Functional Analysis (Kreyszig → Rudin)', 9, 'm12',
          'Banach/Hilbert space exercises', 250, 'Analysis',
          'Kreyszig for the friendly first pass (ch. 1–4 + spectral ideas), '
              'then Rudin\'s Functional Analysis ch. 1–2 for rigor. Prove '
              'Hahn–Banach, open mapping and uniform boundedness unaided; '
              'apply Hilbert-space machinery to one Fourier problem.'),
      // — Algebra & discrete —
      _n('m23', 'Combinatorics & Graph Theory', 3, 'm2',
          'Full exercise sets; 30 competition combinatorics problems', 200, 'Algebra',
          'Levin\'s free Discrete Mathematics book (counting, graphs, '
              'generating functions) with all exercises, then 30 olympiad '
              'combinatorics problems from Engel\'s Problem-Solving '
              'Strategies, written up properly.'),
      _n('m22', 'Elementary Number Theory', 4, 'm23',
          'Congruences→quadratic reciprocity proved; 30 olympiad problems',
          150, 'Algebra',
          'Burton or the free Stein book: everything through quadratic '
              'reciprocity, proving the named theorems yourself (Fermat, '
              'Euler, Wilson, CRT). Then 30 olympiad number theory problems; '
              'implement Miller–Rabin once to make it concrete.'),
      _n('m8', 'Abstract Algebra (Dummit & Foote I–III)', 5, ['m4', 'm22'],
          'Groups/rings/fields exercise sets', 350, 'Algebra',
          'Dummit & Foote parts I–III: groups through field extensions. 15 '
              'exercises per chapter minimum. Weekly ritual: state and prove '
              'the isomorphism theorems from memory. Judson\'s free AATA '
              'book + Macauley\'s visual lectures when stuck.'),
      _n('m30', 'Galois Theory (D&F IV / Stewart)', 7, 'm8',
          'Insolubility of the quintic + the three classical impossibilities '
              'proved unaided', 200, 'Algebra',
          'Stewart\'s Galois Theory (or D&F part IV). Compute Galois groups '
              'of 10 explicit polynomials; prove the quintic\'s insolubility '
              'and the impossibility of trisection, doubling and squaring — '
              'closing a 2,000-year-old question your compass work opened.'),
      // — Probability & applied —
      _n('m5', 'Ordinary Differential Equations (Tenenbaum)', 3, 'm3',
          "Tenenbaum's exercise gauntlet; decay, circuits and orbits modeled",
          150, 'Probability',
          'Tenenbaum & Pollard, the classic Dover: work every lesson\'s '
              'exercises through systems and series solutions. Model three '
              'real phenomena (RC circuit, orbital motion, epidemic curve) '
              'start to finish, solution + plot + sanity check.'),
      _n('m6', 'Probability (Ross)', 4, 'm3',
          'Full chapter sets; birthday, Monty Hall and ruin solved cold',
          200, 'Probability',
          'Ross\'s A First Course in Probability ch. 1–8, full problem sets '
              '(the self-test problems have solutions). Simulate five of the '
              'classic paradoxes in 20 lines of Python each to check your '
              'closed forms against the machine.'),
      _n('m29', 'Numerical Analysis (Sauer/Burden)', 5, 'm5',
          'Newton, spline, RK4 and FFT implemented from scratch; error '
              'orders verified empirically', 180, 'Probability',
          'Sauer or Burden & Faires: root-finding, interpolation, quadrature, '
              'ODE solvers, FFT. Implement each from scratch (NumPy arrays '
              'only), then verify the theoretical convergence order on log-'
              'log plots — theory meeting the machine is the lesson.'),
      _n('m11', 'Mathematical Statistics (Casella & Berger)', 7, 'm6',
          'Full problem sets; the MLE + confidence machinery derived unaided',
          250, 'Probability',
          'Casella & Berger ch. 5–10. Derive estimators, tests and intervals '
              'from definitions on paper — no formula sheets. For three real '
              'datasets, carry one inference each from model to conclusion, '
              'assumptions audited in writing.'),
      _n('m13', 'Partial Differential Equations (Evans, Part I)', 8,
          ['m29', 'm12'],
          'Part I sets; heat, wave and Laplace solved from first principles',
          300, 'Probability',
          'Evans Part I (transport, Laplace, heat, wave): the four classical '
              'derivations reproduced unaided, plus exercise sets. Solve one '
              'physical boundary-value problem analytically AND numerically '
              'with your own RK/finite-difference code; compare.'),
      _n('m14', 'Measure-Theoretic Probability (Durrett)', 8, ['m12', 'm6'],
          'Martingale + CLT chapters', 300, 'Probability',
          'Durrett ch. 1–5 (free PDF from his site): laws of large numbers, '
              'CLT via characteristic functions, martingales. Prove the '
              'strong law and optional stopping unaided; simulate a '
              'martingale betting system to watch the theorem bite.'),
      _n('m21', 'Stochastic Processes & SDEs (Øksendal)', 10, 'm14',
          'Itô calculus problem sets', 250, 'Probability',
          'Øksendal ch. 1–7: construct Brownian motion, prove Itô\'s formula '
              'in the simple case, work the exercise sets. Simulate geometric '
              'Brownian motion and verify your closed-form moments; derive '
              'Black–Scholes once as the payoff.'),
      // — Problem craft & exposition —
      _n('m19', 'Problem Craft: 50 Putnam problems', 4, ['m2', 'm3', 'm27'],
          'Written solutions, self-graded vs official', 120, 'Problem Craft',
          'From the Putnam archive (all free), work the A1/B1–A3/B3 range '
              'across 15 years: 50 problems, full written solutions, graded '
              'against the official ones with Putnam severity (0 or 10, '
              'partial credit is rare). Log each problem\'s key trick.'),
      _n('m24', 'Exposition: 10 mathematical essays', 5, 'm19',
          'Ten posts explaining real proofs to a lay reader, published', 80, 'Problem Craft',
          'Ten essays, each explaining one real theorem (Cantor, Euler '
              'characteristic, arithmetic-geometric mean...) to a smart '
              'friend with no maths degree. Publish where comments are '
              'possible; rewrite the two that confused readers most.'),
      _n('m25', 'Problem Craft II: full Putnams, timed', 6, 'm19',
          'Two 6-hour Putnams, exam conditions; ≥20/120 self-graded '
              '(the real median is 0–2)', 60, 'Problem Craft',
          'Two complete Putnam exams under real conditions: two 3-hour '
              'sessions in one day, no references, solutions written to be '
              'graded. Self-grade against official solutions a day later; '
              '≥20/120 is genuinely strong.'),
      _n('m26', 'Read research: 10 papers in one field', 9, ['m24', 'm12'],
          'Ten annotated papers; one presented as a talk (recorded)', 120, 'Problem Craft',
          'Choose one active corner (extremal combinatorics, dynamics, '
              'analytic number theory...). Read its 10 most-cited recent '
              'papers with full margin annotations; rebuild key lemmas. '
              'Record yourself presenting one paper for 30 minutes.'),
      // — Convergence —
      _n('m16', 'Qualifying Exams (3 real past quals)', 10,
          ['m30', 'm9', 'm13', 'm20'], 'Timed, closed-book, >70%', 200, 'Convergence',
          'Download real PhD qualifying exams (Berkeley, Wisconsin and UCLA '
              'post theirs): one analysis, one algebra, one applied. Sit each '
              'closed-book under its real clock; grade with the posted '
              'solutions. Re-sit any section under 70% a month later.'),
      _n('m17', 'Dissertation-grade monograph', 11,
          ['m11', 'm15', 'm16', 'm21', 'm25', 'm26', 'm31'],
          '60+ pages on one open corner, expert-reviewed', 700, 'Convergence',
          'Pick the narrowest open question your paper-reading exposed. '
              'Survey it completely (that is half the pages), then push: a '
              'special case proved, a bound improved, a conjecture tested '
              'computationally. 60+ LaTeX pages; pay/ask two mathematicians '
              'to referee it like a journal.'),
      _n('m18', 'Crown: original theorem, peer-reviewed', 12, 'm17',
          'DOI exists in a refereed journal', 150, 'Convergence',
          'Extract the strongest original result from the monograph into a '
              'tight 10-page paper. Submit to a refereed journal that takes '
              'independents (Involve, JIS, Integers, or the field\'s own). '
              'Survive the referee rounds; the DOI is the crown.'),
      _n('m31', 'Algebraic Topology (Hatcher ch. 0–2)', 10, ['m10', 'm8'],
          'π₁ and H₀/H₁ computed for 10 spaces; covering-space '
              'correspondence proved', 250, 'Algebra',
          'Hatcher (free PDF) ch. 0–2: fundamental group and homology. '
              'Compute π₁ and first homology for 10 spaces (circle, torus, '
              'Klein bottle, wedges, surfaces); prove the covering-space '
              'correspondence and Brouwer in dimension 2 unaided.'),
    ]),
    // Branches: Basic Science → Step exams · Clinical Craft · Emergency
    // Response (real public certs) · Evidence & Epidemiology.
    Skill('medicine', 'Medicine', '⚕', 'Chief Attending / Diagnostician', [
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
    ]),
    // Branches: Software Systems · Hardware & Embedded · Electronics &
    // Signals · Craft (Unix, security, shipping) — crown = your own stack.
    Skill('engineering', 'Engineering', '⚙',
        'Build Your Own Computer, OS & Distributed System', [
      _n('eg1', 'CS50 + Python', 1, null,
          'Every problem set passing the autograder', 120, 'Foundations',
          'Harvard CS50x, free on edX: all 10 problem sets through the '
              'autograder, no copied code. Then Automate the Boring Stuff '
              '(free online) until you have written five small Python tools '
              'you actually use.'),
      _n('eg2', 'C (K&R, every exercise)', 2, 'eg1',
          'Exercises in a public repo', 120, 'Foundations',
          'K&R second edition, every exercise, compiled with -Wall -Wextra '
              'and run under valgrind — zero leaks accepted. Push each '
              'chapter to a public repo with a README noting what bit you. '
              'CS50\'s memory lectures fill the gaps.'),
      _n('eg3', 'Engineering Mathematics (LinAlg + ODEs)', 2, 'eg1',
          'Strang + ODE problem sets; 3 applications to real circuits '
              'written up', 200, 'Foundations',
          'Strang\'s 18.06 (free MIT OCW, his lectures + exams) plus an ODE '
              'course\'s problem sets. Apply both: write up RC/RLC circuit '
              'response, a coupled-oscillator mode analysis and a Markov '
              'steady-state, maths → plot → sentence.'),
      _n('eg19', 'Unix craft: shell, git, tooling', 2, 'eg1',
          'MIT Missing Semester exercises; dotfiles + 10 scripting katas '
              'public', 60, 'Foundations',
          'MIT\'s The Missing Semester, all lectures + exercises: shell, '
              'tmux, git internals, debugging tools. Build your dotfiles repo '
              'from scratch (no framework), and solve 10 shell katas '
              '(cmdchallenge.com) with one-liners you can explain.'),
      // — Software systems —
      _n('eg5', 'Data Structures & Algorithms', 3, 'eg2',
          'CLRS core + 150 LeetCode, timed log', 300, 'Software',
          'CLRS core chapters (sorting, trees, graphs, DP) implementing '
              'every structure from scratch in C or Python before using any '
              'library. Then 150 LeetCode (50 easy/75 medium/25 hard) with a '
              'timed log; re-solve every failed problem a week later.'),
      _n('eg21', 'Compilers (Crafting Interpreters)', 4, 'eg5',
          'Both jlox and clox complete; one language feature of your own '
              'added', 150, 'Software',
          'Nystrom\'s Crafting Interpreters (free online): build jlox '
              'completely, then clox with its bytecode VM and GC. Finish by '
              'designing and adding one feature of your own — pattern '
              'matching, pipes, decorators — with tests.'),
      _n('eg7', 'Computer Systems (CS:APP + labs)', 4, 'eg4',
          'Bomb lab + malloc lab complete', 250, 'Software',
          'CS:APP (Bryant & O\'Hallaron) with CMU\'s self-study labs, all '
              'free: data lab, bomb lab (defuse it with gdb alone), attack '
              'lab, cache lab, malloc lab. The bomb and malloc labs are the '
              'proof — keep your write-ups.'),
      _n('eg10', 'Operating Systems (OSTEP)', 5, ['eg5', 'eg7'],
          'All projects: shell, malloc, scheduler', 250, 'Software',
          'OSTEP (free at ostep.org) cover to cover with its projects: '
              'write a shell with pipes/redirects, a malloc, an MLFQ '
              'scheduler simulation, and the concurrency projects with '
              'actual pthreads. Every chapter\'s homework simulator run.'),
      _n('eg11', 'Networking: sockets to HTTP server', 6, 'eg5',
          "Beej's guide + your server survives a load test", 100, 'Software',
          'Beej\'s Guide to Network Programming (free), then build an HTTP/'
              '1.1 server in C or Rust from raw sockets: static files, '
              'keep-alive, a thread pool. It must survive wrk with 1,000 '
              'concurrent connections without dropping valid requests.'),
      _n('eg14', 'Database Internals (CMU 15-445)', 7, 'eg10',
          'Buffer pool + B+tree + executor passing tests', 200, 'Software',
          'CMU 15-445 (Pavlo\'s lectures free on YouTube) with the BusTub '
              'projects: buffer pool manager, B+tree index, query executors, '
              'concurrency control — passing the public test suites. Read '
              'the SQLite architecture doc as dessert.'),
      _n('eg16', 'Distributed Systems (DDIA + MIT 6.824)', 9,
          ['eg11', 'eg14'],
          'Raft implementation passing the labs', 300, 'Software',
          'Read Designing Data-Intensive Applications with margin notes. '
              'Then MIT 6.824 (free lectures + labs): MapReduce, then Raft — '
              'your implementation must pass the 6.824 test harness '
              'including the unreliable-network and snapshot suites.'),
      _n('eg27', 'ML from scratch → deployed', 8, ['eg5', 'eg3'],
          'Backprop implemented from scratch (NumPy); one fast.ai model '
              'trained and served publicly', 200, 'Software',
          'fast.ai Practical Deep Learning part 1, then close the black box: '
              'implement a 2-layer net + backprop in pure NumPy, gradient-'
              'checked. Train one real model on your own data and serve it '
              'behind your own HTTP endpoint with honest eval numbers.'),
      // — Hardware & embedded —
      _n('eg4', 'Digital Design & Comp. Arch. (Harris & Harris)', 3, 'eg2',
          'HDL exercises; a single-cycle CPU running in the simulator',
          200, 'Hardware',
          'Harris & Harris Digital Design and Computer Architecture: gates '
              '→ FSMs → a single-cycle RISC-V/MIPS CPU in Verilog or their '
              'simulator, running real compiled programs. Every end-of-'
              'chapter HDL exercise for ch. 2–7.'),
      _n('eg9', 'Nand2Tetris I: CPU from NAND gates', 5, 'eg4',
          'Working Hack computer in the simulator', 100, 'Hardware',
          'nand2tetris.org projects 1–6, free: build every chip from NAND '
              'up — ALU, registers, RAM, the Hack CPU — in their HDL, then '
              'hand-assemble two programs and watch your computer run them. '
              'No skipping the assembler.'),
      _n('eg12', 'Embedded: bare-metal STM32', 6, 'eg8',
          'Blink→UART→interrupt drivers from the datasheet', 150, 'Hardware',
          'A \$15 STM32 Nucleo board, no HAL: from the reference manual '
              'alone, write the linker script and startup code, blink via '
              'registers, then UART and timer-interrupt drivers. Debug with '
              'openocd/gdb; every register write commented with the manual '
              'page.'),
      _n('eg13', 'Nand2Tetris II: compiler + OS', 7, ['eg9', 'eg10', 'eg21'],
          'Tetris runs on your own stack', 200, 'Hardware',
          'Projects 7–12: VM translator, Jack compiler, and the Jack OS '
              '(memory, screen, keyboard libraries). Finish by running a '
              'game — Tetris or Pong — where every layer from NAND to '
              'game-loop is yours.'),
      _n('eg15', 'Write an RTOS in C on real hardware', 8, ['eg12', 'eg13'],
          'Preemptive scheduler + mutexes demoed', 250, 'Hardware',
          'On your STM32: context switch in assembly (PendSV), a preemptive '
              'round-robin scheduler, mutexes with priority inheritance, and '
              'a message queue — then demo three tasks sharing the UART '
              'without corruption, filmed with the logic analyzer trace.'),
      _n('eg17', 'Autonomous robot on ROS 2', 9, ['eg15', 'eg24', 'eg26'],
          'Navigates an unseen room', 300, 'Hardware',
          'A diff-drive base (kit or your own PCB), lidar, ROS 2 Nav2 stack: '
              'SLAM a map, then autonomous point-to-point in a room the '
              'robot has never seen, three runs filmed uncut. Your PID inner '
              'loop from the control node, not a black box.'),
      // — Electronics & signals —
      _n('eg6', 'Circuit Analysis', 3, 'eg3',
          'Breadboard measurements match theory', 150, 'Electronics',
          'Work The Art of Electronics ch. 1–2 problems or Sedra-level DC/AC '
              'analysis: node/mesh, Thévenin, RC/RL transients, resonance. '
              'Build 10 of them on a breadboard and show measured vs '
              'predicted within component tolerance, logged.'),
      _n('eg8', 'Signals & Systems (Oppenheim)', 4, 'eg6',
          'Fourier problem sets + a working filter', 200, 'Electronics',
          'Oppenheim & Willsky with MIT OCW 6.003 problem sets: LTI, '
              'convolution, Fourier series/transforms, sampling. Then design '
              'an active low-pass filter, build it, and show its measured '
              'Bode plot against your maths.'),
      _n('eg23', 'Electronics II: transistors & op-amps', 5, 'eg8',
          'AoE labs: 5 circuits built incl. a discrete audio amp, measured '
              'against spec', 200, 'Electronics',
          'The Art of Electronics ch. 2–4 with Learning the Art of '
              'Electronics labs: BJT biasing, followers, current mirrors, '
              'op-amp circuits. Build five — ending with a discrete class-AB '
              'audio amp — and measure gain, clipping and distortion against '
              'your design targets.'),
      _n('eg24', 'Control Theory: feedback & PID', 5, 'eg8',
          'Inverted pendulum or line-follower stabilised; step response '
              'matches your model', 150, 'Electronics',
          'Åström & Murray\'s Feedback Systems (free PDF) ch. 1–7 + Brian '
              'Douglas\'s lectures. Model one real plant (motor speed or '
              'pendulum), design a PID in simulation, then stabilise the '
              'physical thing and overlay measured vs predicted step '
              'response.'),
      _n('eg26', 'PCB design: a board you shipped', 7, 'eg23',
          'KiCad board fabbed, assembled, brought up; one respin documented',
          100, 'Electronics',
          'Learn KiCad with Contextual Electronics\' free Getting to Blinky. '
              'Design a real 2-layer board (a sensor breakout or your RTOS '
              'carrier), get it fabbed cheaply, hand-solder, bring it up '
              'with a bring-up checklist — and document the respin, because '
              'there will be one.'),
      // — Craft: security & shipping —
      _n('eg20', 'Security fundamentals (CTF training)', 7,
          ['eg11', 'eg19'],
          'picoCTF 2000+ points or pwn.college belt; 10 challenge '
              'write-ups', 120, 'Craft',
          'pwn.college\'s free dojo (start with Program Security) or grind '
              'picoCTF to 2,000+ points: memory corruption, web, crypto, '
              'reversing. Write up 10 solved challenges properly — '
              'vulnerability, exploit, fix — on a blog. White-hat rules '
              'absolute: only sanctioned targets.'),
      _n('eg25', 'Software craft: tests, CI, review', 5, ['eg5', 'eg19'],
          'A project refactored under test coverage with CI + one external '
              'code review addressed', 100, 'Craft',
          'Take your messiest working project. Add a test suite (unit + one '
              'integration path), wire CI (GitHub Actions) to run it on '
              'every push, refactor mercilessly behind the green bar, and '
              'ask one stranger (r/codereview, a Discord) for a real review '
              '— then address every comment.'),
      _n('eg22', 'Ship it: a real networked product', 8,
          ['eg11', 'eg14', 'eg25'],
          'Deployed app with real users; monitoring + honest postmortem',
          200, 'Craft',
          'Build and deploy something 10 strangers actually use (a tool, a '
              'game server, an API): TLS, backups, uptime monitoring, error '
              'tracking. Run it for a month, break something, fix it, and '
              'write the honest postmortem including the graph of the '
              'outage.'),
      // — Convergence —
      _n('eg18', 'Crown: 3-node cluster of your kernel + KV store', 10,
          ['eg16', 'eg17', 'eg20', 'eg22', 'eg27'],
          'Kill a node live — the system survives', 400, 'Convergence',
          'The capstone: your Raft from 6.824 turned into a real replicated '
              'KV store, running on three physical machines (Pis count), '
              'fronted by your own HTTP server, monitored. Demo on film: '
              'writes flowing, pull a node\'s power, writes still flowing, '
              'node rejoins and catches up.'),
    ]),
]);
