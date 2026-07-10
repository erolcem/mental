// data/catalog_maths.dart — the maths constellation.
// Part of skill_data.dart: one Skill tree, governed by the catalog
// laws (see skill_data.dart + test/skill_data_test.dart). Every star:
// id, label, tier, requires, proof (completion standard), hours
// (researched effort), branch, guide (the exact work, step by step).
part of 'skill_data.dart';

final Skill mathsTree = Skill('maths', 'Mathematics', '∑', 'Prove and Publish an Original Theorem', [
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
]);
