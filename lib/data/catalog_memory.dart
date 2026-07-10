// data/catalog_memory.dart — the memory constellation.
// Part of skill_data.dart: one Skill tree, governed by the catalog
// laws (see skill_data.dart + test/skill_data_test.dart). Every star:
// id, label, tier, requires, proof (completion standard), hours
// (researched effort), branch, guide (the exact work, step by step).
part of 'skill_data.dart';

final Skill memoryTree = Skill('memory', 'Memory', '🧩', 'Compete Among the Best from Your Desk', [
      _n('mem1', 'SRS habit: 180-day Anki streak', 1, null,
          'Anki stats export: 180 consecutive days, mature retention ≥90%',
          60, 'Foundations',
          'Build the base habit: Anki every single day for 180 '
              'consecutive days on a subject you actually want (a '
              'language, anatomy, capitals). Learn to write atomic '
              'cards and trust the algorithm. Export the stats — '
              '≥90% mature retention proves the habit is real.'),
      // — Systems —
      _n('mem2', 'Link & story method', 2, 'mem1',
          'Memorise 20-item lists reliably', 20, 'Systems',
          'Learn the link/story method: turn a list into a vivid, '
              'absurd chain of images (the more ridiculous, the '
              'stickier). Practice until you can hear a 20-item list '
              'once and recall it forwards and backwards — the '
              'gateway drug to every mnemonic technique.'),
      _n('mem3', 'Memory palaces: 5 palaces, 100 loci', 3, 'mem2',
          'Palace maps; 50-item recall demo', 40, 'Systems',
          'Build five memory palaces (method of loci) from places you '
              'know cold — home, commute, childhood school — with '
              'clear, ordered loci totalling 100. Draw the maps. '
              'Demonstrate: memorise a 50-item list placed through a '
              'palace and recall it in order.'),
      _n('mem4', 'Major system 00–99', 4, 'mem3',
          'Full table from memory; 40 digits in 2 min', 40, 'Systems',
          'Learn the Major System (digits→consonant sounds→words) and '
              'build your own 00–99 peg table — 100 fixed images. Drill '
              'until every number instantly IS its image. Prove it: 40 '
              'random digits memorised in under two minutes via a '
              'palace.'),
      _n('mem5', 'PAO system', 5, 'mem4',
          'Full PAO table; 80 digits in 5 min', 60, 'Systems',
          'Build a Person-Action-Object system: 100 people, each with '
              'a signature action and object, so six digits compress '
              'into one vivid image. This is the competitive standard. '
              'Drill to 80 digits in five minutes — the table takes '
              'weeks to make automatic, and that is expected.'),
      _n('mem6', 'Palace network: 20 palaces, 500 loci', 5, 'mem3',
          'Index + rotation schedule', 60, 'Systems',
          'Scale to 20 palaces with 500 total loci, indexed so you '
              'never collide, plus a rotation schedule (palaces need '
              '~a day to "clear" before reuse). This infrastructure '
              'is what lets you memorise long material and compete '
              'without overwriting yesterday.'),
      // — Science of learning —
      _n('mem14', 'Learning science (Make It Stick)', 2, 'mem1',
          'Retrieval + interleaving applied to one subject for a month, logged', 30, 'Learning Science',
          'Read Make It Stick and Brown\'s research. Apply retrieval '
              'practice, spacing and interleaving to one real subject '
              'for a month, logging the method and testing the result '
              'against your old approach. Memory technique without '
              'learning science is a party trick.'),
      _n('mem18', 'Speed reading & retention, honestly', 3, 'mem14',
          'Baseline vs trained wpm with comprehension held; 5 books '
              'mapped to memory palaces', 30, 'Learning Science',
          'Cut through the speed-reading myths (skimming is not '
              'reading): learn real techniques — subvocalisation '
              'control, chunking, previewing — and measure wpm WITH a '
              'comprehension quiz so gains are honest. Then map five '
              'non-fiction books into palaces so what you read stays.'),
      // — Applied memory: real knowledge, kept forever —
      _n('mem15', 'Applied I: a poem and a speech', 3, 'mem2',
          '100-line poem + 10-min speech recited on camera, palace maps shown', 40, 'Applied',
          'Memorise a 100-line poem and a 10-minute speech (a real '
              'one — Ted Hughes, a Shakespeare soliloquy, King\'s '
              'oratory) using palaces and rhythm. Recite both on '
              'camera, cold, and show the palace maps you built. '
              'Beauty worth carrying, not just digits.'),
      _n('mem16', 'Applied II: a knowledge vault', 5, ['mem15', 'mem18'],
          'Periodic table, world capitals, 50 constellations: cold-tested ≥95%', 80, 'Applied',
          'Build a permanent knowledge vault via palaces: the whole '
              'periodic table (position + key facts), all world '
              'capitals, 50 constellations, the cranial nerves — '
              'whatever you want to own forever. Cold-tested ≥95%, then '
              'maintained with spaced review.'),
      // — Competition drills —
      _n('mem7', 'Names & faces', 6, 'mem6',
          'Memory League: 15+ names/min level', 60, 'Competition',
          'Train the names-and-faces event: attach a memorable image '
              'to each name and anchor it to a facial feature. Drill on '
              'Memory League / Art of Memory trainers to 15+ names per '
              'minute — the event with the most real-world payoff of '
              'them all.'),
      _n('mem9', 'Numbers discipline', 6, 'mem5',
          'Memory League 80-digit level, or 200 digits in 5 min', 80, 'Competition',
          'Drill speed and marathon numbers with your PAO: Memory '
              'League\'s 80-digit sprint, or 200 digits in five '
              'minutes. Build the review discipline to lock a long '
              'string before it decays. Numbers are the backbone '
              'discipline of the sport.'),
      _n('mem8', 'Cards: one deck under 3 minutes', 7, ['mem5', 'mem6'],
          'A shuffled deck memorised under 3:00 — single on-camera take',
          60, 'Competition',
          'Assign every one of the 52 cards a PAO image, then memorise '
              'a shuffled deck through a palace and recall it in order. '
              'Get under 3:00 in a single unbroken on-camera take — the '
              'benchmark that separates hobbyist from competitor.'),
      _n('mem17', 'Names in the wild', 7, 'mem7',
          '50 real people remembered a week later; verified log', 30, 'Competition',
          'Take the names event off the screen: meet 50 real people '
              '(events, classes, work) and remember every name a week '
              'later, verified. This is the transfer test — the skill '
              'is only real when it survives contact with actual '
              'faces and noise.'),
      _n('mem10', 'Cards: under 90 seconds', 8, 'mem8',
          'Under 1:30 on camera, single take; attempts honestly logged',
          100, 'Competition',
          'Push deck memorisation under 1:30 — this requires fluent, '
              'automatic PAO recall and fast, clean palace journeys. '
              'Log every attempt honestly (the fails too); the plateau-'
              'breaking work is in the review speed, not the '
              'encoding.'),
      _n('mem11', 'Images & words events', 8, 'mem9',
          'Memory League level 60+ in both', 60, 'Competition',
          'Train the abstract-images and random-words events to '
              'Memory League level 60+. Words need a fast image-'
              'conversion reflex; abstract images need you to impose '
              'meaning on the meaningless — the purest test of '
              'encoding creativity.'),
      _n('mem12', 'A full Memory League season', 9,
          ['mem7', 'mem10', 'mem11'], 'Season completed; W/L recorded', 60, 'Competition',
          'Join a Memory League team or the open ladder and play a '
              'full season across all five events. Record your win/loss '
              'and per-event scores. Competition under a clock against '
              'real opponents exposes what solo drilling hides.'),
      // — Convergence —
      _n('mem13', 'Crown: ranked competitor', 10,
          ['mem12', 'mem16', 'mem17'],
          'Memory League top-100, or an official IAM event completed', 100, 'Convergence',
          'The crown: reach Memory League global top-100, OR complete '
              'an official IAM (International Association of Memory) '
              'event — many are online from your desk. A ranked, dated '
              'result against the world\'s best, earned by system and '
              'discipline.'),
]);
