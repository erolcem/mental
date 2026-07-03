// ui/constellation_screen.dart — one skill rendered as a living constellation.
// Ignited stars burn with halos and diffraction spikes, the next unlockable
// stars breathe softly, locked stars are barely-there points. Pan/zoom via
// InteractiveViewer; tapping a star opens its node sheet.
import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart' show setEquals;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repository.dart';
import '../data/skill_data.dart';
import '../state/providers.dart';
import 'constellation_layout.dart';
import 'node_sheet.dart';
import 'review_ledger.dart';
import 'starfield.dart';
import 'theme.dart';

class ConstellationScreen extends ConsumerStatefulWidget {
  final String statId;
  final String skillId;
  const ConstellationScreen(
      {super.key, required this.statId, required this.skillId});

  @override
  ConsumerState<ConstellationScreen> createState() =>
      _ConstellationScreenState();
}

class _ConstellationScreenState extends ConsumerState<ConstellationScreen>
    with TickerProviderStateMixin {
  late final AnimationController _breath; // ambient pulse for available stars
  late final AnimationController _burst; // ignition shockwave
  String? _burstNodeId;
  final _viewCtrl = TransformationController();
  bool _viewInitialised = false;
  Timer? _dueTicker;

  late final StatDomain stat = statById(widget.statId);
  late final Skill skill = skillById(widget.skillId);
  late final ConstellationLayout layout = layoutConstellation(skill);

  @override
  void initState() {
    super.initState();
    _breath =
        AnimationController(vsync: this, duration: const Duration(seconds: 4))
          ..repeat();
    _burst = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    // Reviews can come due while studying a constellation; the sheet's lock
    // gate must notice without a restart.
    _dueTicker = Timer.periodic(const Duration(minutes: 1),
        (_) => ref.invalidate(dueReviewsProvider));
  }

  @override
  void dispose() {
    _dueTicker?.cancel();
    _breath.dispose();
    _burst.dispose();
    _viewCtrl.dispose();
    super.dispose();
  }

  /// Start looking at the base of the constellation (tier 1) — that is where
  /// the journey begins — unless everything fits on screen.
  void _initView(Size viewport) {
    if (_viewInitialised) return;
    _viewInitialised = true;
    final dx = (viewport.width - layout.size.width) / 2;
    final dy = viewport.height - layout.size.height;
    _viewCtrl.value = Matrix4.translationValues(dx, dy < 0 ? dy : dy / 2, 0);
  }

  void _onTapUp(TapUpDetails d) {
    final p = d.localPosition;
    SkillNode? hit;
    var best = 32.0 * 32.0;
    for (final n in skill.tree) {
      final np = layout.pos[n.id];
      if (np == null) continue;
      final dd = (np - p).distanceSquared;
      if (dd < best) {
        best = dd;
        hit = n;
      }
    }
    if (hit == null) return;
    final ignitedNow = showNodeSheet(context, ref,
        stat: stat, skill: skill, node: hit);
    ignitedNow.then((ignited) {
      if (ignited == true && mounted) {
        setState(() => _burstNodeId = hit!.id);
        _burst.forward(from: 0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final progress = ref.watch(progressProvider);
    final mastery = skillMastery(progress, skill);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Starfield(nebulae: [stat.color], starCount: 1400),
          LayoutBuilder(builder: (context, box) {
            _initView(Size(box.maxWidth, box.maxHeight));
            return InteractiveViewer(
              transformationController: _viewCtrl,
              constrained: false,
              boundaryMargin: const EdgeInsets.symmetric(
                  horizontal: 120, vertical: 160),
              minScale: 0.5,
              maxScale: 2.5,
              child: SizedBox(
                width: layout.size.width,
                height: layout.size.height,
                child: GestureDetector(
                  onTapUp: _onTapUp,
                  child: AnimatedBuilder(
                    animation: Listenable.merge([_breath, _burst]),
                    builder: (_, __) => CustomPaint(
                      isComplex: true,
                      painter: ConstellationPainter(
                        skill: skill,
                        color: stat.color,
                        layout: layout,
                        progress: progress,
                        breath: _breath.value,
                        burstNodeId: _burstNodeId,
                        burst: _burst.isAnimating ? _burst.value : null,
                        dueNodeIds: {
                          for (final n in skill.tree)
                            if (progress[progressKey(skill.id, n.id)]
                                    ?.reviewDue(DateTime.now()) ??
                                false)
                              n.id
                        },
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
          _header(context, mastery),
          if (ref.watch(skyLockedProvider)) _lockChip(context),
        ],
      ),
    );
  }

  /// The seal, visible where ignition would happen. Tap → the Ledger.
  Widget _lockChip(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 18,
      child: Center(
        child: GestureDetector(
          onTap: () => showReviewLedger(context),
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xF0141022),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: kGold.withValues(alpha: 0.5)),
              boxShadow: [
                BoxShadow(
                    color: kGold.withValues(alpha: 0.15), blurRadius: 16),
              ],
            ),
            child: Text('🔒 THE SKY IS SEALED — VIEW THE LEDGER',
                style: raleway(9,
                    weight: 700, color: kGold, spacing: 1.5)),
          ),
        ),
      ),
    );
  }

  Widget _header(BuildContext context, double mastery) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
            top: MediaQuery.paddingOf(context).top + 6,
            left: 14,
            right: 16,
            bottom: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              kSpaceDeep.withValues(alpha: 0.92),
              kSpaceDeep.withValues(alpha: 0.0),
            ],
          ),
        ),
        child: Row(
          children: [
            InkWell(
              onTap: () => Navigator.of(context).pop(),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: stat.color.withValues(alpha: 0.35)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('← Sky',
                    style: cinzel(11, weight: 500, color: stat.color)),
              ),
            ),
            const SizedBox(width: 12),
            Text(skill.icon, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(skill.label,
                      style: cinzel(15, weight: 620, color: stat.color)),
                  Text(skill.goal,
                      style: raleway(9.5,
                          color: Colors.white.withValues(alpha: 0.45))),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('MASTERY',
                    style: raleway(7.5,
                        color: Colors.white.withValues(alpha: 0.28),
                        spacing: 1.5)),
                Text('${(mastery * 100).round()}%',
                    style: cinzel(18, weight: 700, color: stat.color)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------

String romanNumeral(int n) {
  const pairs = [
    (10, 'X'),
    (9, 'IX'),
    (5, 'V'),
    (4, 'IV'),
    (1, 'I'),
  ];
  var out = '', v = n;
  for (final (value, sym) in pairs) {
    while (v >= value) {
      out += sym;
      v -= value;
    }
  }
  return out;
}

class ConstellationPainter extends CustomPainter {
  final Skill skill;
  final Color color;
  final ConstellationLayout layout;
  final Map<String, NodeProgress> progress;
  final double breath; // 0–1 looping
  final String? burstNodeId;
  final double? burst; // 0–1 while igniting, else null

  /// Ignited stars past their review date — drawn fading amber.
  final Set<String> dueNodeIds;

  ConstellationPainter({
    required this.skill,
    required this.color,
    required this.layout,
    required this.progress,
    required this.breath,
    this.burstNodeId,
    this.burst,
    this.dueNodeIds = const {},
  });

  bool _complete(String nodeId) =>
      progress[progressKey(skill.id, nodeId)]?.complete ?? false;

  bool _unlocked(SkillNode n) => n.requires.every(_complete);

  @override
  void paint(Canvas canvas, Size size) {
    _paintTierMarks(canvas);
    _paintEdges(canvas);
    for (final n in skill.tree) {
      _paintStar(canvas, n);
    }
    if (burst != null && burstNodeId != null) {
      _paintBurst(canvas, layout.pos[burstNodeId!]!, burst!);
    }
  }

  void _paintTierMarks(Canvas canvas) {
    final maxTier = skill.maxTier;
    for (var t = 1; t <= maxTier; t++) {
      final y = layout.size.height - kBottomPad - (t - 1) * kTierGap;
      final tp = TextPainter(
        text: TextSpan(
          text: romanNumeral(t),
          style: raleway(9,
              color: color.withValues(alpha: 0.16), spacing: 2, weight: 500),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(10, y - tp.height / 2));
      // A hair-thin guide line fading in from the numeral.
      canvas.drawLine(
        Offset(26, y),
        Offset(40, y),
        Paint()
          ..color = color.withValues(alpha: 0.07)
          ..strokeWidth = 0.8,
      );
    }
  }

  void _paintEdges(Canvas canvas) {
    for (final n in skill.tree) {
      final to = layout.pos[n.id];
      if (to == null) continue;
      for (final req in n.requires) {
        final from = layout.pos[req];
        if (from == null) continue;
        final bothLit = _complete(n.id) && _complete(req);
        final pathLit = _complete(req); // parent done → this edge is "active"

        if (bothLit) {
          // The constellation figure line — bright with a soft glow.
          canvas.drawLine(
              from,
              to,
              Paint()
                ..color = color.withValues(alpha: 0.22)
                ..strokeWidth = 3.4
                ..strokeCap = StrokeCap.round
                ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3));
          canvas.drawLine(
              from,
              to,
              Paint()
                ..color = color.withValues(alpha: 0.75)
                ..strokeWidth = 1.1
                ..strokeCap = StrokeCap.round);
        } else if (pathLit) {
          _dashed(canvas, from, to,
              Paint()
                ..color = color.withValues(alpha: 0.32)
                ..strokeWidth = 1.0,
              dash: 5, gap: 4);
        } else {
          _dashed(canvas, from, to,
              Paint()
                ..color = Colors.white.withValues(alpha: 0.06)
                ..strokeWidth = 0.9,
              dash: 3, gap: 6);
        }
      }
    }
  }

  void _dashed(Canvas canvas, Offset a, Offset b, Paint paint,
      {double dash = 4, double gap = 5}) {
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

  void _paintStar(Canvas canvas, SkillNode n) {
    final p = layout.pos[n.id];
    if (p == null) return;
    final mag = layout.magnitude[n.id] ?? 1.0;
    final complete = _complete(n.id);
    final unlocked = _unlocked(n);

    if (complete) {
      _paintIgnitedStar(canvas, p, mag, fading: dueNodeIds.contains(n.id));
    } else if (unlocked) {
      _paintAvailableStar(canvas, p, mag, n);
    } else {
      canvas.drawCircle(
          p, 1.7 * mag, Paint()..color = Colors.white.withValues(alpha: 0.22));
    }

    _paintLabel(canvas, p, n, complete: complete, unlocked: unlocked);
  }

  /// A lit star: hot white core, colour halo, 4-point diffraction spikes.
  /// A [fading] star (review overdue) gutters amber and its light dims.
  void _paintIgnitedStar(Canvas canvas, Offset p, double mag,
      {bool fading = false}) {
    // Fading stars flicker irregularly, like a candle guttering.
    final tw = fading
        ? 0.62 +
            0.18 * math.sin(breath * 2 * math.pi * 5 + p.dx) +
            0.10 * math.sin(breath * 2 * math.pi * 11 + p.dy)
        : 0.92 + 0.08 * math.sin(breath * 2 * math.pi * 2 + p.dx);
    final haloColor = fading ? const Color(0xFFF2B24A) : color;
    final coreAlpha = fading ? 0.75 : 1.0;
    final haloR = 14.0 * mag * tw;
    canvas.drawCircle(
      p,
      haloR,
      Paint()
        ..shader = ui.Gradient.radial(p, haloR, [
          haloColor.withValues(alpha: fading ? 0.28 : 0.35),
          haloColor.withValues(alpha: 0.0),
        ]),
    );
    // Diffraction spikes — vertical/horizontal, fading outward.
    final spikeLen = 13.0 * mag * tw;
    for (final dir in const [Offset(1, 0), Offset(0, 1)]) {
      final aEnd = p + dir * spikeLen;
      final bEnd = p - dir * spikeLen;
      canvas.drawLine(
          bEnd,
          aEnd,
          Paint()
            ..shader = ui.Gradient.linear(bEnd, aEnd, [
              Colors.white.withValues(alpha: 0),
              Colors.white.withValues(alpha: 0.8 * tw * coreAlpha),
              Colors.white.withValues(alpha: 0),
            ], [
              0.0,
              0.5,
              1.0
            ])
            ..strokeWidth = 1.0);
    }
    canvas.drawCircle(
        p,
        3.0 * mag,
        Paint()
          ..color = Colors.white.withValues(alpha: coreAlpha)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1));
    canvas.drawCircle(
        p, 1.6 * mag, Paint()..color = Colors.white.withValues(alpha: coreAlpha));
  }

  /// The frontier: unlocked but unlit — a breathing ember inviting a tap.
  void _paintAvailableStar(Canvas canvas, Offset p, double mag, SkillNode n) {
    final pulse =
        0.5 + 0.5 * math.sin(breath * 2 * math.pi + p.dy * 0.05);
    final haloR = (9.0 + 4.0 * pulse) * mag;
    canvas.drawCircle(
      p,
      haloR,
      Paint()
        ..shader = ui.Gradient.radial(p, haloR, [
          color.withValues(alpha: 0.16 + 0.10 * pulse),
          color.withValues(alpha: 0.0),
        ]),
    );
    canvas.drawCircle(
        p,
        2.6 * mag,
        Paint()
          ..color =
              Color.lerp(color, Colors.white, 0.55)!.withValues(alpha: 0.95));
    canvas.drawCircle(
        p,
        4.4 * mag,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.8
          ..color = color.withValues(alpha: 0.4 + 0.2 * pulse));
  }

  void _paintLabel(Canvas canvas, Offset p, SkillNode n,
      {required bool complete, required bool unlocked}) {
    final alpha = complete ? 0.75 : (unlocked ? 0.85 : 0.24);
    final tp = TextPainter(
      text: TextSpan(
        text: n.label,
        style: raleway(9,
            weight: unlocked && !complete ? 600 : 400,
            color: Colors.white.withValues(alpha: alpha)),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
      maxLines: 2,
      ellipsis: '…',
    )..layout(maxWidth: 110);
    // Subtle dark backing so labels stay legible over the star field.
    final r = RRect.fromRectAndRadius(
      Rect.fromCenter(
          center: Offset(p.dx, p.dy + 24 + tp.height / 2),
          width: tp.width + 8,
          height: tp.height + 3),
      const Radius.circular(4),
    );
    canvas.drawRRect(
        r, Paint()..color = kSpaceBlack.withValues(alpha: 0.35 * alpha));
    tp.paint(canvas, Offset(p.dx - tp.width / 2, p.dy + 24));
  }

  /// Ignition shockwave: expanding ring + flash rays.
  void _paintBurst(Canvas canvas, Offset p, double t) {
    final fade = (1 - t).clamp(0.0, 1.0);
    final r = 10 + 70 * Curves.easeOutCubic.transform(t);
    canvas.drawCircle(
        p,
        r,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2 * fade
          ..color = color.withValues(alpha: 0.5 * fade));
    canvas.drawCircle(
        p,
        r * 0.6,
        Paint()
          ..shader = ui.Gradient.radial(p, r * 0.6, [
            Colors.white.withValues(alpha: 0.5 * fade),
            color.withValues(alpha: 0.0),
          ]));
    // Rays.
    for (var i = 0; i < 6; i++) {
      final a = i * math.pi / 3 + t * 0.6;
      final dir = Offset(math.cos(a), math.sin(a));
      canvas.drawLine(
          p + dir * r * 0.5,
          p + dir * (r * 0.5 + 18 * fade),
          Paint()
            ..strokeWidth = 1.2 * fade
            ..color = Colors.white.withValues(alpha: 0.55 * fade));
    }
  }

  @override
  bool shouldRepaint(covariant ConstellationPainter old) =>
      old.progress != progress ||
      old.breath != breath ||
      old.burst != burst ||
      old.burstNodeId != burstNodeId ||
      !setEquals(old.dueNodeIds, dueNodeIds);
}
