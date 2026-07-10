// data/catalog_business.dart — the business constellation.
// Part of skill_data.dart: one Skill tree, governed by the catalog
// laws (see skill_data.dart + test/skill_data_test.dart). Every star:
// id, label, tier, requires, proof (completion standard), hours
// (researched effort), branch, guide (the exact work, step by step).
part of 'skill_data.dart';

final Skill businessTree = Skill('business', 'Business', '📊', 'Run Money Like an Institution', [
      _n('b1', 'Personal finance: write your own IPS', 1, null,
          'Investment Policy Statement + automated savings, 3 months', 30, 'Foundations',
          'Read the Bogleheads wiki\'s getting-started path, then write a '
              'real Investment Policy Statement: goals, asset allocation, '
              'rebalancing bands, the sentence that stops panic-selling. '
              'Automate savings and run it untouched for three months.'),
      _n('b2', 'Microeconomics (Mankiw)', 1, null,
          'Full problem sets; 5 news stories explained in drawn supply/demand',
          120, 'Foundations',
          'Mankiw\'s Principles of Microeconomics with every end-of-chapter '
              'problem (or the free Core Econ text). Then take five current '
              'news stories — rent caps, tariffs, surge pricing — and '
              'explain each with a hand-drawn supply/demand or elasticity '
              'diagram.'),
      _n('b3', 'Macroeconomics + indicator watch', 1, null,
          'Track CPI/rates/PMI monthly for 3 months, journaled', 120, 'Foundations',
          'Mankiw\'s Macroeconomics core chapters, then go live: every '
              'month for three months, log CPI, the policy rate, PMI, '
              'unemployment and the yield curve from FRED (free), and '
              'write a half page on what moved and why before reading any '
              'commentary.'),
      _n('b24', 'Spreadsheet craft: keyboard-only finance', 2, 'b1',
          'A loan amortiser, budget model and Monte Carlo retirement sheet '
              'built keyboard-only, error-checked', 40, 'CFA Spine',
          'Learn Excel/Sheets properly: keyboard navigation, absolute '
              'references, XLOOKUP/INDEX-MATCH, data tables, named ranges. '
              'Build three models without touching the mouse: a loan '
              'amortiser, a personal budget with scenarios, and a simple '
              'Monte Carlo retirement simulator with error checks.'),
      // — Economics & markets —
      _n('b23', 'Market history: Graham, Bogle & bubbles', 2, 'b3',
          'Brief on 3 historical bubbles; your IPS updated with the lessons', 60, 'Markets',
          'Read The Intelligent Investor (ch. 8 and 20 twice), Bogle\'s '
              'Little Book of Common Sense Investing, and Kindleberger on '
              'manias. Write a brief on three bubbles (1720, 1929, 2000): '
              'the story, the leverage, the aftermath — then update your '
              'IPS with one rule per bubble.'),
      _n('b27', 'Ethics & governance: read the frauds', 5, 'b23',
          '3 fraud post-mortems with red-flag lists; COSO controls mapped '
              'to each failure', 60, 'Markets',
          'Study three great frauds from the filings outward: Enron (The '
              'Smartest Guys in the Room), Wirecard (Money Men), Theranos '
              '(Bad Blood). For each: a post-mortem naming the red flags '
              'visible in public documents, and which COSO control layer '
              'failed. End with your personal red-flag checklist.'),
      // — Accounting → CFA spine —
      _n('b4', 'Financial Accounting', 2, 'b1',
          'Build 3 statements for a mock firm; parse a real 10-K', 120, 'CFA Spine',
          'Work through a financial accounting text (Libby or the free '
              'OpenStax): journal entries → trial balance → the three '
              'statements, built by hand for a 20-transaction mock firm. '
              'Then read one real 10-K cover to cover with a highlighter '
              'and write down every line you could not explain.'),
      _n('b6', 'Corporate Finance (Brealey & Myers)', 3, ['b4', 'b3'],
          'Problem sets + WACC for a real company', 150, 'CFA Spine',
          'Brealey & Myers core chapters: time value, capital budgeting, '
              'capital structure, payout. Problem sets throughout, then '
              'compute a real company\'s WACC from its filings and market '
              'data, documenting every input choice you had to make.'),
      _n('b7', 'Managerial Accounting', 3, 'b4',
          'Costing exercise on a real product teardown', 80, 'CFA Spine',
          'Garrison\'s Managerial Accounting core: cost behaviour, CVP, '
              'budgeting, variances. Then tear down one real product '
              '(coffee shop latte, a phone case) and build its full cost '
              'card: materials, labour, overhead allocation, breakeven '
              'volume.'),
      _n('b8', 'CFA Level 1', 4, ['b6', 'b7'],
          'Full-length timed mock ≥70%', 300, 'CFA Spine',
          'The CFA Institute Level 1 curriculum (or Kaplan Schweser notes) '
              'across all 10 topics, with end-of-reading questions '
              'throughout. Finish with a full-length timed mock (two '
              '135-minute sessions in one day) scoring ≥70% — the real '
              'pass band.'),
      _n('b12', '3-statement model from scratch', 4, ['b6', 'b24'],
          'Keyboard-only build of a real company', 60, 'CFA Spine',
          'Take a real company\'s last three 10-Ks and build the linked '
              'three-statement model keyboard-only: revenue drivers, '
              'schedules for debt/PP&E/working capital, balancing balance '
              'sheet, no hardcodes in the forecast. Free templates from '
              'Macabacus to check structure after.'),
      _n('b11', "Valuation (Damodaran's NYU course)", 5, ['b8', 'b12'],
          'All problem sets; 2 full valuations', 120, 'CFA Spine',
          'Damodaran\'s full NYU Valuation course — every lecture and '
              'problem set is free on his site. Then two complete '
              'valuations of real companies: DCF with your own drivers + '
              'multiples cross-check, each ending in a one-page investment '
              'judgement.'),
      _n('b19', 'CFA Level 2', 6, 'b11', 'Full-length timed mock ≥65%', 350, 'CFA Spine',
          'Level 2 is vignettes: work the curriculum\'s item sets '
              'relentlessly, especially FSA, equity and fixed income. '
              'Blue-box examples rebuilt in your own spreadsheet. Full '
              'timed mock ≥65% — and every miss traced to concept vs '
              'careless in your error log.'),
      _n('b13', 'DCF + LBO models on 2 real companies', 6, 'b11',
          'Assumptions documented and defended', 80, 'CFA Spine',
          'Build a full DCF and a full LBO on two different real '
              'companies (free LBO guides: Macabacus, WSO templates). '
              'Every assumption gets a written defence; run downside '
              'cases; write the two-page memo: would you buy, at what '
              'price, what kills the thesis?'),
      _n('b14', '25 10-Ks: one-page memos', 7, 'b13',
          'Memo book; 5 red flags found and explained', 120, 'CFA Spine',
          'Read 25 10-Ks across five industries, one page of notes each: '
              'the business in one sentence, unit economics, capital '
              'allocation record, incentives, one thing management hopes '
              'you skim. Flag five accounting red flags across the set '
              'and explain each.'),
      _n('b15', 'CFA Level 3', 7, 'b19', 'Full-length timed mock ≥65%', 350, 'CFA Spine',
          'Level 3: portfolio management and the essay format. Practice '
              'constructed-response with the released essay questions '
              '(graded against guideline answers, harshly), master the '
              'IPS-writing recipe, then a full timed mock ≥65%.'),
      // — Strategy & operations —
      _n('b5', 'Strategy (Porter)', 2, 'b2',
          'Five-forces analysis of a real industry', 60, 'Operations',
          'Read Porter\'s Competitive Strategy ch. 1–3 + his 2008 HBR '
              'update, and Rumelt\'s Good Strategy Bad Strategy. Write a '
              'full five-forces analysis of one industry you can observe '
              'directly, ending with where profit pools actually sit and '
              'why.'),
      _n('b10', 'Operations (The Goal)', 3, 'b5',
          'Map and improve a process you can observe', 50, 'Operations',
          'Read The Goal (Goldratt), then map one real process you can '
              'watch end-to-end — a café\'s morning rush, your own '
              'workflow. Find the bottleneck, apply the five focusing '
              'steps, measure before/after throughput, write it up with '
              'the numbers.'),
      _n('b26', 'The business memo: write like Amazon', 4, 'b10',
          '5 six-page memos written; one investment memo defended in a '
              'mock read-through', 40, 'Operations',
          'Study the Amazon narrative-memo culture (Bezos shareholder '
              'letters, the free "working backwards" material). Write '
              'five six-pagers: two process improvements, one market '
              'entry, one kill-this-project, one investment memo — then '
              'run a silent read-and-defend session on the last with two '
              'friends.'),
      // — Practice: negotiation & a real venture —
      _n('b20', 'Negotiation (Voss + Fisher) in the field', 3, 'b5',
          '10 logged real negotiations with prep sheets + outcomes', 50, 'Venture',
          'Read Getting to Yes, then Never Split the Difference. For ten '
              'real negotiations (salary, rent, vendor quotes, a market '
              'stall) prepare a one-page sheet: BATNA, target, opening, '
              'calibrated questions. Log the outcome vs plan and one '
              'lesson each.'),
      _n('b21', 'Micro-venture: legally sell something', 4, ['b10', 'b20'],
          '3 months of a tiny venture: 20+ sales, honest P&L + retrospective', 150, 'Venture',
          'Start the smallest legal venture that sells to strangers: a '
              'market stall, an Etsy line, a service. Run it three months '
              'to 20+ real sales. Keep real books from day one; end with '
              'an honest P&L and a retrospective on what customers taught '
              'you that books did not.'),
      _n('b22', 'Marketing: positioning + landing test', 5, 'b21',
          'Positioning doc; 100-visitor landing-page test, results written up', 60, 'Venture',
          'Read Ries & Trout\'s Positioning + April Dunford\'s Obviously '
              'Awesome. Write the positioning doc for your venture, then '
              'test it: a landing page (Carrd is fine) with two headline '
              'variants, ≥100 real visitors driven, conversion measured, '
              'results written up.'),
      _n('b28', 'Venture II: raise the stakes', 6, 'b22',
          '100 cumulative sales or \$1k profit; unit-economics memo + '
              'either scale or a documented shutdown', 150, 'Venture',
          'Take the venture to 100 cumulative sales or \$1,000 real '
              'profit. Compute true unit economics (CAC, contribution, '
              'payback), write the memo, and make the grown-up call: '
              'systematise and scale it, or shut it down cleanly with a '
              'post-mortem — both are wins.'),
      // — Convergence —
      _n('b16', '12-month paper portfolio vs benchmark', 8,
          ['b14', 'b15', 'b27', 'b25'],
          'IPS-governed, quarterly letters, every trade journaled', 150, 'Convergence',
          'Run a paper portfolio for 12 months under your own written '
              'mandate: every position gets a thesis memo before entry, '
              'every trade a journal line, every quarter a letter to your '
              'one imaginary LP — benchmark-relative, mistakes owned in '
              'writing.'),
      _n('b17', '3 published equity research reports', 9, ['b16', 'b26'],
          'Public + 6-month retrospectives on each call', 120, 'Convergence',
          'Publish three full research reports (SeekingAlpha, Substack, '
              'anywhere public): business, industry, valuation with your '
              'models attached, risks, explicit price target and horizon. '
              'Six months later, publish the retrospective on each call — '
              'especially the wrong ones.'),
      _n('b18', 'Crown: multi-year documented track record', 10,
          ['b17', 'b28'],
          '24+ months benchmark-relative with honest attribution', 250, 'Convergence',
          'Sustain the process 24+ months (paper or real, size is '
              'irrelevant — process is everything): IPS obeyed, every '
              'decision journaled, quarterly letters, annual attribution '
              'of results into luck vs skill. The crown is the documented '
              'record an institution could audit.'),
      _n('b25', 'Fixed income & the yield curve', 5, 'b8',
          'Bond maths worked by hand; 30 days of curve moves journaled '
              'with explanations', 100, 'CFA Spine',
          'Fabozzi core chapters (or the CFA fixed-income readings twice): '
              'price/yield by hand, duration and convexity computed for '
              'three real bonds, the curve\'s shapes and what each has '
              'historically meant. Then journal the Treasury curve daily '
              'for 30 days, explaining every ≥5 bp move.'),
]);
