// ui/widgets/asterism.dart — each skill drawn as its own miniature
// constellation: a unique, deterministic 5–6 star figure. Mastery lights it
// star by star; at 100% the figure burns complete with its lines aglow.
import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Stable seeded random in [0,1) — same figure on every device, forever.
double _rand(String key, int salt) {
  var h = 0x811c9dc5;
  for (final c in '$key#$salt'.codeUnits) {
    h ^= c;
    h = (h * 0x01000193) & 0xFFFFFFFF;
  }
  h ^= h << 13 & 0xFFFFFFFF;
  h ^= h >> 17;
  h ^= h << 5 & 0xFFFFFFFF;
  return (h & 0xFFFFFF) / 0x1000000;
}

double _randIn(String key, int salt, double lo, double hi) =>
    lo + _rand(key, salt) * (hi - lo);

class _Figure {
  final List<Offset> stars; // normalised into the box
  final List<(int, int)> links;
  const _Figure(this.stars, this.links);
}

final Map<String, _Figure> _figureCache = {};

/// Build the skill's asterism: a seeded organic walk of 5–6 stars, sometimes
/// with a spur — like the small constellations of a real atlas (Lyra,
/// Cassiopeia, Delphinus...).
_Figure _figure(String skillId, Size box) {
  return _figureCache.putIfAbsent(skillId, () {
    final n = 5 + (_rand(skillId, 0) > 0.55 ? 1 : 0);
    final pts = <Offset>[Offset.zero];
    var heading = _randIn(skillId, 1, 0, 2 * math.pi);
    for (var i = 1; i < n; i++) {
      heading += _randIn(skillId, i * 3, 0.55, 1.75) *
          (_rand(skillId, i * 3 + 1) > 0.5 ? 1 : -1);
      final len = _randIn(skillId, i * 3 + 2, 0.8, 1.35);
      pts.add(pts.last +
          Offset(math.cos(heading), math.sin(heading)) * len);
    }
    final links = <(int, int)>[for (var i = 0; i < n - 1; i++) (i, i + 1)];
    // ~40% of figures grow a spur off an interior star (fork shapes).
    if (_rand(skillId, 90) > 0.6 && n >= 5) {
      final from = 1 + (_rand(skillId, 91) * (n - 3)).floor();
      final a = _randIn(skillId, 92, 0, 2 * math.pi);
      pts.add(pts[from] + Offset(math.cos(a), math.sin(a)) * 1.0);
      links.add((from, pts.length - 1));
    }

    // Normalise into the box with padding.
    var minX = double.infinity, maxX = -double.infinity;
    var minY = double.infinity, maxY = -double.infinity;
    for (final p in pts) {
      minX = math.min(minX, p.dx);
      maxX = math.max(maxX, p.dx);
      minY = math.min(minY, p.dy);
      maxY = math.max(maxY, p.dy);
    }
    final w = math.max(maxX - minX, 0.001), h = math.max(maxY - minY, 0.001);
    final scale = math.min((box.width - 10) / w, (box.height - 10) / h);
    final offX = (box.width - w * scale) / 2, offY = (box.height - h * scale) / 2;
    return _Figure(
      [
        for (final p in pts)
          Offset((p.dx - minX) * scale + offX, (p.dy - minY) * scale + offY)
      ],
      links,
    );
  });
}

class Asterism extends StatelessWidget {
  final String skillId;
  final Color color;
  final double mastery; // 0–1 → fraction of the figure that is lit
  final Size size;
  const Asterism(
      {super.key,
      required this.skillId,
      required this.color,
      required this.mastery,
      this.size = const Size(60, 44)});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: size,
      painter: _AsterismPainter(skillId, color, mastery),
    );
  }
}

class _AsterismPainter extends CustomPainter {
  final String skillId;
  final Color color;
  final double mastery;
  _AsterismPainter(this.skillId, this.color, this.mastery);

  @override
  void paint(Canvas canvas, Size size) {
    final fig = _figure(skillId, size);
    final n = fig.stars.length;
    // Any progress at all lights the first star — a begun skill must glow.
    final lit = mastery <= 0
        ? 0
        : math.max(1, (mastery * n).round()).clamp(0, n);

    // Figure lines: bright between lit stars, ghostly otherwise.
    for (final (a, b) in fig.links) {
      final bothLit = a < lit && b < lit;
      canvas.drawLine(
        fig.stars[a],
        fig.stars[b],
        Paint()
          ..color = bothLit
              ? color.withValues(alpha: 0.55)
              : Colors.white.withValues(alpha: 0.10)
          ..strokeWidth = bothLit ? 0.9 : 0.7,
      );
    }

    for (var i = 0; i < n; i++) {
      final p = fig.stars[i];
      final mag = _randIn(skillId, 200 + i, 0.8, 1.25);
      if (i < lit) {
        // Halo + hot core; the figure's first star gets a glint.
        canvas.drawCircle(
          p,
          6.5 * mag,
          Paint()
            ..shader = RadialGradient(colors: [
              color.withValues(alpha: 0.40),
              color.withValues(alpha: 0.0)
            ]).createShader(Rect.fromCircle(center: p, radius: 6.5 * mag)),
        );
        canvas.drawCircle(p, 1.7 * mag, Paint()..color = Colors.white);
        if (i == 0) {
          final glint = Paint()
            ..color = Colors.white.withValues(alpha: 0.65)
            ..strokeWidth = 0.7;
          canvas.drawLine(p - Offset(5 * mag, 0), p + Offset(5 * mag, 0), glint);
          canvas.drawLine(p - Offset(0, 5 * mag), p + Offset(0, 5 * mag), glint);
        }
      } else {
        canvas.drawCircle(p, 1.1 * mag,
            Paint()..color = Colors.white.withValues(alpha: 0.28));
      }
    }
  }

  @override
  bool shouldRepaint(covariant _AsterismPainter old) =>
      old.mastery != mastery || old.skillId != skillId || old.color != color;
}
