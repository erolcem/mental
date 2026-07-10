// data/catalog_musictheory.dart — the musicTheory constellation.
// Part of skill_data.dart: one Skill tree, governed by the catalog
// laws (see skill_data.dart + test/skill_data_test.dart). Every star:
// id, label, tier, requires, proof (completion standard), hours
// (researched effort), branch, guide (the exact work, step by step).
part of 'skill_data.dart';

final Skill musicTheoryTree = Skill('musicTheory', 'Music Theory', '🎼', 'Compose and Hear It Performed', [
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
]);
