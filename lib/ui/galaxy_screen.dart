// ui/galaxy_screen.dart — the home sky: four stat constellations stacked as a
// staggered galactic spine (portrait-first), each a glowing orb orbited by its
// skill stars. Tapping a skill star dives into that constellation.
import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repository.dart';
import '../data/skill_data.dart';
import '../state/providers.dart';
import '../state/sync_controller.dart';
import 'constellation_screen.dart';
import 'habit_ledger_sheet.dart';
import 'journal_screen.dart';
import 'review_ledger.dart';
import 'review_screen.dart';
import 'sky_link_sheet.dart';
import 'starfield.dart';
import 'theme.dart';
import 'widgets/asterism.dart';
import 'widgets/mastery_ring.dart';

/// The sky is TALLER than the screen — a canvas you drift through, not a
/// poster squeezed onto one phone height. The viewer starts at the top and
/// pans down the spine (pinch zooms in on a cluster).
const double kSkyHeightFactor = 1.55;

/// Cluster centres as fractions of the (tall) sky, ordered top→bottom. The
/// crowded stats (CHA: 7 skills, DEX: 6) take the middle rows where they have
/// room on both sides; the x stagger keeps the column organic.
const List<(String, Offset)> _spine = [
  ('INT', Offset(0.575, 0.13)),
  ('CHA', Offset(0.425, 0.375)),
  ('DEX', Offset(0.575, 0.625)),
  ('WIS', Offset(0.425, 0.87)),
];

Offset _statCenter(String id) =>
    _spine.firstWhere((e) => e.$1 == id).$2;

class GalaxyScreen extends ConsumerStatefulWidget {
  const GalaxyScreen({super.key});

  @override
  ConsumerState<GalaxyScreen> createState() => _GalaxyScreenState();
}

class _GalaxyScreenState extends ConsumerState<GalaxyScreen> {
  Timer? _dueTicker;

  /// Drives the pannable sky; watched to fade the drift hint once the user
  /// has moved off the top.
  final TransformationController _viewCtrl = TransformationController();
  bool _atTop = true;

  @override
  void initState() {
    super.initState();
    // Reviews become due — and midnight can make the journal overdue — while
    // the app idles here; re-check both lock sources once a minute.
    _dueTicker = Timer.periodic(const Duration(minutes: 1), (_) {
      ref.invalidate(dueReviewsProvider);
      ref.invalidate(journalOverdueProvider);
    });
    _viewCtrl.addListener(() {
      final atTop = _viewCtrl.value.getTranslation().y > -24 &&
          _viewCtrl.value.getMaxScaleOnAxis() <= 1.05;
      if (atTop != _atTop) setState(() => _atTop = atTop);
    });
    // Sky Link: converge with the other devices at startup, then coalesce
    // every local change into a debounced pull→merge→push.
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => ref.read(syncControllerProvider.notifier).syncNow());
    ref.listenManual(progressProvider,
        (_, __) => ref.read(syncControllerProvider.notifier).scheduleSync());
    ref.listenManual(journalProvider,
        (_, __) => ref.read(syncControllerProvider.notifier).scheduleSync());
  }

  @override
  void dispose() {
    _dueTicker?.cancel();
    _viewCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = ref.watch(progressProvider);
    final xp = totalXp(progress);
    final level = levelForXp(xp);
    final overall = overallMastery(progress);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // The starfield stays fixed while the clusters drift over it —
          // free parallax depth.
          Starfield(nebulae: [for (final s in catalog) s.color]),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, box) {
                final w = box.maxWidth, h = box.maxHeight;
                final skyH = h * kSkyHeightFactor;
                return Stack(
                  children: [
                    Positioned.fill(
                      child: InteractiveViewer(
                        transformationController: _viewCtrl,
                        constrained: false,
                        minScale: 1.0,
                        maxScale: 2.2,
                        boundaryMargin: EdgeInsets.zero,
                        child: SizedBox(
                          width: w,
                          height: skyH,
                          child: Stack(
                            children: [
                              // Spine glow + dashed spokes behind the stars.
                              IgnorePointer(
                                child: CustomPaint(
                                  size: Size(w, skyH),
                                  painter: _SpinePainter(),
                                ),
                              ),
                              for (final stat in catalog)
                                ..._buildCluster(
                                    context, stat, w, skyH, progress),
                            ],
                          ),
                        ),
                      ),
                    ),
                    _header(context, ref, level, overall),
                    if (ref.watch(dueReviewsProvider).isNotEmpty)
                      _lockBanner(context, ref.watch(dueReviewsProvider).length),
                    if (ref.watch(journalOverdueProvider))
                      _journalBanner(context,
                          top: ref.watch(dueReviewsProvider).isNotEmpty
                              ? 112.0
                              : 62.0),
                    _driftHint(),
                    _bottomBar(context, ref),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// A whisper above the bottom bar while the viewer rests at the top: the
  /// sky continues below the fold. Fades the moment you drift.
  Widget _driftHint() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 46,
      child: IgnorePointer(
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 400),
          opacity: _atTop ? 1 : 0,
          child: Column(
            children: [
              Text('DRIFT DOWN — THE SKY CONTINUES',
                  textAlign: TextAlign.center,
                  style: raleway(7.5,
                      weight: 600,
                      color: Colors.white.withValues(alpha: 0.30),
                      spacing: 2.5)),
              Text('⌄',
                  style: TextStyle(
                      fontSize: 14,
                      height: 1.1,
                      color: Colors.white.withValues(alpha: 0.30))),
            ],
          ),
        ),
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
                // Raleway, not Cinzel: Cinzel's "1" reads as a Roman "I".
                Text('$level',
                    style: raleway(19, weight: 800, color: kGold)),
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
            IconButton(
              visualDensity: VisualDensity.compact,
              tooltip: 'Review ledger',
              onPressed: () => showReviewLedger(context),
              icon: Icon(Icons.hourglass_empty,
                  color: kGold.withValues(alpha: 0.55), size: 16),
            ),
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert,
                  color: Colors.white.withValues(alpha: 0.4), size: 18),
              color: const Color(0xEE0D0F1A),
              onSelected: (v) {
                if (v == 'wipe') _confirmWipe(context, ref);
                if (v == 'sync') showSkyLinkSheet(context);
                if (v == 'ledger') showHabitLedger(context);
              },
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: 'sync',
                  child: Text(
                      ref.read(syncControllerProvider).linked
                          ? 'Sky Link — synced across devices'
                          : 'Sky Link — sync across devices',
                      style: raleway(12, color: const Color(0xFF7FE7D2))),
                ),
                PopupMenuItem(
                  value: 'ledger',
                  child: Text('The Habit Ledger', style: raleway(12)),
                ),
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

  /// The lockout banner — sits just under the header, pulls you to the Review.
  Widget _lockBanner(BuildContext context, int count) {
    return Positioned(
      top: 62,
      left: 20,
      right: 20,
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const ReviewScreen())),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            // Solid backdrop — the banner floats over star labels.
            color: const Color(0xF0141022),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: kGold.withValues(alpha: 0.5)),
            boxShadow: [
              BoxShadow(color: kGold.withValues(alpha: 0.15), blurRadius: 20),
              const BoxShadow(color: Colors.black54, blurRadius: 12),
            ],
          ),
          child: Row(
            children: [
              const Text('🔒', style: TextStyle(fontSize: 14, color: kGold)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'SKY LOCKED — $count ${count == 1 ? 'REVIEW' : 'REVIEWS'} DUE',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: raleway(9.5, weight: 700, color: kGold, spacing: 1.5),
                ),
              ),
              Text('BEGIN →', style: cinzel(10, weight: 700, color: kGold)),
            ],
          ),
        ),
      ),
    );
  }

  /// Journal-overdue banner — violet twin of the review banner.
  Widget _journalBanner(BuildContext context, {required double top}) {
    return Positioned(
      top: top,
      left: 20,
      right: 20,
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const JournalScreen())),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xF0161028),
            borderRadius: BorderRadius.circular(12),
            border:
                Border.all(color: kJournalViolet.withValues(alpha: 0.5)),
            boxShadow: [
              BoxShadow(
                  color: kJournalViolet.withValues(alpha: 0.15),
                  blurRadius: 20),
              const BoxShadow(color: Colors.black54, blurRadius: 12),
            ],
          ),
          child: Row(
            children: [
              const Text('🌙', style: TextStyle(fontSize: 13)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'SKY LOCKED — THE JOURNAL WENT UNWRITTEN',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: raleway(9.5,
                      weight: 700, color: kJournalViolet, spacing: 1.5),
                ),
              ),
              Text('WRITE →',
                  style: cinzel(10, weight: 700, color: kJournalViolet)),
            ],
          ),
        ),
      ),
    );
  }

  /// Bottom bar: today's action checklist (left) + the journal (right).
  Widget _bottomBar(BuildContext context, WidgetRef ref) {
    final today = ref.watch(todayActionsProvider);
    final journaled = ref.watch(journaledTodayProvider);
    final doneCount =
        today?.actions.where((a) => a.done).length ?? 0;
    return Positioned(
      left: 16,
      right: 16,
      bottom: 12,
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: today == null ? null : () => _showActions(context, ref),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                decoration: BoxDecoration(
                  color: const Color(0xD0100D20),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: kJournalViolet.withValues(
                          alpha: today == null ? 0.15 : 0.35)),
                ),
                child: Row(
                  children: [
                    Text('◈',
                        style: TextStyle(
                            fontSize: 11,
                            color: kJournalViolet.withValues(
                                alpha: today == null ? 0.4 : 0.9))),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        today == null
                            ? 'No actions set — the journal writes tomorrow\'s'
                            : 'TODAY\'S ACTIONS   $doneCount / ${today.actions.length}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: raleway(9,
                            weight: today == null ? 400 : 700,
                            color: Colors.white.withValues(
                                alpha: today == null ? 0.35 : 0.8),
                            spacing: today == null ? 0.2 : 1.2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const JournalScreen())),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              decoration: BoxDecoration(
                color: journaled
                    ? kJournalViolet.withValues(alpha: 0.12)
                    : const Color(0xD0100D20),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: kJournalViolet.withValues(alpha: 0.5)),
              ),
              child: Text(
                journaled ? '✦ JOURNALED' : '🌙 JOURNAL',
                style: raleway(9,
                    weight: 700, color: kJournalViolet, spacing: 1.2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showActions(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Consumer(builder: (context, ref, __) {
        final entry = ref.watch(todayActionsProvider);
        if (entry == null) return const SizedBox.shrink();
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xF20B0E22),
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border(
                top: BorderSide(
                    color: kJournalViolet.withValues(alpha: 0.35))),
          ),
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('TODAY\'S ACTIONS — SET BY LAST NIGHT\'S JOURNAL',
                  style: raleway(8.5,
                      color: Colors.white.withValues(alpha: 0.3),
                      spacing: 2)),
              const SizedBox(height: 10),
              for (var i = 0; i < entry.actions.length; i++)
                InkWell(
                  onTap: () => ref
                      .read(journalProvider.notifier)
                      .toggleAction(entry.day, i),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(entry.actions[i].done ? '✦' : '○',
                            style: TextStyle(
                                fontSize: 15,
                                color: entry.actions[i].done
                                    ? kJournalViolet
                                    : Colors.white38)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            entry.actions[i].text,
                            style: raleway(12.5,
                                height: 1.45,
                                color: Colors.white.withValues(
                                    alpha:
                                        entry.actions[i].done ? 0.45 : 0.9)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (entry.rationale.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text('WHY · ${entry.rationale}',
                    style: raleway(9,
                        height: 1.45,
                        color: kJournalViolet.withValues(alpha: 0.55))),
              ],
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Tonight\'s journal will ask how these went.',
                      style: raleway(9.5,
                          color: Colors.white.withValues(alpha: 0.3)),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      showHabitLedger(this.context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 4),
                      child: Text('THE LEDGER →',
                          style: raleway(8.5,
                              weight: 700,
                              color:
                                  kJournalViolet.withValues(alpha: 0.7),
                              spacing: 1)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
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

    // The stat anchor: a brilliant guide star with the name engraved beneath.
    nodes.add(Positioned(
      left: cx - 70,
      top: cy - 34,
      child: IgnorePointer(
        child: SizedBox(
          width: 140,
          height: 84,
          child: Column(
            children: [
              CustomPaint(
                  size: const Size(64, 40),
                  painter: _GuideStarPainter(stat.color)),
              const SizedBox(height: 2),
              Text(stat.label.toUpperCase(),
                  style: cinzel(10.5,
                      weight: 640,
                      color: stat.color.withValues(alpha: 0.9),
                      spacing: 4)),
              Text('${(mastery * 100).round()}% MASTERED',
                  style: raleway(7,
                      weight: 600,
                      color: Colors.white.withValues(alpha: 0.30),
                      spacing: 2)),
            ],
          ),
        ),
      ),
    ));

    // The skills: each its own miniature constellation, lit by mastery.
    final skillPositions = clusterSkillPositions(stat, w, h);
    for (var i = 0; i < stat.skills.length; i++) {
      final skill = stat.skills[i];
      final p = skillPositions[i];
      final m = skillMastery(progress, skill);
      nodes.add(Positioned(
        left: p.dx - 47,
        top: p.dy - 30,
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
            width: 94,
            height: 62,
            child: Column(
              children: [
                Asterism(
                    skillId: skill.id,
                    color: stat.color,
                    mastery: m,
                    size: const Size(60, 40)),
                const SizedBox(height: 2),
                // FittedBox: long names (PHYSICS & CHEM · 6%) shrink to fit
                // rather than ellipsize.
                SizedBox(
                  height: 12,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      m > 0
                          ? '${skill.label.toUpperCase()} · ${(m * 100).round()}%'
                          : skill.label.toUpperCase(),
                      maxLines: 1,
                      style: raleway(7.5,
                          weight: m > 0 ? 600 : 400,
                          spacing: 1.2,
                          color: Colors.white
                              .withValues(alpha: m > 0 ? 0.72 : 0.42)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ));
    }
    return nodes;
  }
}

/// The stat's guide star: a brilliant four-point diffraction star.
class _GuideStarPainter extends CustomPainter {
  final Color color;
  _GuideStarPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final p = size.center(Offset.zero);
    canvas.drawCircle(
      p,
      20,
      Paint()
        ..shader = RadialGradient(colors: [
          color.withValues(alpha: 0.45),
          color.withValues(alpha: 0.0)
        ]).createShader(Rect.fromCircle(center: p, radius: 20)),
    );
    // Long horizontal / shorter vertical spikes, fading outward.
    for (final (dir, len) in [(const Offset(1, 0), 30.0), (const Offset(0, 1), 15.0)]) {
      final a = p - dir * len, b = p + dir * len;
      canvas.drawLine(
          a,
          b,
          Paint()
            ..shader = ui.Gradient.linear(a, b, [
              Colors.white.withValues(alpha: 0),
              Colors.white.withValues(alpha: 0.9),
              Colors.white.withValues(alpha: 0),
            ], [
              0.0,
              0.5,
              1.0
            ])
            ..strokeWidth = 1.1);
    }
    canvas.drawCircle(
        p,
        3.4,
        Paint()
          ..color = Colors.white
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1));
    canvas.drawCircle(p, 2.0, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant _GuideStarPainter old) => old.color != color;
}

/// Positions of a stat's skill stars around its orb — shared with the spine
/// painter so lines and stars agree.
List<Offset> clusterSkillPositions(StatDomain stat, double w, double h) {
  final c = _statCenter(stat.id);
  final cx = c.dx * w, cy = c.dy * h;
  // The far edge of the stagger must keep the whole 94px label box on
  // screen: cx(0.575w) + rx + 47 ≤ w  →  rx ≤ 0.425w − 47.
  final rx = math.min(w * 0.425 - 49, 150.0);
  // h is the TALL sky canvas (kSkyHeightFactor × viewport) — the ellipses
  // finally get vertical room to breathe.
  final ry = math.min(h * 0.075, 96.0);
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
        ..color = stat.color.withValues(alpha: 0.09)
        ..strokeWidth = 0.8;
      for (final p in clusterSkillPositions(stat, size.width, size.height)) {
        _dashedLine(canvas, center, p, paint, dash: 3, gap: 6);
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
