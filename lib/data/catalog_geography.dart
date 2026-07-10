// data/catalog_geography.dart — the geography constellation.
// Part of skill_data.dart: one Skill tree, governed by the catalog
// laws (see skill_data.dart + test/skill_data_test.dart). Every star:
// id, label, tier, requires, proof (completion standard), hours
// (researched effort), branch, guide (the exact work, step by step).
part of 'skill_data.dart';

final Skill geographyTree = Skill('geography', 'Geography', '🌍', 'Global Geospatial Analyst & Forecaster', [
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
]);
