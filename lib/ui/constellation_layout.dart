// ui/constellation_layout.dart — turns a skill tree into star positions that
// read like a real constellation: tier 1 at the base, the mastery star at the
// crown, organic jitter instead of rigid rows, children drifting toward their
// prerequisites. Fully deterministic (seeded by skill+node id) so every
// launch shows the same sky.
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

const double kTierGap = 104;
const double kEdgeMargin = 56;
const double kTopPad = 96;
const double kBottomPad = 110;
const double kMinStarGap = 62;

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

ConstellationLayout layoutConstellation(Skill skill, {double? width}) {
  final maxTier = skill.maxTier;
  final height = kTopPad + (maxTier - 1) * kTierGap + kBottomPad;

  final byTier = <int, List<SkillNode>>{};
  for (final n in skill.tree) {
    (byTier[n.tier] ??= []).add(n);
  }

  // The canvas grows with the widest tier so dense constellations keep
  // tappable star gaps — the screen pans (InteractiveViewer, unconstrained).
  // `w` is the promoted non-null width (closures below capture it).
  final widest =
      byTier.values.fold(1, (m, l) => l.length > m ? l.length : m);
  final w = width ??
      math.max(390.0, 2 * kEdgeMargin + (widest - 1) * kMinStarGap + 48);

  final pos = <String, Offset>{};
  final magnitude = <String, double>{};
  final usable = w - 2 * kEdgeMargin;

  for (var t = 1; t <= maxTier; t++) {
    final nodes = byTier[t] ?? const <SkillNode>[];
    if (nodes.isEmpty) continue;
    final baseY = height - kBottomPad - (t - 1) * kTierGap;

    // Children gravitate toward the mean x of their prerequisites so chains
    // flow visually; roots spread across the base.
    double desired(SkillNode n, int i) {
      final parents = [
        for (final r in n.requires)
          if (pos.containsKey(r)) pos[r]!.dx
      ];
      if (parents.isEmpty) {
        return nodes.length == 1
            ? w / 2
            : kEdgeMargin + usable * (i / (nodes.length - 1));
      }
      return parents.reduce((a, b) => a + b) / parents.length;
    }

    final order = List.generate(nodes.length, (i) => i)
      ..sort((a, b) =>
          desired(nodes[a], a).compareTo(desired(nodes[b], b)));

    // Blend prerequisite pull with an even spread, then add seeded jitter —
    // enough irregularity to feel like a constellation, not a flowchart.
    final xs = <double>[];
    for (var rank = 0; rank < order.length; rank++) {
      final n = nodes[order[rank]];
      final key = progressKey(skill.id, n.id);
      final slotX = order.length == 1
          ? w / 2
          : kEdgeMargin + usable * (rank / (order.length - 1));
      final pull = desired(n, order[rank]);
      var x = slotX * 0.45 + pull * 0.55 + _randIn(key, 1, -22, 22);
      x = x.clamp(kEdgeMargin, w - kEdgeMargin);
      xs.add(x);
    }

    // Resolve same-tier collisions with a left-to-right sweep, then re-center.
    for (var i = 1; i < xs.length; i++) {
      if (xs[i] - xs[i - 1] < kMinStarGap) xs[i] = xs[i - 1] + kMinStarGap;
    }
    final overflow = xs.isEmpty ? 0.0 : xs.last - (w - kEdgeMargin);
    if (overflow > 0) {
      for (var i = 0; i < xs.length; i++) {
        xs[i] = math.max(kEdgeMargin, xs[i] - overflow);
      }
      for (var i = xs.length - 2; i >= 0; i--) {
        if (xs[i + 1] - xs[i] < kMinStarGap) {
          xs[i] = math.max(kEdgeMargin, xs[i + 1] - kMinStarGap);
        }
      }
    }

    for (var rank = 0; rank < order.length; rank++) {
      final n = nodes[order[rank]];
      final key = progressKey(skill.id, n.id);
      final y = baseY + _randIn(key, 2, -26, 26);
      pos[n.id] = Offset(xs[rank], y);
      // The crown (final tier) burns brightest; everything else varies like a
      // real star field.
      magnitude[n.id] =
          t == maxTier ? 1.5 : _randIn(key, 3, 0.85, 1.3);
    }
  }

  return ConstellationLayout(Size(w, height), pos, magnitude);
}
