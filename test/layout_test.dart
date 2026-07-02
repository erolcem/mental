// The constellation layout must be deterministic, collision-free enough to
// tap, and keep every star inside the canvas.
import 'package:flutter_test/flutter_test.dart';
import 'package:mental/data/skill_data.dart';
import 'package:mental/ui/constellation_layout.dart';

void main() {
  test('every node gets a position inside the canvas', () {
    for (final stat in catalog) {
      for (final skill in stat.skills) {
        final layout = layoutConstellation(skill);
        for (final n in skill.tree) {
          final p = layout.pos[n.id];
          expect(p, isNotNull, reason: '${skill.id}.${n.id} unplaced');
          expect(p!.dx, inInclusiveRange(0, layout.size.width),
              reason: '${skill.id}.${n.id} x out of bounds');
          expect(p.dy, inInclusiveRange(0, layout.size.height),
              reason: '${skill.id}.${n.id} y out of bounds');
        }
      }
    }
  });

  test('layout is deterministic across calls', () {
    for (final skill in [skillById('maths'), skillById('karate')]) {
      final a = layoutConstellation(skill);
      final b = layoutConstellation(skill);
      for (final n in skill.tree) {
        expect(a.pos[n.id], b.pos[n.id]);
        expect(a.magnitude[n.id], b.magnitude[n.id]);
      }
    }
  });

  test('same-tier stars keep a tappable gap', () {
    for (final stat in catalog) {
      for (final skill in stat.skills) {
        final layout = layoutConstellation(skill);
        final byTier = <int, List<SkillNode>>{};
        for (final n in skill.tree) {
          (byTier[n.tier] ??= []).add(n);
        }
        for (final tierNodes in byTier.values) {
          for (var i = 0; i < tierNodes.length; i++) {
            for (var j = i + 1; j < tierNodes.length; j++) {
              final d = (layout.pos[tierNodes[i].id]! -
                      layout.pos[tierNodes[j].id]!)
                  .distance;
              expect(d, greaterThanOrEqualTo(44),
                  reason:
                      '${skill.id}: ${tierNodes[i].id} vs ${tierNodes[j].id} too close ($d)');
            }
          }
        }
      }
    }
  });

  test('crown star has the largest magnitude in its tree', () {
    for (final stat in catalog) {
      for (final skill in stat.skills) {
        final layout = layoutConstellation(skill);
        final crowns =
            skill.tree.where((n) => n.tier == skill.maxTier).toList();
        for (final c in crowns) {
          expect(layout.magnitude[c.id], 1.5);
        }
      }
    }
  });
}
