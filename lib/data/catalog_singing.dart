// data/catalog_singing.dart — the singing constellation.
// Part of skill_data.dart: one Skill tree, governed by the catalog
// laws (see skill_data.dart + test/skill_data_test.dart). Every star:
// id, label, tier, requires, proof (completion standard), hours
// (researched effort), branch, guide (the exact work, step by step).
part of 'skill_data.dart';

final Skill singingTree = Skill('singing', 'Singing', '🎤', 'Release an EP and Sing It Live', [
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
]);
