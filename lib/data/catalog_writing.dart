// data/catalog_writing.dart — the writing constellation.
// Part of skill_data.dart: one Skill tree, governed by the catalog
// laws (see skill_data.dart + test/skill_data_test.dart). Every star:
// id, label, tier, requires, proof (completion standard), hours
// (researched effort), branch, guide (the exact work, step by step).
part of 'skill_data.dart';

final Skill writingTree = Skill('writing', 'Writing', '🖊', 'A Published Novel', [
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
]);
