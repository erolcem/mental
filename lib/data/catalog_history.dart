// data/catalog_history.dart — the history constellation.
// Part of skill_data.dart: one Skill tree, governed by the catalog
// laws (see skill_data.dart + test/skill_data_test.dart). Every star:
// id, label, tier, requires, proof (completion standard), hours
// (researched effort), branch, guide (the exact work, step by step).
part of 'skill_data.dart';

final Skill historyTree = Skill('history', 'History', '📜', 'Master Historian & Archival Synthesis', [
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
]);
