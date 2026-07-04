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

  test('prerequisites always sit in a strictly lower tier (edges flow up)', () {
    for (final stat in catalog) {
      for (final skill in stat.skills) {
        for (final n in skill.tree) {
          for (final r in n.requires) {
            expect(skill.nodeById(r).tier, lessThan(n.tier),
                reason: '${skill.id}.${n.id} (tier ${n.tier}) requires '
                    '$r at tier ${skill.nodeById(r).tier}');
          }
        }
      }
    }
  });

  // The parallel-path design: every skill is a constellation of named branches
  // that converge on one crown.
  test('every node names a branch (parallel path)', () {
    for (final stat in catalog) {
      for (final skill in stat.skills) {
        for (final n in skill.tree) {
          expect(n.branch, isNotEmpty,
              reason: '${skill.id}.${n.id} has no branch');
        }
      }
    }
  });

  test('every skill has many parallel paths (>= 4 branches)', () {
    for (final stat in catalog) {
      for (final skill in stat.skills) {
        expect(skill.branches.length, greaterThanOrEqualTo(4),
            reason: '${skill.id} has too few parallel paths');
      }
    }
  });

  test('exactly one crown, alone at the top tier, on the Crown path', () {
    for (final stat in catalog) {
      for (final skill in stat.skills) {
        final crowns =
            skill.tree.where((n) => n.tier == skill.maxTier).toList();
        expect(crowns.length, 1,
            reason: '${skill.id} must have exactly one crown star');
        expect(crowns.single.branch, 'Crown',
            reason: '${skill.id} crown must be on the Crown path');
      }
    }
  });

  test('parallel paths converge: each skill has a node fed by >= 2 branches',
      () {
    for (final stat in catalog) {
      for (final skill in stat.skills) {
        final converges = skill.tree.any((n) {
          final branches =
              n.requires.map((r) => skill.nodeById(r).branch).toSet();
          return branches.length >= 2;
        });
        expect(converges, isTrue,
            reason: '${skill.id} never merges two parallel paths');
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
