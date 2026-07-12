// data/catalog/model.dart — the pure-Dart data model for the mastery catalog,
// split out so the per-stat catalog files and skill_data.dart can share it
// without an import cycle. No dart:ui here: the analysis tool
// (dart tool/analyze_catalog.dart) compiles this without a Flutter toolchain.

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
  /// planning figure, not a stopwatch.
  final int hours;

  /// The named parallel branch this star belongs to.
  final String branch;

  /// THE QUEST: what to actually do — materials, method, route. [proof] is
  /// the evidence demanded; [guide] is the walkthrough.
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

  /// The stars this one is a prerequisite of — the road its light opens.
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

List<String> _reqList(Object? req) => req == null
    ? const []
    : req is String
        ? [req]
        : List<String>.from(req as List);

/// Node spec WITHOUT a tier: `req` may be null (root), a single id, or a list
/// of ids. Argument order is quest-shaped: identity, its lane in the braid,
/// the effort, then the two texts that make a star a quest — guide (what to
/// do) and proof (how it's confirmed). Tier is DERIVED by [braidSkill], so a
/// prerequisite edge can never sit at or above its child by mistake.
SkillNode nx(String id, String label, Object? req, String branch, int hours,
        String guide, String proof) =>
    SkillNode(id, label, 0, _reqList(req), proof, hours, branch, guide);

/// Node-building shorthand WITH an explicit tier (kept for any hand-tiered
/// tree). Most catalog files use [nx] + [braidSkill] instead.
SkillNode sn(String id, String label, int tier, Object? req, String branch,
        int hours, String guide, String proof) =>
    SkillNode(id, label, tier, _reqList(req), proof, hours, branch, guide);

/// How many stars a single tier band may hold before the sky over-crowds.
const int kMaxTierWidth = 7;

/// Assemble a constellation, DERIVING each node's tier as the longest
/// prerequisite chain to it (tier = 1 for roots, else 1 + max(prereq tiers)),
/// then RELAXING: while any tier holds more than [kMaxTierWidth] stars, the
/// member with the fewest descendants slides one tier deeper (cascading its
/// children as needed), so the braid spreads instead of bunching. Finally the
/// crown — the deepest sink before relaxation — is kept strictly deepest.
/// Both passes are deterministic, and "tiers strictly increase along every
/// edge" holds by construction. Throws on a dependency cycle.
Skill braidSkill(
    String id, String label, String icon, String goal, List<SkillNode> raw) {
  final reqs = {for (final n in raw) n.id: n.requires};
  final tierOf = <String, int>{};
  final visiting = <String>{};
  int tier(String nid) {
    final cached = tierOf[nid];
    if (cached != null) return cached;
    if (!visiting.add(nid)) {
      throw StateError('dependency cycle in $id at node $nid');
    }
    final rs = reqs[nid] ?? const <String>[];
    final t = rs.isEmpty ? 1 : 1 + rs.map(tier).reduce((a, b) => a > b ? a : b);
    visiting.remove(nid);
    tierOf[nid] = t;
    return t;
  }

  for (final n in raw) {
    tier(n.id);
  }

  // Children + descendant counts (for choosing who slides with least drag).
  final children = <String, List<String>>{for (final n in raw) n.id: []};
  for (final n in raw) {
    for (final r in n.requires) {
      children[r]!.add(n.id);
    }
  }
  final descCount = <String, int>{};
  int countDesc(String nid) => descCount.putIfAbsent(nid, () {
        final seen = <String>{};
        final queue = [...children[nid]!];
        while (queue.isNotEmpty) {
          final c = queue.removeLast();
          if (seen.add(c)) queue.addAll(children[c]!);
        }
        return seen.length;
      });

  // The crown is the deepest sink of the authored DAG (unique by law 4;
  // verified by tests/tooling). It must stay the summit through relaxation.
  var crownId = raw.first.id;
  for (final n in raw) {
    if (tierOf[n.id]! > tierOf[crownId]! ||
        (tierOf[n.id] == tierOf[crownId] && n.id.compareTo(crownId) > 0)) {
      crownId = n.id;
    }
  }

  void push(String nid) {
    tierOf[nid] = tierOf[nid]! + 1;
    for (final c in children[nid]!) {
      if (tierOf[c]! <= tierOf[nid]!) push(c);
    }
  }

  for (var guard = 0; guard < 4096; guard++) {
    final byTier = <int, List<String>>{};
    for (final n in raw) {
      (byTier[tierOf[n.id]!] ??= []).add(n.id);
    }
    final overfull = byTier.entries
        .where((e) => e.value.length > kMaxTierWidth)
        .toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    if (overfull.isEmpty) break;
    final members = overfull.first.value
      ..sort((a, b) {
        final d = countDesc(a) - countDesc(b);
        return d != 0 ? d : a.compareTo(b);
      });
    // Slide the least-entangled member (never the crown) one tier deeper.
    push(members.firstWhere((m) => m != crownId));
  }

  // Keep the crown strictly deepest.
  var deepest = 0;
  for (final n in raw) {
    if (n.id != crownId && tierOf[n.id]! > deepest) deepest = tierOf[n.id]!;
  }
  if (tierOf[crownId]! <= deepest) tierOf[crownId] = deepest + 1;

  final nodes = [
    for (final n in raw)
      SkillNode(n.id, n.label, tierOf[n.id]!, n.requires, n.proof, n.hours,
          n.branch, n.guide)
  ];
  return Skill(id, label, icon, goal, nodes);
}
