// data/skill_data.dart — the full mastery catalog: 4 stats → 21 skills → 431
// nodes. PARALLEL PATHS overhaul 2026-07-06 (docs/curriculum/PARALLEL.md).
// Five laws govern every constellation:
//
//   1. PARALLEL — each tree is 3–5 named branches that can be worked at the
//      same time; a stuck branch never blocks the whole sky.
//   2. SELF-ACHIEVABLE — books, free courses, released exams, video-assessed
//      certificates, public arenas, logged practice. Exam mimicry wherever
//      the official gate is closed; no institution's permission anywhere.
//   3. PROOF-BEARING — every node carries a `proof`, the completion standard
//      the Examiner demands evidence against and the Reviewer quizzes from.
//   4. CONVERGENT — branches braid at synthesis nodes and every path ends at
//      one crown: no orphan stars, everything you light matters at the top.
//   5. SAFE — nothing demands unsupervised danger: dead-circuit electrics,
//      dojo-supervised sparring, vocal health before power, jack-stand
//      discipline, food safety first.
//
// Node ids are unique per tree but NOT globally (maths and mechanics both use
// m1..); all persistence therefore keys progress by `skillId.nodeId` — see
// [progressKey]. Ids surviving from earlier catalogs keep their progress.
//
// This file is deliberately pure Dart (no dart:ui) so the analysis tool
// (`dart tool/analyze_catalog.dart`) can compute over the catalog without a
// Flutter toolchain. Stat colors live here as ARGB ints; the UI lifts them
// to Color via the StatColor extension in ui/theme.dart.

part 'catalog_int.dart';
part 'catalog_wis.dart';
part 'catalog_cha.dart';
part 'catalog_dex.dart';

class SkillNode {
  final String id;
  final String label;

  /// 1-based depth band. Tier 1 sits at the constellation's base; the final
  /// tier is the mastery star at its crown.
  final int tier;

  /// Ids (within the same tree) that must be complete before this unlocks.
  final List<String> requires;

  /// The completion standard: what counts as evidence this node is done.
  final String proof;

  /// Estimated deliberate-practice hours to meet [proof] — a researched
  /// planning figure (FSI/JLPT hour studies, CFA guidance, ABRSM norms),
  /// not a stopwatch. Powers the effort analytics in tool/analyze_catalog.
  final int hours;

  /// The named parallel branch this star belongs to (law 1: every tree is a
  /// braid of branches). 'Foundations' roots the tree; each tree's final
  /// branch carries it to the crown.
  final String branch;

  /// The exact work, spelled out: named materials (with a free alternative
  /// where one exists), the method, the cadence, and the artifact to keep.
  /// What [proof] is the standard FOR, this is the recipe OF.
  final String guide;
  const SkillNode(this.id, this.label, this.tier,
      [this.requires = const [],
      this.proof = '',
      this.hours = 0,
      this.branch = '',
      this.guide = '']);
}

class Skill {
  final String id;
  final String label;
  final String icon;

  /// The endgame this constellation represents — shown under the title.
  final String goal;
  final List<SkillNode> tree;
  const Skill(this.id, this.label, this.icon, this.goal, this.tree);

  int get maxTier => tree.fold(1, (m, n) => n.tier > m ? n.tier : m);
  SkillNode nodeById(String id) => tree.firstWhere((n) => n.id == id);

  /// The stars whose way [id] opens — this node's direct dependents.
  List<SkillNode> unlockedBy(String id) =>
      [for (final n in tree) if (n.requires.contains(id)) n];

  /// Estimated deliberate-practice hours base → crown.
  int get totalHours => tree.fold(0, (s, n) => s + n.hours);

  /// The named branches of this constellation, in catalog order.
  List<String> get branches {
    final seen = <String>[];
    for (final n in tree) {
      if (n.branch.isNotEmpty && !seen.contains(n.branch)) seen.add(n.branch);
    }
    return seen;
  }
}

class StatDomain {
  final String id; // INT | WIS | CHA | DEX
  final String label;

  /// ARGB color value (UI lifts this to a Color via ui/theme.dart).
  final int colorValue;
  final List<Skill> skills;
  const StatDomain(this.id, this.label, this.colorValue, this.skills);
}

/// Globally unique progress key for a node.
String progressKey(String skillId, String nodeId) => '$skillId.$nodeId';

SkillNode _n(String id, String label, int tier,
        [Object? req,
        String proof = '',
        int hours = 0,
        String branch = '',
        String guide = '']) =>
    SkillNode(
        id,
        label,
        tier,
        req == null
            ? const []
            : req is String
                ? [req]
                : List<String>.from(req as List),
        proof,
        hours,
        branch,
        guide);

final List<StatDomain> catalog = [intDomain, wisDomain, chaDomain, dexDomain];

StatDomain statById(String id) => catalog.firstWhere((s) => s.id == id);

Skill skillById(String id) =>
    catalog.expand((s) => s.skills).firstWhere((sk) => sk.id == id);

/// Total node count across every constellation (the "lifetime mastery" count).
final int totalNodeCount = catalog.fold(
    0, (sum, s) => sum + s.skills.fold(0, (x, sk) => x + sk.tree.length));
