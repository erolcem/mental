// ui/starfield.dart — the living night sky behind every screen.
//
// Built like an astrophoto, not a texture drawn per frame:
//  • ~1,600 stars on a power-law magnitude curve (multitudes of faint points,
//    a handful of brilliant ones) with real stellar colour classes.
//  • Nine hero stars — the brilliant few that anchor any dark-sky photograph —
//    each with a coloured bloom and a faint four-point diffraction glint.
//  • A textured Milky Way: a dense diagonal star-river with soft galactic
//    glow, dark dust lanes, and a warm core.
//  • Nebular haze in the given accent colours; faint airglow at the horizon;
//    a photographic vignette so the frame's edges fall to black.
//  • Atmosphere on top: twinkling stars, meteors every ~9 s, the occasional
//    drifting satellite. All of it stands down under iOS Reduce Motion.
//
// PERFORMANCE CONTRACT — this is the crash-critical part. The static sky is
// rasterised ONCE into a real GPU texture (ui.Image via toImageSync), then
// every frame is a single image blit + ~60 twinkle dots + one streak + one
// dot. A ui.Picture, by contrast, is a display list the GPU must REPLAY every
// frame — and this sky's picture carried ~30 large gaussian-blurred,
// near-screen-sized circles (galactic glow, dust lanes, nebulae, hero
// blooms). Replaying that blur stack per frame — doubled during route
// transitions when two skies paint at once, and re-recorded per frame during
// keyboard resizes — is a Metal / memory-watchdog kill on iPhone (seen as the
// journal-page crash). Baking to pixels renders every blur exactly once.
//
// Resize policy: the texture is NEVER rebaked for small size changes (the
// keyboard shrinking the body, minor inset shifts) — the existing texture is
// cover-fit blitted, which is invisible on a starfield. Only a genuine growth
// (e.g. rotation to landscape) rebakes. Evicted textures are dropped, never
// dispose()d — a route mid-frame may still reference one; the engine
// finaliser reclaims them safely, and the cache is small and bounded.
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
      {super.key,
      this.nebulae = const [],
      this.starCount = 2200,
      this.dim = 0});

  @override
  State<Starfield> createState() => _StarfieldState();
}

class _StarfieldState extends State<Starfield>
    with SingleTickerProviderStateMixin {
  late final AnimationController _t;

  @override
  void initState() {
    super.initState();
    // Master clock for the live layers (twinkle phase, meteor cycles,
    // satellite passes). One long period so every cadence derives from a
    // single time base.
    _t = AnimationController(vsync: this, duration: const Duration(hours: 2))
      ..repeat();
  }

  @override
  void dispose() {
    _t.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Honour iOS "Reduce Motion": freeze the sky entirely (and stop burning
    // cycles) when the user has asked for calm.
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (reduceMotion && _t.isAnimating) {
      _t.stop();
    } else if (!reduceMotion && !_t.isAnimating) {
      _t.repeat();
    }
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    // Bake at device resolution, capped at 2× — beyond that the extra pixels
    // are invisible on a star scatter and the texture memory doubles.
    final dpr =
        (MediaQuery.maybeOf(context)?.devicePixelRatio ?? 2.0).clamp(1.0, 2.0);
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _t,
        builder: (_, __) => CustomPaint(
          painter: _StarfieldPainter(
            phase: reduceMotion ? 0.0 : _t.value, // 0–1 of the master period
            nebulae: widget.nebulae,
            starCount: widget.starCount,
            dim: widget.dim,
            motion: !reduceMotion,
            pixelRatio: dpr.toDouble(),
          ),
          size: Size.infinite,
          isComplex: true,
        ),
      ),
    );
  }
}

class _Star {
  final Offset p; // position in logical (bake-time) coordinates
  final double r;
  final double a;
  final Color color;
  final double phase;
  final double speed;
  const _Star(this.p, this.r, this.a, this.color, this.phase, this.speed);
}

/// One baked sky: the GPU texture (or, if rasterisation is unavailable in
/// this environment, the recorded picture as a fallback), the logical size it
/// was baked for, and the stars deliberately left out of it so they can
/// twinkle live.
class _BakedSky {
  final ui.Image? image;
  final ui.Picture picture; // fallback path; also keeps the recording alive
  final Size logicalSize;
  final List<_Star> twinklers;
  const _BakedSky(this.image, this.picture, this.logicalSize, this.twinklers);
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
  final bool motion;
  final double pixelRatio;

  _StarfieldPainter(
      {required this.phase,
      required this.nebulae,
      required this.starCount,
      required this.dim,
      this.motion = true,
      this.pixelRatio = 2.0});

  double get _time => phase * 7200; // seconds within the master period

  // -------- baked sky cache --------
  // Keyed by config (star count + nebula colours + pixel ratio) and shared
  // across instances, so each live screen keeps its own texture and route
  // transitions never evict each other. Size is deliberately NOT part of the
  // key — see the resize policy in the header comment.
  static final Map<int, _BakedSky> _skyCache = <int, _BakedSky>{};
  static const int _skyCacheMax = 4;

  int get _cfg =>
      Object.hash(starCount, Object.hashAll(nebulae), (pixelRatio * 4).round());

  _BakedSky _skyFor(Size size) {
    final cached = _skyCache.remove(_cfg);
    if (cached != null) {
      // Rebake only when the target is meaningfully LARGER than the bake
      // (rotation, window growth) — never for keyboard-style shrinks.
      final grewW = size.width > cached.logicalSize.width * 1.25;
      final grewH = size.height > cached.logicalSize.height * 1.25;
      if (!grewW && !grewH) {
        _skyCache[_cfg] = cached; // re-insert: LRU freshness
        return cached;
      }
    }
    final baked = _bake(size);
    _skyCache[_cfg] = baked;
    if (_skyCache.length > _skyCacheMax) {
      _skyCache.remove(_skyCache.keys.first); // drop least-recently-used
    }
    return baked;
  }

  _BakedSky _bake(Size size) {
    final rnd = math.Random(7);
    final rec = ui.PictureRecorder();
    final c = Canvas(rec);
    final twinklers = <_Star>[];

    // Record at device resolution; all coordinates below stay logical.
    c.scale(pixelRatio);

    // The historical star distribution was generated over a disc big enough
    // to rotate; keeping the same anchor + radius keeps the same seeded sky
    // (the visible portion is identical to what shipped before).
    final anchor = Offset(size.width * 0.70, size.height * 0.16);
    var fieldR = 0.0;
    for (final corner in [
      Offset.zero,
      Offset(size.width, 0),
      Offset(0, size.height),
      Offset(size.width, size.height)
    ]) {
      fieldR = math.max(fieldR, (corner - anchor).distance);
    }
    fieldR += 24;

    Offset randInField() {
      // Uniform over the field disc (rejection-free: sqrt for area uniformity).
      final a = rnd.nextDouble() * 2 * math.pi;
      final d = math.sqrt(rnd.nextDouble()) * fieldR;
      return anchor + Offset(math.cos(a) * d, math.sin(a) * d);
    }

    // ---- Deep-space gradient — near-black with the faintest indigo cast ----
    c.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = ui.Gradient.radial(
          Offset(size.width * 0.3, size.height * 0.12),
          size.longestSide * 1.25,
          [
            const Color(0xFF0B1030),
            const Color(0xFF060814),
            const Color(0xFF030409)
          ],
          [0.0, 0.45, 1.0],
        ),
    );

    // ---- The Milky Way: a river of dense faint stars through the field ----
    const bandAngle = 0.62; // rad, diagonal
    final bandDir = Offset(math.cos(bandAngle), math.sin(bandAngle));
    final bandNormal = Offset(-bandDir.dy, bandDir.dx);
    final bandCenter = anchor + bandDir * (fieldR * -0.15);
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
      final along =
          bandCenter + bandDir * ((rnd.nextDouble() * 2 - 1) * fieldR * 0.8);
      final off = bandNormal * (gauss() * bandHalfWidth * 0.16);
      final centerD = along + off;
      final len = size.shortestSide * (0.12 + rnd.nextDouble() * 0.22);
      final rect = Rect.fromCenter(
          center: centerD,
          width: len,
          height: len * (0.22 + rnd.nextDouble() * 0.2));
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
      final along =
          bandCenter + bandDir * ((rnd.nextDouble() * 2 - 1) * fieldR);
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
            ..color =
                Colors.white.withValues(alpha: 0.03 + rnd.nextDouble() * 0.09));
    }

    // ---- General field stars: power-law magnitudes.
    // Background stars stay SMALL — brightness reads through subtle bloom,
    // never size — so the field can never upstage foreground content. The
    // nine hero stars below are the one deliberate exception.
    for (var i = 0; i < starCount; i++) {
      final p = randInField();
      final m = math.pow(rnd.nextDouble(), 3.1).toDouble(); // most stars faint
      final r = 0.28 + m * 1.15; // max ~1.4 px
      final alpha = 0.08 + m * 0.60;
      // Faint stars read white to the eye; colour only shows on brighter ones.
      final color = m > 0.45 ? _stellarColor(rnd) : Colors.white;
      final star = _Star(p, r, alpha, color, rnd.nextDouble() * 2 * math.pi,
          0.4 + rnd.nextDouble());
      if (r > 0.9 &&
          twinklers.length < 60 &&
          rnd.nextDouble() < 0.22 &&
          (Offset.zero & size).inflate(4).contains(p)) {
        twinklers.add(star); // drawn live, not baked
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

    // ---- Hero stars: the brilliant few that anchor a real dark sky, each
    // with a coloured bloom and a faint four-point diffraction glint ----
    for (var i = 0; i < 9; i++) {
      final p = randInField();
      final color = _stellarColor(rnd);
      final r = 1.3 + rnd.nextDouble() * 1.0;
      c.drawCircle(
        p,
        r * 8,
        Paint()
          ..shader = ui.Gradient.radial(p, r * 8, [
            color.withValues(alpha: 0.22),
            color.withValues(alpha: 0.0),
          ])
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
      );
      c.drawCircle(p, r * 1.6, Paint()..color = color.withValues(alpha: 0.9));
      c.drawCircle(p, r * 0.9, Paint()..color = Colors.white);
      for (final d in const [Offset(1, 0), Offset(0, 1)]) {
        final a = p - d * (r * 6), b = p + d * (r * 6);
        c.drawLine(
            a,
            b,
            Paint()
              ..strokeWidth = 0.8
              ..shader = ui.Gradient.linear(a, b, [
                Colors.white.withValues(alpha: 0),
                Colors.white.withValues(alpha: 0.55),
                Colors.white.withValues(alpha: 0),
              ], [
                0.0,
                0.5,
                1.0
              ]));
      }
    }

    // ---- Nebular haze in accent colours, drifted about the field ----
    for (var i = 0; i < nebulae.length; i++) {
      final base = randInField();
      for (var layer = 0; layer < 3; layer++) {
        final centerN = base +
            Offset(
                (rnd.nextDouble() - 0.5) * 90, (rnd.nextDouble() - 0.5) * 90);
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

    // ---- Airglow: the faint warm breath of atmosphere at the horizon ----
    c.drawRect(
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

    // ---- Photographic vignette: the sky's edges fall gently to black so
    // the eye settles toward the centre — the depth of a real long exposure.
    c.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = ui.Gradient.radial(
          Offset(size.width / 2, size.height / 2),
          size.longestSide * 0.75,
          [
            Colors.black.withValues(alpha: 0.0),
            Colors.black.withValues(alpha: 0.38),
          ],
          [0.55, 1.0],
        ),
    );

    final picture = rec.endRecording();
    // Rasterise the whole static sky into a texture — every blur above is
    // rendered exactly once, here. If this environment can't rasterise
    // synchronously, the picture fallback preserves the old behaviour.
    ui.Image? image;
    try {
      image = picture.toImageSync(
        (size.width * pixelRatio).ceil().clamp(1, 8192),
        (size.height * pixelRatio).ceil().clamp(1, 8192),
      );
    } catch (_) {
      image = null;
    }
    return _BakedSky(image, picture, size, twinklers);
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final baked = _skyFor(size);

    // Cover-fit blit, anchored top-left: keyboard shrinks reuse the same
    // texture with the bottom cropped; growth is handled by rebake above.
    final s = math.max(size.width / baked.logicalSize.width,
        size.height / baked.logicalSize.height);
    if (baked.image != null) {
      final img = baked.image!;
      canvas.drawImageRect(
        img,
        Rect.fromLTWH(0, 0, img.width.toDouble(), img.height.toDouble()),
        Rect.fromLTWH(0, 0, baked.logicalSize.width * s,
            baked.logicalSize.height * s),
        Paint()..filterQuality = FilterQuality.low,
      );
    } else {
      canvas.save();
      canvas.scale(s / pixelRatio); // picture was recorded at pixelRatio
      canvas.drawPicture(baked.picture);
      canvas.restore();
    }

    // Live twinklers over the baked field.
    for (final st in baked.twinklers) {
      final tw =
          0.5 + 0.5 * math.sin(_time * st.speed * 2 * math.pi / 6 + st.phase);
      final a = (st.a * (0.30 + 0.9 * tw)).clamp(0.0, 1.0);
      canvas.drawCircle(st.p * s, st.r * (0.85 + 0.3 * tw),
          Paint()..color = st.color.withValues(alpha: a));
    }

    if (motion) {
      _paintMeteor(canvas, size);
      _paintSatellite(canvas, size);
    }

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
    canvas.drawCircle(
        head, 1.3, Paint()..color = Colors.white.withValues(alpha: fade));
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
      old.phase != phase ||
      old.dim != dim ||
      old.starCount != starCount ||
      old.motion != motion ||
      old.pixelRatio != pixelRatio;
}
