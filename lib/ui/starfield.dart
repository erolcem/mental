// ui/starfield.dart — the living night sky behind every screen.
//
// Built like an astrophoto, not a texture:
//  • ~1,600 stars on a power-law magnitude curve (multitudes of faint points,
//    a handful of brilliant ones) with real stellar colour classes.
//  • A textured Milky Way: a dense diagonal star-river with soft galactic
//    glow, dark dust lanes, and a warm core.
//  • Nebular haze in the given accent colours; faint airglow at the horizon.
//  • The whole celestial layer ROTATES imperceptibly around a pole (one full
//    turn every 2 hours) — stand still and the sky turns.
//  • Atmosphere on top: twinkling stars, meteors every ~9 s, the occasional
//    drifting satellite.
//
// Performance contract: everything static is rasterised ONCE into a cached
// ui.Picture (drawn per-frame under a rotation transform, which is cheap);
// per-frame work is ~60 twinkle stars + one streak + one dot.
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class Starfield extends StatefulWidget {
  /// Nebula tint colours (usually the four stat colours, or one skill colour).
  final List<Color> nebulae;
  final int starCount;

  /// 0–1 dims everything (used behind sheets).
  final double dim;
  const Starfield(
      {super.key, this.nebulae = const [], this.starCount = 2200, this.dim = 0});

  @override
  State<Starfield> createState() => _StarfieldState();
}

class _StarfieldState extends State<Starfield>
    with SingleTickerProviderStateMixin {
  late final AnimationController _t;

  @override
  void initState() {
    super.initState();
    // Master clock = one full celestial rotation. Everything (twinkle phase,
    // meteor cycles, satellite passes) derives from this one time base, and
    // the rotation is continuous across the wrap (θ = value·2π).
    _t = AnimationController(vsync: this, duration: const Duration(hours: 2))
      ..repeat();
  }

  @override
  void dispose() {
    _t.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _t,
        builder: (_, __) => CustomPaint(
          painter: _StarfieldPainter(
            phase: _t.value, // 0–1 of a full rotation
            nebulae: widget.nebulae,
            starCount: widget.starCount,
            dim: widget.dim,
          ),
          size: Size.infinite,
          isComplex: true,
        ),
      ),
    );
  }
}

class _Star {
  final Offset p; // position in FIELD coordinates (the oversized square)
  final double r;
  final double a;
  final Color color;
  final double phase;
  final double speed;
  const _Star(this.p, this.r, this.a, this.color, this.phase, this.speed);
}

/// Real-ish stellar colour classes, weighted toward white/warm like a dark
/// rural sky.
Color _stellarColor(math.Random rnd) {
  final x = rnd.nextDouble();
  if (x < 0.10) return const Color(0xFFAECBFF); // blue-white (O/B)
  if (x < 0.55) return Colors.white; //             (A/F)
  if (x < 0.80) return const Color(0xFFFFEFD2); // warm white (G)
  if (x < 0.95) return const Color(0xFFFFD9A3); // amber (K)
  return const Color(0xFFFFB08A); //               orange-red (M)
}

class _StarfieldPainter extends CustomPainter {
  final double phase;
  final List<Color> nebulae;
  final int starCount;
  final double dim;

  _StarfieldPainter(
      {required this.phase,
      required this.nebulae,
      required this.starCount,
      required this.dim});

  double get _time => phase * 7200; // seconds within the rotation

  // -------- static sky cache (shared across instances) --------
  static ui.Picture? _sky;
  static Size? _skySize;
  static int _skyConfig = 0;
  static final List<_Star> _twinklers = [];

  /// The celestial pole the sky turns around — upper area of the screen.
  Offset _pole(Size s) => Offset(s.width * 0.70, s.height * 0.16);

  /// Field square big enough that rotation never reveals an edge.
  double _fieldRadius(Size s) {
    final p = _pole(s);
    final corners = [
      Offset.zero,
      Offset(s.width, 0),
      Offset(0, s.height),
      Offset(s.width, s.height)
    ];
    var r = 0.0;
    for (final c in corners) {
      r = math.max(r, (c - p).distance);
    }
    return r + 24;
  }

  void _buildSky(Size size) {
    final cfg = Object.hash(
        starCount, Object.hashAll(nebulae), size.width.round(), size.height.round());
    if (_sky != null && _skySize == size && _skyConfig == cfg) return;

    final rnd = math.Random(7);
    final pole = _pole(size);
    final fieldR = _fieldRadius(size);
    final rec = ui.PictureRecorder();
    final c = Canvas(rec);
    _twinklers.clear();

    Offset randInField() {
      // Uniform over the field disc (rejection-free: sqrt for area uniformity).
      final a = rnd.nextDouble() * 2 * math.pi;
      final d = math.sqrt(rnd.nextDouble()) * fieldR;
      return pole + Offset(math.cos(a) * d, math.sin(a) * d);
    }

    // ---- The Milky Way: a river of dense faint stars through the field ----
    // Band defined by a line through the pole area at a fixed angle.
    const bandAngle = 0.62; // rad, diagonal
    final bandDir = Offset(math.cos(bandAngle), math.sin(bandAngle));
    final bandNormal = Offset(-bandDir.dy, bandDir.dx);
    final bandCenter = pole + bandDir * (fieldR * -0.15);
    final bandHalfWidth = size.shortestSide * 0.30;

    double gauss() {
      // Box-Muller
      final u1 = rnd.nextDouble().clamp(1e-9, 1.0), u2 = rnd.nextDouble();
      return math.sqrt(-2 * math.log(u1)) * math.cos(2 * math.pi * u2);
    }

    // Galactic glow: layered soft blobs along the band.
    for (var i = -6; i <= 6; i++) {
      final along = bandCenter + bandDir * (i * fieldR / 5.5);
      final off = bandNormal * (gauss() * bandHalfWidth * 0.25);
      final center = along + off;
      final radius = size.shortestSide * (0.22 + rnd.nextDouble() * 0.16);
      c.drawCircle(
        center,
        radius,
        Paint()
          ..shader = ui.Gradient.radial(center, radius, [
            Colors.white.withValues(alpha: 0.035 + rnd.nextDouble() * 0.02),
            Colors.white.withValues(alpha: 0.0),
          ])
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30),
      );
    }
    // Warm galactic core toward one end of the band.
    final core = bandCenter + bandDir * (fieldR * 0.55);
    c.drawCircle(
      core,
      size.shortestSide * 0.34,
      Paint()
        ..shader = ui.Gradient.radial(core, size.shortestSide * 0.34, [
          const Color(0xFFFFE0B8).withValues(alpha: 0.05),
          const Color(0xFFFFE0B8).withValues(alpha: 0.0),
        ])
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 36),
    );
    // Dust lanes: dark blurred streaks hugging the band core.
    for (var i = 0; i < 7; i++) {
      final along = bandCenter + bandDir * ((rnd.nextDouble() * 2 - 1) * fieldR * 0.8);
      final off = bandNormal * (gauss() * bandHalfWidth * 0.16);
      final centerD = along + off;
      final len = size.shortestSide * (0.12 + rnd.nextDouble() * 0.22);
      final rect = Rect.fromCenter(
          center: centerD, width: len, height: len * (0.22 + rnd.nextDouble() * 0.2));
      c.save();
      c.translate(centerD.dx, centerD.dy);
      c.rotate(bandAngle + (rnd.nextDouble() - 0.5) * 0.5);
      c.translate(-centerD.dx, -centerD.dy);
      c.drawOval(
          rect,
          Paint()
            ..color = const Color(0xFF04050D).withValues(alpha: 0.16)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 22));
      c.restore();
    }
    // The river's own stars — dense, tiny, concentrated on the band.
    final riverCount = (starCount * 0.9).round();
    for (var i = 0; i < riverCount; i++) {
      final along = bandCenter + bandDir * ((rnd.nextDouble() * 2 - 1) * fieldR);
      final p = along + bandNormal * (gauss() * bandHalfWidth * 0.5);
      final r = 0.25 + rnd.nextDouble() * 0.55;
      c.drawCircle(
          p,
          r,
          Paint()
            ..color = _stellarColor(rnd)
                .withValues(alpha: 0.05 + rnd.nextDouble() * 0.20));
    }

    // ---- Sub-pixel dust: thousands of barely-there points give the sky its
    // velvet depth without ever competing with foreground content ----
    for (var i = 0; i < (starCount * 0.8).round(); i++) {
      final p = randInField();
      c.drawCircle(
          p,
          0.18 + rnd.nextDouble() * 0.25,
          Paint()
            ..color = Colors.white
                .withValues(alpha: 0.03 + rnd.nextDouble() * 0.09));
    }

    // ---- General field stars: power-law magnitudes.
    // Background stars stay SMALL — brightness reads through subtle bloom,
    // never size. Diffraction glints are reserved for meaningful objects
    // (guide stars, ignited nodes), so the background can never upstage them
    // or sit over text.
    for (var i = 0; i < starCount; i++) {
      final p = randInField();
      final m = math.pow(rnd.nextDouble(), 3.1).toDouble(); // most stars faint
      final r = 0.28 + m * 1.15; // max ~1.4 px
      final alpha = 0.08 + m * 0.60;
      // Faint stars read white to the eye; colour only shows on brighter ones.
      final color = m > 0.45 ? _stellarColor(rnd) : Colors.white;
      final star =
          _Star(p, r, alpha, color, rnd.nextDouble() * 2 * math.pi, 0.4 + rnd.nextDouble());
      if (r > 0.9 && _twinklers.length < 60 && rnd.nextDouble() < 0.22) {
        _twinklers.add(star); // drawn live, not baked
        continue;
      }
      c.drawCircle(p, r, Paint()..color = color.withValues(alpha: alpha));
      if (r > 1.15) {
        c.drawCircle(
            p,
            r * 2.4,
            Paint()
              ..color = color.withValues(alpha: alpha * 0.13)
              ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.5));
      }
    }

    // ---- Nebular haze in accent colours, drifted about the field ----
    for (var i = 0; i < nebulae.length; i++) {
      final base = randInField();
      for (var layer = 0; layer < 3; layer++) {
        final centerN = base +
            Offset((rnd.nextDouble() - 0.5) * 90, (rnd.nextDouble() - 0.5) * 90);
        final radius = size.shortestSide * (0.30 + rnd.nextDouble() * 0.22);
        c.drawCircle(
          centerN,
          radius,
          Paint()
            ..shader = ui.Gradient.radial(centerN, radius, [
              nebulae[i].withValues(alpha: 0.030 + rnd.nextDouble() * 0.016),
              nebulae[i].withValues(alpha: 0.0),
            ])
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 34),
        );
      }
    }

    _sky = rec.endRecording();
    _skySize = size;
    _skyConfig = cfg;
  }

  @override
  void paint(Canvas canvas, Size size) {
    _buildSky(size);
    final pole = _pole(size);
    final theta = phase * 2 * math.pi;

    // Deep-space gradient — near-black with the faintest indigo cast.
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = ui.Gradient.radial(
          Offset(size.width * 0.3, size.height * 0.12),
          size.longestSide * 1.25,
          [const Color(0xFF0B1030), const Color(0xFF060814), const Color(0xFF030409)],
          [0.0, 0.45, 1.0],
        ),
    );

    // The turning celestial layer: baked sky + live twinklers.
    canvas.save();
    canvas.translate(pole.dx, pole.dy);
    canvas.rotate(theta);
    canvas.translate(-pole.dx, -pole.dy);
    canvas.drawPicture(_sky!);
    for (final s in _twinklers) {
      final tw = 0.5 + 0.5 * math.sin(_time * s.speed * 2 * math.pi / 6 + s.phase);
      final a = (s.a * (0.30 + 0.9 * tw)).clamp(0.0, 1.0);
      canvas.drawCircle(s.p, s.r * (0.85 + 0.3 * tw),
          Paint()..color = s.color.withValues(alpha: a));
    }
    canvas.restore();

    _paintMeteor(canvas, size);
    _paintSatellite(canvas, size);

    // Airglow: the faint warm breath of atmosphere at the horizon.
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.86, size.width, size.height * 0.14),
      Paint()
        ..shader = ui.Gradient.linear(
          Offset(0, size.height * 0.86),
          Offset(0, size.height),
          [
            const Color(0xFF2E4038).withValues(alpha: 0.0),
            const Color(0xFF2E4038).withValues(alpha: 0.05),
          ],
        ),
    );

    if (dim > 0) {
      canvas.drawRect(Offset.zero & size,
          Paint()..color = Colors.black.withValues(alpha: dim * 0.6));
    }
  }

  /// A meteor roughly every 9 s, each on its own seeded path.
  void _paintMeteor(Canvas canvas, Size size) {
    final cycle = (_time / 9).floor();
    final tIn = (_time % 9) / 0.8;
    if (tIn >= 1.0) return;
    final rnd = math.Random(cycle * 977);
    if (rnd.nextDouble() < 0.25) return; // some cycles stay quiet
    final start = Offset(size.width * (0.05 + rnd.nextDouble() * 0.8),
        size.height * (0.04 + rnd.nextDouble() * 0.45));
    final ang = 0.5 + rnd.nextDouble() * 0.5;
    final dir = Offset(math.cos(ang), math.sin(ang));
    final len = 70.0 + rnd.nextDouble() * 70;
    final head = start + dir * (tIn * 300);
    final fade = math.sin(math.pi * tIn).clamp(0.0, 1.0) * 0.9;
    canvas.drawLine(
      head - dir * len,
      head,
      Paint()
        ..shader = ui.Gradient.linear(head - dir * len, head, [
          Colors.white.withValues(alpha: 0),
          Colors.white.withValues(alpha: fade),
        ])
        ..strokeWidth = 1.3
        ..strokeCap = StrokeCap.round,
    );
    // Hot head.
    canvas.drawCircle(head, 1.3,
        Paint()..color = Colors.white.withValues(alpha: fade));
  }

  /// A satellite drifts across every ~50 s — slow, steady, mundane, real.
  void _paintSatellite(Canvas canvas, Size size) {
    final cycle = (_time / 50).floor();
    final tIn = (_time % 50) / 26; // ~26 s crossing
    if (tIn >= 1.0) return;
    final rnd = math.Random(cycle * 1409);
    if (rnd.nextDouble() < 0.5) return; // half the passes skip
    final y0 = size.height * (0.08 + rnd.nextDouble() * 0.6);
    final y1 = y0 + (rnd.nextDouble() - 0.5) * size.height * 0.3;
    final leftToRight = rnd.nextBool();
    final x = size.width * (leftToRight ? tIn : 1 - tIn);
    final y = ui.lerpDouble(y0, y1, tIn)!;
    final blink = 0.35 + 0.25 * math.sin(_time * 2 * math.pi / 2.3);
    canvas.drawCircle(Offset(x, y), 0.9,
        Paint()..color = Colors.white.withValues(alpha: blink));
  }

  @override
  bool shouldRepaint(covariant _StarfieldPainter old) =>
      old.phase != phase || old.dim != dim || old.starCount != starCount;
}
