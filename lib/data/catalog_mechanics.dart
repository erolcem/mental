// data/catalog_mechanics.dart — the mechanics constellation.
// Part of skill_data.dart: one Skill tree, governed by the catalog
// laws (see skill_data.dart + test/skill_data_test.dart). Every star:
// id, label, tier, requires, proof (completion standard), hours
// (researched effort), branch, guide (the exact work, step by step).
part of 'skill_data.dart';

final Skill mechanicsTree = Skill('mechanics', 'Mechanics', '🔧', 'Rebuild It Yourself', [
      _n('m1', 'Shop safety + tool literacy', 1, null,
          'Tool ID quiz; torque practice; jack-stand discipline video', 20, 'Foundations',
          'Learn every common hand and power tool by name and use, '
              'PPE discipline (eyes always, no gloves in rotating '
              'tools), and the non-negotiable safety rituals. Film '
              'yourself lifting a car and placing jack stands correctly '
              '— NEVER work under a jack alone.'),
      // — Auto —
      _n('m2', 'Auto basics: fluids, filters, battery, tyres', 2, 'm1',
          'Perform + document all on a real car', 30, 'Auto',
          'On a real car: oil and filter change, air and cabin '
              'filters, check and top all fluids, test and clean the '
              'battery, rotate tyres and set pressures. Document each '
              'with the torque specs from the manual — the maintenance '
              'that prevents most breakdowns.'),
      _n('m4', 'Auto: brakes & suspension', 3, 'm2',
          'Pad/rotor change documented; ASE A5 practice ≥80%', 40, 'Auto',
          'Change brake pads and rotors, bleed the lines, inspect the '
              'suspension (bushings, shocks, ball joints). Document the '
              'job and pass an ASE A5 (brakes) practice exam ≥80%. '
              'Brakes are where mistakes are unforgiving — torque to '
              'spec, no shortcuts.'),
      _n('m6', 'Auto: electrics + OBD-II diagnostics', 4, 'm4',
          '3 real faults chased with multimeter + scanner log', 60, 'Auto',
          'Learn automotive electrical (12V circuits, grounds, '
              'relays, fuses) and OBD-II. Chase three real faults with '
              'a multimeter and a scanner — read the code, form a '
              'hypothesis, test it, fix it — logging the diagnostic '
              'reasoning, not just the part swapped.'),
      _n('m12', 'ASE knowledge gauntlet', 7, 'm10',
          'A1–A8 practice exams, all ≥80%', 120, 'Auto',
          'Work through the ASE A1–A8 material (engine, transmission, '
              'brakes, electrical, HVAC, steering/suspension, '
              'performance, diesel) and pass every practice exam ≥80%. '
              'This is the automotive body of knowledge, self-verified '
              'against the professional standard.'),
      // — Home —
      _n('m3', 'Home basics: drywall, painting, patching', 2, 'm1',
          'Repair a wall section, document the finish', 30, 'Home',
          'Patch a real hole in drywall — cut, backer, mud in three '
              'coats, sand, prime, paint to an invisible finish. Learn '
              'the taping-knife technique and how to feather. The '
              'finish is the test: run a light along the wall and see '
              'no shadow.'),
      _n('m5', 'Home: plumbing fundamentals', 3, 'm3',
          'Replace a trap/valve; sweat or press one joint', 40, 'Home',
          'Learn supply vs drain-waste-vent, then do real work: '
              'replace a P-trap, swap a shutoff valve or faucet, and '
              'make one permanent joint — sweat copper with a torch '
              '(fire-safe) or press/PEX. Water off first, always test '
              'for leaks under pressure.'),
      _n('m7', 'Home: electrical theory + code literacy', 4, 'm5',
          'Practice board wired (dead circuits); code quiz ≥80%', 60, 'Home',
          'Learn residential wiring theory and NEC basics. Practice '
              'ONLY on dead, disconnected circuits (a plywood practice '
              'board): outlets, switches, three-ways, a small panel '
              'mock-up. Pass a code-literacy quiz ≥80%. Know exactly '
              'what a licensed electrician must legally do.'),
      _n('m9', 'Home: framing & structural basics', 5, 'm17',
          'Stud wall or shed section, square + plumb', 60, 'Home',
          'Learn load paths, spans and framing (Larry Haun\'s free '
              'videos are gold). Build a real stud wall or shed '
              'section: layout, plates, studs 16" on-centre, headers, '
              'checked square and plumb. Understand what is structural '
              'before you ever remove a wall.'),
      _n('m11', 'Home: full room renovation', 6, ['m9', 'm7'],
          'Before/after with process log', 150, 'Home',
          'Renovate one room end to end: demo, any framing changes, '
              'the electrical and plumbing you are qualified to do '
              '(licensed help where required), drywall, trim, paint, '
              'floor. Document the whole process — this integrates '
              'every home skill into one visible transformation.'),
      _n('m15', 'EPA 608 (refrigerant handling)', 7, 'm7',
          'The real certificate — publicly bookable', 30, 'Home',
          'Study for and pass the real EPA Section 608 certification '
              '(Universal) — publicly bookable, legally required to '
              'buy refrigerant. Learn the refrigeration cycle, '
              'recovery, and why venting is both illegal and '
              'environmentally serious.'),
      // — Machines: bicycle → engine —
      _n('m16', 'Bicycle: full tune-up', 2, 'm1',
          'Brakes, gears, bearings serviced; Park Tool checklist; ride test', 25, 'Machines',
          'Using the free Park Tool Big Blue Book / videos, fully '
              'service a bike: true a wheel, adjust brakes and '
              'derailleurs to shift crisply, overhaul a hub or '
              'bottom-bracket bearing, check the whole safety '
              'checklist. Ride-test it. The mechanical fundamentals in '
              'miniature.'),
      _n('m8', 'Small-engine teardown: rebuild to running', 5, ['m6', 'm16'],
          'Junkyard/lawnmower engine — video of first start', 60, 'Machines',
          'Get a dead lawnmower or small engine (free on curbs). '
              'Diagnose, tear it fully down, clean the carb, replace '
              'what is worn, reassemble to spec, and film the first '
              'start. The four-stroke cycle becomes real in your '
              'hands here.'),
      _n('m10', 'Motorcycle/car engine rebuild', 6, 'm8',
          'Compression numbers before/after', 150, 'Machines',
          'Rebuild a real engine: teardown, measure wear against '
              'spec (bore, ring gap, bearing clearance with '
              'plastigauge), replace gaskets/rings/bearings, torque '
              'in sequence, reassemble. Prove it with compression '
              'numbers before and after — the deep end of machines.'),
      // — Making: wood, CAD, metal —
      _n('m17', 'Woodworking I: build a workbench', 3, 'm3',
          'Square, level bench from plans; joinery photos; technique video', 60, 'Making',
          'Build a real workbench from plans (Paul Sellers\' free '
              'series is a superb start): dimension the stock, cut '
              'genuine joinery (mortise-and-tenon or bridle joints), '
              'glue up square and flat. Photograph the joints; the '
              'bench is both tool and proof.'),
      _n('m18', 'CAD + 3D printing', 4, 'm17',
          'Three designed-and-printed functional parts; tolerances measured', 60, 'Making',
          'Learn parametric CAD (Fusion 360 free tier or FreeCAD) and '
              'FDM printing. Design and print three FUNCTIONAL parts — '
              'a bracket, a replacement knob, a jig — measuring '
              'tolerances with calipers and iterating until they fit. '
              'Digital fabrication for real repairs.'),
      _n('m19', 'Metalwork & fasteners', 5, 'm18',
          'Tap & die practice; a steel bracket made; makerspace intro class ok', 40, 'Making',
          'Learn to work metal: cut, file, drill, tap and die '
              'threads, and rivet or bolt. Make a steel bracket to a '
              'drawing. A makerspace intro-to-welding class is the '
              'ideal (supervised) way to add MIG basics — safety gear '
              'mandatory.'),
      _n('m20', 'Welding: sound structural joints', 6, 'm19',
          'A supervised course completed; 5 joint types passing a '
              'bend/break test', 60, 'Making',
          'Take a real supervised welding course (community college or '
              'makerspace — never self-taught with a rented machine and '
              'no ventilation). Learn MIG at minimum: five joint types '
              '(butt, lap, tee, corner, edge) that pass a bend-or-'
              'break test, with full PPE and fire discipline.'),
      // — Convergence —
      _n('m14', 'Crown: one machine + one room, end to end', 8,
          ['m12', 'm11', 'm15', 'm20'],
          'A vehicle you rebuilt driving; a room you transformed', 200, 'Convergence',
          'The two-part crown: a machine you rebuilt with your own '
              'hands running and safe (a car passing inspection, a '
              'motorcycle on the road, an engine at spec), AND a room '
              'you transformed end to end. Documented before/after for '
              'both — self-reliance made visible.'),
]);
