// data/catalog_dex.dart — the DEX constellations.
// Part of skill_data.dart: same library, same laws (see the five
// laws there and test/skill_data_test.dart). Every node: id, label,
// tier, requires, proof (completion standard), hours (researched
// effort), branch, guide (the exact work, spelled out).
part of 'skill_data.dart';

final StatDomain dexDomain = StatDomain('DEX', 'Dexterity', 0xFF4ADE80, [
    // Branches: Construction · Observation (figure, Bargue, masters) ·
    // Light & Color · Imagination, Habit & Digital — crown = an exhibit.
    Skill('drawing', 'Drawing', '✏️', 'A Body of Work Worth Exhibiting', [
      _n('d1', 'Drawabox: lines, ghosting, 250 boxes', 1, null,
          'Completed homework, posted for critique', 100, 'Foundations',
          'Work Drawabox lessons 0–1 (free) exactly as written: '
              'superimposed lines, ghosted planes, then the 250 Box '
              'Challenge — no rushing, no erasing. Post every homework '
              'set to the r/ArtFundamentals critique queue and apply the '
              'notes before continuing.'),
      // — Construction —
      _n('d2', 'Shape, proportion & measuring', 2, 'd1',
          '20 still-life studies with measured comparisons', 60, 'Construction',
          'Learn sight-size and comparative measuring (pencil-held-at-'
              'arm\'s-length). Draw 20 still lifes from observation, '
              'blocking in big shapes first and checking every proportion '
              'against a plumb line and angle comparison before detailing.'),
      _n('d3', 'Form: boxes, cylinders, ellipses in space', 3, 'd2',
          'Drawabox lessons 2–3 homework', 80, 'Construction',
          'Drawabox lessons 2–3: arrows, organic forms, then the '
              'cylinder challenge. Drill ellipses inside boxes daily until '
              'they sit convincingly in perspective. The goal is forms '
              'that feel three-dimensional, not outlines that look right.'),
      _n('d4', 'Perspective I: 1 & 2 point', 4, 'd3',
          'A real interior drawn twice, plotted', 60, 'Construction',
          'Study one- and two-point perspective from Robertson\'s How To '
              'Draw (ch. 1–4) or free equivalents. Plot a real room twice '
              'with ruled vanishing points and a measuring system — '
              'furniture, tiles, receding detail all converging '
              'correctly.'),
      _n('d7', 'Perspective II: 3-point + foreshortening', 5, 'd4',
          'Worm/bird-eye city scene, plotted', 80, 'Construction',
          'Add the third vanishing point and inclined planes. Construct a '
              'dramatic worm\'s-eye or bird\'s-eye city scene from '
              'imagination with all three points plotted, then a '
              'foreshortened figure or object using the same box-first '
              'method.'),
      _n('d22', 'Perspective III: curvilinear & atmosphere', 6, 'd7',
          'A 5-point panorama plotted; 3 depth studies using aerial '
              'perspective and edge control', 60, 'Construction',
          'Learn curvilinear (4/5-point) perspective for wide '
              'panoramas, then atmospheric depth: how value contrast, '
              'edge sharpness and colour temperature recede. Plot one '
              'fisheye panorama and paint three studies that create deep '
              'space through air, not just lines.'),
      // — Observation: figure, plates, masters —
      _n('d6', 'Gesture: 500 timed figure poses', 4, ['d3', 'd18'],
          'Dated sketchbook pages, 30s–2min poses', 80, 'Observation',
          'Daily gesture from Line of Action or Quickposes (free): 30-'
              'second to 2-minute poses, chasing the line of action and '
              'weight, NOT contour. 500 poses logged and dated. The bad '
              'ones are the reps — keep every page.'),
      _n('d8', 'Anatomy I: skeleton (Proko)', 5, 'd6',
          'Skeleton from imagination, 3 angles', 80, 'Observation',
          'Proko\'s free skeleton series bone by bone: landmarks, '
              'proportions, the ribcage-pelvis relationship. Draw the '
              'full skeleton from imagination in three views, then find '
              'each landmark on your own gesture drawings.'),
      _n('d17', 'Bargue plates: 10 copies', 5, 'd5',
          'Side-by-side comparisons, flaws annotated', 100, 'Observation',
          'Copy 10 Bargue plates (free scans) using sight-size: the '
              'atelier method that trains the eye. Block in with straight '
              'lines, refine slowly, then overlay your copy on the '
              'original and annotate every drift in angle and proportion.'),
      _n('d10', 'Anatomy II: muscles', 6, 'd8',
          'Écorché studies over 10 gesture drawings', 120, 'Observation',
          'Learn the major muscle groups as forms (Proko, Bridgman\'s '
              'Constructive Anatomy). Draw écorché (muscle) layers over '
              'ten of your own gesture drawings — origin, insertion, what '
              'each muscle does to the surface when it acts.'),
      _n('d19', 'Master studies: 10 copies', 6, 'd17',
          'Ten master copies (Rubens/Sargent/Bridgman); deviations annotated', 100, 'Observation',
          'Copy ten master drawings (Rubens, Sargent, Bridgman, '
              'Loomis). Match their construction and mark-making, not '
              'just the image; write one paragraph per study on the '
              'specific decision you stole from each.'),
      _n('d11', 'Anatomy III: hands, feet, portrait', 7, 'd10',
          '100 hands, 50 feet, 20 portraits', 200, 'Observation',
          'The hard mile: 100 hands, 50 feet, 20 portraits from '
              'observation and imagination. Use the Loomis head method '
              'for portraits and box-construction for hands. These are '
              'where amateur drawings betray themselves — earn them.'),
      // — Light & color —
      _n('d5', 'Value: light logic + 10-step scales', 4, 'd3',
          'Sphere/cube/cylinder under 3 light setups', 60, 'Light & Color',
          'Learn the light logic — halftone, core shadow, reflected '
              'light, cast shadow, occlusion. Render sphere, cube and '
              'cylinder under three lighting setups, controlling a clean '
              '10-step value scale by eye.'),
      _n('d9', 'Color theory (Gurney)', 6, 'd5',
          '12 limited-palette studies', 100, 'Light & Color',
          'Read Gurney\'s Color and Light. Do 12 studies with a limited '
              'palette (start with the Zorn four), matching observed '
              'colour by mixing rather than picking — gamut masking, '
              'temperature shifts in light vs shadow.'),
      _n('d12', 'Material rendering', 8, ['d9', 'd7'],
          'Metal, glass, cloth, skin — one still life each', 120, 'Light & Color',
          'Study how different materials handle light (specular vs '
              'diffuse, subsurface, transparency). Render one careful '
              'still life each of metal, glass, cloth and skin — the '
              'differences live entirely in the highlights and edges.'),
      // — Imagination, habit & digital —
      _n('d18', 'Sketchbook habit: 100 consecutive days', 2, 'd1',
          'Dated pages, 100-day streak; monthly self-critique', 100, 'Imagination',
          'Draw something from life every single day for 100 unbroken '
              'days — a page minimum, dated. Miss a day, the streak '
              'restarts. Monthly, lay out the last 30 pages and write an '
              'honest self-critique of what is improving and what is '
              'avoided.'),
      _n('d21', 'Environments: 20 plein-air sketches', 7, ['d22', 'd9'],
          'On-location sketchbook; 5 finished scenes', 80, 'Imagination',
          'Twenty on-location sketches — cafés, streets, parks — '
              'working fast, editing the chaos into a design. Then take '
              'five back to the studio and push to finished scenes with '
              'full value and colour.'),
      _n('d20', 'Digital craft (Krita/Procreate)', 8, 'd9',
          '5 studies replicating your traditional values and color digitally', 80, 'Imagination',
          'Learn a digital tool (Krita is free): layers, brushes, '
              'blending modes, colour picking discipline. Reproduce five '
              'of your traditional studies digitally so the medium is a '
              'tool, not a crutch — the values and colour must match your '
              'hand.'),
      _n('d13', 'Composition & storytelling', 9, ['d12', 'd19', 'd21'],
          '10 thumbnails/day for 30 days; 3 narrative pieces', 150, 'Imagination',
          'Study composition (notan, focal hierarchy, the eye\'s path). '
              'Thumbnail 10 compositions a day for 30 days from prompts, '
              'then develop three into narrative pieces that tell a story '
              'in a single image — someone should read it without a '
              'caption.'),
      // — Convergence —
      _n('d23', 'Portraiture: 30 heads to true likeness', 8, 'd11',
          '30 portraits from life/photo scored for likeness by a stranger',
          120, 'Observation',
          'Thirty portraits pushing past generic to actual likeness: '
              'the Reilly/Loomis structure underneath, then the specific '
              'asymmetries that make one face that person. Test '
              'honestly — show ten to someone who knows the sitters and '
              'have them name each.'),
      _n('d24', 'Digital illustration: 5 full pieces', 9, 'd20',
          '5 finished illustrations start-to-final; process files kept',
          120, 'Imagination',
          'Five complete illustrations from thumbnail → value comp → '
              'colour comp → render, using your digital craft fully '
              '(custom brushes, adjustment layers, photobashing where '
              'honest). Keep the process files — the workflow is half the '
              'skill you are proving.'),
      _n('d14', 'Portfolio: 20 finished works', 10, ['d13', 'd23', 'd24'],
          'Curated, unified voice + artist statement', 300, 'Convergence',
          'Produce and curate 20 finished works with a recognisable '
              'point of view — subject, palette or mark that ties them '
              'together. Write a one-page artist statement. Cut anything '
              'that does not belong; a tight 15 beats a scattered 25.'),
      _n('d16', 'Crown: exhibit', 11, 'd14',
          'A real show (café/library/gallery/online curated), documented reach', 60, 'Convergence',
          'Mount a real exhibition: a café or library wall, a group '
              'show, a booked online viewing room. Hang or sequence it '
              'deliberately, price or caption the work, invite an '
              'audience, and document who actually came and what they '
              'said.'),
    ]),
    // Branches: Craft Study · Production (the novel spine) · Community &
    // Submission · Reading — crown = a published novel with real readers.
    Skill('writing', 'Writing', '🖊', 'A Published Novel', [
      _n('w1', 'Grammar & mechanics cold', 1, null,
          'Error-free 1,000-word sample; style-guide quiz', 40, 'Foundations',
          'Work the free Purdue OWL grammar modules and one style guide '
              '(Chicago basics). Prove it: write a 1,000-word sample a '
              'stranger finds error-free, and pass a punctuation/usage '
              'quiz cold — the mechanics must be automatic so craft can '
              'have your attention.'),
      // — Reading —
      _n('w2', 'Read like a writer: 30 classics', 2, 'w1',
          'Reading journal: one craft lesson per book', 300, 'Reading',
          'Read 30 acknowledged-great novels across eras, but read as a '
              'writer: after each, journal ONE craft lesson you can '
              'steal — how Austen handles free indirect speech, how '
              'Hemingway loads white space. Reading is the deepest '
              'writing practice there is.'),
      _n('w20', 'Genre immersion: 20 books', 3, 'w2',
          'Genre map: tropes, expectations, comp titles; reading journal', 150, 'Reading',
          'Choose your target genre and read its 20 most important '
              'recent books. Build a genre map: the tropes readers '
              'demand, the ones they are tired of, the pacing '
              'conventions, and 5 comp titles your book would sit '
              'beside on the shelf.'),
      // — Craft study —
      _n('w18', 'Prose rhythm: poetry & sentences', 2, 'w1',
          '30 poems studied; 20 sentence imitations, before/after', 40, 'Craft',
          'Study 30 poems for sound — meter, line, the music of '
              'stressed syllables. Then imitate 20 great sentences of '
              'prose (Baldwin, Woolf, McCarthy), keeping the rhythm and '
              'syntax while swapping the content. Keep before/after '
              'pairs.'),
      _n('w4', 'Story structure (McKee + Save the Cat)', 4, 'w3',
          'Beat-sheet 5 favourite novels/films', 60, 'Craft',
          'Read McKee\'s Story and Snyder\'s Save the Cat. Then reverse-'
              'engineer five stories you love into full beat sheets — '
              'inciting incident, midpoint, crisis, climax — until you '
              'can feel the load-bearing structure under any narrative.'),
      _n('w23', 'Scene & dialogue craft', 5, 'w4',
          '15 scenes written to a checklist; dialogue that carries '
              'subtext, peer-verified', 60, 'Craft',
          'Learn scene architecture (goal-conflict-disaster / reaction) '
              'and dialogue that does three jobs at once. Write 15 '
              'scenes to a craft checklist; for five, the dialogue must '
              'carry subtext a reader catches without narration — verify '
              'with a critique partner.'),
      _n('w6', 'On Writing (King) + Bird by Bird', 6, 'w5',
          'Revision philosophy memo', 30, 'Craft',
          'Read King\'s On Writing and Lamott\'s Bird by Bird — the two '
              'honest books about the actual daily work. Write your own '
              'one-page revision philosophy: your rules for shitty first '
              'drafts, when to cut, how you will handle the middle-of-'
              'book despair.'),
      _n('w19', 'Research & world-building bible', 5, 'w20',
          'Story bible: places, cast, timeline, research notes with sources', 60, 'Craft',
          'Build the story bible before the draft consumes you: a '
              'character dossier per major cast member, a place list, a '
              'timeline that will not contradict itself, and researched '
              'notes (with sources) on anything you cannot fake. '
              'Consistency is a craft, not a memory.'),
      // — Production: the novel spine —
      _n('w3', '12 short stories (one a month)', 3, 'w2',
          'Finished drafts — quantity before quality', 200, 'The Novel',
          'Write and FINISH one short story a month for a year. Finished '
              'is the skill being trained — beginning, middle, end, typed '
              'THE END. Quantity buys quality here; do not polish, do not '
              'stall, feed the twelve.'),
      _n('w5', 'NaNoWriMo: 50,000-word draft', 5, 'w4',
          "Winner's word-count export", 100, 'The Novel',
          'Draft 50,000 words in 30 days (1,667/day). The point is to '
              'silence the inner editor and prove you can produce at '
              'volume — outline first if you are a plotter, wing it if '
              'you are a pantser, but hit the count and export the '
              'proof.'),
      _n('w7', 'The novel: 90,000-word complete draft', 7, ['w6', 'w19', 'w23'],
          'Full manuscript, beginning–middle–end', 400, 'The Novel',
          'Write the whole novel — 90,000 words, structurally complete, '
              'from your bible and beat sheet. A daily word quota you '
              'never break (even 500). This is the mountain; most '
              'aspiring novelists never summit it. Finish the draft, '
              'however rough.'),
      _n('w8', 'Developmental revision (macro edit)', 8, ['w7', 'w16'],
          'Revision map: what changed and why', 200, 'The Novel',
          'The macro edit: read the whole draft as a reader, map its '
              'structural failures (sagging middle, weak stakes, a '
              'character who does nothing), then rebuild. Write the '
              'revision map first — what changes and why — before '
              'touching a sentence.'),
      _n('w9', 'Prose craft (Zinsser + line edits)', 9, ['w8', 'w18'],
          'Three chapters line-edited; before/after with cut-word counts',
          100, 'The Novel',
          'Now the line edit: read On Writing Well, then edit three '
              'chapters sentence by sentence — cut every word that does '
              'not work, vary rhythm, kill filter words and '
              'redundancy. Track the cut-word count; 10–15% shrinkage '
              'is normal and healthy.'),
      _n('w11', 'Beta cycle: 5 readers', 10, 'w9',
          'Feedback grid + acted-on list', 60, 'The Novel',
          'Send the revised manuscript to five beta readers with a '
              'targeted question sheet (where were you bored, confused, '
              'lost trust). Collate answers into a grid; where three or '
              'more agree, it is real. Decide what to act on and write '
              'the acted-on list.'),
      // — Community & submission —
      _n('w16', 'Critique circle membership', 4, 'w3',
          '20 critiques given, 5 received (Scribophile/Critters)', 60, 'Arena',
          'Join a real critique community (Scribophile, Critters, a '
              'local group). Give 20 thoughtful critiques — reading '
              'critically is how you learn to see your own faults — and '
              'receive five on your own work. Learn to take notes '
              'without defending.'),
      _n('w17', 'Flash & short: submit 10 pieces', 5, 'w16',
          '10 submissions logged (Duotrope); rejections collected proudly', 40, 'Arena',
          'Polish short pieces and submit to real markets, tracked in '
              'Duotrope or a spreadsheet: 10 submissions out at once. '
              'Rejections are the entry fee — collect them proudly. '
              'Learn the submission machinery on low stakes before the '
              'novel.'),
      _n('w21', 'Place a short story', 8, 'w17',
          'One story accepted anywhere real, or 3 personal rejections earned', 40, 'Arena',
          'Keep submitting and revising until one story is accepted by '
              'a real venue (paying or reputable), OR you earn three '
              'personal rejections — the editor-wrote-back kind that '
              'mean you are close. Either proves you can meet an '
              'outside bar.'),
      _n('w10', 'Submission craft: query + synopsis', 11, ['w11', 'w21'],
          'Package critiqued in a query workshop', 40, 'Arena',
          'Write the query letter (hook, book, bio) and the dreaded '
              'one-page synopsis. These are their own genre. Run the '
              'package through a query workshop (r/PubTips, Query '
              'Shark archives as your textbook) and revise until it '
              'stops drawing form-reject predictions.'),
      _n('w12', 'Enter the arena: 20 submissions', 12, 'w10',
          'Log — 3 personal responses OR 1 acceptance', 40, 'Arena',
          'Query 20 agents or submit to 20 presses in tiers, tracked '
              'carefully. The bar to clear: three personal responses '
              '(a request, a near-miss with notes) or one offer. '
              'Revise the package between tiers based on the pattern of '
              'responses.'),
      // — Convergence —
      _n('w14', 'Crown: publish', 13, ['w12', 'w24'],
          'Traditional deal OR professional self-release, 50+ verified readers', 150, 'Convergence',
          'Get the book into readers\' hands: sign with an agent/press, '
              'or self-publish to a professional standard (edited, '
              'designed cover, proper formatting). The crown is not the '
              'upload — it is 50+ verified readers who are not your '
              'friends and family.'),
      _n('w24', 'Publishing literacy: contracts, rights & marketing', 12, 'w10',
          'Trad vs indie decision memo; a mock contract read for the 5 '
              'clauses that matter; a launch plan', 40, 'Arena',
          'Before you publish blind, learn the business: read the free '
              'Writer Beware and SFWA resources, understand rights, '
              'royalties and the five contract clauses that bite. Write '
              'a trad-vs-indie decision memo for YOUR book and a '
              'realistic launch plan — publishing is a second craft.'),
    ]),
    // Branches: Technique Spine · Baking & Pastry · Food Science · World
    // Cuisines & Presentation — crown = the 8-course tasting menu.
    Skill('cooking', 'Cooking', '🍳', 'Chef of Your Own Table', [
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
    ]),
    // Branches: Auto · Home · Machines (bike → engine) · Making (wood, CAD,
    // metal) — crown = a rebuilt machine and a transformed room.
    Skill('mechanics', 'Mechanics', '🔧', 'Rebuild It Yourself', [
      _n('m1', 'Shop safety + tool literacy', 1, null,
          'Tool ID quiz; torque practice; jack-stand discipline video', 20, 'Foundations',
          'Learn every common hand and power tool by name and use, '
              'PPE discipline (eyes always, no gloves in rotating '
              'tools), and the non-negotiable safety rituals. Film '
              'yourself lifting a car and placing jack stands correctly '
              '— NEVER work under a jack alone.'),
      // — Auto —
      _n('m2', 'Auto basics: fluids, filters, battery, tyres', 2, 'm1',
          'Perform + document all on a real car', 30, 'Auto',
          'On a real car: oil and filter change, air and cabin '
              'filters, check and top all fluids, test and clean the '
              'battery, rotate tyres and set pressures. Document each '
              'with the torque specs from the manual — the maintenance '
              'that prevents most breakdowns.'),
      _n('m4', 'Auto: brakes & suspension', 3, 'm2',
          'Pad/rotor change documented; ASE A5 practice ≥80%', 40, 'Auto',
          'Change brake pads and rotors, bleed the lines, inspect the '
              'suspension (bushings, shocks, ball joints). Document the '
              'job and pass an ASE A5 (brakes) practice exam ≥80%. '
              'Brakes are where mistakes are unforgiving — torque to '
              'spec, no shortcuts.'),
      _n('m6', 'Auto: electrics + OBD-II diagnostics', 4, 'm4',
          '3 real faults chased with multimeter + scanner log', 60, 'Auto',
          'Learn automotive electrical (12V circuits, grounds, '
              'relays, fuses) and OBD-II. Chase three real faults with '
              'a multimeter and a scanner — read the code, form a '
              'hypothesis, test it, fix it — logging the diagnostic '
              'reasoning, not just the part swapped.'),
      _n('m12', 'ASE knowledge gauntlet', 7, 'm10',
          'A1–A8 practice exams, all ≥80%', 120, 'Auto',
          'Work through the ASE A1–A8 material (engine, transmission, '
              'brakes, electrical, HVAC, steering/suspension, '
              'performance, diesel) and pass every practice exam ≥80%. '
              'This is the automotive body of knowledge, self-verified '
              'against the professional standard.'),
      // — Home —
      _n('m3', 'Home basics: drywall, painting, patching', 2, 'm1',
          'Repair a wall section, document the finish', 30, 'Home',
          'Patch a real hole in drywall — cut, backer, mud in three '
              'coats, sand, prime, paint to an invisible finish. Learn '
              'the taping-knife technique and how to feather. The '
              'finish is the test: run a light along the wall and see '
              'no shadow.'),
      _n('m5', 'Home: plumbing fundamentals', 3, 'm3',
          'Replace a trap/valve; sweat or press one joint', 40, 'Home',
          'Learn supply vs drain-waste-vent, then do real work: '
              'replace a P-trap, swap a shutoff valve or faucet, and '
              'make one permanent joint — sweat copper with a torch '
              '(fire-safe) or press/PEX. Water off first, always test '
              'for leaks under pressure.'),
      _n('m7', 'Home: electrical theory + code literacy', 4, 'm5',
          'Practice board wired (dead circuits); code quiz ≥80%', 60, 'Home',
          'Learn residential wiring theory and NEC basics. Practice '
              'ONLY on dead, disconnected circuits (a plywood practice '
              'board): outlets, switches, three-ways, a small panel '
              'mock-up. Pass a code-literacy quiz ≥80%. Know exactly '
              'what a licensed electrician must legally do.'),
      _n('m9', 'Home: framing & structural basics', 5, 'm17',
          'Stud wall or shed section, square + plumb', 60, 'Home',
          'Learn load paths, spans and framing (Larry Haun\'s free '
              'videos are gold). Build a real stud wall or shed '
              'section: layout, plates, studs 16" on-centre, headers, '
              'checked square and plumb. Understand what is structural '
              'before you ever remove a wall.'),
      _n('m11', 'Home: full room renovation', 6, ['m9', 'm7'],
          'Before/after with process log', 150, 'Home',
          'Renovate one room end to end: demo, any framing changes, '
              'the electrical and plumbing you are qualified to do '
              '(licensed help where required), drywall, trim, paint, '
              'floor. Document the whole process — this integrates '
              'every home skill into one visible transformation.'),
      _n('m15', 'EPA 608 (refrigerant handling)', 7, 'm7',
          'The real certificate — publicly bookable', 30, 'Home',
          'Study for and pass the real EPA Section 608 certification '
              '(Universal) — publicly bookable, legally required to '
              'buy refrigerant. Learn the refrigeration cycle, '
              'recovery, and why venting is both illegal and '
              'environmentally serious.'),
      // — Machines: bicycle → engine —
      _n('m16', 'Bicycle: full tune-up', 2, 'm1',
          'Brakes, gears, bearings serviced; Park Tool checklist; ride test', 25, 'Machines',
          'Using the free Park Tool Big Blue Book / videos, fully '
              'service a bike: true a wheel, adjust brakes and '
              'derailleurs to shift crisply, overhaul a hub or '
              'bottom-bracket bearing, check the whole safety '
              'checklist. Ride-test it. The mechanical fundamentals in '
              'miniature.'),
      _n('m8', 'Small-engine teardown: rebuild to running', 5, ['m6', 'm16'],
          'Junkyard/lawnmower engine — video of first start', 60, 'Machines',
          'Get a dead lawnmower or small engine (free on curbs). '
              'Diagnose, tear it fully down, clean the carb, replace '
              'what is worn, reassemble to spec, and film the first '
              'start. The four-stroke cycle becomes real in your '
              'hands here.'),
      _n('m10', 'Motorcycle/car engine rebuild', 6, 'm8',
          'Compression numbers before/after', 150, 'Machines',
          'Rebuild a real engine: teardown, measure wear against '
              'spec (bore, ring gap, bearing clearance with '
              'plastigauge), replace gaskets/rings/bearings, torque '
              'in sequence, reassemble. Prove it with compression '
              'numbers before and after — the deep end of machines.'),
      // — Making: wood, CAD, metal —
      _n('m17', 'Woodworking I: build a workbench', 3, 'm3',
          'Square, level bench from plans; joinery photos; technique video', 60, 'Making',
          'Build a real workbench from plans (Paul Sellers\' free '
              'series is a superb start): dimension the stock, cut '
              'genuine joinery (mortise-and-tenon or bridle joints), '
              'glue up square and flat. Photograph the joints; the '
              'bench is both tool and proof.'),
      _n('m18', 'CAD + 3D printing', 4, 'm17',
          'Three designed-and-printed functional parts; tolerances measured', 60, 'Making',
          'Learn parametric CAD (Fusion 360 free tier or FreeCAD) and '
              'FDM printing. Design and print three FUNCTIONAL parts — '
              'a bracket, a replacement knob, a jig — measuring '
              'tolerances with calipers and iterating until they fit. '
              'Digital fabrication for real repairs.'),
      _n('m19', 'Metalwork & fasteners', 5, 'm18',
          'Tap & die practice; a steel bracket made; makerspace intro class ok', 40, 'Making',
          'Learn to work metal: cut, file, drill, tap and die '
              'threads, and rivet or bolt. Make a steel bracket to a '
              'drawing. A makerspace intro-to-welding class is the '
              'ideal (supervised) way to add MIG basics — safety gear '
              'mandatory.'),
      _n('m20', 'Welding: sound structural joints', 6, 'm19',
          'A supervised course completed; 5 joint types passing a '
              'bend/break test', 60, 'Making',
          'Take a real supervised welding course (community college or '
              'makerspace — never self-taught with a rented machine and '
              'no ventilation). Learn MIG at minimum: five joint types '
              '(butt, lap, tee, corner, edge) that pass a bend-or-'
              'break test, with full PPE and fire discipline.'),
      // — Convergence —
      _n('m14', 'Crown: one machine + one room, end to end', 8,
          ['m12', 'm11', 'm15', 'm20'],
          'A vehicle you rebuilt driving; a room you transformed', 200, 'Convergence',
          'The two-part crown: a machine you rebuilt with your own '
              'hands running and safe (a car passing inspection, a '
              'motorcycle on the road, an engine at spec), AND a room '
              'you transformed end to end. Documented before/after for '
              'both — self-reliance made visible.'),
    ]),
    // Branches: Systems · Applied Memory (real knowledge) · Competition
    // Drills · Science of Learning — crown = ranked competition.
    Skill('memory', 'Memory', '🧩', 'Compete Among the Best from Your Desk', [
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
    ]),
    // Branches: Kihon & Kata · Kumite & Partner Work · Conditioning ·
    // Theory, History & Mind — crown = Sandan and a group you lead.
    Skill('karate', 'Karate', '🥋', 'Shodan and Beyond, Honestly Earned', [
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
    ]),
]);
