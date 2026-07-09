// data/catalog_cha.dart — the CHA constellations.
// Part of skill_data.dart: same library, same laws (see the five
// laws there and test/skill_data_test.dart). Every node: id, label,
// tier, requires, proof (completion standard), hours (researched
// effort), branch, guide (the exact work, spelled out).
part of 'skill_data.dart';

final StatDomain chaDomain = StatDomain('CHA', 'Charisma', 0xFFFB923C, [
    // Branches: Language (vocab/roots) · Writing Craft · Rhetoric & Speech ·
    // Argument & Analysis — crown = an essay that travels.
    Skill('english', 'English', '🔤', 'Command the Room and the Page', [
      _n('e1', 'Elements of Style + Williams', 1, null,
          'Rewrite 10 bad paragraphs; before/after', 40, 'Foundations',
          'Read Strunk & White in an afternoon, then Williams\'s Style: '
              'Lessons in Clarity and Grace slowly, doing its exercises. '
              'Collect 10 genuinely bad paragraphs from the wild (corporate '
              'sites, notices) and rewrite each; keep before/after pairs.'),
      _n('e2', 'Vocabulary I: 500 GRE words', 1, null,
          'Matured Anki deck, used in writing', 40, 'Foundations',
          'The Magoosh GRE 1000 list (free) → an Anki deck of the top 500: '
              'word, sentence, register note. 20 new/day. The real test: '
              'each week write one paragraph naturally using five of that '
              'week\'s words without strain.'),
      _n('e3', 'Etymology: 300 Latin & Greek roots', 1, null,
          'Decompose 100 unfamiliar words correctly', 40, 'Foundations',
          'Learn 300 roots/prefixes/suffixes with a deck built from a '
              'roots dictionary (free lists abound). Weekly game: take 10 '
              'unfamiliar words from real reading and decompose them '
              'before checking — done when you go 100-for-120.'),
      // — Language —
      _n('e21', 'Grammar for writers: real syntax', 2, 'e1',
          '30 sentences parsed; 10 grammar myths debunked with citations',
          60, 'Language',
          'Work through Huddleston & Pullum\'s A Student\'s Introduction '
              'to English Grammar (or the free parts of their blog, '
              'Language Log). Parse 30 real sentences to labelled trees, '
              'and write up 10 zombie rules (split infinitives, final '
              'prepositions) with the actual evidence.'),
      _n('e4', 'Vocabulary II: to 2,000 words + idioms', 2, 'e2',
          'Matured deck; GRE verbal practice sets', 80, 'Language',
          'Grow the deck to 2,000 including 300 idioms and phrasal nuances. '
              'Source words from your own reading, not lists, from here on: '
              'any word you look up becomes a card. GRE verbal practice '
              'sets as the fluency check.'),
      _n('e16', 'GRE Verbal', 3, 'e4', 'ETS POWERPREP timed, ≥163', 80, 'Language',
          'Drill official ETS material only (POWERPREP tests + the Verbal '
              'guide). Learn the text-completion elimination discipline; '
              'read the RC passage BEFORE the questions. Two full timed '
              'POWERPREPs; ≥163 on the second.'),
      // — Writing craft —
      _n('e22', 'The canon: 12 great essays, annotated', 2, 'e1',
          '12 essays annotated; 3 imitation openings written', 50, 'Writing',
          'Read 12 masterpieces slowly — Orwell (Politics and the English '
              'Language, Shooting an Elephant), Baldwin (Notes of a Native '
              'Son), Didion (Goodbye to All That), Woolf, White, Sontag. '
              'Annotate structure and moves in the margins; imitate three '
              'of their openings with your own material.'),
      _n('e17', 'Close reading: poetry & prose', 3, 'e22',
          '15 close readings; 5 poems memorised and recited', 60, 'Writing',
          'Fifteen close readings (a sonnet, free verse, prose paragraphs): '
              'line by line, what each word is doing, sound and rhythm '
              'included. Memorise five poems and record recitations — '
              'memory forces attention nothing else does.'),
      _n('e20', 'Style imitation: 10 pastiches', 4, 'e17',
          '10 passages imitated (Orwell→Didion); what each taught, noted', 50, 'Writing',
          'Take ten distinctive writers and write one passage each in '
              'their exact manner — sentence lengths, cadence, imagery '
              'habits — on YOUR subject matter. After each, one paragraph: '
              'what this style can do that yours cannot (yet).'),
      _n('e8', 'Sense of Style (Pinker)', 4, ['e6', 'e21'],
          'Essay applying the classic-style lens', 40, 'Writing',
          'Read Pinker\'s The Sense of Style, especially the classic-style '
              'and curse-of-knowledge chapters. Then take your three best '
              'old pieces and revise them under the classic-style lens; '
              'write a short essay on what changed and why.'),
      _n('e10', '10 persuasive long-form essays', 5, ['e8', 'e5', 'e20'],
          'Published; 2 revised after critique', 150, 'Writing',
          'Ten essays of 1,500–3,000 words on subjects you actually hold '
              'stakes in, published anywhere public (Substack, Medium, a '
              'blog). Ask readers for the strongest objection; pick the '
              'two most-challenged pieces and publish honest revisions.'),
      _n('e12', 'Cognitive Linguistics (Lakoff)', 5, 'e8',
          'Metaphor audit of your own writing', 40, 'Writing',
          'Read Metaphors We Live By (Lakoff & Johnson). Then audit your '
              'own ten essays: list every structural metaphor you leaned '
              'on (argument-as-war, time-as-money), and rewrite two '
              'passages using deliberately different framings to feel the '
              'persuasive machinery move.'),
      // — Rhetoric & speech —
      _n('e6', 'Classical Rhetoric (Farnsworth)', 3, ['e1', 'e3'],
          'Device notebook: 40 devices, own examples', 60, 'Rhetoric',
          'Farnsworth\'s Classical English Rhetoric: for each of 40 '
              'devices (anaphora, chiasmus, praeteritio...), copy his best '
              'example, then write two of your own on live topics. The '
              'notebook is the artifact — carry it into every speech you '
              'write.'),
      _n('e9', 'Speech study: 25 great speeches', 4, 'e6',
          'Rhetorical breakdowns: structure, devices, delivery', 60, 'Rhetoric',
          'From American Rhetoric\'s top-100 bank: 25 speeches across '
              'eras. For each: outline the structure, mark the devices, '
              'note the delivery choices on video where it exists, and '
              'write the one-line reason it worked on its audience that '
              'day.'),
      _n('e11', '10 recorded speeches', 5, 'e9',
          'Self-scored vs Toastmasters rubrics, visible arc', 80, 'Rhetoric',
          'Write and deliver ten 5–7 minute speeches on camera — '
              'informative, persuasive, commemorative. Score each against '
              'the free Toastmasters evaluation rubrics; re-watch with the '
              'sound off once (gesture audit) and muted-video once (vocal '
              'audit).'),
      _n('e13', 'Impromptu: 30 table-topics drills', 6, 'e11',
          'Recorded 2-min impromptus, no dead air', 30, 'Rhetoric',
          'Thirty drills: random prompt (table-topics generators are '
              'free), 15 seconds of thought, two minutes on camera. Learn '
              'the PREP and past-present-future scaffolds until structure '
              'is automatic under pressure. No restarts allowed.'),
      _n('e19', 'Storytelling: 5 true stories, Moth rules', 6, 'e11',
          '5 filmed 5-min stories, no notes; one told to a live audience', 40, 'Rhetoric',
          'Study Moth principles (stakes, scenes, a change in you). Craft '
              'five true five-minute stories from your own life; film '
              'each told without notes. Tell one at a live story night or '
              'open mic — the room\'s reaction is the honest grade.'),
      // — Argument & analysis —
      _n('e5', 'Logical Fallacies & Argument', 2, 'e1',
          '30 fallacies catalogued from real media', 40, 'Argument',
          'Learn the standard fallacy taxonomy plus real argument '
              'structure (Toulmin\'s claim-grounds-warrant). Then hunt: 30 '
              'fallacies captured from real editorials, ads and podcasts, '
              'each catalogued with why it persuades anyway.'),
      _n('e18', 'Debate: 10 formal debates', 7, ['e13', 'e5'],
          '10 debates in an online club; 3 filmed + rebuttals self-scored', 60, 'Argument',
          'Join an online debate club or society. Ten formal debates in a '
              'real format (BP or Lincoln–Douglas), arguing both sides of '
              'motions you care about at least twice. Film three; score '
              'your rebuttals specifically — rebuttal is where debates '
              'are won.'),
      // — Convergence —
      _n('e14', '20-min keynote from memory', 7, ['e10', 'e13', 'e19', 'e23'],
          'One continuous take, audience of 5+', 60, 'Convergence',
          'Build a 20-minute keynote from your strongest essay: full '
              'arc, stories embedded, memorised by structure (memory '
              'palace of beats, not words). Deliver in one continuous '
              'take to a live audience of five or more, filmed.'),
      _n('e15', 'Crown: an essay that travels', 8, ['e14', 'e12', 'e16', 'e18'],
          '1,000+ genuine readers, or printed in a venue you respect', 100, 'Convergence',
          'Write the essay only you could write — the one your ten '
              'essays were circling. Edit it through three full drafts '
              'with outside readers. Then earn its audience: pitch it to '
              'venues you respect, or publish and promote honestly until '
              '1,000+ real humans have read it.'),
      _n('e23', 'Interviewing & listening', 6, 'e11',
          '5 recorded interviews; questions that opened doors, noted', 40, 'Rhetoric',
          'Study the craft (Terry Gross\'s and Cal Fussman\'s advice is '
              'free online): open questions, silence, follow-ups that '
              'chase specifics. Record five 30-minute interviews with '
              'people who fascinate you; afterwards mark which questions '
              'opened doors and which closed them.'),
    ]),
    // Branches: Grammar Spine · Input · Output · Culture & Song — crown =
    // consecutive interpretation, the skill no exam grants.
    Skill('turkish', 'Turkish', '🇹🇷', 'C1+ and Real-Time Interpretation', [
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
    ]),
    // Branches: Hanzi · Grammar · Input · Output · Culture · HSK spine —
    // crown = literature + the spoken skill HSK never tests.
    Skill('chinese', 'Chinese', '🇨🇳', 'HSK 6 + the Spoken Skill HSK Never Tests', [
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
    ]),
    // Branches: Script & Literacy · Core Language · Input · Output ·
    // Culture — built for a language with no textbook ecosystem.
    Skill('khmer', 'Khmer', '🇰🇭', 'Fluency Where No Textbook Ecosystem Exists', [
      _n('kh1', 'Script I: consonants (two series) + vowels', 1, null,
          'Read any letter; write the alphabet from memory', 40, 'Foundations',
          'Learn the 33 consonants in their two series and the dependent '
              'vowels with their series-split sounds — the two-series '
              'system IS Khmer literacy. Use the free khmerlessons.com '
              'charts + write every letter daily for two weeks until the '
              'full alphabet flows from memory.'),
      // — Script & literacy —
      _n('kh2', 'Script II: subscripts; length & aspiration', 2, 'kh1',
          'Read 100 real words aloud, native-checked (Khmer has no tones)', 60, 'Script',
          'Learn the subscript (coeng) forms and consonant clusters, '
              'vowel length and aspiration contrasts. Read 100 real words '
              'aloud recorded, checked by a native speaker (HelloTalk '
              'finds one in a day). No tones — the sounds themselves are '
              'the challenge.'),
      _n('kh15', 'Digital Khmer: typing & tools', 2, 'kh1',
          'Type 15 wpm in Khmer Unicode; phone + desktop setup documented', 15, 'Script',
          'Install Khmer Unicode keyboards on phone and desktop, learn '
              'the layout (free typing tutors exist), and reach 15 wpm. '
              'Document your setup — fonts, dictionaries (SEAlang), input '
              'quirks — so the toolchain never blocks study again.'),
      _n('kh6', 'Street literacy: signs, menus, prices', 5, 'kh2',
          'Read 50 photographed real-world signs', 30, 'Script',
          'Collect 50 photos of real Khmer signage (Google Street View '
              'in Phnom Penh works from anywhere): shop signs, menus, '
              'prices, notices. Read each aloud and translate; note the '
              'abbreviations and stylised scripts that schoolbooks never '
              'show.'),
      _n('kh9', 'Read native news (VOA Khmer)', 7, ['kh6', 'kh8', 'kh15'],
          '20 articles summarised in Khmer', 60, 'Script',
          'Twenty VOA Khmer / RFA Khmer articles: read with the SEAlang '
              'dictionary open, mine vocabulary, then write a three-line '
              'summary in Khmer for each, corrected by your tutor. News '
              'register is its own vocabulary layer — treat it as one.'),
      // — Core language —
      _n('kh3', 'A1: SVO syntax, 300 words (Aakanee)', 3, 'kh2',
          'Describe 20 Aakanee scenes from memory', 120, 'Core',
          'Aakanee.com\'s Khmer picture-description recordings (made for '
              'exactly this) + the IndoChine audio course: 300 words, '
              'basic SVO sentences, classifier basics. Test: describe 20 '
              'Aakanee scenes from memory, recorded.'),
      _n('kh19', 'Numbers, money & the market', 3, 'kh2',
          'The bi-quinary number system fluent to 1M; 10 recorded '
              'bargaining role-plays', 30, 'Core',
          'Master the bi-quinary numbers (6 = 5+1, 7 = 5+2), prices in '
              'riel and dollars, dates and times. Then role-play ten '
              'market exchanges with a tutor — greeting, asking price, '
              'bargaining politely, thanking — recorded and corrected.'),
      _n('kh4', 'A2: classifiers, aspect markers, 800 words', 4,
          ['kh3', 'kh19'],
          '10 self-recorded dialogues', 150, 'Core',
          'Build to 800 words with the full classifier set and aspect '
              'markers (បាន, កំពុង, ហើយ). Colloquial Cambodian (Smyth) is '
              'the one real textbook — work it cover to cover. Ten '
              'two-minute self-recorded dialogues, tutor-corrected.'),
      _n('kh5', 'B1: 1,500 core words', 5, 'kh4',
          'Matured deck; 15-min conversation attempt logged', 200, 'Core',
          'Push the deck to 1,500 — every card sourced from Aakanee, '
              'Smyth or your conversations, always with audio (record '
              'your tutor saying each). First 15-minute all-Khmer '
              'conversation attempt, logged with its failure points.'),
      _n('kh8', 'B2 grammar: serial verbs, complex sentences', 6, 'kh5',
          'Translate 30 sentences both ways, checked', 150, 'Core',
          'Khmer\'s serial verb constructions (យកទៅឱ្យ — take-go-give) '
              'and sentence-linking particles have no textbook chapter — '
              'harvest them from Aakanee transcripts and news, build '
              'your own grammar notes, and translate 30 complex '
              'sentences both directions, native-checked.'),
      _n('kh10', 'Registers: formal, clergy & royal', 8, 'kh20',
          'Register-switch drill on 30 sentences', 60, 'Core',
          'Khmer has distinct vocabulary for monks and royalty and a '
              'formal register for elders: learn the everyday↔formal '
              'pairs (eat: ញ៉ាំ/ពិសា/សោយ), then drill 30 sentences '
              'switched across registers with your tutor grading '
              'appropriateness.'),
      // — Input —
      _n('kh11', 'Input: 100 hrs media/news', 8, 'kh9',
          '100-hour log; weekly summaries written in Khmer', 100, 'Input',
          'One hundred logged hours: Khmer YouTube (cooking channels are '
              'gold — concrete vocabulary, visible referents), VOA video '
              'reports, dubbed dramas. Weekly written summary in Khmer, '
              'corrected. Log lookups falling as proof of progress.'),
      // — Output —
      _n('kh18', 'First output: 10 exchanges', 4, 'kh3',
          '10 short exchanges (HelloTalk/tutor); 5 recorded dialogues corrected', 15, 'Output',
          'Ten short real exchanges on HelloTalk or with an italki tutor '
              '(Khmer tutors are few but present — book ahead). Record '
              'five dialogues, get line-by-line corrections, and re-'
              'record each corrected version.'),
      _n('kh7', 'Conversation: 25 logged hours', 6, ['kh5', 'kh18'],
          "Session log + tutor's written assessment", 30, 'Output',
          'Twenty-five tutor hours: half free conversation, half '
              'prepared topics (your day, your town, Cambodian food). '
              'After hour 25, ask the tutor for a written assessment '
              'against ILR levels — Khmer has no CEFR ecosystem, so '
              'borrow the framework.'),
      _n('kh16', 'Songs & karaoke: 20 songs', 7, 'kh7',
          '20 songs studied; 5 sung with lyrics from memory', 30, 'Output',
          'Twenty Khmer songs from Sinn Sisamouth classics to modern '
              'pop: lyrics transcribed (great script practice), '
              'translated, sung along. Five memorised and sung over '
              'karaoke tracks, recorded — the fastest route to natural '
              'rhythm.'),
      _n('kh12', 'Conversation: 100 total hours', 9, 'kh7',
          'ILR self-assessment + native-rated interview (S-2+)', 90, 'Output',
          'Build to 100 cumulative hours with multiple speakers (age and '
              'region vary speech hugely). Finish with a 20-minute '
              'interview a native rates against ILR speaking descriptors '
              '— S-2+ (conversational competence on concrete topics) is '
              'the bar.'),
      // — Culture —
      _n('kh17', 'Culture & history (Chandler)', 2, 'kh1',
          "A History of Cambodia read; 10 culture briefs written", 40, 'Culture',
          'Read Chandler\'s A History of Cambodia — Angkor through the '
              'tragedy of the 1970s to now; you cannot speak to Khmer '
              'people without this weight understood. Ten briefs: the '
              'sampeah greeting levels, pagoda etiquette, Pchum Ben, '
              'weddings, the Khmer New Year games.'),
      _n('kh20', 'Proverbs & polite speech', 7, 'kh8',
          '30 proverbs learned with contexts; polite-particle usage '
              'native-verified in 10 dialogues', 40, 'Culture',
          'Learn 30 Khmer proverbs (សុភាសិត) with when-to-use contexts '
              'from your tutor, and master the politeness particles '
              '(បាទ/ចាស rhythm) and kinship-term address system. Ten '
              'dialogues where a native verifies you address everyone '
              'correctly.'),
      _n('kh13', 'Traditional literature (Reamker excerpts)', 9,
          ['kh10', 'kh17'], 'Reading journal with cultural notes', 60, 'Culture',
          'Read Reamker excerpts (the Khmer Ramayana) in a modern '
              'edition with your tutor, plus two folktales (Judge '
              'Rabbit stories). Journal the vocabulary register and the '
              'cultural references — this is the deep layer under '
              'temple murals and proverbs alike.'),
      // — Convergence —
      _n('kh14', 'Crown: interpretation + literacy', 10,
          ['kh11', 'kh12', 'kh13', 'kh16'],
          'Interpret a 10-min talk KM→EN, recorded, native-verified', 40, 'Convergence',
          'The crown for a language with no C2 exam: consecutively '
              'interpret a 10-minute Khmer talk (a VOA segment) into '
              'English, recorded, verified for fidelity by a bilingual '
              '— plus read one full news feature aloud cold. Fluency '
              'proven by function, not certificate.'),
    ]),
    // Branches: Written Theory (ABRSM spine) · Ear Training · Analysis ·
    // Composition (starts at tier 3, not the summit) — crown = a real work.
    Skill('musicTheory', 'Music Theory', '🎼', 'Compose and Hear It Performed', [
      _n('mt1', 'Notation: pitch, rhythm, clefs, metre', 1, null,
          'ABRSM Grade 1–2 past papers ≥90%', 40, 'Foundations',
          'Learn staff notation properly: both clefs, note values, time '
              'signatures, dynamics. musictheory.net\'s free lessons + '
              'exercises daily, then two ABRSM Grade 1–2 theory past '
              'papers ≥90% each, timed.'),
      // — Written theory —
      _n('mt2', 'Scales, keys & the circle of fifths', 2, 'mt1',
          'Any key signature/scale on demand', 40, 'Written Theory',
          'All 30 major/minor keys: build each scale on paper, drill key '
              'signatures with flashcards until any key comes in under '
              'two seconds. Draw the circle of fifths from memory weekly; '
              'know why the pattern works, not just that it does.'),
      _n('mt4', 'Triads, inversions & cadences', 4, 'mt3',
          'Four-part cadence exercises', 50, 'Written Theory',
          'Build every triad type in every inversion on paper; learn '
              'figured-bass symbols for them. Write 20 four-part perfect, '
              'plagal, imperfect and interrupted cadences following '
              'voice-leading basics, checked against a workbook key '
              '(ABRSM Grade 4–5 workbooks).'),
      _n('mt5', 'ABRSM Grade 5 Theory', 5, ['mt4', 'mt19'],
          'Two past papers ≥ merit, timed', 80, 'Written Theory',
          'The gateway grade (real ABRSM entry is open — sit it online '
              'if you want the certificate). Work the Grade 5 workbook '
              'cover to cover, then two timed past papers at merit level '
              'or above, marked with the published schemes.'),
      _n('mt7', 'Sevenths, figured bass & Roman numerals', 6, 'mt5',
          'Analyse 10 Bach chorales', 80, 'Written Theory',
          'All seventh-chord types and their figures; Roman-numeral '
              'analysis with inversions. Analyse ten Bach chorales '
              '(free Riemenschneider scans): every chord labelled, every '
              'non-chord tone named. Open Music Theory (free) is the '
              'reference.'),
      _n('mt8', 'Four-part harmony (chorale writing)', 7, 'mt7',
          'Harmonise 20 melodies; check vs Bach', 120, 'Written Theory',
          'Harmonise 20 chorale melodies in four parts under the full '
              'rule set (ranges, doubling, no parallels). For ten of '
              'them, compare your setting bar by bar against Bach\'s own '
              '— note every place his solution is stranger and better.'),
      _n('mt9', 'Species Counterpoint (Fux)', 8, 'mt8',
          'All five species, two then three voices', 100, 'Written Theory',
          'Fux\'s Gradus (Mann translation) exactly as written: all five '
              'species in two voices against given cantus firmi, then '
              'three voices. Sing every exercise you write — counterpoint '
              'is heard, not solved.'),
      _n('mt10', 'ABRSM Grade 8 Theory', 8, 'mt8',
          'Two past papers ≥ merit, timed', 120, 'Written Theory',
          'Grade 8: extended harmony, composition questions, score '
              'reading. Work the workbook, then two timed past papers at '
              'merit+. Sit the real online exam if you want it on paper '
              '— it is open to independent candidates.'),
      // — Ear training —
      _n('mt3', 'Intervals & ear training I', 3, 'mt2',
          'Interval dictation ≥90% (functional ear trainer)', 60, 'Ear',
          'Daily 15 minutes: Functional Ear Trainer (free) for scale-'
              'degree hearing plus interval drills (Teoria/Tenuto). '
              'Within-octave intervals ascending, descending and '
              'harmonic at ≥90% before moving on. Sing every interval '
              'you identify.'),
      _n('mt21', 'Solfège & sight-singing', 4, 'mt3',
          '30 melodies sight-sung in movable-do; 10 recorded and '
              'pitch-checked', 60, 'Ear',
          'Movable-do solfège: sing all diatonic patterns, then 30 '
              'unseen melodies from a sight-singing anthology (Ottman or '
              'free alternatives), conducting while singing. Record ten '
              'and check against a keyboard — intonation honesty is the '
              'point.'),
      _n('mt15', 'Ear training II: dictation', 5, 'mt21',
          'Transcribe 20 short passages by ear', 60, 'Ear',
          'Melodic and rhythmic dictation daily (Teoria exercises, or a '
              'friend playing): 20 four-to-eight-bar passages notated '
              'from three hearings max. Start diatonic stepwise; end '
              'with leaps and simple chromaticism.'),
      _n('mt20', 'Ear training III: transcription', 8, 'mt15',
          'Transcribe 10 songs (melody + chords) and 5 chorale phrases by ear', 80, 'Ear',
          'Full transcription: ten real songs (melody + chord symbols) '
              'and five Bach chorale phrases (all four voices) by ear '
              'alone, checked against published scores. Slow-downer '
              'software allowed; isolation tools are cheating.'),
      // — Rhythm —
      _n('mt19', 'Rhythm I: reading & clapping', 2, 'mt1',
          '20 rhythms clapped at tempo from notation, recorded', 30, 'Rhythm',
          'Twenty rhythm studies from simple to compound and syncopated '
              '(free: rhythmrandomizer.com + a metronome): clap and '
              'count aloud at marked tempo, recorded. Add two-against-'
              'three preparation with hands on knees.'),
      // — Composition: begins early, grows with the theory —
      _n('mt16', 'Composition I: 12 eight-bar melodies', 3, 'mt2',
          'Notated in MuseScore; 3 peer critiques gathered', 40, 'Composition',
          'Twelve eight-bar melodies in MuseScore (free): antecedent-'
              'consequent phrases, varied keys and metres, each with a '
              'dynamic and articulation plan. Post three to a notation '
              'forum for critique and revise one accordingly.'),
      _n('mt17', 'Composition II: theme & 5 variations', 6, ['mt16', 'mt5'],
          'Score + render; harmonic analysis of your own piece attached', 60, 'Composition',
          'Write a theme and five variations for solo piano or duo: '
              'figuration, mode change, metre change, contrapuntal, '
              'free. Engrave properly, render audio, and attach your own '
              'Roman-numeral analysis — compose with the theory, not '
              'beside it.'),
      _n('mt18', 'Jazz & pop harmony', 7, 'mt7',
          'Levine chapters worked; 10 standards analysed; 5 reharmonisations', 100, 'Composition',
          'Levine\'s Jazz Theory Book core chapters: ii-V-I, modes, '
              'shell voicings, tritone subs. Analyse ten standards from '
              'lead sheets; reharmonise five (two pop songs included) '
              'and render before/after comparisons.'),
      // — Analysis & orchestration —
      _n('mt11', 'Form & analysis: sonata and fugue', 9, 'mt10',
          'Full analyses of 6 scores (2 fugues)', 100, 'Analysis',
          'Analyse six complete movements with scores: two Bach fugues '
              '(subject/answer/episodes mapped), two classical sonata '
              'movements (full formal map), a rondo, a set of '
              'variations. Caplin\'s Classical Form (or Open Music '
              'Theory\'s form chapters) as guide.'),
      _n('mt22', 'Post-tonal & 20th-century techniques', 9, 'mt18',
          '5 modern works analysed; 3 short studies composed with the '
              'techniques', 80, 'Analysis',
          'Study the toolkit that followed tonality: modes and '
              'polytonality (Debussy, Stravinsky), set basics (free '
              'Open Music Theory chapters), minimalism (Reich). Analyse '
              'five works, then compose three one-minute studies each '
              'using one technique honestly.'),
      _n('mt12', 'Orchestration (Adler) + MuseScore', 10, ['mt11', 'mt22'],
          'Orchestrate a piano piece for 12+ instruments', 120, 'Analysis',
          'Adler\'s The Study of Orchestration core chapters: every '
              'instrument\'s range, transposition and character. '
              'Orchestrate a romantic piano piece for chamber orchestra '
              '(12+ real parts) in MuseScore, then A/B your render '
              'against professional orchestrations of similar music.'),
      // — Convergence —
      _n('mt13', 'Portfolio I: song + quartet movement', 11,
          ['mt9', 'mt11', 'mt17', 'mt18', 'mt20'],
          'Scores + rendered audio, published', 150, 'Convergence',
          'Two finished works: an art song or produced song (voice + '
              'accompaniment, real text) and a string quartet movement '
              'in sonata or ternary form. Full engraved scores + '
              'renders, published (MuseScore.com, YouTube), feedback '
              'gathered from two musicians.'),
      _n('mt14', 'Crown: a 10-minute multi-movement work', 12,
          ['mt12', 'mt13'],
          'Full score + performance or convincing render, released', 250, 'Convergence',
          'The work: 10+ minutes, multiple movements, real forces you '
              'choose (chamber orchestra, choir, hybrid). Complete '
              'engraved score, programme note, and either a live '
              'performance you organised or a production-grade render — '
              'released publicly with its story.'),
    ]),
    // Branches: Technique · Repertoire (ABRSM spine) · Reading ·
    // Musicianship (lead sheets, improv, ensemble) · Performance Craft.
    Skill('piano', 'Piano', '🎹', 'The One-Hour Memorised Recital', [
      _n('p1', 'Setup: posture, hand shape, first pieces', 1, null,
          'Video self-check vs reference; 5 beginner pieces', 40, 'Foundations',
          'Bench height, distance, curved fingers, relaxed wrist — film '
              'yourself against a reference video (any conservatoire '
              'channel) weekly. Faber Adult Piano Adventures book 1: '
              'five pieces played cleanly, hands together, filmed.'),
      // — Technique —
      _n('p3', 'Major scales & arpeggios (2 octaves)', 2, 'p1',
          'Metronome video, all 12 keys, hands together', 80, 'Technique',
          'All 12 major scales and arpeggios, two octaves hands '
              'together, standard fingerings (memorise the thumb '
              'crossings, they never change). Daily 15 minutes with '
              'metronome, +4 bpm when perfect twice. One video: all 12, '
              'clean, at your top steady tempo.'),
      _n('p4', 'Minor scales & arpeggios', 3, 'p3',
          'All 12 minor keys, harmonic + melodic, hands together on video',
          80, 'Technique',
          'Harmonic and melodic minors, all 12 keys, two octaves hands '
              'together with correct fingerings. The melodic minor\'s '
              'different descent must be automatic. Same metronome '
              'ladder; same single-take video proof.'),
      _n('p5', 'Technique I: Hanon 1–20 / Czerny 599', 3, 'p3',
          'Clean at marked tempi, video', 120, 'Technique',
          'Hanon 1–20 transposed through several keys OR Czerny 599 '
              'first half — but never mindlessly: every repetition has '
              'a target (evenness, rotation, dynamics). Record weekly; '
              'listen for the weak finger 4 everyone has.'),
      _n('p8', 'Pedalling: legato, syncopated, una corda', 5, 'p5',
          'Before/after recordings of 3 pieces', 40, 'Technique',
          'Learn syncopated (legato) pedalling until the ear, not the '
              'foot, drives changes. Apply to three pieces: record each '
              'senza pedale, then pedalled — the before/after pair must '
              'show cleaner harmony, not soup.'),
      _n('p9', 'Technique II: Czerny School of Velocity', 6, 'p5',
          'Four studies at tempo, video', 150, 'Technique',
          'Czerny Op. 299: four studies chosen to attack your actual '
              'weaknesses (passagework, repeated notes, left-hand '
              'agility). Practice ladder: rhythms → hands separate at '
              'speed → together climbing. Video each at the marked '
              'tempo.'),
      _n('p12', 'Polyrhythm & independence studies', 9, 'p9',
          '3:2 and 4:3 études at tempo', 80, 'Technique',
          'Master 3:2 then 4:3: tap on knees with the composite-rhythm '
              'method, then études that use them (Chopin Op. posth. '
              'pieces, Debussy Arabesque No. 1). Two études filmed at '
              'tempo with the polyrhythm locked, not approximated.'),
      // — Reading —
      _n('p2', 'Reading I: grand staff fluency', 2, 'p1',
          'Sight-read Grade 1 pieces at tempo', 60, 'Reading',
          'Daily flashcard drills (Tenuto) for instant note naming, '
              'both clefs including ledger lines; intervallic reading '
              '(read shapes, not letters). Sight-read one Grade 1 piece '
              'daily WITHOUT stopping — steadiness beats correctness.'),
      _n('p13', 'Reading II: daily sight-reading to Grade 6', 5, 'p2',
          '8-week log; unseen piece test', 80, 'Reading',
          'Eight weeks of daily sight-reading (Piano Marvel SASR or the '
              'ABRSM specimen books), climbing one difficulty notch per '
              'week when accuracy holds. Test: an unseen Grade 6 piece '
              'read at 70% tempo without stopping, filmed.'),
      // — Musicianship: chords, improvisation, playing with others —
      _n('p7', 'Harmonisation & lead sheets', 3, 'p2',
          'Play 10 songs from chords alone', 60, 'Musicianship',
          'Learn the chord shapes and left-hand patterns (root-fifth, '
              'stride basics, arpeggiation) to play from lead sheets. '
              'Ten songs from chord charts alone, each in two different '
              'accompaniment styles, recorded.'),
      _n('p24', 'Ear & transposition at the keys', 4, 'p7',
          '10 melodies picked out by ear + harmonised; 5 songs '
              'transposed into 3 keys', 50, 'Musicianship',
          'Pick out ten known melodies by ear, then harmonise them by '
              'ear (hear the bass motion first). Transpose five lead-'
              'sheet songs into three keys each at sight — the skill '
              'that makes you useful to every singer you ever meet.'),
      _n('p20', 'Improvisation I: blues & pentatonic', 4, 'p7',
          '10 recorded improvisations over backing tracks; honest self-review', 60, 'Musicianship',
          '12-bar blues in three keys: left-hand patterns, blues scale '
              'and mixolydian colours, call-and-response phrasing over '
              'backing tracks. Ten recorded improvisations with written '
              'self-review: what did you actually play vs intend?'),
      _n('p22', 'Accompany: play with others', 7, ['p20', 'p21', 'p24'],
          'Accompany a singer or instrumentalist on 5 songs, recorded', 40, 'Musicianship',
          'Find one singer or instrumentalist (community groups, '
              'church, school). Accompany five songs: learn to follow '
              'breathing, cover mistakes without stopping, balance '
              'under a voice. Record all five — ensemble time reshapes '
              'your solo playing.'),
      // — Repertoire spine —
      _n('p18', 'ABRSM Grade 3 Performance', 4, ['p2', 'p4'],
          'Video submission (real cert) or mock to its criteria', 120, 'Repertoire',
          'Three pieces from the current ABRSM Grade 3 syllabus, '
              'polished to performance: recorded in one take each, then '
              'all three in one sitting. Submit the real video exam '
              '(open to independents) or self-mark against the '
              'published criteria.'),
      _n('p6', 'Bach: three Two-Part Inventions', 5, 'p18',
          'One continuous video take each', 120, 'Repertoire',
          'Inventions 1, 8 and 13 (or your choice of three): learn '
              'hands separately to tempo first, ornaments researched, '
              'articulation chosen deliberately. One continuous take '
              'each — Bach exposes everything; that is the point.'),
      _n('p19', 'ABRSM Grade 5 Performance', 7, ['p6', 'p8'],
          'Video submission (real cert) or mock to its criteria', 150, 'Repertoire',
          'The Grade 5 programme: three syllabus pieces across '
              'contrasting styles, with the scales/arpeggios '
              'requirement folded into daily technique. Real video '
              'submission or a full mock filmed in exam conditions '
              '(one sitting, no retakes).'),
      _n('p10', 'Classical: full Mozart/Haydn sonata', 8, 'p19',
          'One-take video, memorised', 200, 'Repertoire',
          'A complete sonata (Mozart K. 545 or a Haydn Hob. XVI): all '
              'movements, memorised, with classical articulation and '
              'ornament choices you can defend. One-take video of the '
              'whole work — 15 minutes of sustained concentration.'),
      _n('p11', 'Romantic: Chopin nocturne + waltz', 9, ['p10', 'p9'],
          'One-take videos, memorised; rubato that breathes without breaking '
              'pulse', 200, 'Repertoire',
          'One nocturne (Op. 9/2 or Op. 55/1) and one waltz, memorised. '
              'Study three great recordings of each — mark where they '
              'bend time; find your own rubato that breathes without '
              'losing the underlying pulse. One-take videos.'),
      _n('p14', 'ABRSM Grade 8 Performance', 10, ['p11', 'p13', 'p23'],
          'Video submission (real cert — ABRSM requires Grade 5 Theory '
              'first: see the Music Theory tree) or mock to its criteria', 300, 'Repertoire',
          'The Grade 8 programme: three advanced pieces of contrasting '
              'period, technical work at grade, quick studies. Note the '
              'prerequisite: ABRSM requires Grade 5 Theory for the real '
              'certificate — the Music Theory constellation carries it. '
              'Submit or mock under full exam discipline.'),
      _n('p15', 'Impressionist: Debussy/Ravel work', 11, 'p14',
          'One-take video; your colour and pedalling choices annotated',
          150, 'Repertoire',
          'Clair de Lune, an Arabesque, or Ravel\'s Pavane: half-'
              'pedalling, una corda colours, voicing inside soft '
              'dynamics. Annotate your score with every colour decision, '
              'then film the one-take that honours them.'),
      // — Performance craft —
      _n('p21', 'Performance ritual: monthly one-takes', 6, 'p18',
          '6 months of monthly one-take videos; log of nerves and fixes', 30, 'Performance',
          'On the first Sunday of each month for six months: one piece, '
              'one take, camera rolling, no matter what. Log the nerve '
              'symptoms and one fix attempted each time (slower '
              'breathing, dress rehearsal the day before). Adrenaline '
              'is a trainable variable.'),
      _n('p23', 'Memorisation craft', 8, 'p19',
          'Memorise 3 pieces via analysis; test: restart from any section', 60, 'Performance',
          'Memorise three pieces four ways at once: muscle, aural, '
              'visual, ANALYTICAL (know the harmony at every bar). '
              'Test each: someone names any section — you restart '
              'there cold. Hand-memory-only always collapses on stage; '
              'this is the insurance.'),
      _n('p25', 'Repertoire book: 20 pieces alive', 8, 'p19',
          '20 pieces at performance level in rotation; monthly '
              'maintenance log; any 3 on demand', 80, 'Repertoire',
          'Build and maintain a living repertoire book of 20 pieces '
              'across eras and moods. Rotation: each piece revisited '
              'monthly, logged. Test quarterly: a friend picks any '
              'three; you play them that day, performance-ready — the '
              'difference between having learned and owning.'),
      // — Convergence —
      _n('p16', 'Crown: 60-minute memorised recital', 12,
          ['p15', 'p12', 'p22', 'p25'],
          'Single continuous recording, 4+ eras, published', 400, 'Convergence',
          'Programme 60 minutes across four+ eras from your repertoire '
              'book — Bach through impressionism, a lead-sheet arrangement '
              'welcome. Dress-rehearse twice for humans. Then one '
              'continuous recording (or live recital), memorised, '
              'published with programme notes.'),
    ]),
    // Branches: Technique (health-first) · Ear & Musicianship · Repertoire &
    // Style · Performance & Production — crown = your EP, sung live.
    Skill('singing', 'Singing', '🎤', 'Release an EP and Sing It Live', [
      _n('v1', 'Breath: diaphragmatic support', 1, null,
          '20-sec sustained tone, steady dB, video', 20, 'Foundations',
          'Learn appoggio basics: rib expansion, low breath, steady '
              'release (free: NYVC and Cheryl Porter channels have '
              'honest drills). Daily hiss-and-sustain work until a '
              '20-second tone holds steady on a dB meter app, filmed.'),
      // — Technique, vocal health first —
      _n('v17', 'Vocal health & anatomy', 2, 'v1',
          'How the voice works, summarised; warm-up routine; strain red-flags', 20, 'Technique',
          'Learn what folds, resonators and support actually do (free '
              'lectures; VoiceScienceWorks). Write your own two-page '
              'summary, build a 10-minute daily warm-up, and memorise '
              'the red flags (pain, hoarseness >2 weeks, loss of range) '
              'that mean STOP and rest.'),
      _n('v2', 'Pitch matching & ear', 2, 'v1',
          '≤10-cent average error across 2 octaves (pitch app)', 40, 'Technique',
          'Daily 10 minutes with a pitch app (Vocal Pitch Monitor): '
              'match played notes, slide-and-hold, then short phrases. '
              'Log weekly average error until ≤10 cents across your '
              'comfortable two octaves.'),
      _n('v3', 'Chest voice development', 3, ['v2', 'v17'],
          'Recorded scale ladder, no strain, vs rubric', 60, 'Technique',
          'Strengthen chest voice on open vowels: 5-note scales '
              'ascending by semitones, stopping BELOW strain every '
              'time. Record the ladder monthly; grade against your '
              'rubric (tone, evenness, effort) — louder is not the '
              'goal, freer is.'),
      _n('v4', 'Head voice & falsetto', 3, ['v2', 'v17'],
          'Recorded sirens through the break', 60, 'Technique',
          'Sirens and octave slides on ng and oo, light and unforced, '
              'through the break without flipping where possible — and '
              'without judgement where not (yet). Record monthly '
              'sirens; the crack moves and shrinks over time. That '
              'migration is the progress.'),
      _n('v5', 'Diction & vowel modification', 4, 'v3',
          'Same phrase in 5 vowels, spectrogram compare', 40, 'Technique',
          'Learn the singer\'s vowel set and modification up the range '
              '(ah→uh near the top). Sing one phrase on five vowels '
              'into a free spectrogram (Voce Vista Video or web tools); '
              'compare formant behaviour and adjust by ear+eye.'),
      _n('v6', 'Mix voice through the passaggio', 5, ['v3', 'v4'],
          'Recorded bridging, no flip, month-apart comparisons', 120, 'Technique',
          'The long project: gees and nays through the first passaggio, '
              'crescendo from head into mix, never pushing chest up. '
              'Record the same three exercises monthly and compare — '
              'this is measured in months, and that is normal. A few '
              'checkup lessons with a real teacher are worth their '
              'price here.'),
      _n('v7', 'Vibrato', 6, 'v6',
          'Straight tone → 5–7 Hz vibrato on demand', 60, 'Technique',
          'Cultivate released vibrato: pulse exercises at 4→5→6 Hz on '
              'sustained tones, then let the pulse become natural '
              'oscillation. Test on recordings: straight tone on '
              'demand, vibrato on demand, measurable at 5–7 Hz in a '
              'pitch app.'),
      _n('v8', 'Agility & runs', 7, 'v6',
          'Pentatonic run drills at 120 bpm, clean', 80, 'Technique',
          'Pentatonic and diatonic run patterns starting at 60 bpm, '
              'each note articulated from the support not the throat, '
              '+8 bpm when clean twice. Build to the classic 5-note '
              'runs at 120 bpm, recorded, then lift two runs from '
              'singers you love and match them.'),
      _n('v9', 'Dynamics (messa di voce)', 8, 'v7',
          'Crescendo–decrescendo on one breath, recorded', 60, 'Technique',
          'The old-school crown of control: one note, pp→ff→pp on a '
              'single breath, tone quality constant. Build from mf '
              'swells on middle-range notes. Record across your range; '
              'the top notes will take months longer, and that is '
              'fine.'),
      // — Ear & musicianship —
      _n('v21', 'Ear for singers: intervals & harmony', 3, 'v2',
          'Interval singing ≥90%; root/3rd/5th sung against drones', 40, 'Ear',
          'Sing intervals (not just identify): given a root, sing any '
              'interval on demand at ≥90% accuracy (checked by app). '
              'Drone work daily: hold root, third, fifth against a '
              'tanpura drone — the fastest intonation medicine there '
              'is.'),
      _n('v22', 'Sight-singing & lyric memory', 4, 'v21',
          '20 melodies sight-sung; 10 full lyrics memorised with a '
              'method', 40, 'Ear',
          'Sight-sing 20 simple melodies in movable-do (Ottman '
              'anthology or free equivalents), conducting the beat. '
              'Build a lyric-memory method (story-mapping verses, '
              'first-letter cues) and prove it: ten full songs '
              'recited cold, no music.'),
      _n('v18', 'Harmony singing: duets', 7, ['v22', 'v16'],
          '5 duet/harmony recordings (virtual duets fine); pitch-checked', 40, 'Ear',
          'Record five harmony tracks against existing songs or a '
              'partner (virtual duets count): thirds above, thirds '
              'below, one counter-melody. Pitch-check your line in '
              'isolation, then in the blend — holding your line '
              'against another voice is a distinct muscle.'),
      // — Repertoire & style —
      _n('v16', 'Repertoire I: 10 songs performed clean', 6, ['v5', 'v6'],
          'Full-take recordings + honest self-review', 80, 'Repertoire',
          'Ten songs fully learned in keys chosen FOR YOUR VOICE '
              '(transpose without shame): full-take recordings, no '
              'punch-ins. After each, a written self-review against '
              'pitch, rhythm, diction, emotion — then one re-record '
              'applying your own notes.'),
      _n('v10', 'Style versatility: 3 genres × 3 songs', 9, ['v16', 'v8'],
          'Recordings judged against genre references', 120, 'Repertoire',
          'Three genres you actually love (say soul, folk, musical '
              'theatre): three songs each, studying the genre\'s '
              'ornaments, phrasing and tone ideals from reference '
              'singers. Record all nine; play yours against the '
              'references and grade the stylistic fit honestly.'),
      _n('v20', 'Songwriting I: 5 originals', 8, 'v16',
          '5 songs written (lyrics + melody + chords), rough demos recorded', 80, 'Repertoire',
          'Write five complete songs: lyric drafts (object writing '
              'daily for a month — Pattison\'s method), melodies that '
              'sit in YOUR best range, chords from your piano/guitar '
              'basics. Rough phone demos are enough — finished beats '
              'perfect.'),
      // — Performance & production —
      _n('v11', 'Home recording craft', 10, ['v9', 'v10'],
          'One polished vocal track (Reaper/Audacity)', 60, 'Production',
          'Learn the home vocal chain: room treatment with blankets, '
              'mic technique, comping takes, then EQ, compression, '
              'reverb basics in Reaper (free trial forever) or '
              'Audacity. Produce ONE polished vocal over a licensed '
              'backing track; A/B it against a commercial reference.'),
      _n('v19', 'Stage & mic technique', 10, 'v10',
          'Mic-distance/plosive demo; 3 filmed performances with movement', 40, 'Production',
          'Handheld mic craft: distance for dynamics, off-axis for '
              'plosives, cable discipline. Film a demo showing each. '
              'Then three full performances filmed standing and '
              'moving — eye lines, gestures that mean something, '
              'recovering from a flub without the face.'),
      _n('v13', 'Perform live: 5 open-mic sets', 11, 'v19',
          'All five sets filmed; a nerves-and-fixes note after each',
          40, 'Production',
          'Five real open-mic sets (music nights, not comedy): 2–3 '
              'songs each, filmed from the audience. After each, the '
              'honest note: what the nerves did, what you fixed, what '
              'the room responded to. By set five you will know '
              'stagecraft no bedroom can teach.'),
      _n('v14', 'Produce an EP: 5 tracks', 11, ['v11', 'v20'],
          'Released on streaming platforms — your own songs on it', 150, 'Production',
          'Five tracks — at least three your own songs: arrange '
              '(simple is fine), record vocals properly, mix (or trade '
              'mixing help), master via a service, artwork, and '
              'release through a free distributor (DistroKid/'
              'RouteNote-class) to real streaming platforms.'),
      // — Convergence —
      _n('v15', 'Crown: live set of your EP', 12, ['v13', 'v14', 'v23'],
          '20+ min filmed live; critique from 2 musicians', 60, 'Convergence',
          'Book a real slot (café gig, showcase night, a living-room '
              'concert with 15 humans). Perform 20+ minutes centred on '
              'YOUR EP, filmed multi-angle if you can. Send the film '
              'to two musicians you respect for written critique — '
              'and take the notes like a professional.'),
      _n('v23', 'Ensemble season: sing with others', 8, 'v18',
          'A season (8+ rehearsals) with a choir/group; 2 performances '
              'sung; blend self-assessed', 40, 'Ear',
          'Join a community choir, a cappella group or regular jam '
              'circle for a full season: eight-plus rehearsals, two '
              'performances. Learn to tune to the section, follow a '
              'director, and blend — record rehearsals and note where '
              'your voice sticks out vs serves the chord.'),
    ]),
]);
