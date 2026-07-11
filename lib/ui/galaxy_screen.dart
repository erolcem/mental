// ui/galaxy_screen.dart — the home sky: four stat constellations strung down
// a galactic spine TALLER than the screen. The sky pans (drag) and breathes
// (pinch out to take in the whole galaxy, pinch in to walk among the stars);
// each stat is a brilliant guide star orbited by its skill asterisms.
// Tapping a skill star dives into that constellation.
import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repository.dart';
import '../data/skill_data.dart';
import '../data/transfer.dart';
import '../state/providers.dart';
import 'constellation_screen.dart';
import 'journal_screen.dart';
import 'review_ledger.dart';
import 'review_screen.dart';
import 'starfield.dart';
import 'theme.dart';
import 'widgets/asterism.dart';
import 'widgets/mastery_ring.dart';

/// How much taller the galaxy is than the viewport — the room that lets each
/// cluster spread out instead of being squeezed into one screen.
const double kSkyHeightFactor = 1.85;

/// Cluster centres as fractions of the TALL sky, ordered top→bottom. The
/// x stagger keeps the column organic.
const List<(String, Offset)> _spine = [
  ('INT', Offset(0.565, 0.115)),
  ('CHA', Offset(0.435, 0.375)),
  ('DEX', Offset(0.565, 0.625)),
  ('WIS', Offset(0.435, 0.875)),
];

Offset _statCenter(String id) => _spine.firstWhere((e) => e.$1 == id).$2;

class GalaxyScreen extends ConsumerStatefulWidget {
  const GalaxyScreen({super.key});

  @override
  ConsumerState<GalaxyScreen> createState() => _GalaxyScreenState();
}

class _GalaxyScreenState extends ConsumerState<GalaxyScreen> {
  Timer? _dueTicker;
  final _skyCtrl = TransformationController();
  bool _skyInitialised = false;

  @override
  void initState() {
    super.initState();
    // Reviews become due while the app idles here; re-check once a minute.
    _dueTicker = Timer.periodic(
        const Duration(minutes: 1), (_) => ref.invalidate(dueReviewsProvider));
  }

  @override
  void dispose() {
    _dueTicker?.cancel();
    _skyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = ref.watch(progressProvider);
    final xp = totalXp(progress);
    final level = levelForXp(xp);
    final overall = overallMastery(progress);

    return Scaffold(
      // No inputs live on this screen; never let insets resize the sky.
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Starfield(nebulae: [for (final s in catalog) s.color]),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, box) {
                final w = box.maxWidth, h = box.maxHeight;
                final skyH = h * kSkyHeightFactor;
                // Pinch all the way out and the whole galaxy just fits.
                final minScale = (h / skyH) + 0.005;
                if (!_skyInitialised) {
                  _skyInitialised = true;
                  _skyCtrl.value = Matrix4.identity();
                }
                return Stack(
                  children: [
                    // The pannable sky: spine + clusters live on a canvas
                    // taller than the screen. Drag to drift between stats,
                    // pinch out to survey everything at once.
                    InteractiveViewer(
                      transformationController: _skyCtrl,
                      constrained: false,
                      boundaryMargin: EdgeInsets.zero,
                      minScale: minScale,
                      maxScale: 1.0,
                      child: SizedBox(
                        width: w,
                        height: skyH,
                        child: Stack(
                          children: [
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
                    _header(context, ref, level, overall),
                    if (ref.watch(dueReviewsProvider).isNotEmpty)
                      _lockBanner(
                          context, ref.watch(dueReviewsProvider).length),
                    if (ref.watch(journalOverdueProvider))
                      _journalBanner(context,
                          top: ref.watch(dueReviewsProvider).isNotEmpty
                              ? 112.0
                              : 62.0),
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
                Text('$level', style: raleway(19, weight: 800, color: kGold)),
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
                if (v == 'export') _exportSky(context, ref);
                if (v == 'import') _importSky(context, ref);
              },
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: 'export',
                  child: Text('Export sky to clipboard',
                      style: raleway(12, color: Colors.white70)),
                ),
                PopupMenuItem(
                  value: 'import',
                  child: Text('Import sky from clipboard',
                      style: raleway(12, color: Colors.white70)),
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
        onTap: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => const ReviewScreen())),
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
        onTap: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => const JournalScreen())),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xF0161028),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: kJournalViolet.withValues(alpha: 0.5)),
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
    final doneCount = today?.actions.where((a) => a.done).length ?? 0;
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
                            color: Colors.white
                                .withValues(alpha: today == null ? 0.35 : 0.8),
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
            onTap: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const JournalScreen())),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              decoration: BoxDecoration(
                color: journaled
                    ? kJournalViolet.withValues(alpha: 0.12)
                    : const Color(0xD0100D20),
                borderRadius: BorderRadius.circular(12),
                border:
                    Border.all(color: kJournalViolet.withValues(alpha: 0.5)),
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
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border(
                top: BorderSide(color: kJournalViolet.withValues(alpha: 0.35))),
          ),
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('TODAY\'S ACTIONS — SET BY LAST NIGHT\'S JOURNAL',
                  style: raleway(8.5,
                      color: Colors.white.withValues(alpha: 0.3), spacing: 2)),
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry.actions[i].text,
                                style: raleway(12.5,
                                    height: 1.45,
                                    color: Colors.white.withValues(
                                        alpha: entry.actions[i].done
                                            ? 0.45
                                            : 0.9)),
                              ),
                              if (entry.actions[i].why.isNotEmpty)
                                Text(
                                  entry.actions[i].why,
                                  style: raleway(9.5,
                                      height: 1.4,
                                      color: kJournalViolet.withValues(
                                          alpha: entry.actions[i].done
                                              ? 0.4
                                              : 0.65)),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 6),
              Text(
                'Tonight\'s journal will ask how these went.',
                style: raleway(9.5, color: Colors.white.withValues(alpha: 0.3)),
              ),
            ],
          ),
        );
      }),
    );
  }

  /// Cross-device carry, no account needed: the whole sky (progress +
  /// journal) as one JSON blob on the clipboard — message it to yourself,
  /// paste it on the other device.
  Future<void> _exportSky(BuildContext context, WidgetRef ref) async {
    final blob =
        exportBlob(ref.read(progressProvider), ref.read(journalProvider));
    await Clipboard.setData(ClipboardData(text: blob));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: const Color(0xF0141022),
      content: Text(
          'Sky copied to clipboard — paste it into Mental on your other device.',
          style: raleway(12, color: Colors.white)),
    ));
  }

  Future<void> _importSky(BuildContext context, WidgetRef ref) async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (!context.mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    void toast(String msg, {Color color = Colors.white}) =>
        messenger.showSnackBar(SnackBar(
          backgroundColor: const Color(0xF0141022),
          content: Text(msg, style: raleway(12, color: color)),
        ));
    final raw = data?.text ?? '';
    if (raw.trim().isEmpty) {
      toast('The clipboard is empty — export from your other device first.',
          color: const Color(0xFFFFC46B));
      return;
    }
    final TransferPayload payload;
    try {
      payload = parseBlob(raw);
    } on FormatException catch (e) {
      toast(e.message, color: const Color(0xFFFFC46B));
      return;
    }
    final lit = payload.progress.values.where((p) => p.complete).length;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0D0F1A),
        title: Text('Merge this sky?', style: cinzel(16)),
        content: Text(
          'The import holds $lit ignited stars and '
          '${payload.journal.length} journal days. Merging keeps whichever '
          'record is newer on each star — nothing on this device goes dark.',
          style: raleway(13, color: Colors.white70, height: 1.5),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Cancel', style: raleway(13))),
          TextButton(
            onPressed: () {
              ref
                  .read(progressProvider.notifier)
                  .importMerged(payload.progress);
              ref.read(journalProvider.notifier).importMerged(payload.journal);
              Navigator.pop(ctx);
              toast('Skies merged — every newer star and journal day landed.');
            },
            child: Text('Merge', style: raleway(13, color: kGold)),
          ),
        ],
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
      double skyH, Map<String, NodeProgress> progress) {
    final c = _statCenter(stat.id);
    final cx = c.dx * w, cy = c.dy * skyH;
    final mastery = statMastery(progress, stat);
    final nodes = <Widget>[];

    // A breath of the stat's colour behind the whole cluster — depth, not
    // decoration.
    nodes.add(Positioned(
      left: cx - 230,
      top: cy - 190,
      child: IgnorePointer(
        child: Container(
          width: 460,
          height: 380,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(colors: [
              stat.color.withValues(alpha: 0.045),
              stat.color.withValues(alpha: 0.0),
            ]),
          ),
        ),
      ),
    ));

    // The stat anchor: a brilliant guide star with the name engraved beneath.
    nodes.add(Positioned(
      left: cx - 70,
      top: cy - 36,
      child: IgnorePointer(
        child: SizedBox(
          width: 140,
          height: 92,
          child: Column(
            children: [
              CustomPaint(
                  size: const Size(72, 44),
                  painter: _GuideStarPainter(stat.color)),
              const SizedBox(height: 3),
              Text(stat.label.toUpperCase(),
                  style: cinzel(11.5,
                      weight: 640,
                      color: stat.color.withValues(alpha: 0.92),
                      spacing: 4.5)),
              Text('${(mastery * 100).round()}% MASTERED',
                  style: raleway(6.5,
                      weight: 600,
                      color: Colors.white.withValues(alpha: 0.26),
                      spacing: 2.5)),
            ],
          ),
        ),
      ),
    ));

    // The skills: each its own miniature constellation, lit by mastery.
    final skillPositions = clusterSkillPositions(stat, w, skyH);
    for (var i = 0; i < stat.skills.length; i++) {
      final skill = stat.skills[i];
      final p = skillPositions[i];
      final m = skillMastery(progress, skill);
      nodes.add(Positioned(
        left: p.dx - 52,
        top: p.dy - 34,
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
            width: 104,
            height: 68,
            child: Column(
              children: [
                Asterism(
                    skillId: skill.id,
                    color: stat.color,
                    mastery: m,
                    size: const Size(66, 44)),
                const SizedBox(height: 2),
                // FittedBox: long names (PHYSICS & CHEM · 6%) shrink to fit
                // rather than ellipsize.
                SizedBox(
                  height: 13,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      m > 0
                          ? '${skill.label.toUpperCase()} · ${(m * 100).round()}%'
                          : skill.label.toUpperCase(),
                      maxLines: 1,
                      style: raleway(8,
                          weight: m > 0 ? 600 : 400,
                          spacing: 1.3,
                          color: Colors.white
                              .withValues(alpha: m > 0 ? 0.75 : 0.45)),
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

/// The stat's guide star, painted like a bright star in an astrophoto:
/// layered bloom, hot white core, fine four-point diffraction with a faint
/// 45° secondary cross — luminous, not iconographic.
class _GuideStarPainter extends CustomPainter {
  final Color color;
  _GuideStarPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final p = size.center(Offset.zero);
    // Outer bloom in the stat colour, inner bloom nearly white.
    canvas.drawCircle(
      p,
      24,
      Paint()
        ..shader = RadialGradient(colors: [
          color.withValues(alpha: 0.34),
          color.withValues(alpha: 0.0)
        ]).createShader(Rect.fromCircle(center: p, radius: 24)),
    );
    canvas.drawCircle(
      p,
      9,
      Paint()
        ..shader = RadialGradient(colors: [
          Color.lerp(color, Colors.white, 0.75)!.withValues(alpha: 0.55),
          color.withValues(alpha: 0.0)
        ]).createShader(Rect.fromCircle(center: p, radius: 9)),
    );
    // Primary spikes: long horizontal, shorter vertical, hair-fine.
    for (final (dir, len, aMax) in [
      (const Offset(1, 0), 34.0, 0.85),
      (const Offset(0, 1), 17.0, 0.8),
    ]) {
      final a = p - dir * len, b = p + dir * len;
      canvas.drawLine(
          a,
          b,
          Paint()
            ..shader = ui.Gradient.linear(a, b, [
              Colors.white.withValues(alpha: 0),
              Colors.white.withValues(alpha: aMax),
              Colors.white.withValues(alpha: 0),
            ], [
              0.0,
              0.5,
              1.0
            ])
            ..strokeWidth = 0.9);
    }
    // Whisper of a 45° secondary cross — the JWST signature.
    const inv = 0.7071;
    for (final dir in const [Offset(inv, inv), Offset(inv, -inv)]) {
      final a = p - dir * 10.0, b = p + dir * 10.0;
      canvas.drawLine(
          a,
          b,
          Paint()
            ..shader = ui.Gradient.linear(a, b, [
              Colors.white.withValues(alpha: 0),
              Colors.white.withValues(alpha: 0.30),
              Colors.white.withValues(alpha: 0),
            ], [
              0.0,
              0.5,
              1.0
            ])
            ..strokeWidth = 0.7);
    }
    canvas.drawCircle(
        p,
        3.2,
        Paint()
          ..color = Colors.white
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.2));
    canvas.drawCircle(p, 1.9, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant _GuideStarPainter old) => old.color != color;
}

/// Stable seeded random in [0,1) — cluster shapes must not shuffle between
/// launches.
double _clusterRand(String key, int salt) {
  var x = 0x811c9dc5;
  for (final c in '$key#$salt'.codeUnits) {
    x ^= c;
    x = (x * 0x01000193) & 0xFFFFFFFF;
  }
  x ^= x << 13 & 0xFFFFFFFF;
  x ^= x >> 17;
  x ^= x << 5 & 0xFFFFFFFF;
  return (x & 0xFFFFFF) / 0x1000000;
}

/// Positions of a stat's skill stars around its guide star — shared with the
/// spine painter so lines and stars agree. On the tall sky each cluster gets
/// real room: a wide ellipse with seeded radial variance, so the ring reads
/// as a loose asterism rather than a diagram.
List<Offset> clusterSkillPositions(StatDomain stat, double w, double skyH) {
  final c = _statCenter(stat.id);
  final cx = c.dx * w, cy = c.dy * skyH;
  // The far edge of the stagger must keep the whole ~104px label box on
  // screen: cx(0.565w) + rx + 52 ≤ w  →  rx ≤ 0.435w − 52.
  final rx = math.min(w * 0.435 - 54, 168.0);
  final ry = math.min(skyH * 0.062, 132.0);
  final n = stat.skills.length;
  return [
    for (var i = 0; i < n; i++)
      () {
        final id = stat.skills[i].id;
        final a = (i / n) * 2 * math.pi -
            math.pi / 2 +
            (_clusterRand(id, 1) - 0.5) * (math.pi / n) * 0.7;
        final r = 0.86 + _clusterRand(id, 2) * 0.26;
        return Offset(cx + math.cos(a) * rx * r, cy + math.sin(a) * ry * r);
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

    // Whisper-faint dashed spokes, guide star → skill asterisms. They stop
    // short of both ends so they read as sightlines, not wiring.
    for (final stat in catalog) {
      final c = _statCenter(stat.id);
      final center = Offset(c.dx * size.width, c.dy * size.height);
      final paint = Paint()
        ..color = stat.color.withValues(alpha: 0.055)
        ..strokeWidth = 0.7;
      for (final p in clusterSkillPositions(stat, size.width, size.height)) {
        final dir = (p - center) / (p - center).distance;
        _dashedLine(canvas, center + dir * 34, p - dir * 30, paint,
            dash: 2.5, gap: 7);
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
