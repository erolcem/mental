// data/catalog_turkish.dart — the turkish constellation.
// Part of skill_data.dart: one Skill tree, governed by the catalog
// laws (see skill_data.dart + test/skill_data_test.dart). Every star:
// id, label, tier, requires, proof (completion standard), hours
// (researched effort), branch, guide (the exact work, step by step).
part of 'skill_data.dart';

final Skill turkishTree = Skill('turkish', 'Turkish', '🇹🇷', 'C1+ and Real-Time Interpretation', [
      _n('tr1', 'Phonology, vowel harmony, agglutination', 1, null,
          'Transcribe/pronounce 50 words; suffix-chain drills', 30, 'Foundations',
          'Learn the sound system and vowel harmony rules (free: Turkish '
              'Tea Time archives, Manisa Turkish). Drill suffix chains '
              'until ev→evler→evlerimizde feels mechanical. Record '
              'yourself pronouncing 50 words; have a native (or '
              'Forvo) arbitrate the vowels.'),
      // — Grammar spine —
      _n('tr2', 'A1: 500 words + present tense', 2, 'tr1',
          'Matured deck; 10 self-recorded dialogues', 100, 'Grammar',
          'A1 with a real course (Yeni İstanbul A1 or the free Hands-on '
              'Turkish): present continuous, possessives, question '
              'particles, 500-word deck from the lessons. Record ten '
              'two-minute dialogues with yourself playing both sides.'),
      _n('tr3', 'A2: 1,500 words; past/future; cases begin', 3, 'tr2',
          'Timed A2 mock (TÖMER-format) ≥70%', 180, 'Grammar',
          'A2 coursebook throughout: past/future tenses, the case system '
              'in earnest, 1,500 cumulative words. Finish with a TÖMER-'
              'format A2 mock under time, all four skills, self-scored '
              '≥70%.'),
      _n('tr4', 'B1: 3,000 words; full case system', 4, 'tr3',
          'Timed B1 mock; first 5 conversation hours', 300, 'Grammar',
          'B1: full case system including combinations, -ken/-ince/-dikçe '
              'clauses, 3,000 words. Book your first five hours of italki '
              'conversation — badness is the point. B1 mock timed at the '
              'end.'),
      _n('tr5', 'B2 grammar: chains, conditionals, evidentiality', 5, 'tr4',
          'Every structure drilled both ways; error log kept', 200, 'Grammar',
          'The B2 wall: -mış evidentiality, conditionals real and unreal, '
              'suffix chains (yapabileceğimden). For every structure: 10 '
              'sentences TR→EN and 10 EN→TR, checked by tutor or '
              'LangCorrect; every error into a typed log by category.'),
      _n('tr6', 'Relative clauses & nominalisation', 6, 'tr5',
          'Translate 30 complex sentences both ways', 60, 'Grammar',
          'The -en/-dik participle system is Turkish\'s real boss fight: '
              'drill "the man who came" vs "the book I read" until '
              'instant. Translate 30 genuinely complex sentences (news '
              'prose) both directions, tutor-checked.'),
      _n('tr8', 'B2 exam', 7, ['tr6', 'tr9', 'tr15'],
          'Full TYS-format mock, timed, ≥B2 band', 40, 'Grammar',
          'Sit a full TYS-format mock (Yunus Emre Institute publishes '
              'materials) under exam timing: reading, listening, writing, '
              'speaking recorded. Grade against the band descriptors '
              'honestly or pay a tutor one session to grade it.'),
      // — Input —
      _n('tr9', 'Input: 60 hrs Turkish media, no subs', 5, 'tr4',
          'Log + weekly summaries written in Turkish', 70, 'Input',
          'Sixty logged hours: start with Easy Turkish street interviews '
              'and A2/B1 podcasts, graduate to normal YouTube. No English '
              'subtitles ever; Turkish subtitles allowed until the last '
              '20 hours. Weekly 150-word summary written in Turkish.'),
      _n('tr15', 'Vocabulary: 5,000-word SRS', 5, 'tr4',
          'Deck built from your own input; sampled retention ≥90%', 150, 'Input',
          'Grow to 5,000 words — from HERE on, only words you met in real '
              'input or conversation become cards (with the sentence they '
              'came from). Monthly: sample 50 random mature cards; ≥90% '
              'recalled or you are adding too fast.'),
      _n('tr20', 'Dizi immersion: 3 series arcs', 6, 'tr9',
          '3 full dizi arcs watched; 300 mined sentences; plot summaries '
              'written in Turkish', 60, 'Input',
          'Pick three Turkish series (a classic dizi, a crime drama, a '
              'comedy) and watch a full arc of each with Turkish subs, '
              'mining 100 sentences per show into your SRS. After each '
              'arc: a one-page plot summary in Turkish, corrected.'),
      _n('tr10', 'C1 reading: a full Pamuk novel', 8, ['tr8', 'tr16', 'tr17', 'tr20'],
          'Reading journal; 500-word review in Turkish', 60, 'Input',
          'Read a complete literary novel in Turkish (Pamuk\'s Kar, or '
              'start friendlier with Ayşe Kulin). Reading journal per '
              'chapter: new structures, not just words. Finish with a '
              '500-word review in Turkish, corrected by a native.'),
      // — Output —
      _n('tr18', 'Scripted speaking: 20 monologues', 4, 'tr3',
          '20 recorded 2-min monologues; native feedback on 5', 20, 'Output',
          'Twenty two-minute monologues on everyday topics: script it, '
              'correct the script (tutor/LangCorrect), then record it '
              'WITHOUT the script. Post five to a language exchange for '
              'native feedback on pronunciation.'),
      _n('tr7', 'Conversation: 30 logged hours', 5, ['tr4', 'tr18'],
          'Session log; self-rated CEFR descriptors', 35, 'Output',
          'Thirty hours across italki/Tandem/HelloTalk: mix free '
              'conversation with topic sessions you prep vocabulary for. '
              'Log every session (date, topic, three new phrases, one '
              'recurring error). Self-rate against CEFR speaking '
              'descriptors monthly.'),
      _n('tr19', 'Writing I: 20 corrected texts', 6, 'tr5',
          'LangCorrect archive; error classes tracked and shrinking', 40, 'Output',
          'Twenty texts of 150–300 words on LangCorrect (or tutor-'
              'corrected): descriptions, opinions, a complaint letter, a '
              'story. Track error classes in a spreadsheet — case '
              'endings, vowel harmony slips, word order — and watch the '
              'counts fall.'),
      _n('tr11', 'Conversation: 100 total hours', 7, 'tr7',
          '15-min recorded discussion, native-checked', 80, 'Output',
          'Push to 100 cumulative hours, now mostly with natives who '
              'don\'t slow down. Monthly: record a 15-minute discussion '
              'on an abstract topic (politics, a film) and have a tutor '
              'mark the B2/C1 line moments.'),
      _n('tr12', 'C1 writing: 10 essays, corrected', 8, ['tr8', 'tr19'],
          'Corrected drafts archived', 40, 'Output',
          'Ten 400-word essays on abstract prompts (TYS-style): argued '
              'structure, connectors (halbuki, nitekim, dolayısıyla), '
              'register control. Every draft corrected and archived '
              'alongside its redline — the diff is the curriculum.'),
      _n('tr21', 'The news register: 30 articles shadowed', 8, 'tr19',
          '30 news items read aloud + summarised; 10 headline decodings '
              'explained', 40, 'Output',
          'Turkish news prose is its own dialect. Thirty articles (BBC '
              'Türkçe, bianet): read aloud, then summarise in your own '
              'Turkish. Decode ten dense headlines — the nominalisation '
              'chains — into plain sentences, checked.'),
      // — Culture & song —
      _n('tr16', 'Music & lyrics: 30 songs', 2, 'tr1',
          '30 songs studied; 10 sung or recited from memory', 40, 'Culture',
          'Thirty Turkish songs across arabesk, pop, Anadolu rock (Sezen '
              'Aksu, Barış Manço, Tarkan): lyrics printed, translated '
              'line by line, sung along. Ten memorised — melody carries '
              'vocabulary like nothing else.'),
      _n('tr17', 'Culture & history of Türkiye', 3, 'tr2',
          'A short history read; 10 culture briefs (customs, regions, cuisine)', 40, 'Culture',
          'Read a short history (Zürcher\'s Turkey: A Modern History, '
              'skimming the dense middle, or Pope\'s Turkey Unveiled). '
              'Write ten one-page briefs: tea culture, bayram customs, '
              'the seven regions, meze, hospitality codes — the software '
              'the language runs on.'),
      // — Convergence —
      _n('tr13', 'C1/C2 exam', 9, ['tr10', 'tr11', 'tr12', 'tr21'],
          'Full TYS mock ≥C1 (sit the real TYS if reachable)', 60, 'Convergence',
          'The full TYS under real conditions — sit the actual exam at a '
              'Yunus Emre centre if one is reachable, otherwise the '
              'complete mock with a tutor grading writing and speaking '
              'against the official rubric. ≥C1 band across all four '
              'skills.'),
      _n('tr14', 'Crown: consecutive interpretation', 10, 'tr13',
          'Interpret a 10-min talk EN→TR, recorded, native-verified', 40, 'Convergence',
          'Train the interpreter\'s drill: listen to 1-minute EN '
              'segments, take symbol notes, deliver in Turkish. Build to '
              'a full 10-minute TED-style talk interpreted EN→TR in '
              'chunks, recorded, and verified by a native for fidelity — '
              'the skill no certificate grants.'),
]);
