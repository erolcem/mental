// tool/analyze_catalog.dart — compute over the mastery catalog without a
// Flutter toolchain (skill_data.dart is pure Dart by design).
//
//   dart tool/analyze_catalog.dart          verify invariants + print report
//   dart tool/analyze_catalog.dart --write  also regenerate
//                                           docs/curriculum/ANALYSIS.md
//
// Verifies every structural law from test/skill_data_test.dart (so CI or a
// bare machine can gate the data without Flutter), then computes the effort
// and parallelism analytics documented in docs/curriculum/ANALYSIS.md.
import 'dart:io';
import 'dart:math' as math;

import 'package:mental/data/skill_data.dart';

int failures = 0;
void check(bool cond, String msg) {
  if (!cond) {
    failures++;
    stderr.writeln('FAIL: $msg');
  }
}

/// XP mirror of state/providers.dart (which imports Flutter, so it cannot be
/// imported here). Keep in sync with xpForNode/levelForXp.
int xpForNode(SkillNode n) => n.hours + n.tier * 10;
int levelForXp(int xp, int maxXp) =>
    maxXp == 0 ? 1 : 1 + (98 * math.sqrt((xp / maxXp).clamp(0.0, 1.0))).floor();

class SkillReport {
  final StatDomain stat;
  final Skill skill;
  final int edges;
  final int criticalPathHours;
  final List<String> criticalPath;
  final double meanFrontier;
  final int minFrontier;
  final double choiceShare; // fraction of ignition steps with ≥2 open stars
  SkillReport(this.stat, this.skill, this.edges, this.criticalPathHours,
      this.criticalPath, this.meanFrontier, this.minFrontier, this.choiceShare);

  int get xp => skill.tree.fold(0, (s, n) => s + xpForNode(n));

  /// Braid factor: how much shorter the crown's calendar is than the summed
  /// work, because branches overlap. 1.0 = pure chain.
  double get braid => skill.totalHours / math.max(1, criticalPathHours);
}

void verify(Skill skill) {
  final ids = skill.tree.map((n) => n.id).toSet();
  check(ids.length == skill.tree.length, 'duplicate node id in ${skill.id}');
  final byId = {for (final n in skill.tree) n.id: n};
  check(skill.branches.length >= 5,
      '${skill.id} names only ${skill.branches.length} branches — not a braid');
  for (final n in skill.tree) {
    check(n.tier >= 1, '${skill.id}.${n.id} tier < 1');
    check(n.hours > 0, '${skill.id}.${n.id} has no hour estimate');
    check(n.branch.isNotEmpty, '${skill.id}.${n.id} belongs to no branch');
    check(n.proof.length >= 24,
        '${skill.id}.${n.id} has a thin completion standard: "${n.proof}"');
    for (final r in n.requires) {
      check(ids.contains(r), '${skill.id}.${n.id} requires missing $r');
      if (byId[r] != null) {
        check(n.tier > byId[r]!.tier,
            '${skill.id}.${n.id} does not sit above prerequisite $r');
      }
    }
  }
  check(skill.tree.any((n) => n.tier == 1), '${skill.id} has no tier-1 root');

  final done = <String>{};
  var remaining = List.of(skill.tree);
  while (remaining.isNotEmpty) {
    final ready =
        remaining.where((n) => n.requires.every(done.contains)).toList();
    if (ready.isEmpty) {
      check(false, 'cycle in ${skill.id}');
      return;
    }
    done.addAll(ready.map((n) => n.id));
    remaining = remaining.where((n) => !done.contains(n.id)).toList();
  }

  final crowns = skill.tree.where((n) => n.tier == skill.maxTier).toList();
  check(crowns.length == 1, '${skill.id} needs exactly one crown');
  if (crowns.length == 1) {
    final anc = <String>{crowns.single.id};
    final queue = [crowns.single.id];
    while (queue.isNotEmpty) {
      for (final r in byId[queue.removeLast()]!.requires) {
        if (anc.add(r)) queue.add(r);
      }
    }
    for (final n in skill.tree) {
      check(anc.contains(n.id), '${skill.id}.${n.id} is an orphan star');
    }
  }

  // No redundant edges: a prerequisite already implied by another
  // prerequisite's ancestry adds a false constraint line to the sky.
  final ancestorsOf = <String, Set<String>>{};
  Set<String> ancestors(String id) => ancestorsOf.putIfAbsent(id, () {
        final out = <String>{};
        for (final r in byId[id]!.requires) {
          out
            ..add(r)
            ..addAll(ancestors(r));
        }
        return out;
      });
  for (final n in skill.tree) {
    for (final r in n.requires) {
      final implied = n.requires
          .where((o) => o != r && ancestors(o).contains(r))
          .toList();
      check(implied.isEmpty,
          '${skill.id}.${n.id}: requiring $r is redundant — already implied '
          'via ${implied.join(', ')}');
    }
  }

  final widths = <int, int>{};
  for (final n in skill.tree) {
    widths[n.tier] = (widths[n.tier] ?? 0) + 1;
  }
  widths.forEach(
      (t, w) => check(w <= 8, '${skill.id} tier $t crowds the layout ($w)'));
  check(widths.values.where((w) => w >= 2).length >= 4,
      '${skill.id} is chain-shaped');
  check(widths.values.where((w) => w >= 3).isNotEmpty,
      '${skill.id} never opens 3 stars at once');
  check(skill.tree.length >= 16, '${skill.id} is too small');
}

SkillReport analyze(StatDomain stat, Skill skill) {
  final edges = skill.tree.fold(0, (s, n) => s + n.requires.length);

  // Critical path: hour-weighted longest path ending at the crown (DAG DP in
  // topological order).
  final best = <String, int>{};
  final via = <String, String?>{};
  final topo = <SkillNode>[];
  final placed = <String>{};
  var remaining = List.of(skill.tree);
  while (remaining.isNotEmpty) {
    final ready =
        remaining.where((n) => n.requires.every(placed.contains)).toList()
          ..sort((a, b) => a.id.compareTo(b.id));
    topo.addAll(ready);
    placed.addAll(ready.map((n) => n.id));
    remaining = remaining.where((n) => !placed.contains(n.id)).toList();
  }
  for (final n in topo) {
    var b = 0;
    String? from;
    for (final r in n.requires) {
      if (best[r]! > b) {
        b = best[r]!;
        from = r;
      }
    }
    best[n.id] = b + n.hours;
    via[n.id] = from;
  }
  final crown = skill.tree.firstWhere((n) => n.tier == skill.maxTier);
  final path = <String>[];
  for (String? c = crown.id; c != null; c = via[c]) {
    path.insert(0, c);
  }

  // Frontier simulation: ignite one star per step (lowest tier, then id —
  // a patient student clearing foundations first) and measure how many
  // unlocked-unlit stars the sky offered before each choice.
  final lit = <String>{};
  final sizes = <int>[];
  while (lit.length < skill.tree.length) {
    final open = skill.tree
        .where((n) =>
            !lit.contains(n.id) && n.requires.every(lit.contains))
        .toList()
      ..sort((a, b) =>
          a.tier != b.tier ? a.tier - b.tier : a.id.compareTo(b.id));
    sizes.add(open.length);
    lit.add(open.first.id);
  }
  final mean = sizes.reduce((a, b) => a + b) / sizes.length;
  final minF = sizes.reduce(math.min);
  final choice = sizes.where((s) => s >= 2).length / sizes.length;

  return SkillReport(
      stat, skill, edges, best[crown.id]!, path, mean, minF, choice);
}

String fmt(num v, [int dp = 1]) => v.toStringAsFixed(dp);
String pct(double v) => '${(v * 100).round()}%';

void main(List<String> args) {
  for (final stat in catalog) {
    for (final skill in stat.skills) {
      verify(skill);
    }
  }
  final keys = <String>{};
  for (final stat in catalog) {
    for (final sk in stat.skills) {
      for (final n in sk.tree) {
        check(keys.add(progressKey(sk.id, n.id)), 'key collision');
      }
    }
  }
  if (failures > 0) {
    stderr.writeln('$failures invariant failures — fix the catalog first.');
    exit(1);
  }

  final reports = [
    for (final stat in catalog)
      for (final skill in stat.skills) analyze(stat, skill)
  ];
  final totalHours =
      reports.fold(0, (s, r) => s + r.skill.totalHours);
  final totalXp = reports.fold(0, (s, r) => s + r.xp);

  final heaviest = [
    for (final stat in catalog)
      for (final sk in stat.skills)
        for (final n in sk.tree) (skill: sk, node: n)
  ]..sort((a, b) => b.node.hours - a.node.hours);

  final buf = StringBuffer('''
# Catalog Analysis — generated by `dart tool/analyze_catalog.dart --write`

**Do not edit by hand.** Numbers recompute from `lib/data/skill_data.dart`.

## The whole sky

| | nodes | edges | hours | XP |
|---|---|---|---|---|
''');
  for (final stat in catalog) {
    final rs = reports.where((r) => r.stat.id == stat.id);
    buf.writeln('| **${stat.id} ${stat.label}** '
        '| ${rs.fold(0, (s, r) => s + r.skill.tree.length)} '
        '| ${rs.fold(0, (s, r) => s + r.edges)} '
        '| ${rs.fold(0, (s, r) => s + r.skill.totalHours)} '
        '| ${rs.fold(0, (s, r) => s + r.xp)} |');
  }
  buf.writeln('| **TOTAL** | $totalNodeCount '
      '| ${reports.fold(0, (s, r) => s + r.edges)} '
      '| $totalHours | $totalXp |');

  buf.write('''

**$totalHours hours of deliberate work** separate a dark sky from a full one —
≈ ${fmt(totalHours / (4 * 365), 0)} years at four focused hours a day, a
five-fold Gladwell. XP is effort-weighted (XP = hours + tier × 10) so a star
pays what it costs; the level curve (level = 1 + 98·√(xp/max)) pays out fast
early and slow late:

| sky completed (XP) | 1% | 5% | 10% | 25% | 50% | 75% | 100% |
|---|---|---|---|---|---|---|---|
| level | ${[0.01, 0.05, 0.10, 0.25, 0.50, 0.75, 1.0].map((f) => levelForXp((totalXp * f).round(), totalXp)).join(' | ')} |

## Per constellation

Reading the columns:

- **crit. path** — hour-weighted longest chain base → crown: the calendar
  floor even for someone working every branch at once.
- **braid** — total hours ÷ critical path. 1.0 would be a pure chain; higher
  means more of the tree runs beside itself in parallel.
- **frontier** — simulate igniting one star at a time (foundations first);
  mean/min stars simultaneously open, and the share of steps offering a
  real choice (≥2 open stars).

| skill | nodes | hours | crit. path | braid | frontier mean/min | choice |
|---|---|---|---|---|---|---|
''');
  for (final r in reports) {
    buf.writeln('| ${r.skill.id} | ${r.skill.tree.length} '
        '| ${r.skill.totalHours} | ${r.criticalPathHours} '
        '| ${fmt(r.braid)}× | ${fmt(r.meanFrontier)} / ${r.minFrontier} '
        '| ${pct(r.choiceShare)} |');
  }

  buf.write('''

## The braid, branch by branch

Branches are first-class data (`SkillNode.branch`): every constellation is
Foundations → 3–5 working lanes → a summit lane that carries the crown.

| skill | branches (nodes · hours) |
|---|---|
''');
  for (final r in reports) {
    final parts = r.skill.branches.map((b) {
      final ns = r.skill.tree.where((n) => n.branch == b);
      final h = ns.fold(0, (s, n) => s + n.hours);
      return '$b ${ns.length}·${h}h';
    }).join(' / ');
    buf.writeln('| ${r.skill.id} | $parts |');
  }

  buf.write('''

## Pacing: what the hours mean in calendar time

For one person the braid buys **choice, not speed** — you still live every
hour. Parallel branches mean a plateau in one lane never idles you; the
braid factor above is how much simultaneous progress the structure offers,
not a discount on the work. At sustained deliberate-practice rates the
whole sky takes:

| pace | 10 h/wk | 20 h/wk | 28 h/wk | 40 h/wk |
|---|---|---|---|---|
| full sky | ${[10, 20, 28, 40].map((w) => '${fmt(totalHours / (w * 52), 1)} yrs').join(' | ')} |

Single-constellation crowns at a focused 10 h/week:

| skill | hours | years solo | skill | hours | years solo |
|---|---|---|---|---|---|
''');
  for (var i = 0; i < reports.length; i += 2) {
    final a = reports[i];
    final b = i + 1 < reports.length ? reports[i + 1] : null;
    buf.writeln('| ${a.skill.id} | ${a.skill.totalHours} '
        '| ${fmt(a.skill.totalHours / 520, 1)} '
        '| ${b == null ? ' |  | ' : '${b.skill.id} | ${b.skill.totalHours} | ${fmt(b.skill.totalHours / 520, 1)}'} |');
  }

  buf.write('''

## Critical paths (the spine of each constellation)

The one chain in each tree you cannot parallelise away:

''');
  for (final r in reports) {
    buf.writeln('- **${r.skill.id}** (${r.criticalPathHours} h): '
        '${r.criticalPath.join(' → ')}');
  }

  buf.write('''

## The heaviest stars

| star | hours | what it is |
|---|---|---|
''');
  for (final e in heaviest.take(12)) {
    buf.writeln('| ${e.skill.id}.${e.node.id} | ${e.node.hours} '
        '| ${e.node.label} |');
  }

  buf.write('''

## Methodology: where the hours come from

Estimates are planning figures for a motivated self-studier, anchored to
published research rather than invented:

- **Languages** — FSI classroom-hour categories (Turkish Cat IV ≈ 1,100 h,
  Japanese Cat V ≈ 2,200 h classroom / 3,000–4,500 h self-study surveys for
  JLPT N1 without kanji background, Khmer Cat III ≈ 900 h plus a
  resource-scarcity overhead), CEFR level deltas for the per-level nodes.
- **Finance** — CFA Institute's ≈300 h/level guidance for the three mock
  gauntlets.
- **Music** — ABRSM grade norms (Grade 8 piano ≈ 2,000+ deliberate hours
  cumulative); note ABRSM Performance Grades 6–8 legally require Grade 5
  Theory first (encoded in the piano tree's proof text).
- **Mathematics** — Putnam medians run 0–2 points/120, which is why the
  problem-craft bar is ≥20 self-graded, not a casual target.
- **Textbook nodes** — sized by problem-set volume (a Jackson or Peskin
  pass is a 350–400 h object; a first-course text 150–300 h).

Hours measure *deliberate* work toward the proof standard, not elapsed
calendar time or ambient exposure.
''');

  stdout.write(buf.toString());
  if (args.contains('--write')) {
    final f = File('docs/curriculum/ANALYSIS.md');
    f.writeAsStringSync(buf.toString());
    stderr.writeln('\nwrote ${f.path}');
  }
  stderr.writeln('\nALL INVARIANTS PASS — $totalNodeCount nodes, '
      '$totalHours hours, $totalXp XP');
}
