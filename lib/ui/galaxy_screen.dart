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

/// The sky is a 2D map larger than the screen in both axes — the four stat
/// constellations spread into their own quadrants. Open on the whole map
/// (overview), then pinch or tap a sigil on the rail to fly and zoom into a
/// constellation. Canvas = viewport × these factors.
const double kSkyW = 1.62;
const double kSkyH = 1.92;

/// The zoom the rail/sigils fly you in to; the overview multiplies fit-scale.
const double _focusScale = 1.18;
const double _overviewFactor = 0.95;

/// Quadrant centres as fractions of the CANVAS — a colour in each corner,
/// gently off-grid so the sky reads as a natural field, not a tiled table.
const List<(String, Offset)> _quads = [
  ('INT', Offset(0.29, 0.25)),
  ('CHA', Offset(0.72, 0.30)),
  ('DEX', Offset(0.28, 0.73)),
  ('WIS', Offset(0.71, 0.78)),
];

Offset _statCenter(String id) =>
    _quads.firstWhere((e) => e.$1 == id).$2;

double _fitScale(Size vp, Size canvas) =>
    math.min(vp.width / canvas.width, vp.height / canvas.height);

/// A uniform scale-then-translate transform, mapping a point p → (s·p + t).
/// Built with the plain column-major Matrix4 constructor rather than
/// Matrix4.translate/scale, which newer Flutter analyzers flag as deprecated
/// (and Codemagic treats those infos as fatal).
Matrix4 _scaleTranslate(double s, double tx, double ty) => Matrix4(
      s, 0, 0, 0, //
      0, s, 0, 0, //
      0, 0, 1, 0, //
      tx, ty, 0, 1, //
    );

/// A transform that centres the whole [canvas] in [vp] at [scale].
Matrix4 _centeredM(double scale, Size vp, Size canvas) => _scaleTranslate(
    scale,
    (vp.width - scale * canvas.width) / 2,
    (vp.height - scale * canvas.height) / 2);

/// A transform that puts [canvasPoint] at the viewport centre at [scale],
/// clamped so the view never slides past the canvas edges.
Matrix4 _focusM(Offset canvasPoint, double scale, Size vp, Size canvas) {
  var tx = vp.width / 2 - scale * canvasPoint.dx;
  var ty = vp.height / 2 - scale * canvasPoint.dy;
  tx = tx.clamp(math.min(0.0, vp.width - scale * canvas.width), 0.0);
  ty = ty.clamp(math.min(0.0, vp.height - scale * canvas.height), 0.0);
  return _scaleTranslate(scale, tx, ty);
}

class GalaxyScreen extends ConsumerStatefulWidget {
  const GalaxyScreen({super.key});

  @override
  ConsumerState<GalaxyScreen> createState() => _GalaxyScreenState();
}

class _GalaxyScreenState extends ConsumerState<GalaxyScreen>
    with SingleTickerProviderStateMixin {
  Timer? _dueTicker;

  /// Drives the pannable/zoomable sky; watched to light the rail's current
  /// stat and to fade the explore hint once the user zooms in.
  final TransformationController _viewCtrl = TransformationController();
  late final AnimationController _fly;
  bool _showHint = true;
  int _railIndex = 0; // index into _quads of the cluster nearest the centre
  Size? _vp; // viewport size, set during build
  Size? _canvas; // sky-canvas size, set during build
  bool _didInitView = false;

  @override
  void initState() {
    super.initState();
    _fly = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 620));
    // Reviews become due — and midnight can make the journal overdue — while
    // the app idles here; re-check both lock sources once a minute.
    _dueTicker = Timer.periodic(const Duration(minutes: 1), (_) {
      ref.invalidate(dueReviewsProvider);
      ref.invalidate(journalOverdueProvider);
    });
    _viewCtrl.addListener(_onView);
    // Sky Link: converge with the other devices at startup, then coalesce
    // every local change into a debounced pull→merge→push.
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => ref.read(syncControllerProvider.notifier).syncNow());
    ref.listenManual(progressProvider,
        (_, __) => ref.read(syncControllerProvider.notifier).scheduleSync());
    ref.listenManual(journalProvider,
        (_, __) => ref.read(syncControllerProvider.notifier).scheduleSync());
  }

  /// Recompute which quadrant we're looking at and whether the hint shows.
  void _onView() {
    final vp = _vp, canvas = _canvas;
    if (vp == null || canvas == null) return;
    final m = _viewCtrl.value;
    final s = m.getMaxScaleOnAxis();
    final t = m.getTranslation();
    final centre =
        Offset((vp.width / 2 - t.x) / s, (vp.height / 2 - t.y) / s);
    var best = double.infinity, idx = _railIndex;
    for (var i = 0; i < _quads.length; i++) {
      final p = Offset(_quads[i].$2.dx * canvas.width,
          _quads[i].$2.dy * canvas.height);
      final d = (p - centre).distanceSquared;
      if (d < best) {
        best = d;
        idx = i;
      }
    }
    final hint = s <= _fitScale(vp, canvas) * 1.08;
    if (idx != _railIndex || hint != _showHint) {
      setState(() {
        _railIndex = idx;
        _showHint = hint;
      });
    }
  }

  @override
  void dispose() {
    _dueTicker?.cancel();
    _fly.dispose();
    _viewCtrl.dispose();
    super.dispose();
  }

  void _animateTo(Matrix4 target) {
    final anim = Matrix4Tween(begin: _viewCtrl.value, end: target).animate(
        CurvedAnimation(parent: _fly, curve: Curves.easeInOutCubic));
    void tick() => _viewCtrl.value = anim.value;
    anim.addListener(tick);
    _fly.forward(from: 0).whenCompleteOrCancel(() => anim.removeListener(tick));
  }

  /// Fly-and-zoom so [statId]'s constellation fills the screen.
  void _flyTo(String statId) {
    final vp = _vp, canvas = _canvas;
    if (vp == null || canvas == null) return;
    final c = _statCenter(statId);
    _animateTo(_focusM(
        Offset(c.dx * canvas.width, c.dy * canvas.height),
        _focusScale, vp, canvas));
  }

  /// Pull back to the whole map.
  void _overview() {
    final vp = _vp, canvas = _canvas;
    if (vp == null || canvas == null) return;
    _animateTo(_centeredM(_fitScale(vp, canvas) * _overviewFactor, vp, canvas));
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
                final vp = Size(box.maxWidth, box.maxHeight);
                final canvas = Size(vp.width * kSkyW, vp.height * kSkyH);
                _vp = vp;
                _canvas = canvas;
                // Open on the whole map, centred — the beautiful spread.
                if (!_didInitView) {
                  _didInitView = true;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      _viewCtrl.value = _centeredM(
                          _fitScale(vp, canvas) * _overviewFactor, vp, canvas);
                      _onView();
                    }
                  });
                }
                return Stack(
                  children: [
                    Positioned.fill(
                      child: InteractiveViewer(
                        transformationController: _viewCtrl,
                        constrained: false,
                        minScale: _fitScale(vp, canvas) * 0.85,
                        maxScale: 2.6,
                        boundaryMargin: EdgeInsets.all(vp.shortestSide * 0.4),
                        child: SizedBox(
                          width: canvas.width,
                          height: canvas.height,
                          child: Stack(
                            children: [
                              // The constellation web + spokes behind the stars.
                              IgnorePointer(
                                child: CustomPaint(
                                  size: canvas,
                                  painter: _WebPainter(),
                                ),
                              ),
                              for (final stat in catalog)
                                ..._buildCluster(context, stat, canvas.width,
                                    canvas.height, progress),
                            ],
                          ),
                        ),
                      ),
                    ),
                    _header(context, ref, level, xp, overall),
                    if (ref.watch(dueReviewsProvider).isNotEmpty)
                      _lockBanner(context, ref.watch(dueReviewsProvider).length),
                    if (ref.watch(journalOverdueProvider))
                      _journalBanner(context,
                          top: ref.watch(dueReviewsProvider).isNotEmpty
                              ? 176.0
                              : 122.0),
                    _statRail(),
                    _exploreHint(),
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

  /// The constellation rail: an overview button plus four stat sigils riding
  /// the right edge. Tap a sigil to fly-and-zoom to that constellation; the
  /// one you're looking at burns brightest, so you always know where you are.
  Widget _statRail() {
    return Positioned(
      right: 6,
      top: 0,
      bottom: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 9),
          decoration: BoxDecoration(
            color: const Color(0x80080A16),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 10)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _overview,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.zoom_out_map,
                      size: 15,
                      color: Colors.white.withValues(alpha: 0.55)),
                ),
              ),
              Container(
                width: 16,
                height: 1,
                color: Colors.white.withValues(alpha: 0.10),
              ),
              for (var i = 0; i < _quads.length; i++) ...[
                const SizedBox(height: 13),
                _railSigil(statById(_quads[i].$1), i == _railIndex),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _railSigil(StatDomain stat, bool active) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _flyTo(stat.id),
      child: AnimatedScale(
        scale: active ? 1.0 : 0.86,
        duration: const Duration(milliseconds: 250),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 250),
          opacity: active ? 1 : 0.45,
          child: Column(
            children: [
              Text('✦',
                  style: TextStyle(
                      fontSize: active ? 16 : 12,
                      height: 1.2,
                      color: stat.color,
                      shadows: active
                          ? [Shadow(color: stat.color, blurRadius: 10)]
                          : null)),
              Text(stat.id,
                  style: raleway(6.5,
                      weight: active ? 800 : 500,
                      color: active
                          ? stat.color
                          : Colors.white.withValues(alpha: 0.5),
                      spacing: 1)),
            ],
          ),
        ),
      ),
    );
  }

  /// A whisper at the overview, before the first zoom in.
  Widget _exploreHint() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 46,
      child: IgnorePointer(
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 400),
          opacity: _showHint ? 1 : 0,
          child: Text('PINCH TO EXPLORE  ·  TAP A SIGIL TO FLY IN',
              textAlign: TextAlign.center,
              style: raleway(7.5,
                  weight: 600,
                  color: Colors.white.withValues(alpha: 0.32),
                  spacing: 2.5)),
        ),
      ),
    );
  }

  Widget _header(BuildContext context, WidgetRef ref, int level, int xp,
      double overall) {
    final toNext = xpToNextLevel(xp);
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(18, 6, 6, 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              kSpaceBlack.withValues(alpha: 0.92),
              kSpaceDeep.withValues(alpha: 0.55),
              kSpaceDeep.withValues(alpha: 0.0),
            ],
            stops: const [0.0, 0.6, 1.0],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title line.
            Row(
              children: [
                Text('✦ MENTAL',
                    style: cinzel(16.5,
                        weight: 640,
                        color: Colors.white.withValues(alpha: 0.9),
                        spacing: 5)),
                const Spacer(),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  tooltip: 'Review ledger',
                  onPressed: () => showReviewLedger(context),
                  icon: Icon(Icons.hourglass_empty,
                      color: kGold.withValues(alpha: 0.6), size: 17),
                ),
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert,
                      color: Colors.white.withValues(alpha: 0.45), size: 19),
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
            const SizedBox(height: 6),
            // The command bar: level badge · XP progress · sky mastery.
            Row(
              children: [
                MasteryRing(
                  progress: levelProgress(xp),
                  size: 46,
                  stroke: 3,
                  color: kGold,
                  child: Text('$level',
                      style: raleway(17, weight: 800, color: kGold)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('LEVEL $level',
                              style: cinzel(10.5,
                                  weight: 680, color: kGold, spacing: 1.5)),
                          const Spacer(),
                          Text('${_fmtXp(xp)} XP',
                              style: raleway(9,
                                  weight: 600,
                                  color: Colors.white.withValues(alpha: 0.5),
                                  spacing: 0.5)),
                        ],
                      ),
                      const SizedBox(height: 5),
                      _xpBar(levelProgress(xp)),
                      const SizedBox(height: 3),
                      Text(
                        toNext == 0
                            ? 'THE SUMMIT — EVERY STAR LIT'
                            : '${_fmtXp(toNext)} XP TO LEVEL ${level + 1}',
                        style: raleway(7.5,
                            weight: 600,
                            color: Colors.white.withValues(alpha: 0.34),
                            spacing: 1.2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Column(
                  children: [
                    MasteryRing(
                      progress: overall,
                      size: 40,
                      color: Colors.white.withValues(alpha: 0.9),
                      child: Text('${(overall * 100).round()}%',
                          style: raleway(9, weight: 700)),
                    ),
                    const SizedBox(height: 2),
                    Text('SKY',
                        style: raleway(6.5,
                            weight: 700,
                            color: Colors.white.withValues(alpha: 0.4),
                            spacing: 2)),
                  ],
                ),
                const SizedBox(width: 6),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// A thin gold XP progress bar that fills to [p] (0–1).
  Widget _xpBar(double p) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: Container(
        height: 5,
        color: Colors.white.withValues(alpha: 0.10),
        child: Align(
          alignment: Alignment.centerLeft,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: p.clamp(0.0, 1.0)),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutCubic,
            builder: (_, v, __) => FractionallySizedBox(
              widthFactor: v <= 0 ? 0.001 : v,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    kGold.withValues(alpha: 0.7),
                    kGold,
                  ]),
                  boxShadow: [
                    BoxShadow(color: kGold.withValues(alpha: 0.5), blurRadius: 6),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static String _fmtXp(int n) {
    final s = n.toString();
    final b = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) b.write(',');
      b.write(s[i]);
    }
    return b.toString();
  }

  /// The lockout banner — sits just under the header, pulls you to the Review.
  Widget _lockBanner(BuildContext context, int count) {
    return Positioned(
      top: 122,
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
    // Tapping it glides the viewer to centre this cluster (deferToChild so
    // the box's empty corners never steal a neighbouring skill star's tap).
    nodes.add(Positioned(
      left: cx - 70,
      top: cy - 34,
      child: GestureDetector(
        onTap: () => _flyTo(stat.id),
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

/// Positions of a stat's skill stars around its orb — shared with the web
/// painter so lines and stars agree. Each cluster owns a generous ellipse
/// inside its quadrant of the canvas.
List<Offset> clusterSkillPositions(StatDomain stat, double w, double h) {
  final c = _statCenter(stat.id);
  final cx = c.dx * w, cy = c.dy * h;
  final rx = w * 0.185;
  final ry = h * 0.135;
  final n = stat.skills.length;
  return [
    for (var i = 0; i < n; i++)
      () {
        // Start at the top and walk round; a half-step offset per cluster
        // keeps the four rings from mirroring each other exactly.
        final a = (i / n) * 2 * math.pi - math.pi / 2 + (stat.id.hashCode % 5) * 0.13;
        return Offset(cx + math.cos(a) * rx, cy + math.sin(a) * ry);
      }()
  ];
}

/// The constellation web: soft nebular ribbons looping the four stat orbs,
/// and dashed spokes from each orb to its skill stars.
class _WebPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final centres = {
      for (final (id, c) in _quads)
        id: Offset(c.dx * size.width, c.dy * size.height)
    };
    // A gentle closed loop INT → CHA → WIS → DEX → INT, drawn as a wide,
    // heavily-blurred ribbon of faint light — the galaxy's connective tissue.
    final loop = ['INT', 'CHA', 'WIS', 'DEX'];
    final path = Path();
    for (var i = 0; i <= loop.length; i++) {
      final a = centres[loop[i % loop.length]]!;
      final b = centres[loop[(i + 1) % loop.length]]!;
      if (i == 0) path.moveTo(a.dx, a.dy);
      final mid = (a + b) / 2;
      // Bow each segment outward from the canvas centre for an organic arc.
      final centre = Offset(size.width / 2, size.height / 2);
      final bow = mid + (mid - centre) * 0.12;
      path.quadraticBezierTo(bow.dx, bow.dy, b.dx, b.dy);
    }
    canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 34
          ..color = Colors.white.withValues(alpha: 0.022)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 26));
    canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.1
          ..color = Colors.white.withValues(alpha: 0.05));

    // Dashed spokes orb → skill stars, tinted by the stat.
    for (final stat in catalog) {
      final center = centres[stat.id]!;
      final paint = Paint()
        ..color = stat.color.withValues(alpha: 0.11)
        ..strokeWidth = 0.9;
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
