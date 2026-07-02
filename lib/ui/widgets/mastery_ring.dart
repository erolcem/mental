// ui/widgets/mastery_ring.dart — thin circular progress ring used on stat
// orbs, skill stars and the level badge.
import 'dart:math' as math;

import 'package:flutter/material.dart';

class MasteryRing extends StatelessWidget {
  final double progress; // 0–1
  final double size;
  final double stroke;
  final Color color;
  final Widget? child;
  const MasteryRing(
      {super.key,
      required this.progress,
      required this.size,
      required this.color,
      this.stroke = 2.5,
      this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: progress.clamp(0.0, 1.0)),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutCubic,
            builder: (_, p, __) => CustomPaint(
              size: Size.square(size),
              painter: _RingPainter(p, color, stroke),
            ),
          ),
          if (child != null) child!,
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double p;
  final Color color;
  final double stroke;
  _RingPainter(this.p, this.color, this.stroke);

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = (size.shortestSide - stroke) / 2;
    canvas.drawCircle(
        c,
        r,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke
          ..color = color.withValues(alpha: 0.12));
    if (p > 0) {
      canvas.drawArc(
          Rect.fromCircle(center: c, radius: r),
          -math.pi / 2,
          2 * math.pi * p,
          false,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = stroke
            ..strokeCap = StrokeCap.round
            ..color = color);
    }
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) =>
      old.p != p || old.color != color || old.stroke != stroke;
}
