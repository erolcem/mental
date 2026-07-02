// ui/starfield.dart — the living night sky behind every screen: hundreds of
// static stars (painted once into a cached Picture), a small twinkling set,
// drifting nebula haze in the stat colours, and the occasional shooting star.
//
// Performance contract: the static layer (stars + nebulae) is rasterised into
// a ui.Picture once per size; per-frame work is ~40 twinkle stars + 1 streak.
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class Starfield extends StatefulWidget {
  /// Nebula tint colours (usually the four stat colours, or one skill colour).
  final List<Color> nebulae;
  final int starCount;

  /// 0–1 slows/dims everything (used behind sheets).
  final double dim;
  const Starfield(
      {super.key, this.nebulae = const [], this.starCount = 260, this.dim = 0});

  @override
  State<Starfield> createState() => _StarfieldState();
}

class _StarfieldState extends State<Starfield>
    with SingleTickerProviderStateMixin {
  late final AnimationController _t;

  @override
  void initState() {
    super.initState();
    // One slow master clock; painters derive twinkle phases + streak windows.
    _t = AnimationController(vsync: this, duration: const Duration(seconds: 60))
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
            time: _t.value * 60,
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
  final Offset p; // fractional position
  final double r; // radius px
  final double baseOpacity;
  final Color color;
  final double phase; // twinkle phase offset
  final double speed; // twinkle speed multiplier
  const _Star(this.p, this.r, this.baseOpacity, this.color, this.phase, this.speed);
}

class _StarfieldPainter extends CustomPainter {
  final double time;
  final List<Color> nebulae;
  final int starCount;
  final double dim;

  _StarfieldPainter(
      {required this.time,
      required this.nebulae,
      required this.starCount,
      required this.dim});

  // Cache of the static sky keyed by size+config — survives across frames
  // because CustomPainter instances share it statically.
  static ui.Picture? _staticSky;
  static Size? _skySize;
  static int _skyConfig = 0;

  static final List<_Star> _stars = [];
  static final List<_Star> _twinklers = [];
  static int _builtCount = -1;

  void _buildStars(int count) {
    if (_builtCount == count) return;
    _builtCount = count;
    _stars.clear();
    _twinklers.clear();
    final rnd = math.Random(7); // fixed seed — same sky every launch
    for (var i = 0; i < count; i++) {
      // ~7% of stars carry a faint colour cast (blue/amber) like a real sky.
      final tinted = rnd.nextDouble() > 0.93;
      final color = !tinted
          ? Colors.white
          : (rnd.nextBool()
              ? const Color(0xFFBFD8FF)
              : const Color(0xFFFFE3B8));
      final star = _Star(
        Offset(rnd.nextDouble(), rnd.nextDouble()),
        rnd.nextDouble() * 1.1 + 0.35,
        rnd.nextDouble() * 0.55 + 0.12,
        color,
        rnd.nextDouble() * math.pi * 2,
        rnd.nextDouble() * 0.7 + 0.4,
      );
      // A minority twinkle every frame; the rest are painted once.
      (i % 7 == 0 ? _twinklers : _stars).add(star);
    }
  }

  void _paintStaticSky(Canvas canvas, Size size) {
    final cfg = Object.hash(starCount, Object.hashAll(nebulae));
    if (_staticSky != null && _skySize == size && _skyConfig == cfg) {
      canvas.drawPicture(_staticSky!);
      return;
    }
    final rec = ui.PictureRecorder();
    final c = Canvas(rec);

    // Nebula haze — big soft radial blobs in the given colours.
    final anchors = [
      const Alignment(-0.7, -0.6),
      const Alignment(0.75, -0.45),
      const Alignment(-0.65, 0.65),
      const Alignment(0.7, 0.7),
      const Alignment(0.0, 0.05),
    ];
    for (var i = 0; i < nebulae.length && i < anchors.length; i++) {
      final center = Offset(
        size.width * (0.5 + anchors[i].x / 2),
        size.height * (0.5 + anchors[i].y / 2),
      );
      final radius = size.shortestSide * 0.55;
      c.drawCircle(
        center,
        radius,
        Paint()
          ..shader = ui.Gradient.radial(center, radius, [
            nebulae[i].withValues(alpha: 0.055),
            nebulae[i].withValues(alpha: 0.0),
          ])
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 40),
      );
    }

    // The Milky Way — a faint diagonal band of light.
    final band = Paint()
      ..shader = ui.Gradient.linear(
        Offset(0, size.height * 0.2),
        Offset(size.width, size.height * 0.75),
        [
          Colors.white.withValues(alpha: 0.0),
          Colors.white.withValues(alpha: 0.03),
          Colors.white.withValues(alpha: 0.0),
        ],
        [0.25, 0.5, 0.75],
      )
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30);
    c.drawRect(Offset.zero & size, band);

    // Static stars.
    for (final s in _stars) {
      final p = Offset(s.p.dx * size.width, s.p.dy * size.height);
      final paint = Paint()..color = s.color.withValues(alpha: s.baseOpacity);
      c.drawCircle(p, s.r, paint);
      if (s.r > 1.15) {
        c.drawCircle(
            p,
            s.r * 2.6,
            Paint()
              ..color = s.color.withValues(alpha: s.baseOpacity * 0.25)
              ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3));
      }
    }

    _staticSky = rec.endRecording();
    _skySize = size;
    _skyConfig = cfg;
    canvas.drawPicture(_staticSky!);
  }

  @override
  void paint(Canvas canvas, Size size) {
    _buildStars(starCount);

    // Sky gradient base.
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = ui.Gradient.radial(
          Offset(size.width * 0.25, size.height * 0.15),
          size.longestSide * 1.2,
          [const Color(0xFF0F1855), const Color(0xFF080B20), const Color(0xFF050712)],
          [0.0, 0.42, 1.0],
        ),
    );

    _paintStaticSky(canvas, size);

    // Twinkling stars.
    for (final s in _twinklers) {
      final p = Offset(s.p.dx * size.width, s.p.dy * size.height);
      final tw =
          0.5 + 0.5 * math.sin(time * s.speed * 2 * math.pi / 6 + s.phase);
      final a = (s.baseOpacity * (0.35 + 0.85 * tw)).clamp(0.0, 1.0);
      canvas.drawCircle(p, s.r * (0.9 + 0.3 * tw),
          Paint()..color = s.color.withValues(alpha: a));
    }

    // A shooting star roughly every 9 seconds, each on its own seeded path.
    final cycle = (time / 9).floor();
    final tIn = (time % 9) / 0.9; // first 0.9s of each cycle
    if (tIn < 1.0) {
      final rnd = math.Random(cycle * 977);
      final start = Offset(size.width * (0.1 + rnd.nextDouble() * 0.7),
          size.height * (0.05 + rnd.nextDouble() * 0.4));
      final dir = Offset(1, 0.55 + rnd.nextDouble() * 0.3);
      final len = 90.0 + rnd.nextDouble() * 60;
      final head = start + dir * (tIn * 260);
      final fade = (1 - tIn) * 0.85;
      canvas.drawLine(
        head - dir * len,
        head,
        Paint()
          ..shader = ui.Gradient.linear(head - dir * len, head, [
            Colors.white.withValues(alpha: 0),
            Colors.white.withValues(alpha: fade),
          ])
          ..strokeWidth = 1.4
          ..strokeCap = StrokeCap.round,
      );
    }

    if (dim > 0) {
      canvas.drawRect(Offset.zero & size,
          Paint()..color = Colors.black.withValues(alpha: dim * 0.6));
    }
  }

  @override
  bool shouldRepaint(covariant _StarfieldPainter old) =>
      old.time != time || old.dim != dim || old.starCount != starCount;
}
