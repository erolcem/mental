// data/catalog_english.dart — the english constellation.
// Part of skill_data.dart: one Skill tree, governed by the catalog
// laws (see skill_data.dart + test/skill_data_test.dart). Every star:
// id, label, tier, requires, proof (completion standard), hours
// (researched effort), branch, guide (the exact work, step by step).
part of 'skill_data.dart';

final Skill englishTree = Skill('english', 'English', '🔤', 'Command the Room and the Page', [
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
]);
