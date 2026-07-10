// data/catalog_cooking.dart — the cooking constellation.
// Part of skill_data.dart: one Skill tree, governed by the catalog
// laws (see skill_data.dart + test/skill_data_test.dart). Every star:
// id, label, tier, requires, proof (completion standard), hours
// (researched effort), branch, guide (the exact work, step by step).
part of 'skill_data.dart';

final Skill cookingTree = Skill('cooking', 'Cooking', '🍳', 'Chef of Your Own Table', [
      _n('c1', 'Food safety', 1, null,
          'ServSafe Food Handler — real cert, online', 10, 'Foundations',
          'Take the real ServSafe Food Handler course and exam online '
              '(a genuine certificate, cheap). Then apply it: '
              'temperature danger zone, cross-contamination discipline, '
              'a thermometer you actually use, and a fridge organised '
              'by cook temperature.'),
      // — Technique spine —
      _n('c2', 'Knife skills', 2, 'c1',
          'Uniformity test videos: julienne, brunoise, chiffonade', 40, 'Technique',
          'Learn the grip, the claw, and the rock chop from a '
              'professional demo (any culinary school channel). Drill on '
              'cheap vegetables daily until your julienne, brunoise, '
              'dice and chiffonade are uniform — filmed close-up as '
              'proof, because evenness cooks evenly.'),
      _n('c3', 'Eggs & heat control', 3, 'c2',
          '8 egg preparations photographed at standard', 30, 'Technique',
          'Eggs are the heat-control exam: a French omelette with no '
              'browning, a barely-set scramble, poached, coddled, sunny, '
              'a proper hollandaise. Cook all eight to standard, '
              'photographed. If you can control heat on eggs, you can '
              'control it anywhere.'),
      _n('c4', 'Salt Fat Acid Heat (framework cooking)', 4, ['c3', 'c17'],
          '12 dishes tagged by which lever fixed them', 60, 'Technique',
          'Read Samin Nosrat\'s Salt Fat Acid Heat (the book; the show '
              'is dessert). Cook 12 dishes consciously seasoning by '
              'taste, and for each write which of the four levers a '
              'dish needed — the framework that turns recipe-following '
              'into cooking.'),
      _n('c5', 'Stocks: white, brown, vegetable', 4, 'c2',
          'Gel-set photos + reduction tasting notes', 30, 'Technique',
          'Make a white stock, a brown stock (bones roasted) and a '
              'vegetable stock from scratch. Proof: they gel when cold '
              '(photo it) from real collagen extraction, and you can '
              'describe how each tastes reduced. Stock is the '
              'foundation of everything savoury.'),
      _n('c8', 'Vegetables: roast, braise, blanch, pickle', 5, 'c4',
          'Seasonal menu using 8 techniques', 40, 'Technique',
          'Master the vegetable methods — high-roast, braise, '
              'blanch-and-shock, glaze, sauté, grill, pickle, raw with '
              'salt. Build one seasonal menu using eight of them, '
              'choosing the technique that flatters each vegetable at '
              'its peak.'),
      _n('c6', 'The five mother sauces + derivatives', 6, ['c4', 'c5'],
          'All five + 2 derivatives each, documented', 60, 'Technique',
          'The classical sauce tree: béchamel, velouté, espagnole, '
              'tomato, hollandaise, plus two derivatives of each '
              '(mornay, suprême, bordelaise...). Make all fifteen, '
              'documented — this is the grammar that lets you improvise '
              'sauces forever.'),
      _n('c9', 'Proteins: butchery + temperature mastery', 7, ['c6', 'c20'],
          'Whole chicken broken down; temp log for 3 proteins', 60, 'Technique',
          'Break down a whole chicken into eight (knife skills meet '
              'anatomy), and cook three proteins to exact doneness by '
              'internal temperature, rested, with a probe-thermometer '
              'log. Learn carryover cooking — the difference between '
              'good and perfect is 5°F.'),
      _n('c10', 'Emulsions & dressings', 7, 'c6',
          'Mayo, hollandaise, 5 vinaigrettes from memory', 30, 'Technique',
          'Understand emulsion (why oil and water hold, why they '
              'break, how to fix them). Make mayonnaise and hollandaise '
              'by hand and five vinaigrettes from memory in correct '
              'ratio — the 3:1 backbone you can flavour a hundred '
              'ways.'),
      // — Food science & tools —
      _n('c17', 'Food science (McGee)', 2, 'c1',
          'Chapter notes; 10 kitchen experiments explained (rest, brine, sear)', 80, 'Science',
          'Read Harold McGee\'s On Food and Cooking (the relevant '
              'chapters) and Kenji López-Alt\'s free articles. Run ten '
              'kitchen experiments — resting meat, brining, the Maillard '
              'sear, salting timing — and explain the WHY, so you can '
              'reason about food, not just follow it.'),
      _n('c20', 'Sharpening & tool care', 3, 'c2',
          'Whetstone progression video; paper-slice test; care log', 20, 'Science',
          'Learn to sharpen on whetstones (1000/6000 grit): the angle, '
              'the burr, the progression. Film the process; prove it '
              'with a clean paper-slice and a tomato that yields to the '
              'blade\'s weight. Keep a care log — a dull knife is the '
              'dangerous one.'),
      _n('c11', 'Fermentation & preservation', 8, 'c9',
          'Kraut, yogurt, pickles + one long ferment', 40, 'Science',
          'Preserve safely and deliberately (Katz\'s The Art of '
              'Fermentation, safety first with pH and salt ratios): '
              'sauerkraut, yogurt, quick and lacto pickles, plus one '
              'long ferment (miso, kimchi, hot sauce). Taste how time '
              'builds flavour.'),
      // — Baking & pastry —
      _n('c7', 'Baking ratios (Ruhlman) + bread', 5, 'c4',
          'Baguette, loaf, pizza — crumb shots', 80, 'Baking',
          'Learn Ruhlman\'s Ratio thinking — bread is flour-water-salt-'
              'yeast in proportion, not a recipe to obey. Bake a '
              'baguette, a sandwich loaf and a pizza to open, even '
              'crumb (photograph the crumb), understanding hydration '
              'and gluten development.'),
      _n('c21', 'Pastry: desserts & lamination', 7, 'c7',
          'Croissants, tart, custards; lamination layers photographed', 80, 'Baking',
          'The precision branch: a proper crème pâtissière and crème '
              'anglaise, a pâte sucrée tart, and laminated dough — '
              'croissants with visible, countable layers (photographed). '
              'Pastry punishes carelessness and rewards exactness.'),
      // — World cuisines & presentation —
      _n('c16', 'World techniques: 5 dishes × 4 cuisines', 7, 'c23',
          'Cook-throughs with authenticity notes', 100, 'World & Plate',
          'Cook five signature dishes from each of four cuisines you '
              'did not grow up with, using authentic techniques and '
              'ingredients (a real wok hei, a proper sofrito, a dal '
              'tempered correctly). Notes on what makes each authentic '
              'vs the westernised version.'),
      _n('c18', 'Plating & presentation', 8, ['c16', 'c10'],
          '10 plated dishes vs reference plating; natural-light photos', 40, 'World & Plate',
          'Study plating principles (negative space, height, odd '
              'numbers, sauce as design, the clock composition). Plate '
              'ten dishes against restaurant references, photographed in '
              'natural light — we eat with our eyes first, and this is '
              'a learnable craft.'),
      _n('c19', 'Menu craft: plan & cost 5 menus', 9, 'c18',
          '5 costed menus with prep timelines; one executed on budget', 40, 'World & Plate',
          'Plan five coherent menus (a dinner party, a brunch, a '
              'seasonal tasting): balanced across richness and '
              'technique, costed per head, with a backwards prep '
              'timeline. Execute one on budget and on time — this is '
              'the chef\'s real skill.'),
      // — Convergence —
      _n('c22', 'Soups, braises & the low-and-slow build', 5, 'c5',
          '6 dishes building layered flavour from scratch; one 6-hour '
              'braise', 40, 'Technique',
          'Learn to build deep flavour with time: a proper French '
              'onion, a pho or ramen broth from bones, a Sunday ragù, '
              'a red-braised or coq-au-vin style dish. Six dishes '
              'developing layers — sweat, deglaze, reduce, simmer — '
              'including one that cooks six-plus hours.'),
      _n('c23', 'Global pantry & spice mastery', 6, ['c8', 'c22'],
          '20 spices used from memory; 6 spice blends toasted and ground '
              'from whole', 40, 'Science',
          'Learn 20 core spices by smell and use, and blooming/toasting '
              'technique. Make six blends from whole spices, toasted and '
              'ground yourself — garam masala, ras el hanout, a curry '
              'powder, five-spice, berbere, za\'atar. The pantry that '
              'unlocks the world\'s cuisines.'),
      _n('c12', 'Replicate 3 Michelin-book recipes', 9, ['c11', 'c21', 'c18'],
          'Full process documented, plating compared', 60, 'Convergence',
          'Cook three genuinely ambitious recipes from restaurant '
              'cookbooks (French Laundry, Noma, an Ottolenghi '
              'showpiece): multi-component, multi-day where needed. '
              'Document the full process and compare your plate '
              'honestly to the book\'s photo.'),
      _n('c13', 'Develop 10 original recipes', 10, 'c12',
          'Written recipes tested by someone else from the page', 80, 'Convergence',
          'Create ten original dishes — your own combinations, tested '
              'and refined across attempts. Write each up precisely '
              '(weights, times, temperatures) and have someone else '
              'cook it FROM YOUR PAGE and get your result. A recipe '
              'that only works for its author is not finished.'),
      _n('c15', 'Crown: 8-course tasting menu for 8', 11, ['c13', 'c19', 'c24'],
          'Menu design → prep schedule → solo execution → guest feedback', 60, 'Convergence',
          'Design and cook an 8-course tasting menu for eight guests: '
              'progression from light to rich, technique variety, your '
              'original dishes featured, drinks paired. Build the prep '
              'schedule, execute mostly solo, and gather written '
              'feedback. The dinner IS the diploma.'),
      _n('c24', 'Beverages & pairing', 9, 'c18',
          'A pairing built for a 5-course menu; 3 non-alcoholic pairings '
              'designed and defended', 30, 'World & Plate',
          'Learn the logic of pairing — matching and contrasting weight, '
              'acidity, sweetness, tannin — for wine and, just as '
              'seriously, for non-alcoholic drinks (teas, shrubs, '
              'kombucha, juices). Build a full pairing for a five-course '
              'menu and defend each choice in a sentence.'),
]);
