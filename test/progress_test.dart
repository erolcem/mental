// Progress rules: unlock gating, ignition, cascade extinguish, XP/level, and
// persistence round-trip through the JSON blob.
import 'package:flutter_test/flutter_test.dart';
import 'package:mental/data/repository.dart';
import 'package:mental/data/skill_data.dart';
import 'package:mental/state/providers.dart';

void main() {
  final maths = skillById('maths');
  SkillNode node(String id) => maths.nodeById(id);

  ProgressNotifier fresh() => ProgressNotifier(InMemoryProgressRepository());

  test('locked node cannot ignite', () {
    final n = fresh();
    n.ignite(maths, node('m3')); // Calculus requires m1 (Precalculus)
    expect(n.isComplete('maths', 'm3'), isFalse);
  });

  test('root ignites, then dependent unlocks and ignites', () {
    final n = fresh();
    n.ignite(maths, node('m1'), summary: 'precalc done');
    expect(n.isComplete('maths', 'm1'), isTrue);
    expect(n.isUnlocked(maths, node('m3')), isTrue);
    n.ignite(maths, node('m3'));
    expect(n.isComplete('maths', 'm3'), isTrue);
  });

  test('multi-prereq node needs all parents', () {
    final n = fresh();
    n.ignite(maths, node('m1'));
    n.ignite(maths, node('m3'));
    expect(n.isUnlocked(maths, node('m5')), isFalse, // needs m3 AND m2
        reason: 'm5 (Axler) needs m2 (proofs) too');
    n.ignite(maths, node('m2'));
    expect(n.isUnlocked(maths, node('m5')), isTrue);
  });

  test('extinguish cascades to dependents', () {
    final n = fresh();
    for (final id in ['m1', 'm2', 'm3', 'm5']) {
      n.ignite(maths, node(id));
    }
    // Extinguishing Precalculus darkens Calculus and Axler above it, but the
    // proofs root (m2) keeps its own light.
    expect(n.extinguishImpact(maths, node('m1')), 3);
    n.extinguish(maths, node('m1'));
    for (final id in ['m1', 'm3', 'm5']) {
      expect(n.isComplete('maths', id), isFalse, reason: '$id must go dark');
    }
    expect(n.isComplete('maths', 'm2'), isTrue,
        reason: 'independent root keeps its light');
  });

  test('extinguish keeps the summary sheet', () {
    final n = fresh();
    n.ignite(maths, node('m1'), summary: 'my notes');
    n.extinguish(maths, node('m1'));
    expect(n.state[progressKey('maths', 'm1')]!.summary, 'my notes');
  });

  test('maths progress does not leak into mechanics (shared m1 id)', () {
    final n = fresh();
    n.ignite(maths, node('m1'));
    expect(n.isComplete('mechanics', 'm1'), isFalse);
  });

  test('XP and level: zero at start, 99 at full completion', () {
    expect(levelForXp(0), 1);
    var xp = 0;
    for (final stat in catalog) {
      for (final sk in stat.skills) {
        for (final nd in sk.tree) {
          xp += xpForNode(nd);
        }
      }
    }
    expect(levelForXp(xp), 99);
    expect(levelForXp(xp ~/ 2), inInclusiveRange(2, 98));
  });

  test('NodeProgress JSON round-trip', () {
    final p = NodeProgress(
        completedAt: DateTime(2026, 7, 2, 12, 30), summary: 'sheet');
    final back = NodeProgress.fromJson(p.toJson());
    expect(back.completedAt, p.completedAt);
    expect(back.summary, 'sheet');
    expect(back.complete, isTrue);
    const empty = NodeProgress();
    expect(NodeProgress.fromJson(empty.toJson()).complete, isFalse);
  });
}
