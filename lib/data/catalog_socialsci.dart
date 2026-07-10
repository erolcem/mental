// data/catalog_socialsci.dart — the socialSci constellation.
// Part of skill_data.dart: one Skill tree, governed by the catalog
// laws (see skill_data.dart + test/skill_data_test.dart). Every star:
// id, label, tier, requires, proof (completion standard), hours
// (researched effort), branch, guide (the exact work, step by step).
part of 'skill_data.dart';

final Skill socialSciTree = Skill('socialSci', 'Social Sci', '🧠', 'Run a Real Behavioral Study', [
      _n('ss1', 'Intro Psychology (OpenStax + AP)', 1, null,
          '≥4 on a released AP Psychology exam', 120, 'Foundations',
          'OpenStax Psychology 2e (free) cover to cover with its self-'
              'checks, then one released AP Psychology exam under real '
              'timing, self-scored. Keep a running list of every classic '
              'study mentioned — you will audit them for replication '
              'later.'),
      // — Psych core —
      _n('ss3', 'Biological Psych & Neuroscience', 2, 'ss1',
          'Brain-region deck matured + essay', 120, 'Psych Core',
          'Kalat\'s Biological Psychology (any edition) or the free '
              'Foundations of Neuroscience text: neurons, '
              'neurotransmission, the sensory and motor systems. Mature a '
              '300-card brain-region/function deck and write one essay: '
              '"what an fMRI blob can and cannot tell you."'),
      _n('ss4', 'Cognitive Psychology', 3, 'ss3',
          'Self-exams + one experiment replication write-up', 100, 'Psych Core',
          'Goldstein\'s Cognitive Psychology: attention, memory, language, '
              'decision-making, with chapter self-exams ≥80%. Then '
              'replicate one classic effect on yourself and friends '
              '(Stroop, serial position, dual-task cost) with real '
              'stimuli, and write it up: method, data, plot.'),
      _n('ss6', 'Developmental Psych', 4, 'ss3', 'Stage-theory comparison essay', 80, 'Psych Core',
          'Berk\'s Development Through the Lifespan core chapters. Essay '
              'comparing Piaget, Vygotsky and modern statistical-learning '
              'accounts: what each predicts for a concrete milestone, '
              'where the evidence has moved since. Observe one child '
              '(ethically, a family member) against the milestone charts.'),
      _n('ss7', 'Abnormal Psych (DSM-5-TR)', 5, ['ss4', 'ss6'],
          '10 case vignettes correctly formulated', 100, 'Psych Core',
          'Barlow\'s Abnormal Psychology + the DSM-5-TR criteria for the '
              'major classes. Work 10 published case vignettes: for each, '
              'a differential, the criteria met line by line, and a '
              'biopsychosocial formulation — checked against the '
              'instructor answers where available.'),
      // — Methods & statistics —
      _n('ss2', 'Research Methods & Statistics I', 2, 'ss1',
          'Design critique of 5 published studies', 80, 'Methods',
          'A methods text (Morling\'s Research Methods) plus OpenIntro '
              'Statistics for the numbers. Then pick five published '
              'studies from press coverage and critique the designs: '
              'construct validity, confounds, power, what the headline '
              'claimed vs what the data showed.'),
      _n('ss17', 'Statistics in practice: R or JASP', 3, 'ss2',
          'Reproduce the stats of 3 open-data papers (OSF)', 80, 'Methods',
          'Learn R with the free R for Data Science (or JASP if code '
              'scares you — it shouldn\'t). Pull three open datasets from '
              'OSF and reproduce each paper\'s key statistics — t-tests, '
              'ANOVAs, correlations — to the decimal, noting where you '
              'cannot.'),
      _n('ss25', 'Learning science: study like the evidence', 3, 'ss2',
          'Make It Stick + Ericsson applied: your study system redesigned '
              'and A/B-tested for a month', 50, 'Methods',
          'Read Make It Stick and Ericsson\'s Peak. Redesign your own '
              'study system around retrieval practice, spacing and '
              'interleaving; run a month-long self-experiment on two '
              'comparable topics (one old method, one new) with a real '
              'pre/post test and honest write-up.'),
      _n('ss18', 'Game Theory (Schelling + Dixit)', 4, 'ss2',
          'Problem sets; 5 real situations modeled as games', 80, 'Methods',
          'Dixit & Nalebuff\'s The Art of Strategy plus Yale\'s free game '
              'theory course problem sets (Polak). Model five real '
              'situations you\'ve lived — a negotiation, a group project '
              'free-rider, a bidding war — as formal games with payoff '
              'tables and equilibria.'),
      _n('ss26', 'Measurement: build a real scale', 5, 'ss17',
          'A short scale built, piloted on 30 people; α and item analysis '
              'computed and interpreted', 60, 'Methods',
          'Read the free chapters on psychometrics (reliability, '
              'validity) from an open measurement text. Draft a 10-item '
              'scale for something you care about, pilot it on 30 people '
              '(Google Forms), compute Cronbach\'s α and item-total '
              'correlations in R, drop the bad items, and say what the '
              'scale still cannot claim to measure.'),
      // — Mind & society —
      _n('ss5', 'Social Psychology — replication-aware', 2, 'ss1',
          '10 classic findings annotated: survived or died?', 80, 'Mind & Society',
          'Read a social psych text\'s core chapters (Aronson\'s The '
              'Social Animal), then audit ten classics against the '
              'replication record (ego depletion, power posing, priming, '
              'Stanford prison...): for each, what was claimed, what '
              'replicated, current status — sourced.'),
      _n('ss22', 'Sociology: the structural lens', 2, 'ss1',
          'Mills essay + 3 institutions analysed structurally vs '
              'individually', 80, 'Mind & Society',
          'Read Mills\'s The Sociological Imagination ch. 1 + OpenStax '
              'Introduction to Sociology (free). Write the Mills essay — '
              'one personal trouble reframed as a public issue — then '
              'analyse three institutions (school, prison, marriage) '
              'structurally: whose interests, what reproduces them.'),
      _n('ss8', 'Thinking, Fast & Slow — with corrections', 3, 'ss5',
          'Brief: which chapters survived replication', 40, 'Mind & Society',
          'Read Kahneman, then the correction literature (the priming '
              'chapter\'s collapse, Kahneman\'s own open letter). Write '
              'the brief: chapter by chapter, what stands (loss aversion, '
              'anchoring) vs what fell, and what that teaches about '
              'trusting any single book.'),
      _n('ss23', 'Anthropology: culture up close', 3, 'ss22',
          'Eriksen worked; 3 cultural practices analysed emically vs '
              'etically', 70, 'Mind & Society',
          'Eriksen\'s Small Places, Large Issues core chapters: fieldwork, '
              'kinship, exchange, ritual. Analyse three practices — one '
              'from your own culture made strange, two from ethnographies '
              '— in emic and etic terms; write what "cultural relativism" '
              'does and does not commit you to.'),
      _n('ss9', 'Influence (Cialdini) + field notes', 4, 'ss8',
          '20 observed persuasion instances catalogued', 40, 'Mind & Society',
          'Read Influence (new edition with the seventh principle). Then '
              'two weeks of field notes: 20 real persuasion attempts on '
              'you — ads, upsells, guilt trips — each catalogued by '
              'principle, technique, and whether it worked. Practice the '
              'defence, not the attack.'),
      _n('ss10', "Moral Philosophy (Sandel's Justice)", 4, ['ss5', 'ss22'],
          'All lectures + 3 position essays', 60, 'Mind & Society',
          'Harvard\'s Justice course (all 24 lectures free) with the '
              'readings: Bentham, Kant, Rawls, Aristotle. Three position '
              'essays on the hard cases — the trolley variants, markets '
              'in organs, affirmative action — each stating the strongest '
              'objection to your own view first.'),
      _n('ss20', 'Behavioral Economics — audited', 5, ['ss8', 'ss18'],
          'Misbehaving + Ariely annotated with replication status; 10 nudges judged', 60, 'Mind & Society',
          'Read Thaler\'s Misbehaving, annotating every cited effect with '
              'its current replication status (the Ariely data scandals '
              'included — audit honestly). Then judge ten real-world '
              'nudges (defaults, framing on bills, app streaks): ethical? '
              'effective? evidence?'),
      _n('ss11', 'Behave (Sapolsky)', 6, ['ss3', 'ss9'],
          'Multi-level analysis of one behaviour', 60, 'Mind & Society',
          'Sapolsky\'s Behave cover to cover (his free Stanford lectures '
              'as accompaniment). Then run his method yourself: one real '
              'behaviour you witnessed, analysed at every timescale — '
              'neurons seconds before, hormones hours before, development '
              'years before, evolution millennia before.'),
      // — Applied practice —
      _n('ss12', 'Applied Stoicism', 5, 'ss10',
          '30 days journaled: morning premeditatio, evening review',
          40, 'Practice',
          'Read the Enchiridion + Meditations book by book alongside '
              'Irvine\'s A Guide to the Good Life. Then 30 unbroken days: '
              'morning premeditatio malorum (written), evening Senecan '
              'review (what done well, badly, differently tomorrow). Note '
              'which exercises actually moved your reactions.'),
      _n('ss19', 'Ethnography: 20 hrs public observation', 6, ['ss9', 'ss23'],
          'Anonymised, ethics-aware field-note corpus + thematic write-up', 30, 'Practice',
          'Twenty logged hours of public-space observation (cafés, '
              'markets, transit) using jottings→full field notes the same '
              'evening, fully anonymised, no recording of private '
              'conversation. Code the corpus into themes and write up '
              'three patterns with excerpts.'),
      _n('ss21', 'Wellbeing science + 8-week practice', 6, ['ss12', 'ss25'],
          "Yale's Science of Well-Being; 8 weeks of tracked practice, honest data", 40, 'Practice',
          'Yale\'s The Science of Well-Being (free on Coursera) including '
              'the rewirement exercises. Pick three practices with decent '
              'evidence (gratitude letters, savoring, exercise), run them '
              'eight weeks with a daily 1–10 mood log, and analyse your '
              'own data honestly — including if nothing moved.'),
      // — Convergence: the study —
      _n('ss13', 'Design + preregister a study', 7, ['ss11', 'ss20', 'ss26'],
          'Preregistration live on OSF', 60, 'The Study',
          'Turn one question from your reading into a real design: '
              'hypothesis, operationalisation (your scale from ss26 if it '
              'fits), power analysis in G*Power for a realistic sample, '
              'analysis plan, exclusions. Preregister the whole thing '
              'publicly on OSF before touching data.'),
      _n('ss14', 'Run it: collect real data', 8, 'ss13',
          'Online sample; data + analysis code public', 80, 'The Study',
          'Build the study in a free tool (Google Forms, PsyToolkit, '
              'formr), recruit ethically (consent text, no deception '
              'without debrief, anonymous), collect to your preregistered '
              'N. Run ONLY the preregistered analysis in R; post '
              'anonymised data + code to OSF.'),
      _n('ss15', 'Write it up preprint-style', 9, 'ss14',
          'PsyArXiv-format manuscript', 80, 'The Study',
          'Write the full APA-format manuscript: intro grounded in the '
              'literature you actually read, method exact enough to '
              'replicate, results with effect sizes and intervals, '
              'limitations without spin. Exploratory analyses labelled as '
              'exactly that.'),
      _n('ss16', 'Crown: publish the preprint', 10,
          ['ss15', 'ss7', 'ss19', 'ss21', 'ss24'],
          'Posted publicly; critique from 2 researchers incorporated', 60, 'The Study',
          'Post to PsyArXiv. Email it to two researchers in the area with '
              'three specific questions; post it where methods people '
              'gather. Incorporate the critique in a revision note, and '
              'state plainly what a proper replication would need. That '
              'honest public artifact is the crown.'),
      _n('ss24', 'Political science: institutions & voters', 4, 'ss22',
          'Two comparative briefs; one election analysed against the '
              'fundamentals models', 60, 'Mind & Society',
          'Read Klein\'s Why We\'re Polarized + a comparative institutions '
              'primer (Lijphart\'s patterns, summarised free). Write two '
              'briefs: presidential vs parliamentary trade-offs, and '
              'proportional vs majoritarian voting. Then analyse one real '
              'election against the fundamentals models vs the campaign '
              'narrative.'),
]);
