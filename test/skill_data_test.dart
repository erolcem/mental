// Guards the mastery catalog: whatever the curriculum becomes, these
// structural invariants must hold or trees render/unlock wrongly.
import 'package:flutter_test/flutter_test.dart';
import 'package:mental/data/skill_data.dart';

void main() {
  test('catalog has 4 stats and 21 skills', () {
    expect(catalog.length, 4);
    expect(catalog.expand((s) => s.skills).length, 21);
    expect(totalNodeCount, greaterThan(400));
  });

  test('node ids are unique within every tree', () {
    for (final stat in catalog) {
      for (final skill in stat.skills) {
        final ids = skill.tree.map((n) => n.id).toSet();
        expect(ids.length, skill.tree.length,
            reason: 'duplicate node id in ${skill.id}');
      }
    }
  });

  test('every prerequisite exists in the same tree', () {
    for (final stat in catalog) {
      for (final skill in stat.skills) {
        final ids = skill.tree.map((n) => n.id).toSet();
        for (final n in skill.tree) {
          for (final r in n.requires) {
            expect(ids.contains(r), isTrue,
                reason: '${skill.id}.${n.id} requires missing $r');
          }
        }
      }
    }
  });

  test('no dependency cycles (topological order exists)', () {
    for (final stat in catalog) {
      for (final skill in stat.skills) {
        final done = <String>{};
        var remaining = List.of(skill.tree);
        while (remaining.isNotEmpty) {
          final ready = remaining
              .where((n) => n.requires.every(done.contains))
              .toList();
          expect(ready, isNotEmpty,
              reason: 'cycle in ${skill.id} among '
                  '${remaining.map((n) => n.id).toList()}');
          done.addAll(ready.map((n) => n.id));
          remaining =
              remaining.where((n) => !done.contains(n.id)).toList();
        }
      }
    }
  });

  test('tiers are positive and every tree starts at tier 1', () {
    for (final stat in catalog) {
      for (final skill in stat.skills) {
        expect(skill.tree.any((n) => n.tier == 1), isTrue,
            reason: '${skill.id} has no tier-1 root');
        for (final n in skill.tree) {
          expect(n.tier, greaterThanOrEqualTo(1));
        }
      }
    }
  });

  test('progress keys are globally unique (maths m1 vs mechanics m1)', () {
    final keys = <String>{};
    for (final stat in catalog) {
      for (final skill in stat.skills) {
        for (final n in skill.tree) {
          expect(keys.add(progressKey(skill.id, n.id)), isTrue,
              reason: 'colliding key ${progressKey(skill.id, n.id)}');
        }
      }
    }
    expect(keys.length, totalNodeCount);
  });

  // ---------------------------------------------------------------------
  // Parallel-path laws (the 2026-07 overhaul): each constellation is a
  // braid of simultaneous branches that all converge on a single crown.

  test('tiers strictly increase along every prerequisite edge', () {
    for (final stat in catalog) {
      for (final skill in stat.skills) {
        final byId = {for (final n in skill.tree) n.id: n};
        for (final n in skill.tree) {
          for (final r in n.requires) {
            expect(n.tier, greaterThan(byId[r]!.tier),
                reason: '${skill.id}.${n.id} (t${n.tier}) sits at or below '
                    'its prerequisite $r (t${byId[r]!.tier})');
          }
        }
      }
    }
  });

  test('every constellation has exactly one crown at its max tier', () {
    for (final stat in catalog) {
      for (final skill in stat.skills) {
        final crowns =
            skill.tree.where((n) => n.tier == skill.maxTier).toList();
        expect(crowns.length, 1,
            reason: '${skill.id} has ${crowns.length} stars at max tier: '
                '${crowns.map((n) => n.id).toList()}');
      }
    }
  });

  test('every star lies on a path to the crown (no orphans)', () {
    for (final stat in catalog) {
      for (final skill in stat.skills) {
        final byId = {for (final n in skill.tree) n.id: n};
        final crown =
            skill.tree.firstWhere((n) => n.tier == skill.maxTier);
        final ancestors = <String>{crown.id};
        final queue = [crown.id];
        while (queue.isNotEmpty) {
          for (final r in byId[queue.removeLast()]!.requires) {
            if (ancestors.add(r)) queue.add(r);
          }
        }
        for (final n in skill.tree) {
          expect(ancestors.contains(n.id), isTrue,
              reason: '${skill.id}.${n.id} is an orphan star — '
                  'no path leads from it to the crown');
        }
      }
    }
  });

  test('trees are truly parallel and still fit the sky', () {
    for (final stat in catalog) {
      for (final skill in stat.skills) {
        final widths = <int, int>{};
        for (final n in skill.tree) {
          widths[n.tier] = (widths[n.tier] ?? 0) + 1;
        }
        widths.forEach((t, w) => expect(w, lessThanOrEqualTo(5),
            reason: '${skill.id} tier $t has $w stars — layout crowds past 5'));
        expect(widths.values.where((w) => w >= 2).length,
            greaterThanOrEqualTo(4),
            reason: '${skill.id} is chain-shaped: fewer than 4 tiers offer '
                'a choice of stars to work in parallel');
        expect(widths.values.where((w) => w >= 3).length,
            greaterThanOrEqualTo(1),
            reason: '${skill.id} never opens 3 parallel stars at once');
        expect(skill.tree.length, greaterThanOrEqualTo(16),
            reason: '${skill.id} is too small for a mastery constellation');
      }
    }
  });
}
