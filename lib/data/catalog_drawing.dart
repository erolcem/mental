// data/catalog_drawing.dart — the drawing constellation.
// Part of skill_data.dart: one Skill tree, governed by the catalog
// laws (see skill_data.dart + test/skill_data_test.dart). Every star:
// id, label, tier, requires, proof (completion standard), hours
// (researched effort), branch, guide (the exact work, step by step).
part of 'skill_data.dart';

final Skill drawingTree = Skill('drawing', 'Drawing', '✏️', 'A Body of Work Worth Exhibiting', [
      _n('d1', 'Drawabox: lines, ghosting, 250 boxes', 1, null,
          'Completed homework, posted for critique', 100, 'Foundations',
          'Work Drawabox lessons 0–1 (free) exactly as written: '
              'superimposed lines, ghosted planes, then the 250 Box '
              'Challenge — no rushing, no erasing. Post every homework '
              'set to the r/ArtFundamentals critique queue and apply the '
              'notes before continuing.'),
      // — Construction —
      _n('d2', 'Shape, proportion & measuring', 2, 'd1',
          '20 still-life studies with measured comparisons', 60, 'Construction',
          'Learn sight-size and comparative measuring (pencil-held-at-'
              'arm\'s-length). Draw 20 still lifes from observation, '
              'blocking in big shapes first and checking every proportion '
              'against a plumb line and angle comparison before detailing.'),
      _n('d3', 'Form: boxes, cylinders, ellipses in space', 3, 'd2',
          'Drawabox lessons 2–3 homework', 80, 'Construction',
          'Drawabox lessons 2–3: arrows, organic forms, then the '
              'cylinder challenge. Drill ellipses inside boxes daily until '
              'they sit convincingly in perspective. The goal is forms '
              'that feel three-dimensional, not outlines that look right.'),
      _n('d4', 'Perspective I: 1 & 2 point', 4, 'd3',
          'A real interior drawn twice, plotted', 60, 'Construction',
          'Study one- and two-point perspective from Robertson\'s How To '
              'Draw (ch. 1–4) or free equivalents. Plot a real room twice '
              'with ruled vanishing points and a measuring system — '
              'furniture, tiles, receding detail all converging '
              'correctly.'),
      _n('d7', 'Perspective II: 3-point + foreshortening', 5, 'd4',
          'Worm/bird-eye city scene, plotted', 80, 'Construction',
          'Add the third vanishing point and inclined planes. Construct a '
              'dramatic worm\'s-eye or bird\'s-eye city scene from '
              'imagination with all three points plotted, then a '
              'foreshortened figure or object using the same box-first '
              'method.'),
      _n('d22', 'Perspective III: curvilinear & atmosphere', 6, 'd7',
          'A 5-point panorama plotted; 3 depth studies using aerial '
              'perspective and edge control', 60, 'Construction',
          'Learn curvilinear (4/5-point) perspective for wide '
              'panoramas, then atmospheric depth: how value contrast, '
              'edge sharpness and colour temperature recede. Plot one '
              'fisheye panorama and paint three studies that create deep '
              'space through air, not just lines.'),
      // — Observation: figure, plates, masters —
      _n('d6', 'Gesture: 500 timed figure poses', 4, ['d3', 'd18'],
          'Dated sketchbook pages, 30s–2min poses', 80, 'Observation',
          'Daily gesture from Line of Action or Quickposes (free): 30-'
              'second to 2-minute poses, chasing the line of action and '
              'weight, NOT contour. 500 poses logged and dated. The bad '
              'ones are the reps — keep every page.'),
      _n('d8', 'Anatomy I: skeleton (Proko)', 5, 'd6',
          'Skeleton from imagination, 3 angles', 80, 'Observation',
          'Proko\'s free skeleton series bone by bone: landmarks, '
              'proportions, the ribcage-pelvis relationship. Draw the '
              'full skeleton from imagination in three views, then find '
              'each landmark on your own gesture drawings.'),
      _n('d17', 'Bargue plates: 10 copies', 5, 'd5',
          'Side-by-side comparisons, flaws annotated', 100, 'Observation',
          'Copy 10 Bargue plates (free scans) using sight-size: the '
              'atelier method that trains the eye. Block in with straight '
              'lines, refine slowly, then overlay your copy on the '
              'original and annotate every drift in angle and proportion.'),
      _n('d10', 'Anatomy II: muscles', 6, 'd8',
          'Écorché studies over 10 gesture drawings', 120, 'Observation',
          'Learn the major muscle groups as forms (Proko, Bridgman\'s '
              'Constructive Anatomy). Draw écorché (muscle) layers over '
              'ten of your own gesture drawings — origin, insertion, what '
              'each muscle does to the surface when it acts.'),
      _n('d19', 'Master studies: 10 copies', 6, 'd17',
          'Ten master copies (Rubens/Sargent/Bridgman); deviations annotated', 100, 'Observation',
          'Copy ten master drawings (Rubens, Sargent, Bridgman, '
              'Loomis). Match their construction and mark-making, not '
              'just the image; write one paragraph per study on the '
              'specific decision you stole from each.'),
      _n('d11', 'Anatomy III: hands, feet, portrait', 7, 'd10',
          '100 hands, 50 feet, 20 portraits', 200, 'Observation',
          'The hard mile: 100 hands, 50 feet, 20 portraits from '
              'observation and imagination. Use the Loomis head method '
              'for portraits and box-construction for hands. These are '
              'where amateur drawings betray themselves — earn them.'),
      // — Light & color —
      _n('d5', 'Value: light logic + 10-step scales', 4, 'd3',
          'Sphere/cube/cylinder under 3 light setups', 60, 'Light & Color',
          'Learn the light logic — halftone, core shadow, reflected '
              'light, cast shadow, occlusion. Render sphere, cube and '
              'cylinder under three lighting setups, controlling a clean '
              '10-step value scale by eye.'),
      _n('d9', 'Color theory (Gurney)', 6, 'd5',
          '12 limited-palette studies', 100, 'Light & Color',
          'Read Gurney\'s Color and Light. Do 12 studies with a limited '
              'palette (start with the Zorn four), matching observed '
              'colour by mixing rather than picking — gamut masking, '
              'temperature shifts in light vs shadow.'),
      _n('d12', 'Material rendering', 8, ['d9', 'd7'],
          'Metal, glass, cloth, skin — one still life each', 120, 'Light & Color',
          'Study how different materials handle light (specular vs '
              'diffuse, subsurface, transparency). Render one careful '
              'still life each of metal, glass, cloth and skin — the '
              'differences live entirely in the highlights and edges.'),
      // — Imagination, habit & digital —
      _n('d18', 'Sketchbook habit: 100 consecutive days', 2, 'd1',
          'Dated pages, 100-day streak; monthly self-critique', 100, 'Imagination',
          'Draw something from life every single day for 100 unbroken '
              'days — a page minimum, dated. Miss a day, the streak '
              'restarts. Monthly, lay out the last 30 pages and write an '
              'honest self-critique of what is improving and what is '
              'avoided.'),
      _n('d21', 'Environments: 20 plein-air sketches', 7, ['d22', 'd9'],
          'On-location sketchbook; 5 finished scenes', 80, 'Imagination',
          'Twenty on-location sketches — cafés, streets, parks — '
              'working fast, editing the chaos into a design. Then take '
              'five back to the studio and push to finished scenes with '
              'full value and colour.'),
      _n('d20', 'Digital craft (Krita/Procreate)', 8, 'd9',
          '5 studies replicating your traditional values and color digitally', 80, 'Imagination',
          'Learn a digital tool (Krita is free): layers, brushes, '
              'blending modes, colour picking discipline. Reproduce five '
              'of your traditional studies digitally so the medium is a '
              'tool, not a crutch — the values and colour must match your '
              'hand.'),
      _n('d13', 'Composition & storytelling', 9, ['d12', 'd19', 'd21'],
          '10 thumbnails/day for 30 days; 3 narrative pieces', 150, 'Imagination',
          'Study composition (notan, focal hierarchy, the eye\'s path). '
              'Thumbnail 10 compositions a day for 30 days from prompts, '
              'then develop three into narrative pieces that tell a story '
              'in a single image — someone should read it without a '
              'caption.'),
      // — Convergence —
      _n('d23', 'Portraiture: 30 heads to true likeness', 8, 'd11',
          '30 portraits from life/photo scored for likeness by a stranger',
          120, 'Observation',
          'Thirty portraits pushing past generic to actual likeness: '
              'the Reilly/Loomis structure underneath, then the specific '
              'asymmetries that make one face that person. Test '
              'honestly — show ten to someone who knows the sitters and '
              'have them name each.'),
      _n('d24', 'Digital illustration: 5 full pieces', 9, 'd20',
          '5 finished illustrations start-to-final; process files kept',
          120, 'Imagination',
          'Five complete illustrations from thumbnail → value comp → '
              'colour comp → render, using your digital craft fully '
              '(custom brushes, adjustment layers, photobashing where '
              'honest). Keep the process files — the workflow is half the '
              'skill you are proving.'),
      _n('d14', 'Portfolio: 20 finished works', 10, ['d13', 'd23', 'd24'],
          'Curated, unified voice + artist statement', 300, 'Convergence',
          'Produce and curate 20 finished works with a recognisable '
              'point of view — subject, palette or mark that ties them '
              'together. Write a one-page artist statement. Cut anything '
              'that does not belong; a tight 15 beats a scattered 25.'),
      _n('d16', 'Crown: exhibit', 11, 'd14',
          'A real show (café/library/gallery/online curated), documented reach', 60, 'Convergence',
          'Mount a real exhibition: a café or library wall, a group '
              'show, a booked online viewing room. Hang or sequence it '
              'deliberately, price or caption the work, invite an '
              'audience, and document who actually came and what they '
              'said.'),
]);
