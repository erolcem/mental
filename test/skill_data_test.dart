// Guards the mastery catalog: whatever the curriculum becomes, these
// structural invariants must hold or trees render/unlock wrongly.
import 'package:flutter_test/flutter_test.dart';
import 'package:mental/data/skill_data.dart';

void main() {
  test('catalog has 4 stats and 21 skills', () {
    expect(catalog.length, 4);
    expect(catalog.expand((s) => s.skills).length, 21);
    expect(totalNodeCount, greaterThan(300));
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
}
