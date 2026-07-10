// data/catalog_chinese.dart — the chinese constellation.
// Part of skill_data.dart: one Skill tree, governed by the catalog
// laws (see skill_data.dart + test/skill_data_test.dart). Every star:
// id, label, tier, requires, proof (completion standard), hours
// (researched effort), branch, guide (the exact work, step by step).
part of 'skill_data.dart';

final Skill chineseTree = Skill('chinese', 'Chinese', '🇨🇳', 'HSK 6 + the Spoken Skill HSK Never Tests', [
      _n('ch1', 'Pinyin + the four tones', 1, null,
          'Tone-pair minimal-pair test ≥90%; 50 syllables read aloud, '
              'native-checked', 40, 'Foundations',
          'Master pinyin and tones FIRST — errors fossilise. Use a tone-'
              'pair trainer (free: Dong Chinese, Hacking Chinese drills) '
              'daily; drill the ü/u, zh/j, q/x contrasts with minimal '
              'pairs. Record 50 syllables and have a native (or Forvo '
              'comparison) grade your tones.'),
      // — Hanzi —
      _n('ch2', 'Hanzi I: 500 characters + radicals', 2, 'ch1',
          'SRS matured; the 100 most common written from memory; 50 '
              'radicals named', 200, 'Hanzi',
          'Learn the 214 radicals\' top 50 first, then 500 characters via '
              'Anki with mnemonics (Heisig-style or Outlier dictionary). '
              'Every card: character→meaning+pinyin WITH tone. Write the '
              '100 most frequent by hand from memory — stroke order '
              'matters (Skritter or grid paper).'),
      _n('ch3', 'Hanzi II: 1,500 characters', 3, 'ch2',
          'SRS matured; a graded reader read leaning on hanzi, not pinyin',
          250, 'Hanzi',
          'Push to 1,500 with phonetic-component awareness — start '
              'predicting readings from 青/清/请 families. Read one full '
              'Mandarin Companion level-1 graded reader relying on '
              'characters alone, pinyin covered.'),
      _n('ch23', 'Traditional characters & calligraphy taste', 4, 'ch3',
          '300 traditional forms read; 20 characters brushed with a '
              'critique of stroke form', 60, 'Hanzi',
          'Learn the 300 most-diverged traditional forms (愛/爱, 學/学) '
              'so Taiwan/Hong Kong text and classical inscriptions open '
              'up. Then a taste of the art: brush (or brush-pen) 20 '
              'characters following a Kaishu copybook, comparing your '
              'strokes to the model honestly.'),
      _n('ch4', 'Hanzi III: 3,000 + handwriting 500', 5, 'ch3',
          'SRS matured at 3,000; 500 written from memory; a news article '
              'read aloud', 400, 'Hanzi',
          'The literacy summit: 3,000 characters covers 99% of running '
              'text. Keep mining components; handwrite the HSK-4-level '
              '500 from memory. Finish by reading a real news article '
              'aloud — characters, tones and all.'),
      // — Grammar spine —
      _n('ch5', 'HSK 1–2: Integrated Chinese I', 2, 'ch1',
          'All workbook exercises; HSK 2 mock ≥80%', 150, 'Grammar',
          'Integrated Chinese vol. 1 (or HSK Standard Course 1–2): every '
              'workbook exercise, every dialogue shadowed. Grammar here '
              'is word order — drill 把-less basics, 了 timing, measure '
              'words. HSK 2 mock (free past papers) ≥80%.'),
      _n('ch6', 'HSK 3: Integrated Chinese II', 3, 'ch5',
          'All workbook exercises; HSK 3 mock ≥80%, timed', 150, 'Grammar',
          'Integrated Chinese vol. 2 / HSK Standard Course 3: '
              'complements of result and direction (看完, 拿出来), '
              'comparisons, 的/得/地. All exercises; the Chinese Grammar '
              'Wiki (free) is your reference for every point. Timed HSK '
              '3 mock ≥80%.'),
      _n('ch7', 'HSK 4 grammar: the connector layer', 5, 'ch6',
          'HSK 4 grammar points drilled both ways; error log by pattern',
          250, 'Grammar',
          'HSK Standard Course 4 (both halves): 把/被 for real, 越来越, '
              'connector pairs (不但…而且, 虽然…但是, 只要…就). For every '
              'pattern: 10 sentences produced, corrected (tutor or '
              'LangCorrect), errors logged by pattern until the log '
              'stops growing.'),
      _n('ch8', 'HSK 5 grammar + formal patterns', 7, 'ch19',
          'HSK 5 patterns drilled; 20 formal/written constructions '
              'recognised in real text', 250, 'Grammar',
          'HSK Standard Course 5: written-register constructions (对于/'
              '关于, 以…为, 之所以…是因为), chengyu grammar slots, 是…的 '
              'nuances. Find each pattern three times in real articles '
              'and copy the sentences into your log — grammar becomes '
              'real when you meet it in the wild.'),
      // — Input —
      _n('ch9', 'Core 2k vocab + graded readers', 4, ['ch6', 'ch3'],
          'Matured 2,000-word deck; 5 graded readers finished', 200, 'Input',
          'Grow a 2,000-word deck sourced from your textbook + readers '
              '(never bare frequency lists — always with the sentence). '
              'Read five graded readers across Mandarin Companion level '
              '2 and Sinolingua level 1–2. Lookups per page should '
              'visibly fall.'),
      _n('ch10', 'Input I: 100 hrs listening', 5, 'ch9',
          '100-hour log; weekly summaries written in Chinese', 150, 'Input',
          'One hundred logged hours: Comprehensible Chinese and Lazy '
              'Chinese (free, graded), then Peppa Pig in Mandarin, then '
              'Teatime Chinese podcasts. No English subs ever. Weekly: a '
              '100-character summary of something you watched, corrected.'),
      _n('ch11', 'Core 5k + native podcasts', 7, 'ch9',
          '5,000-word deck matured; 20 podcast episodes summarised', 300, 'Input',
          'Vocabulary to 5,000 — all mined from input (DuChinese and The '
              'Chairman\'s Bao make mining painless; export to Anki). '
              'Listening moves to native-speed podcasts (故事FM, 声东击西): '
              '20 episodes, each with a five-line Chinese summary.'),
      _n('ch12', 'Native TV: 15 episodes + a first book', 7, 'ch10',
          '15 episodes with CN subs only, 300 sentences mined; one '
              'youth/translated novel finished', 200, 'Input',
          'Fifteen episodes of real television (家有儿女 for sitcom '
              'clarity, 隐秘的角落 for drama) with Chinese subtitles '
              'only, mining 20 sentences per episode. Then finish one '
              'full easy book: 小王子 (The Little Prince) or a youth '
              'novel, journal per chapter.'),
      // — Output —
      _n('ch13', 'Tones in the wild: shadowing I', 3, 'ch5',
          '10 dialogues shadowed to rhythm; tone-pair errors in sentences '
              '≤10%, native-checked', 40, 'Output',
          'Shadow ten textbook dialogues sentence by sentence until your '
              'recording overlays the original\'s rhythm and tone '
              'contours (record both, compare in Audacity). Third tones '
              'in sequence and tone changes for 不/一 must be automatic — '
              'natives (italki community) verify.'),
      _n('ch14', 'Writing I: 30 corrected entries', 6, 'ch7',
          '30 corrected texts archived; typed AND 10 handwritten; error '
              'classes shrinking', 50, 'Output',
          'Thirty short texts (100–300 characters) on LangCorrect or with '
              'a tutor: diary entries, opinions, a complaint, a story. '
              'Type twenty, handwrite ten. Track error classes — 了 '
              'placement, measure words, connector logic — and watch the '
              'counts fall.'),
      _n('ch15', 'Speaking: 50 conversation hours', 9, ['ch12', 'ch13'],
          '50 logged hours; a 15-min discussion recorded and native-rated '
              'B2-equivalent', 80, 'Output',
          'Fifty hours of real conversation (italki tutors + language '
              'exchange): prep topic vocabulary before each session, log '
              'three new phrases and one recurring error after. Monthly, '
              'record 15 minutes of abstract discussion; a tutor rates '
              'against CEFR descriptors until B2 holds.'),
      _n('ch16', 'Formal register & business Chinese', 9, 'ch20',
          '10 role-plays (meetings, toasts, negotiations) native-checked; '
              '20 formal emails written', 60, 'Output',
          'Learn the courtesy architecture: 您/贵公司, toast order at '
              'dinner, how to disagree without 不. Write 20 formal '
              'emails/messages (requests, apologies, invitations), '
              'corrected; role-play ten business situations with a tutor '
              'until the register switching is clean.'),
      // — Culture —
      _n('ch17', 'Culture: customs, regions, food', 4, 'ch6',
          '20 culture briefs; a China geography deck matured', 40, 'Culture',
          'Twenty one-page briefs from real sources: guanxi and face, '
              'Spring Festival customs, the north/south food line, the '
              'provinces and their stereotypes, tea culture, gift '
              'taboos. Mature a small deck: provinces, capitals, major '
              'cities placed on a blank map.'),
      _n('ch18', 'Chengyu & internet Chinese: 150 + 50', 8, ['ch11', 'ch17'],
          '150 chengyu with stories; 50 internet/slang terms; 20 used '
              'correctly in corrected writing', 60, 'Culture',
          'Learn 150 high-frequency chengyu WITH their origin stories '
              '(the story is the mnemonic) and 50 live internet terms '
              '(内卷, 躺平, yyds). Deploy twenty of them in writing that '
              'a native corrects for naturalness — chengyu misused is '
              'worse than absent.'),
      // — Exam spine & convergence —
      _n('ch19', 'HSK 4 exam', 6, ['ch7', 'ch9'],
          'Official sitting if reachable, else 2 timed mocks ≥ pass +10%',
          60, 'HSK',
          'Drill the HSK 4 format with official past papers (free '
              'downloads): listening once-only discipline, the 80-minute '
              'clock. Sit the real exam at a Confucius Institute if '
              'reachable — the certificate is real — otherwise two timed '
              'mocks ≥10% above the pass line.'),
      _n('ch20', 'HSK 5 exam', 8, ['ch8', 'ch11', 'ch4'],
          'Official sitting if reachable, else 2 timed mocks ≥ pass +10%',
          80, 'HSK',
          'HSK 5 adds the 写作 section: practice the 80-character photo '
              'essays and sentence-building daily for a month. Official '
              'past papers under exact timing; error log by section. '
              'Real sitting if reachable, else two clean mocks.'),
      _n('ch21', 'HSK 6 / HSK 3.0 band 7 prep', 10, ['ch20', 'ch18'],
          'Full timed mock ≥ pass +10%; the 缩写 summary-writing task '
              'practiced 10 times', 250, 'HSK',
          'The endgame exam: 2,500+ word families, near-native reading '
              'speed, and the notorious 缩写 (read 1,000 characters for '
              '10 minutes, then rewrite from memory in 400). Ten timed '
              '缩写 drills, corrected. Track the new HSK 3.0 band 7–9 '
              'materials as they mature and fold them in.'),
      _n('ch22', 'Crown: literature + your own voice', 11,
          ['ch21', 'ch15', 'ch16', 'ch23', 'ch14'],
          'A full literary novel finished; 30-min unscripted native '
              'conversation, recorded', 150, 'HSK',
          'Read one complete literary novel in Chinese (余华《活着》— To '
              'Live — is the classic gateway: short, devastating, '
              'linguistically clean), reading journal throughout. Then '
              'the true crown: a 30-minute unscripted conversation with '
              'a native on real topics, recorded, where you are a '
              'person, not a student.'),
]);
