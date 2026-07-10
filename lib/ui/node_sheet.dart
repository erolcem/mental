// ui/node_sheet.dart — the ritual of igniting a star. Shows the node's place
// in its constellation (tier, prerequisites, XP) and the MASTERY SUMMARY
// SHEET. With a backend configured, the sheet must convince the AI Examiner
// before the star may ignite; without one, the sky runs on the honour system.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/api_client.dart';
import '../data/repository.dart';
import '../data/skill_data.dart';
import '../state/providers.dart';
import 'constellation_screen.dart' show romanNumeral;
import 'journal_screen.dart';
import 'review_screen.dart';
import 'theme.dart';

/// Matches the backend's MIN_SUMMARY_CHARS floor.
const int kMinSummaryChars = 80;

/// The generated quest briefing: where this star sits in its constellation,
/// what it costs, and what its light means — computed from catalog
/// structure, so every one of the 431 stars reads as a legible quest.
String starBriefing(Skill skill, SkillNode node) {
  final isCrown =
      node.tier == skill.maxTier && skill.unlockedBy(node.id).isEmpty;
  final b = StringBuffer();
  if (isCrown) {
    b.write('The crown of ${skill.label} — every branch of this '
        'constellation converges here, and the endgame stands or falls on '
        'this one star. ');
  } else if (node.requires.isEmpty) {
    b.write(node.branch.isNotEmpty && node.branch != 'Foundations'
        ? 'A root star of the ${node.branch} branch — it begins here, with '
            'no prerequisites. '
        : 'A foundation star — this constellation begins here, with no '
            'prerequisites. ');
  } else {
    b.write('Tier ${node.tier} of ${skill.maxTier}'
        '${node.branch.isNotEmpty ? ' on the ${node.branch} branch' : ''}'
        ' — ${node.tier <= 2 ? 'early climb' : node.tier >= skill.maxTier - 1 ? 'the high climb toward the crown' : 'deep in the braid'}. ');
  }
  if (node.hours > 0) {
    final months = (node.hours / 60).round(); // two focused hours a day
    b.write('Budget ≈${node.hours} hours of deliberate work'
        '${months >= 2 ? ' — roughly $months months at two focused hours a day' : ''}. ');
  }
  return b.toString().trimRight();
}

/// Returns true (via the popped future) if the user ignited the star.
Future<bool?> showNodeSheet(BuildContext context, WidgetRef ref,
    {required StatDomain stat,
    required Skill skill,
    required SkillNode node}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black54,
    // Cap the ceiling below the phone's top so the grab handle is always
    // reachable and there's a clear gap to drag the sheet down through.
    constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.9),
    builder: (_) => _NodeSheet(stat: stat, skill: skill, node: node),
  );
}

class _NodeSheet extends ConsumerStatefulWidget {
  final StatDomain stat;
  final Skill skill;
  final SkillNode node;
  const _NodeSheet(
      {required this.stat, required this.skill, required this.node});

  @override
  ConsumerState<_NodeSheet> createState() => _NodeSheetState();
}

class _NodeSheetState extends ConsumerState<_NodeSheet> {
  late final TextEditingController _summary;
  bool _submitting = false;
  ExaminerVerdict? _failVerdict;
  String? _error;

  @override
  void initState() {
    super.initState();
    final saved = ref
            .read(progressProvider)[
                progressKey(widget.skill.id, widget.node.id)]
            ?.summary ??
        '';
    _summary = TextEditingController(text: saved);
    _summary.addListener(() => setState(() {})); // char counter + button state
  }

  @override
  void dispose() {
    _summary.dispose();
    super.dispose();
  }

  void _persistSummary() => ref
      .read(progressProvider.notifier)
      .saveSummary(widget.skill, widget.node, _summary.text);

  Future<void> _submitToExaminer() async {
    final api = ref.read(apiProvider);
    final notifier = ref.read(progressProvider.notifier);
    _persistSummary();
    setState(() {
      _submitting = true;
      _failVerdict = null;
      _error = null;
    });
    try {
      final verdict = await api.verifySummary(
        stat: widget.stat.label,
        skill: widget.skill.label,
        goal: widget.skill.goal,
        node: widget.node.label,
        tier: widget.node.tier,
        prerequisites: [
          for (final r in widget.node.requires)
            widget.skill.nodeById(r).label
        ],
        summary: _summary.text,
        proof: widget.node.proof,
      );
      if (!mounted) return;
      if (verdict.passed) {
        notifier.ignite(widget.skill, widget.node,
            summary: _summary.text,
            examinerNote: verdict.feedback,
            verified: true);
        Navigator.of(context).pop(true);
      } else {
        setState(() {
          _submitting = false;
          _failVerdict = verdict;
        });
      }
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _submitting = false;
        _error = e.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.stat.color;
    final progress = ref.watch(progressProvider);
    final notifier = ref.read(progressProvider.notifier);
    final api = ref.watch(apiProvider);
    final key = progressKey(widget.skill.id, widget.node.id);
    final np = progress[key];
    final complete = np?.complete ?? false;
    final unlocked = nodeUnlocked(progress, widget.skill, widget.node);

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xF20B0E22),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border(
              top: BorderSide(color: color.withValues(alpha: 0.35), width: 1)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Fixed grab handle — stays put as the body scrolls, and marks
            // the reachable top edge for dragging the sheet down.
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 4),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2)),
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 10, 22, 26),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _StarGlyph(
                      color: color, complete: complete, unlocked: unlocked),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.node.label, style: cinzel(16, weight: 640)),
                        const SizedBox(height: 3),
                        Text(
                          '${widget.skill.label}'
                          '${widget.node.branch.isNotEmpty ? '  ·  ${widget.node.branch.toUpperCase()}' : ''}',
                          style: raleway(9.5,
                              color: color.withValues(alpha: 0.8),
                              spacing: 1.2),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'TIER ${romanNumeral(widget.node.tier)}  ·  +${xpForNode(widget.node)} XP'
                          '${widget.node.hours > 0 ? '  ·  ≈${widget.node.hours} H' : ''}',
                          style: raleway(9.5,
                              color: color.withValues(alpha: 0.8),
                              spacing: 1.2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'THE ROAD · ${widget.skill.goal.toUpperCase()}',
                style: raleway(7.5,
                    weight: 700,
                    color: Colors.white.withValues(alpha: 0.3),
                    spacing: 1.8),
              ),
              const SizedBox(height: 5),
              Text(
                starBriefing(widget.skill, widget.node),
                style: raleway(10.5,
                    color: Colors.white.withValues(alpha: 0.6), height: 1.55),
              ),
              if (widget.node.guide.isNotEmpty) ...[
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: Colors.white.withValues(alpha: 0.12)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('THE WORK — DO EXACTLY THIS',
                          style: raleway(7.5,
                              weight: 700,
                              color: Colors.white.withValues(alpha: 0.55),
                              spacing: 2)),
                      const SizedBox(height: 5),
                      ..._guideLines(widget.node.guide, color),
                    ],
                  ),
                ),
              ],
              if (widget.node.proof.isNotEmpty) ...[
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: color.withValues(alpha: 0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('COMPLETION STANDARD — WHAT MUST BE TRUE',
                          style: raleway(7.5,
                              weight: 700,
                              color: color.withValues(alpha: 0.7),
                              spacing: 2)),
                      const SizedBox(height: 3),
                      Text(widget.node.proof,
                          style: raleway(11,
                              color: Colors.white.withValues(alpha: 0.8),
                              height: 1.45)),
                    ],
                  ),
                ),
              ],
              if (widget.node.requires.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text('PREREQUISITE STARS — LIGHT THESE FIRST',
                    style: raleway(8.5,
                        color: Colors.white.withValues(alpha: 0.3),
                        spacing: 2)),
                const SizedBox(height: 6),
                for (final reqId in widget.node.requires)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.5),
                    child: Row(
                      children: [
                        Text(
                          nodeComplete(progress, widget.skill.id, reqId)
                              ? '✦'
                              : '○',
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                nodeComplete(progress, widget.skill.id, reqId)
                                    ? color
                                    : Colors.white.withValues(alpha: 0.3),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.skill.nodeById(reqId).label,
                            style: raleway(11.5,
                                color: nodeComplete(
                                        progress, widget.skill.id, reqId)
                                    ? Colors.white.withValues(alpha: 0.8)
                                    : Colors.white.withValues(alpha: 0.4)),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
              const SizedBox(height: 16),
              Row(
                children: [
                  Text('MASTERY SUMMARY SHEET',
                      style: raleway(8.5,
                          color: Colors.white.withValues(alpha: 0.3),
                          spacing: 2)),
                  const Spacer(),
                  if (!complete && unlocked && api.configured)
                    Text(
                      '${_summary.text.trim().length} / $kMinSummaryChars',
                      style: raleway(8.5,
                          color: _summary.text.trim().length >=
                                  kMinSummaryChars
                              ? color.withValues(alpha: 0.7)
                              : Colors.white.withValues(alpha: 0.3)),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                api.configured
                    ? 'Write what you did and what you now understand. The '
                        'Examiner reads your sheet and must be convinced before '
                        'this star can ignite.'
                    : 'Write what you did and what you now understand. Your '
                        'summary is kept with this star. (Examiner offline — '
                        'this build has no BACKEND_URL; igniting on the '
                        'honour system.)',
                style: raleway(10,
                    color: Colors.white.withValues(alpha: 0.42), height: 1.5),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _summary,
                onChanged: (_) => _persistSummary(),
                maxLines: 6,
                minLines: 3,
                style: raleway(12.5, height: 1.5),
                cursorColor: color,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: unlocked
                      ? 'e.g. Worked through every chapter; the hardest part was…'
                      : 'Unlock this star first.',
                  hintStyle: raleway(11.5,
                      color: Colors.white.withValues(alpha: 0.25)),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.05),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: color.withValues(alpha: 0.5)),
                  ),
                ),
                enabled: (unlocked || complete) && !_submitting,
              ),
              if (_failVerdict != null) ...[
                const SizedBox(height: 12),
                _VerdictPanel(
                  color: const Color(0xFFFF8A7A),
                  title: 'THE EXAMINER IS NOT CONVINCED',
                  body: _failVerdict!.feedback,
                ),
              ],
              if (_error != null) ...[
                const SizedBox(height: 12),
                _VerdictPanel(
                  color: const Color(0xFFFFC46B),
                  title: 'THE EXAMINER COULD NOT BE REACHED',
                  body: _error!,
                ),
              ],
              const SizedBox(height: 18),
              if (complete)
                _completedFooter(np, color, notifier)
              else if (ref.watch(skyLockedProvider))
                _skyLockedButton(context)
              else
                _actionButton(color, unlocked, api),
              // Reference reading below the action: where this light leads,
              // and the unchanging ritual.
              ..._unlocksSection(color),
              _riteSection(api, color),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Render a guide as styled lines: numbered steps ("1. ...") get a gold
  /// step badge; plain lines (intro, "Keep:") render quiet. Single-line
  /// guides fall through as one paragraph, so both formats read well.
  static final RegExp _stepRe = RegExp(r'^(\d+)\.\s+(.*)$');
  List<Widget> _guideLines(String guide, Color color) {
    final lines = guide.split('\n').where((l) => l.trim().isNotEmpty).toList();
    return [
      for (final line in lines)
        () {
          final m = _stepRe.firstMatch(line.trim());
          if (m == null) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(line.trim(),
                  style: raleway(11,
                      color: Colors.white.withValues(alpha: 0.72),
                      height: 1.5)),
            );
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 17,
                  height: 17,
                  margin: const EdgeInsets.only(top: 1),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withValues(alpha: 0.10),
                    border:
                        Border.all(color: color.withValues(alpha: 0.35)),
                  ),
                  child: Text(m.group(1)!,
                      style: raleway(8.5,
                          weight: 800,
                          color: color.withValues(alpha: 0.95))),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(m.group(2)!,
                      style: raleway(11,
                          color: Colors.white.withValues(alpha: 0.85),
                          height: 1.5)),
                ),
              ],
            ),
          );
        }(),
    ];
  }

  /// What this star's light opens — the quest's forward pull.
  List<Widget> _unlocksSection(Color color) {
    final unlocks = widget.skill.unlockedBy(widget.node.id);
    final isCrown =
        unlocks.isEmpty && widget.node.tier == widget.skill.maxTier;
    if (unlocks.isEmpty && !isCrown) return const [];
    return [
      const SizedBox(height: 14),
      Text('ITS LIGHT OPENS THE WAY TO',
          style: raleway(8.5,
              color: Colors.white.withValues(alpha: 0.3), spacing: 2)),
      const SizedBox(height: 6),
      if (isCrown)
        Text(
          'Nothing further — this is the endgame. Beyond this star there is '
          'only keeping its light alive.',
          style: raleway(11,
              color: color.withValues(alpha: 0.75), height: 1.45),
        )
      else
        for (final n in unlocks)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.5),
            child: Row(
              children: [
                Text('✧',
                    style: TextStyle(
                        fontSize: 12,
                        color: color.withValues(alpha: 0.55))),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${n.label}'
                    '${n.branch.isNotEmpty && n.branch != widget.node.branch ? '  ·  ${n.branch.toUpperCase()}' : ''}',
                    style: raleway(11.5,
                        color: Colors.white.withValues(alpha: 0.55)),
                  ),
                ),
              ],
            ),
          ),
    ];
  }

  /// The same five-step ritual on every star — the quest loop made explicit.
  Widget _riteSection(MentalApi api, Color color) {
    final steps = [
      'Do the work until the completion standard is simply true.',
      'Keep artifacts as you go — worked pages, recordings, builds, drafts.',
      'Write the mastery sheet below: what you did, what you now understand.',
      api.configured
          ? 'Submit — the star ignites only when the Examiner is convinced.'
          : 'Ignite on your honour (no Examiner in this build).',
      'A lit star enters the review cycle — first recall test in '
          '${kReviewIntervalDays.first} days; going dark on reviews or the '
          'journal locks the whole sky.',
    ];
    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('THE RITE OF IGNITION',
              style: raleway(8.5,
                  color: Colors.white.withValues(alpha: 0.3), spacing: 2)),
          const SizedBox(height: 6),
          for (var i = 0; i < steps.length; i++)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 16,
                    child: Text('${i + 1}.',
                        style: raleway(9.5,
                            weight: 700,
                            color: color.withValues(alpha: 0.5))),
                  ),
                  Expanded(
                    child: Text(steps[i],
                        style: raleway(10,
                            color: Colors.white.withValues(alpha: 0.5),
                            height: 1.45)),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  /// Overdue reviews or an unwritten journal seal the sky: no new ignitions
  /// until the debt is faced. Routes to whichever is blocking (reviews first).
  Widget _skyLockedButton(BuildContext context) {
    final reviewsBlock = ref.watch(dueReviewsProvider).isNotEmpty;
    final color = reviewsBlock ? kGold : kJournalViolet;
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: color.withValues(alpha: 0.14),
          foregroundColor: color,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          side: BorderSide(color: color.withValues(alpha: 0.45)),
        ),
        onPressed: () {
          Navigator.of(context).pop(false);
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => reviewsBlock
                  ? const ReviewScreen()
                  : const JournalScreen()));
        },
        child: Text(
            reviewsBlock
                ? '🔒  THE SKY IS LOCKED — FACE YOUR REVIEWS'
                : '🔒  THE SKY IS LOCKED — JOURNAL YOUR DAY',
            style: raleway(10.5, weight: 700, color: color, spacing: 1)),
      ),
    );
  }

  Widget _actionButton(Color color, bool unlocked, MentalApi api) {
    final examined = api.configured;
    final longEnough = _summary.text.trim().length >= kMinSummaryChars;
    final canSubmit =
        unlocked && !_submitting && (!examined || longEnough);
    final label = !unlocked
        ? '🔒  COMPLETE PREREQUISITES TO UNLOCK'
        : _submitting
            ? 'THE EXAMINER IS READING YOUR SHEET…'
            : examined
                ? (_failVerdict == null
                    ? '⚖  SUBMIT TO THE EXAMINER'
                    : '⚖  RESUBMIT TO THE EXAMINER')
                : '✦  IGNITE STAR';
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: canSubmit
              ? color.withValues(alpha: 0.9)
              : Colors.white.withValues(alpha: 0.06),
          foregroundColor: canSubmit ? kSpaceBlack : Colors.white38,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        onPressed: canSubmit
            ? () {
                if (examined) {
                  _submitToExaminer();
                } else {
                  _persistSummary();
                  ref.read(progressProvider.notifier).ignite(
                      widget.skill, widget.node,
                      summary: _summary.text);
                  Navigator.of(context).pop(true);
                }
              }
            : null,
        child: _submitting
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white.withValues(alpha: 0.5)),
                  ),
                  const SizedBox(width: 10),
                  Text(label,
                      style: raleway(10.5,
                          weight: 600, color: Colors.white54, spacing: 1)),
                ],
              )
            : Text(
                label,
                style: canSubmit
                    ? cinzel(12.5, weight: 700, color: kSpaceBlack)
                    : raleway(10.5,
                        weight: 600, color: Colors.white38, spacing: 1),
              ),
      ),
    );
  }

  Widget _completedFooter(
      NodeProgress? np, Color color, ProgressNotifier notifier) {
    return Column(
      children: [
        Center(
          child: Text(
            '✦ Ignited ${_fmtDate(np?.completedAt)}'
            '${(np?.verified ?? false) ? '  ·  VERIFIED BY THE EXAMINER' : ''}',
            textAlign: TextAlign.center,
            style: raleway(10.5, color: color.withValues(alpha: 0.85)),
          ),
        ),
        if ((np?.examinerNote ?? '').isNotEmpty) ...[
          const SizedBox(height: 10),
          _VerdictPanel(
            color: color,
            title: "THE EXAMINER'S NOTE",
            body: np!.examinerNote,
          ),
        ],
        const SizedBox(height: 10),
        Center(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.white.withValues(alpha: 0.18)),
              foregroundColor: Colors.white54,
            ),
            onPressed: () => _confirmExtinguish(context, notifier),
            child: Text('Extinguish star', style: raleway(11.5)),
          ),
        ),
      ],
    );
  }

  void _confirmExtinguish(BuildContext context, ProgressNotifier notifier) {
    final impact = notifier.extinguishImpact(widget.skill, widget.node);
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0D0F1A),
        title: Text('Extinguish this star?', style: cinzel(15)),
        content: Text(
          impact > 1
              ? 'This star holds up $impact ignited stars — all of them will go dark.'
              : 'Its light (but not your summary sheet) will be lost.',
          style: raleway(12.5, color: Colors.white70, height: 1.5),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Keep it lit', style: raleway(12.5))),
          TextButton(
            onPressed: () {
              notifier.extinguish(widget.skill, widget.node);
              Navigator.pop(ctx);
              Navigator.of(context).pop(false);
            },
            child: Text('Extinguish',
                style: raleway(12.5, color: const Color(0xFFFF8888))),
          ),
        ],
      ),
    );
  }

  static String _fmtDate(DateTime? d) {
    if (d == null) return '';
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }
}

class _VerdictPanel extends StatelessWidget {
  final Color color;
  final String title;
  final String body;
  const _VerdictPanel(
      {required this.color, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: raleway(8.5,
                  weight: 700,
                  color: color.withValues(alpha: 0.9),
                  spacing: 2)),
          const SizedBox(height: 5),
          Text(body,
              style: raleway(11.5,
                  color: Colors.white.withValues(alpha: 0.85), height: 1.5)),
        ],
      ),
    );
  }
}

class _StarGlyph extends StatelessWidget {
  final Color color;
  final bool complete;
  final bool unlocked;
  const _StarGlyph(
      {required this.color, required this.complete, required this.unlocked});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [
          color.withValues(alpha: complete ? 0.5 : (unlocked ? 0.2 : 0.06)),
          color.withValues(alpha: 0.02),
        ]),
        border: Border.all(
            color: color.withValues(
                alpha: complete ? 0.7 : (unlocked ? 0.4 : 0.15))),
        boxShadow: complete
            ? [BoxShadow(color: color.withValues(alpha: 0.35), blurRadius: 18)]
            : null,
      ),
      alignment: Alignment.center,
      child: Text(
        complete ? '✦' : (unlocked ? '✧' : '🔒'),
        style: TextStyle(
            fontSize: complete || unlocked ? 20 : 14,
            color: complete ? Colors.white : color.withValues(alpha: 0.8)),
      ),
    );
  }
}
