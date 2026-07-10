// data/catalog_khmer.dart — the khmer constellation.
// Part of skill_data.dart: one Skill tree, governed by the catalog
// laws (see skill_data.dart + test/skill_data_test.dart). Every star:
// id, label, tier, requires, proof (completion standard), hours
// (researched effort), branch, guide (the exact work, step by step).
part of 'skill_data.dart';

final Skill khmerTree = Skill('khmer', 'Khmer', '🇰🇭', 'Fluency Where No Textbook Ecosystem Exists', [
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
]);
