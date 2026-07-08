// data/catalog_wis.dart — the WIS constellations.
// Part of skill_data.dart: same library, same laws (see the five
// laws there and test/skill_data_test.dart). Every node: id, label,
// tier, requires, proof (completion standard), hours (researched
// effort), branch, guide (the exact work, spelled out).
part of 'skill_data.dart';

final StatDomain wisDomain = StatDomain('WIS', 'Wisdom', 0xFFC084FC, [
    // Branches: World Knowledge · Physical & Human Geography · Geopolitics ·
    // Spatial Tech & Field Craft — crown = published analysis + forecasts.
    Skill('geography', 'Geography', '🌍', 'Global Geospatial Analyst & Forecaster', [
      _n('g1', 'Anki: 196 nations, capitals & flags', 1, null,
          'Matured deck, 95%+ retention; all 196 placed on a blank map',
          60, 'Foundations',
          'Download a shared "countries of the world" Anki deck (or build '
              'one from the UN list): name↔capital↔flag↔location, 20 new '
              'cards a day with honest reviews. Weekly, print a blank world '
              'map and fill every country you have learned so far.'),
      // — World knowledge —
      _n('g3', 'Blank-map mastery: 100 physical features', 2, 'g1',
          'Rivers, ranges, straits, chokepoints placed from memory', 50, 'World Knowledge',
          'Build a 100-item list: 25 rivers, 20 mountain ranges, 15 straits '
              'and canals, 20 seas/gulfs, 20 deserts/plateaus. Drill with '
              'Seterra (free) until 95%+, then place all 100 on one printed '
              'blank map in a single sitting, no references.'),
      _n('g21', 'Navigation: map & compass', 2, 'g1',
          'A 10 km navigation leg completed with map+compass only; contour '
              'quiz passed', 40, 'World Knowledge',
          'Learn contour reading, bearings and triangulation from a free '
              'orienteering-club course or The Natural Navigator + practice. '
              'Then walk a pre-planned 10 km route with paper map and '
              'compass only — phone sealed in the bag for emergencies — '
              'hitting 8 checkpoints.'),
      _n('g6', 'iGeo past papers', 4, ['g3', 'g5'],
          '2 full papers self-timed, ≥60%', 60, 'World Knowledge',
          'Download past International Geography Olympiad written-response '
              'and multimedia tests (free on the iGeo site). Sit two full '
              'papers under exam timing, mark against the published answer '
              'keys, and drill whichever section scored lowest.'),
      // — Physical & human geography —
      _n('g2', 'Physical Geography (Strahler)', 2, 'g1',
          'Chapter self-exams: landforms, climate, biomes', 150, 'Physical & Human',
          'Strahler\'s Introducing Physical Geography (or the free Physical '
              'Geography.net text): plate tectonics, landforms, climate '
              'systems, biomes. After each chapter, take its self-exam and '
              'explain one local landform through what you just read.'),
      _n('g5', 'Human Geography (AP HuG)', 3, 'g2',
          '≥4 on two released AP exams, timed', 120, 'Physical & Human',
          'The AMSCO AP Human Geography text (or Mr. Sinn\'s free video '
              'course) unit by unit: population, culture, politics, '
              'agriculture, cities. Then two released AP exams under real '
              'timing, self-scored with the College Board rubrics.'),
      _n('g18', 'Weather & climate systems', 3, 'g2',
          'Cloud/front identification; 30-day forecast journal vs actuals', 60, 'Physical & Human',
          'The free JetStream school (NOAA) end to end. Then keep a 30-day '
              'journal: each morning read the synoptic chart, write your own '
              'local forecast, and score it against what happened. Learn the '
              '10 cloud genera from photos until identification is instant.'),
      _n('g22', 'Urban geography & city form', 4, 'g5',
          'Three cities analysed (form, transit, land use) with maps; Jacobs '
              'essay written', 60, 'Physical & Human',
          'Read The Death and Life of Great American Cities (Jacobs), then '
              'analyse three cities you know from satellite + street level: '
              'street grid, transit skeleton, land-use rings, where the '
              'plans failed. Write what Jacobs would say about each.'),
      _n('g19', 'Demography & migration', 5, 'g22',
          'UN population data: 5 charted analyses; migration-corridor brief', 60, 'Physical & Human',
          'Pull raw data from UN World Population Prospects and OurWorldIn'
              'Data. Chart five stories yourself (pyramids of 3 contrasting '
              'nations, fertility transitions, dependency ratios), then '
              'write a 2-page brief on one real migration corridor: pushes, '
              'pulls, remittances, policy.'),
      // — Geopolitics & strategy —
      _n('g4', 'Prisoners + Revenge of Geography', 2, 'g1',
          'One-page strategic brief per chapter', 40, 'Geopolitics',
          'Read Marshall\'s Prisoners of Geography, then Kaplan\'s The '
              'Revenge of Geography. For every chapter write a one-page '
              'brief: the constraint (mountains, rivers, ports), the '
              'strategy it forces, and one current news story it explains.'),
      _n('g8', 'Guns, Germs & Steel — with its critics', 3, 'g4',
          '1,500-word assessment arguing both sides', 50, 'Geopolitics',
          'Read Diamond, then read the anthropologists\' criticisms '
              '(the "Vulgar materialism" debates, McNeill\'s review). Write '
              '1,500 words: what the thesis explains, where determinism '
              'overreaches, what evidence would settle it.'),
      _n('g12', 'The Silk Roads + The Grand Chessboard', 4, 'g8',
          'Comparative essay: geography as strategy', 60, 'Geopolitics',
          'Frankopan\'s The Silk Roads for the longue-durée trade view, '
              'Brzezinski\'s The Grand Chessboard for the strategist\'s '
              'view. Essay: where do they agree that geography writes '
              'strategy, and which of Brzezinski\'s 1997 predictions '
              'survived?'),
      _n('g23', 'Economic geography: trade, ports, energy', 6, 'g12',
          'Global flow maps of one commodity + energy; brief on 3 '
              'chokepoints with disruption scenarios', 70, 'Geopolitics',
          'Using UN Comtrade and free shipping-density maps, map the global '
              'flow of one commodity and of oil/LNG. Write a brief on three '
              'chokepoints (Hormuz, Malacca, Suez): what passes, what a '
              'closure reroutes, who pays.'),
      _n('g14', 'Forecasting: 25 scored predictions', 6, ['g6', 'g12'],
          'Good Judgment Open — beat the median Brier score', 100, 'Geopolitics',
          'Read Superforecasting (Tetlock), then make 25 real forecasts on '
              'Good Judgment Open or Metaculus over ~6 months. Follow the '
              'commandments: break questions down, update often, keep a '
              'decision journal. Beat the median Brier score.'),
      _n('g25', 'Regional mastery: one region deep', 7, ['g23', 'g14'],
          'A 4,000-word regional risk assessment with maps and 5 scored '
              'forecasts attached', 80, 'Geopolitics',
          'Choose one region (Sahel, South China Sea, Caucasus...). Read '
              'its two standard histories, follow its specialist analysts '
              'for two months, then write a 4,000-word risk assessment — '
              'actors, constraints, scenarios with probabilities — and '
              'register five falsifiable forecasts about it.'),
      // — Spatial tech & field craft —
      _n('g7', 'QGIS Fundamentals', 3, 'g2',
          'Official training manual exercises; 3 finished maps', 80, 'Spatial Tech',
          'The official QGIS Training Manual (free), modules 1–7: layers, '
              'symbology, attribute queries, print layouts. Produce three '
              'finished maps of your own area — land use, elevation, a '
              'themed choropleth — exported print-quality.'),
      _n('g24', 'OpenStreetMap: 500 real edits', 3, 'g3',
          '500 surviving edits incl. one HOT task; edits pass validation', 50, 'Spatial Tech',
          'Learn editing with the OSM iD walkthrough, then make 500 real '
              'contributions: your neighbourhood\'s missing buildings, '
              'shops, paths — plus at least one Humanitarian OSM Team '
              '(HOT) mapping task. Edits must survive community validation.'),
      _n('g9', 'Spatial SQL (PostGIS)', 4, 'g7',
          'Workshop queries + one analysis of your own', 60, 'Spatial Tech',
          'The free Introduction to PostGIS workshop end to end: loading '
              'shapefiles, spatial joins, buffers, nearest-neighbour. Then '
              'one analysis of your own on open city data ("which homes are '
              '>800 m from a park?"), query file + map published.'),
      _n('g20', 'Field craft: survey your own region', 4, ['g7', 'g18', 'g21'],
          'Field notebook + a hand-drawn then QGIS map of your local landscape', 40, 'Spatial Tech',
          'Walk your area for a week with a field notebook: landforms, '
              'drainage, land use, microclimates, desire paths. Sketch a '
              'hand-drawn map first (the looking is the lesson), then '
              'rebuild it properly in QGIS with your GPS traces.'),
      _n('g10', 'Python Geospatial (GeoPandas)', 5, 'g9',
          'Reproduce 3 published maps from raw data', 80, 'Spatial Tech',
          'The GeoPandas official tutorials + Automating GIS Processes '
              '(free Helsinki course). Reproduce three published maps from '
              'their raw open data — a choropleth, a flow map, a cluster '
              'analysis — notebooks public on GitHub.'),
      _n('g13', 'Commodity chain: one resource end-to-end', 5, ['g9', 'g12'],
          'Sourced map + 2,000-word report', 80, 'Spatial Tech',
          'Pick one commodity (lithium, coffee, cobalt). Trace mine/farm → '
              'processing → shipping lanes → end markets with real trade '
              'data (UN Comtrade, USGS). Deliver a sourced flow map built '
              'with your own SQL/GeoPandas plus a 2,000-word report.'),
      _n('g17', 'Cartographic design', 5, ['g20', 'g24'],
          '5 publication-quality maps; redesigns critiqued against classics', 60, 'Spatial Tech',
          'Study Cartography (Field) or the free Axis Maps guide: visual '
              'hierarchy, projections, colour, labels. Produce five '
              'publication-quality maps, including one redesign of a bad '
              'map you found in the wild, with a written critique of both.'),
      _n('g11', 'Remote Sensing (Google Earth Engine)', 6, 'g10',
          'NDVI change-detection study of a region', 80, 'Spatial Tech',
          'Google Earth Engine\'s free tutorials: image collections, '
              'compositing, indices. Run an NDVI change-detection study of '
              'one region across 10 years (deforestation, urban sprawl, '
              'a drying lake), with honest cloud-masking and a write-up.'),
      // — Convergence —
      _n('g15', 'Interactive global dashboard', 7, ['g11', 'g13', 'g17'],
          'Public URL, 3 datasets you processed', 120, 'Convergence',
          'Build a public dashboard (Streamlit/Leaflet/Observable) serving '
              'three datasets you processed yourself — your remote-sensing '
              'study, your commodity chain, one live feed. Design to your '
              'cartography standards; a stranger must understand it in 60 '
              'seconds.'),
      _n('g16', 'Crown: original spatial analysis, published', 8,
          ['g25', 'g15', 'g19'],
          'Write-up + data + code public, forecast record attached', 150, 'Convergence',
          'Ask one original spatial question inside your region of mastery, '
              'answer it with your full stack (field notes → PostGIS → '
              'GeoPandas → Earth Engine → cartography), and publish: '
              'write-up, data, code, and your scored forecast record. Send '
              'it to three geographers for critique.'),
    ]),
    // Branches: Grand Survey (Durant spine) · Methods & Primary Sources ·
    // Thematic Depth · Craft & Output — crown = a published monograph.
    Skill('history', 'History', '📜', 'Master Historian & Archival Synthesis', [
      _n('h1', 'Methods: From Reliable Sources', 1, null,
          'Source-critique exercise on 3 documents', 40, 'Foundations',
          'Read Howell & Prevenier\'s From Reliable Sources. Then take '
              'three documents (a medieval charter from a digitised archive, '
              'a WWI letter, a modern press release) and write a full '
              'source critique of each: provenance, audience, bias, '
              'corroboration.'),
      // — Grand survey —
      _n('h5', 'Big picture: Sapiens + Why the West Rules', 2, 'h1',
          'Critical brief: where they disagree and why', 60, 'Grand Survey',
          'Read Harari\'s Sapiens, then Morris\'s Why the West Rules — For '
              'Now. Write a critical brief: their models of historical '
              'change, three places they disagree, and which claims a '
              'working historian would call overreach.'),
      _n('h2', 'Durant I–III: Antiquity', 2, 'h1',
          'Era synthesis essay per volume', 150, 'Grand Survey',
          'The Story of Civilization volumes I–III (Our Oriental Heritage, '
              'The Life of Greece, Caesar and Christ) — free on the '
              'Internet Archive. One volume per month; after each, a '
              '1,500-word synthesis: what the era believed, built and '
              'broke.'),
      _n('h25', 'The memory timeline: 300 anchor dates', 2, 'h1',
          '300 dated events recalled to the decade, tested cold twice a '
              'month apart', 50, 'Grand Survey',
          'Build a 300-event anchor list spanning 3000 BCE → today (major '
              'wars, dynasties, inventions, plagues). Memorise with a '
              'timeline memory palace + Anki. Test: given any 30 random '
              'events, place all within the correct decade — twice, a '
              'month apart.'),
      _n('h3', 'Durant IV–VI: Middle Ages', 3, ['h2'],
          'Essay per volume: what the era believed, built and broke',
          150, 'Grand Survey',
          'Volumes IV–VI (The Age of Faith through The Reformation). Keep '
              'the essay ritual, and start a running "threads" file: trace '
              'law, money and faith as continuous threads across volumes '
              'rather than era-bound facts.'),
      _n('h4', 'Durant VII–XI: Modern Era', 4, ['h3', 'h25'],
          'Essay per volume; a century timeline you can redraw from memory',
          250, 'Grand Survey',
          'Volumes VII–XI (Age of Reason through Age of Napoleon). Essay '
              'per volume as before; merge everything into your anchor '
              'timeline so you can redraw 1500–1815 century by century — '
              'rulers, wars, ideas — on a blank sheet.'),
      // — Methods & primary sources —
      _n('h18', 'Historiography: Carr vs Evans', 2, 'h1',
          'What is History? + In Defense of History; your own position essay', 50, 'Sources',
          'Read E.H. Carr\'s What Is History?, then Richard Evans\'s In '
              'Defense of History as the rebuttal. Write your own 1,500-'
              'word position: what a historical fact is, what objectivity '
              'can mean, where you land between them — with examples.'),
      _n('h11', 'Primary sources I: analyse 10', 3, 'h1',
          'Avalon Project etc. — provenance-first analyses', 40, 'Sources',
          'From the Avalon Project, Fordham sourcebooks and EuroDocs, pick '
              '10 primary documents across eras. For each: a provenance-'
              'first analysis (who, when, for whom, surviving how) before '
              'any interpretation. One page each.'),
      _n('h20', 'Local history: your town from records', 4, 'h11',
          'Census/parish/newspaper archives: 2,000 words on your own street', 60, 'Sources',
          'Use digitised censuses, parish registers, old newspapers and '
              'maps (most libraries give free access) to reconstruct your '
              'own street or district across a century: who lived there, '
              'what changed, why. 2,000 words, every claim footnoted to a '
              'record.'),
      _n('h19', 'Oral history: 3 recorded interviews', 6, 'h20',
          'Consent-documented recordings, transcriptions + contextual essay', 40, 'Sources',
          'Follow the Oral History Association\'s free guidelines: signed '
              'consent, good audio, open questions, silence tolerated. '
              'Interview three elders about one theme (migration, work, a '
              'local event); transcribe fully and write the contextual '
              'essay connecting them to the documented record.'),
      // — Thematic depth —
      _n('h6', 'SPQR (Beard)', 3, 'h2', "2,000-word review against Durant's Rome", 40, 'Thematic Depth',
          'Read Beard\'s SPQR with Durant\'s Caesar and Christ fresh in '
              'mind. The 2,000-word review: where modern scholarship '
              '(Beard) overturns the 1940s synthesis (Durant), what '
              'evidence did it — inscriptions, archaeology — and what '
              'Durant still gets right.'),
      _n('h21', 'China: the dynastic arc', 3, 'h5',
          'Ebrey worked through; dynasty timeline + 3 turning-point essays '
              'from memory', 80, 'Thematic Depth',
          'Ebrey\'s Cambridge Illustrated History of China cover to cover, '
              'with Harvard\'s free ChinaX clips where a topic needs more. '
              'Redraw the dynasty timeline from memory (dates to the '
              'decade), and write three turning-point essays: Qin '
              'unification, the Song commercial revolution, 1644.'),
      _n('h16', 'AP World History', 4, ['h21', 'h2'],
          '≥4 on two released exams, timed', 80, 'Thematic Depth',
          'Fill gaps with AMSCO\'s AP World text (or Heimler\'s free video '
              'course), then sit two released AP World exams under real '
              'timing including the essays, self-scored against College '
              'Board rubrics. ≥4-equivalent on both.'),
      _n('h22', 'The Islamic world & the Ottomans', 4, 'h3',
          'Ansary + an Ottoman history; 5 corrective essays on the standard '
              'Western narrative', 70, 'Thematic Depth',
          'Read Ansary\'s Destiny Disrupted (history through Islamic eyes), '
              'then Finkel\'s Osman\'s Dream on the Ottomans. Write five '
              'short corrective essays: where the Europe-centred story you '
              'learned gets the caliphates, al-Andalus, the Mongols, '
              'Süleyman and 1683 wrong.'),
      _n('h7', 'The Sleepwalkers (WWI origins)', 5, 'h4',
          'Essay comparing 3 schools on war guilt', 50, 'Thematic Depth',
          'Read Clark\'s The Sleepwalkers, plus summaries of the Fischer '
              'thesis and the older "slide to war" consensus. Essay: three '
              'schools on 1914 war guilt, their key evidence, and which '
              'you find most convincing after Clark — argued, not '
              'asserted.'),
      _n('h8', 'The Second World War (Keegan)', 5, 'h4',
          'Campaign analysis of one theatre', 60, 'Thematic Depth',
          'Keegan\'s The Second World War entire, then choose one theatre '
              '(North Africa, Pacific 1942, the Eastern Front) and write a '
              'campaign analysis: objectives, logistics, decisive choices, '
              'counterfactuals — with hand-drawn campaign maps.'),
      _n('h23', 'The Americas: 1491 to independence', 5, 'h16',
          '1491 + colonial survey; 3 essays; the Columbian Exchange mapped '
              'from memory', 60, 'Thematic Depth',
          'Mann\'s 1491 (pre-Columbian societies as they actually were), '
              'then a colonial survey (Taylor\'s American Colonies or '
              'Restall for New Spain). Three essays: Cahokia/Tenochtitlan '
              'urbanism, demographic catastrophe, the independence wave — '
              'plus the Columbian Exchange drawn from memory.'),
      _n('h24', 'Africa: the continental survey', 5, 'h16',
          'Meredith worked; 5 pre-colonial states essayed; the Scramble '
              'mapped from memory', 60, 'Thematic Depth',
          'Meredith\'s The Fortunes of Africa cover to cover. Write five '
              'short essays on pre-colonial states (Aksum, Mali, Great '
              'Zimbabwe, Benin, Ethiopia), and redraw the 1884→1914 '
              'Scramble map from memory with the colonial powers labelled.'),
      _n('h9', 'Cold War (Gaddis)', 6, 'h8',
          'Periodisation essay: when did it begin and end?', 40, 'Thematic Depth',
          'Gaddis\'s The Cold War: A New History, plus one revisionist '
              'chapter (Westad\'s The Global Cold War introduction). '
              'Periodisation essay: candidate start and end dates, what '
              'each implies about causes, and the view from the Third '
              'World that Gaddis underweights.'),
      _n('h10', 'Economic history (Clark + VSI)', 6, 'h4',
          'Brief: why the Industrial Revolution, why England', 50, 'Thematic Depth',
          'Clark\'s A Farewell to Alms + the Very Short Introduction to '
              'the Industrial Revolution + Allen\'s coal-and-wages '
              'argument (papers free online). Brief: the four main answers '
              'to "why England, why 1760", the evidence each rests on, '
              'your ranking.'),
      // — Craft & output —
      _n('h17', 'DBQ craft: 5 document-based essays', 5, ['h11', 'h16'],
          'Self-graded vs College Board rubrics, ≥5/7', 40, 'Craft',
          'Five released AP DBQs (World or Euro), written under the real '
              '60-minute clock: thesis, document grouping, outside '
              'evidence, sourcing commentary. Grade against the official '
              'rubric a day later; ≥5/7 on the last three.'),
      _n('h12', 'Lessons of History + write your own', 7, ['h7', 'h9', 'h10'],
          'Your own 12 lessons, each sourced', 60, 'Craft',
          'Reread the Durants\' The Lessons of History (it is 100 pages). '
              'Then write your own twelve lessons — each one page, each '
              'grounded in at least three episodes you can cite from your '
              'own reading, each with the strongest counterexample stated '
              'honestly.'),
      _n('h13', '5,000-word era synthesis', 7, ['h6', 'h17', 'h18', 'h22'],
          'Your chosen era, 15+ sources, footnoted', 80, 'Craft',
          'Choose the era you know best. 5,000 words with a real thesis — '
              'not a summary — built on 15+ sources including 5 primary. '
              'Full footnotes (Chicago style), an honest historiography '
              'paragraph, and one map or table you made yourself.'),
      _n('h14', 'Archival project: a real digitised archive', 8,
          ['h13', 'h19'], '10 primary finds transcribed + contextualised', 80, 'Craft',
          'Pick one digitised archive (national archives, Old Bailey '
              'Online, a newspaper archive). Define a question, then find '
              'TEN documents no synthesis you own discusses; transcribe '
              'each (palaeography guides are free) and write its context '
              'card: what it is, what it shows, what it complicates.'),
      _n('h15', 'Crown: 10,000-word sourced monograph', 9,
          ['h12', 'h14', 'h24', 'h23'],
          'Published online; critique from 2 knowledgeable readers', 200, 'Craft',
          'The capstone: 10,000 words on the question your archival finds '
              'opened, argued against the existing literature, primary '
              'sources at the core. Publish it (a blog, a local history '
              'journal), send it to two knowledgeable readers, and '
              'incorporate their objections in a revision note.'),
    ]),
    // Branches: Economics & Markets · Accounting → CFA spine · Strategy &
    // Operations · Practice (negotiation, a real venture) — crown = record.
    Skill('business', 'Business', '📊', 'Run Money Like an Institution', [
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
    ]),
    // Branches: Psych Core · Methods & Statistics · Mind & Society ·
    // Applied Practice — crown = a published, preregistered study.
    Skill('socialSci', 'Social Sci', '🧠', 'Run a Real Behavioral Study', [
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
    ]),
]);
