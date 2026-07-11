// ui/constellation_layout.dart — turns a skill tree into star positions that
// read like a real constellation: tier 1 at the base, the mastery star at the
// crown, organic jitter instead of rigid rows, children drifting toward their
// prerequisites. Fully deterministic (seeded by skill+node id) so every
// launch shows the same sky.
//
// PARALLEL PATHS rendering: every branch of the braid gets its own lane of
// sky. A node's resting x blends its branch lane with the mean of its
// prerequisites, so branches run beside each other as visible strands, drift
// together where they braid, and converge on the summit lane — which is
// always the CENTRE of the sky, with the working branches fanned around it.
// The canvas is as wide as the tree's densest tier demands; the screen pans.
import 'dart:math' as math;
import 'dart:ui';

import '../data/skill_data.dart';

class ConstellationLayout {
  final Size size;

  /// Node id → position on the constellation canvas.
  final Map<String, Offset> pos;

  /// Node id → star magnitude scale (~0.85–1.35; the crown star is largest).
  final Map<String, double> magnitude;

  const ConstellationLayout(this.size, this.pos, this.magnitude);
}

const double kTierGap = 108;
const double kEdgeMargin = 58;
const double kTopPad = 96;
const double kBottomPad = 110;
const double kMinStarGap = 74;

/// Narrowest canvas a constellation may occupy (phone-width-ish so small
/// trees don't stretch).
const double kMinCanvasWidth = 400;

/// Stable 32-bit FNV-1a — Dart's String.hashCode is not guaranteed stable
/// across platforms, and the sky must not rearrange between phone and CI.
int _fnv1a(String s) {
  var h = 0x811c9dc5;
  for (final c in s.codeUnits) {
    h ^= c;
    h = (h * 0x01000193) & 0xFFFFFFFF;
  }
  return h;
}

/// Deterministic uniform double in [0,1) for a (key, salt) pair.
double _rand(String key, int salt) {
  var x = _fnv1a('$key#$salt');
  // xorshift scramble — FNV alone correlates for near-identical keys.
  x ^= x << 13 & 0xFFFFFFFF;
  x ^= x >> 17;
  x ^= x << 5 & 0xFFFFFFFF;
  return (x & 0xFFFFFF) / 0x1000000;
}

double _randIn(String key, int salt, double lo, double hi) =>
    lo + _rand(key, salt) * (hi - lo);

/// Left→right lane order: the summit branch (the one carrying the crown)
/// holds the centre; the other branches alternate outward around it, keeping
/// catalog order roughly intact (first branches nearest the centre).
List<String> _laneOrder(Skill skill) {
  final branches = skill.branches;
  if (branches.isEmpty) return const [''];
  final crown = skill.tree.firstWhere((n) => n.tier == skill.maxTier);
  final summit = branches.contains(crown.branch) ? crown.branch : branches.last;
  final others = [
    for (final b in branches)
      if (b != summit) b
  ];
  final left = <String>[], right = <String>[];
  for (var i = 0; i < others.length; i++) {
    (i.isEven ? left : right).add(others[i]);
  }
  return [...left.reversed, summit, ...right];
}

ConstellationLayout layoutConstellation(Skill skill, {double? width}) {
  final maxTier = skill.maxTier;
  final height = kTopPad + (maxTier - 1) * kTierGap + kBottomPad;

  final byTier = <int, List<SkillNode>>{};
  var maxOccupancy = 1;
  for (final n in skill.tree) {
    final row = byTier[n.tier] ??= [];
    row.add(n);
    maxOccupancy = math.max(maxOccupancy, row.length);
  }

  // The canvas grows with the densest tier; the screen pans over it.
  final w = width ??
      math.max(kMinCanvasWidth,
          2 * kEdgeMargin + (maxOccupancy - 1) * (kMinStarGap + 14) + 20);

  final lanes = _laneOrder(skill);
  final usable = w - 2 * kEdgeMargin;
  double laneCenter(String branch) {
    final i = lanes.indexOf(branch);
    if (i < 0 || lanes.length == 1) return w / 2;
    return kEdgeMargin + usable * ((i + 0.5) / lanes.length);
  }

  final pos = <String, Offset>{};
  final magnitude = <String, double>{};

  for (var t = 1; t <= maxTier; t++) {
    final nodes = byTier[t] ?? const <SkillNode>[];
    if (nodes.isEmpty) continue;
    final baseY = height - kBottomPad - (t - 1) * kTierGap;

    // A node rests where its branch lane and its prerequisites agree:
    // lane keeps strands apart, parent-pull makes them flow and braid.
    double desired(SkillNode n, int i) {
      final parents = [
        for (final r in n.requires)
          if (pos.containsKey(r)) pos[r]!.dx
      ];
      final lane = laneCenter(n.branch);
      if (parents.isEmpty) {
        // Rootless base nodes spread across the sky like the tree's roots —
        // unless they have a working branch, in which case they seed it.
        if (t == 1 && nodes.length > 1) {
          return kEdgeMargin + usable * (i / (nodes.length - 1));
        }
        return lane;
      }
      final pull = parents.reduce((a, b) => a + b) / parents.length;
      return lane * 0.52 + pull * 0.48;
    }

    final order = List.generate(nodes.length, (i) => i)
      ..sort((a, b) => desired(nodes[a], a).compareTo(desired(nodes[b], b)));

    final xs = <double>[];
    for (var rank = 0; rank < order.length; rank++) {
      final n = nodes[order[rank]];
      final key = progressKey(skill.id, n.id);
      var x = desired(n, order[rank]) + _randIn(key, 1, -20, 20);
      x = x.clamp(kEdgeMargin, w - kEdgeMargin);
      xs.add(x);
    }

    // Resolve same-tier collisions. The row always fits — tier width is
    // capped at 7 by braidSkill and the canvas adapts — so three bounded
    // sweeps settle every case: push right to open gaps, pull back inside
    // the right margin (opening gaps leftward), then push anything the
    // pull-back drove past the left margin rightward again.
    for (var i = 1; i < xs.length; i++) {
      if (xs[i] - xs[i - 1] < kMinStarGap) xs[i] = xs[i - 1] + kMinStarGap;
    }
    if (xs.isNotEmpty && xs.last > w - kEdgeMargin) {
      xs[xs.length - 1] = w - kEdgeMargin;
      for (var i = xs.length - 2; i >= 0; i--) {
        xs[i] = math.min(xs[i], xs[i + 1] - kMinStarGap);
      }
    }
    if (xs.isNotEmpty && xs.first < kEdgeMargin) {
      xs[0] = kEdgeMargin;
      for (var i = 1; i < xs.length; i++) {
        xs[i] = math.max(xs[i], xs[i - 1] + kMinStarGap);
      }
    }

    for (var rank = 0; rank < order.length; rank++) {
      final n = nodes[order[rank]];
      final key = progressKey(skill.id, n.id);
      final y = baseY + _randIn(key, 2, -26, 26);
      pos[n.id] = Offset(xs[rank], y);
      // The crown (final tier) burns brightest; everything else varies like a
      // real star field.
      magnitude[n.id] = t == maxTier ? 1.5 : _randIn(key, 3, 0.85, 1.3);
    }
  }

  return ConstellationLayout(Size(w, height), pos, magnitude);
}
