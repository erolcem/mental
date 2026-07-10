// data/catalog_karate.dart — the karate constellation.
// Part of skill_data.dart: one Skill tree, governed by the catalog
// laws (see skill_data.dart + test/skill_data_test.dart). Every star:
// id, label, tier, requires, proof (completion standard), hours
// (researched effort), branch, guide (the exact work, step by step).
part of 'skill_data.dart';

final Skill karateTree = Skill('karate', 'Karate', '🥋', 'Shodan and Beyond, Honestly Earned', [
      _n('k1', 'Foundations: etiquette, stances, tai sabaki', 1, null,
          'Stance-hold times; video vs JKA reference', 40, 'Foundations',
          'Join a real dojo — karate is not safely self-taught. Learn '
              'dojo etiquette, the basic stances (zenkutsu, kokutsu, '
              'kiba dachi) and body-shifting. Hold each stance correctly '
              'for time and film yourself against a JKA reference to '
              'catch what your teacher cannot always watch.'),
      // — Kihon & kata —
      _n('k2', 'Kihon: 9th–7th kyu syllabus', 2, 'k1',
          'Full syllabus on video, self-scored vs standard', 80, 'Kata',
          'Drill the basic techniques (choku-zuki, oi-zuki, age-uke, '
              'gedan-barai, mae-geri) up and down the dojo floor until '
              'the form is clean under fatigue. Film the full 9th–7th '
              'kyu syllabus and self-score against the standard, with '
              'your instructor\'s corrections logged.'),
      _n('k3', 'Heian Shodan–Sandan', 3, 'k2',
          'Each kata one-take video, compared move-by-move', 80, 'Kata',
          'Learn the first three Heian kata to a real standard: '
              'correct embusen, timing, kime, and breathing. One '
              'continuous-take video of each, compared move-by-move to '
              'a JKA reference — kata is where technique becomes '
              'memory.'),
      _n('k5', 'Heian Yondan–Godan + Tekki Shodan', 4, 'k3',
          'One-take videos + bunkai notes', 80, 'Kata',
          'The last two Heian plus Tekki Shodan (introducing kiba-'
              'dachi power and lateral movement). One-take videos, and '
              'for each begin your bunkai notebook — what does each '
              'move actually DO against an opponent? Kata without '
              'application is dance.'),
      _n('k7', 'Advanced kata: Bassai Dai, Jion, Enpi', 6, 'k5',
          'One-take videos vs JKA reference', 100, 'Kata',
          'Learn three Shodan-level kata (Bassai Dai\'s dynamic '
              'power, Jion\'s dignity, Enpi\'s changes of level). '
              'These carry real technical weight — one-take videos '
              'against reference, with your instructor signing off the '
              'timing and stances before you call them done.'),
      _n('k8', 'Bunkai: applications of every kata', 7, 'k7',
          'Partner demo video, 3 applications per kata', 80, 'Kata',
          'Study and demonstrate the bunkai — real applications — for '
              'every kata you know, at least three per kata, with a '
              'compliant partner under dojo supervision. Film the '
              'demonstrations. This is where kata stops being '
              'choreography and becomes fighting knowledge.'),
      // — Kumite & partner work (always dojo-supervised) —
      _n('k4', 'Partner work: gohon/sanbon kumite', 3, 'k2',
          'Logged dojo sessions; distance and timing notes after each',
          60, 'Kumite',
          'Begin structured partner work — five-step and three-step '
              'kumite — ALWAYS in the dojo under supervision. Learn '
              'distance (maai), timing, and controlled contact. Log '
              'each session with notes on what your distance and '
              'timing did right and wrong.'),
      _n('k6', 'Jiyu kumite: 50 free-sparring rounds', 5, ['k4', 'k15'],
          'Dojo log; 5 rounds on video, reviewed', 60, 'Kumite',
          'Free sparring, always supervised, with proper protective '
              'gear and a controlled partner: 50 logged rounds '
              'building from light to committed. Film five and review '
              'them — sparring exposes the gap between kata-perfect '
              'technique and what works under pressure.'),
      _n('k9', 'Kumite depth: 150 rounds + shiai', 7, 'k6',
          'Log; one tournament or in-dojo shiai', 120, 'Kumite',
          'Build to 150 total supervised rounds against varied '
              'partners, then test it in one real shiai — a tournament '
              'or in-dojo competition under WKF-style rules and a '
              'referee. Controlled contact, respect, and honest '
              'reflection on what the pressure revealed.'),
      // — Conditioning —
      _n('k15', 'Conditioning: strength & mobility', 3, 'k2',
          '12-week program log; belt-height kicks held 10s', 80, 'Conditioning',
          'Build the body karate demands: a 12-week logged program of '
              'strength (posterior chain, core), and the mobility for '
              'clean high kicks — hold a mae-geri and yoko-geri at '
              'belt height for 10 seconds. Warm up properly; the '
              'injuries here are avoidable.'),
      // — Theory, history & mind —
      _n('k16', 'Dojo terms & etiquette (Japanese)', 2, 'k1',
          'Terminology deck matured: counting, commands, kata names', 20, 'The Way',
          'Learn the dojo\'s working Japanese: counting to ten, the '
              'commands (rei, yoi, hajime, yame), every technique and '
              'stance name, and the kata names. Mature a small deck. '
              'Understanding the words is part of respecting the '
              'tradition you have joined.'),
      _n('k17', 'History & philosophy (Funakoshi)', 4, 'k16',
          'Karate-Do: My Way of Life + precepts; essay: what karate is for', 30, 'The Way',
          'Read Funakoshi\'s Karate-Do: My Way of Life and the twenty '
              'precepts (Niju Kun). Write an essay on what karate is '
              'actually for — "karate ni sente nashi" (there is no '
              'first attack). The martial art without its ethics is '
              'just violence with etiquette.'),
      _n('k18', 'Rules & judging literacy', 6, ['k5', 'k17'],
          'WKF/JKA rules summarised; 10 recorded matches scored vs officials', 30, 'The Way',
          'Learn to see the sport as a judge does: summarise the '
              'WKF/JKA rules for kata and kumite, then score ten '
              'recorded matches and compare your scoring to the '
              'officials\'. This trains your eye and prepares you to '
              'teach and to grade juniors fairly.'),
      // — Convergence: the dan chain —
      _n('k10', 'Shodan grading', 8, ['k8', 'k9'],
          'The real grading at your dojo/organisation', 100, 'Dan Chain',
          'Sit the real Shodan (first-degree black belt) grading at '
              'your dojo or organisation — kihon, kata, kumite, and '
              'often an essay, judged by a real panel. This is not a '
              'certificate you can shortcut; it is awarded by teachers '
              'who have watched you earn it.'),
      _n('k11', 'Sempai: assist teaching, 6 months', 9, 'k10',
          "Instructor's written confirmation", 120, 'Dan Chain',
          'Serve as sempai: assist teaching juniors for at least six '
              'months under your instructor\'s guidance. Teaching '
              'forces you to understand technique deeply enough to '
              'transmit it, and to embody the dojo\'s values. Your '
              'instructor confirms it in writing.'),
      _n('k12', 'Nidan → Sandan gradings', 10, 'k11',
          'Real gradings — multi-year, as intended', 400, 'Dan Chain',
          'Grade to Nidan and then Sandan — a multi-year path, as the '
              'ranks are meant to be. Deeper kata, sharper kumite, '
              'genuine teaching contribution, and the maturity the '
              'grades demand. There is no rushing this; the time IS '
              'the training.'),
      _n('k14', 'Crown: Sandan + your own study group', 11, ['k12', 'k18'],
          '3rd dan certificate; a regular group you lead', 150, 'Dan Chain',
          'The crown: hold a legitimate Sandan (third-degree) '
              'certificate AND lead a regular study group — juniors or '
              'peers you guide week to week. Mastery in a martial art '
              'is proven not only in your own body but in what you can '
              'pass on, honestly and safely.'),
]);
