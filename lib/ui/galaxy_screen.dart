// ui/galaxy_screen.dart — the home sky: four stat constellations stacked as a
// staggered galactic spine (portrait-first), each a glowing orb orbited by its
// skill stars. Tapping a skill star dives into that constellation.
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repository.dart';
import '../data/skill_data.dart';
import '../state/providers.dart';
import 'constellation_screen.dart';
import 'starfield.dart';
import 'theme.dart';
import 'widgets/mastery_ring.dart';

/// Cluster centres as fractions of the sky, ordered top→bottom. The crowded
/// stats (CHA: 7 skills, DEX: 6) take the middle rows where they have room on
/// both sides; the x stagger keeps the column organic.
const List<(String, Offset)> _spine = [
  ('INT', Offset(0.575, 0.135)),
  ('CHA', Offset(0.425, 0.375)),
  ('DEX', Offset(0.575, 0.615)),
  ('WIS', Offset(0.425, 0.855)),
];

Offset _statCenter(String id) =>
    _spine.firstWhere((e) => e.$1 == id).$2;

class GalaxyScreen extends ConsumerWidget {
  const GalaxyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(progressProvider);
    final xp = totalXp(progress);
    final level = levelForXp(xp);
    final overall = overallMastery(progress);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Starfield(nebulae: [for (final s in catalog) s.color]),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, box) {
                final w = box.maxWidth, h = box.maxHeight;
                return Stack(
                  children: [
                    // Spine glow + dashed spokes behind everything.
                    IgnorePointer(
                      child: CustomPaint(
                        size: Size(w, h),
                        painter: _SpinePainter(),
                      ),
                    ),
                    for (final stat in catalog)
                      ..._buildCluster(context, stat, w, h, progress),
                    _header(context, ref, level, overall),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 8,
                      child: IgnorePointer(
                        child: Text(
                          'TAP A CONSTELLATION TO EXPLORE',
                          textAlign: TextAlign.center,
                          style: raleway(8.5,
                              color: Colors.white.withValues(alpha: 0.13),
                              spacing: 3),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _header(
      BuildContext context, WidgetRef ref, int level, double overall) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 10, 8, 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              kSpaceDeep.withValues(alpha: 0.85),
              kSpaceDeep.withValues(alpha: 0.0)
            ],
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('✦ MENTAL',
                      style: cinzel(17,
                          weight: 620,
                          color: Colors.white.withValues(alpha: 0.85),
                          spacing: 5)),
                  const SizedBox(height: 2),
                  Text('$totalNodeCount LIFETIME MASTERY NODES',
                      style: raleway(8.5,
                          color: Colors.white.withValues(alpha: 0.28),
                          spacing: 2.5)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('LEVEL',
                    style: raleway(8,
                        color: Colors.white.withValues(alpha: 0.28),
                        spacing: 1.5)),
                Text('$level', style: cinzel(20, weight: 700, color: kGold)),
              ],
            ),
            const SizedBox(width: 10),
            MasteryRing(
              progress: overall,
              size: 40,
              color: kGold,
              child: Text('${(overall * 100).round()}%',
                  style: raleway(8.5, weight: 600, color: kGold)),
            ),
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert,
                  color: Colors.white.withValues(alpha: 0.4), size: 18),
              color: const Color(0xEE0D0F1A),
              onSelected: (v) {
                if (v == 'wipe') _confirmWipe(context, ref);
              },
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: 'wipe',
                  child: Text('Reset all progress',
                      style: raleway(12, color: const Color(0xFFFF8888))),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _confirmWipe(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0D0F1A),
        title: Text('Extinguish the sky?', style: cinzel(16)),
        content: Text('Every ignited star and summary sheet will be erased.',
            style: raleway(13, color: Colors.white70)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Keep', style: raleway(13))),
          TextButton(
            onPressed: () {
              ref.read(progressProvider.notifier).wipe();
              Navigator.pop(ctx);
            },
            child: Text('Erase everything',
                style: raleway(13, color: const Color(0xFFFF8888))),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCluster(BuildContext context, StatDomain stat, double w,
      double h, Map<String, NodeProgress> progress) {
    final c = _statCenter(stat.id);
    final cx = c.dx * w, cy = c.dy * h;
    final mastery = statMastery(progress, stat);
    final nodes = <Widget>[];

    // The stat orb — id + mastery % live inside it, no external label.
    nodes.add(Positioned(
      left: cx - 34,
      top: cy - 34,
      child: MasteryRing(
        progress: mastery,
        size: 68,
        stroke: 3,
        color: stat.color,
        child: Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              center: const Alignment(-0.3, -0.4),
              colors: [
                stat.color.withValues(alpha: 0.35),
                stat.color.withValues(alpha: 0.08)
              ],
            ),
            border: Border.all(
                color: stat.color.withValues(alpha: 0.45), width: 1.2),
            boxShadow: [
              BoxShadow(
                  color: stat.color.withValues(alpha: 0.18),
                  blurRadius: 26,
                  spreadRadius: 5),
            ],
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(stat.id,
                  style:
                      cinzel(13, weight: 700, color: stat.color, spacing: 1.2)),
              Text('${(mastery * 100).round()}%',
                  style: raleway(7.5,
                      weight: 600,
                      color: stat.color.withValues(alpha: 0.75))),
            ],
          ),
        ),
      ),
    ));

    // Skill stars orbiting the orb.
    final skillPositions = clusterSkillPositions(stat, w, h);
    for (var i = 0; i < stat.skills.length; i++) {
      final skill = stat.skills[i];
      final p = skillPositions[i];
      final m = skillMastery(progress, skill);
      nodes.add(Positioned(
        left: p.dx - 37,
        top: p.dy - 26,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Navigator.of(context).push(
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 420),
              reverseTransitionDuration: const Duration(milliseconds: 300),
              pageBuilder: (_, __, ___) =>
                  ConstellationScreen(statId: stat.id, skillId: skill.id),
              transitionsBuilder: (_, anim, __, child) {
                final curved =
                    CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
                return FadeTransition(
                  opacity: curved,
                  child: ScaleTransition(
                    scale: Tween(begin: 1.06, end: 1.0).animate(curved),
                    child: child,
                  ),
                );
              },
            ),
          ),
          child: SizedBox(
            width: 74,
            height: 64,
            child: Column(
              children: [
                MasteryRing(
                  progress: m,
                  size: 38,
                  stroke: 2,
                  color: stat.color,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: m > 0
                          ? stat.color.withValues(alpha: 0.14)
                          : Colors.white.withValues(alpha: 0.04),
                      border: Border.all(
                          color: stat.color
                              .withValues(alpha: m > 0.15 ? 0.4 : 0.18)),
                    ),
                    alignment: Alignment.center,
                    child:
                        Text(skill.icon, style: const TextStyle(fontSize: 13)),
                  ),
                ),
                const SizedBox(height: 3),
                Text(skill.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: raleway(8.5,
                        color: Colors.white.withValues(alpha: 0.65))),
              ],
            ),
          ),
        ),
      ));
    }
    return nodes;
  }
}

/// Positions of a stat's skill stars around its orb — shared with the spine
/// painter so lines and stars agree.
List<Offset> clusterSkillPositions(StatDomain stat, double w, double h) {
  final c = _statCenter(stat.id);
  final cx = c.dx * w, cy = c.dy * h;
  final rx = math.min(w * 0.31, 130.0);
  final ry = math.min(h * 0.075, 64.0);
  final n = stat.skills.length;
  return [
    for (var i = 0; i < n; i++)
      () {
        final a = (i / n) * 2 * math.pi - math.pi / 2;
        return Offset(cx + math.cos(a) * rx, cy + math.sin(a) * ry);
      }()
  ];
}

class _SpinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // A faint river of light flowing through the four stat orbs.
    final pts = [
      for (final (_, c) in _spine) Offset(c.dx * size.width, c.dy * size.height)
    ];
    final spine = Path()..moveTo(pts.first.dx, pts.first.dy);
    for (var i = 1; i < pts.length; i++) {
      final mid = Offset(
          (pts[i - 1].dx + pts[i].dx) / 2, (pts[i - 1].dy + pts[i].dy) / 2);
      spine.quadraticBezierTo(
          pts[i - 1].dx, (pts[i - 1].dy + mid.dy) / 2, mid.dx, mid.dy);
      spine.quadraticBezierTo(
          pts[i].dx, (pts[i].dy + mid.dy) / 2, pts[i].dx, pts[i].dy);
    }
    canvas.drawPath(
        spine,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 26
          ..color = Colors.white.withValues(alpha: 0.028)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18));

    // Dashed spokes orb → skill stars.
    for (final stat in catalog) {
      final c = _statCenter(stat.id);
      final center = Offset(c.dx * size.width, c.dy * size.height);
      final paint = Paint()
        ..color = stat.color.withValues(alpha: 0.16)
        ..strokeWidth = 1;
      for (final p in clusterSkillPositions(stat, size.width, size.height)) {
        _dashedLine(canvas, center, p, paint, dash: 3, gap: 5);
      }
    }
  }

  void _dashedLine(Canvas canvas, Offset a, Offset b, Paint paint,
      {double dash = 3, double gap = 5}) {
    final total = (b - a).distance;
    if (total <= 0) return;
    final dir = (b - a) / total;
    var d = 0.0;
    while (d < total) {
      final end = math.min(d + dash, total);
      canvas.drawLine(a + dir * d, a + dir * end, paint);
      d = end + gap;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
