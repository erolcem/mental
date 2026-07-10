// data/catalog_piano.dart — the piano constellation.
// Part of skill_data.dart: one Skill tree, governed by the catalog
// laws (see skill_data.dart + test/skill_data_test.dart). Every star:
// id, label, tier, requires, proof (completion standard), hours
// (researched effort), branch, guide (the exact work, step by step).
part of 'skill_data.dart';

final Skill pianoTree = Skill('piano', 'Piano', '🎹', 'The One-Hour Memorised Recital', [
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
]);
