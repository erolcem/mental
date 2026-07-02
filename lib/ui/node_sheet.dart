// ui/node_sheet.dart — the ritual of igniting a star. Shows the node's place
// in its constellation (tier, prerequisites, XP) and the MASTERY SUMMARY
// SHEET: the user's own written account of the work. In stage 2 an AI
// examiner will verify that sheet before the star may ignite; the editor and
// storage are already wired for it.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/skill_data.dart';
import '../state/providers.dart';
import 'constellation_screen.dart' show romanNumeral;
import 'theme.dart';

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

  @override
  void initState() {
    super.initState();
    final saved = ref
            .read(progressProvider)[
                progressKey(widget.skill.id, widget.node.id)]
            ?.summary ??
        '';
    _summary = TextEditingController(text: saved);
  }

  @override
  void dispose() {
    _summary.dispose();
    super.dispose();
  }

  void _persistSummary() => ref
      .read(progressProvider.notifier)
      .saveSummary(widget.skill, widget.node, _summary.text);

  @override
  Widget build(BuildContext context) {
    final color = widget.stat.color;
    final progress = ref.watch(progressProvider);
    final notifier = ref.read(progressProvider.notifier);
    final complete =
        nodeComplete(progress, widget.skill.id, widget.node.id);
    final unlocked = nodeUnlocked(progress, widget.skill, widget.node);
    final completedAt = progress[
            progressKey(widget.skill.id, widget.node.id)]
        ?.completedAt;

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
        padding: const EdgeInsets.fromLTRB(22, 14, 22, 26),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _StarGlyph(color: color, complete: complete, unlocked: unlocked),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.node.label, style: cinzel(16, weight: 640)),
                        const SizedBox(height: 3),
                        Text(
                          '${widget.skill.label}  ·  TIER ${romanNumeral(widget.node.tier)}  ·  +${xpForNode(widget.node)} XP',
                          style: raleway(9.5,
                              color: color.withValues(alpha: 0.8), spacing: 1.2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (widget.node.requires.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text('PREREQUISITE STARS',
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
                            color: nodeComplete(
                                    progress, widget.skill.id, reqId)
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
              Text('MASTERY SUMMARY SHEET',
                  style: raleway(8.5,
                      color: Colors.white.withValues(alpha: 0.3), spacing: 2)),
              const SizedBox(height: 4),
              Text(
                'Write what you did and what you now understand. Your summary is '
                'kept with this star — soon an AI examiner will read it to verify '
                'mastery before the star can ignite.',
                style: raleway(10,
                    color: Colors.white.withValues(alpha: 0.42), height: 1.5),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _summary,
                onChanged: (_) => _persistSummary(),
                maxLines: 5,
                minLines: 3,
                style: raleway(12.5, height: 1.5),
                cursorColor: color,
                decoration: InputDecoration(
                  hintText: unlocked
                      ? 'e.g. Worked through every chapter; can now derive…'
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
                enabled: unlocked || complete,
              ),
              const SizedBox(height: 18),
              if (complete) ...[
                Center(
                  child: Text(
                    '✦ Ignited ${_fmtDate(completedAt)}',
                    style: raleway(11, color: color.withValues(alpha: 0.85)),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                          color: Colors.white.withValues(alpha: 0.18)),
                      foregroundColor: Colors.white54,
                    ),
                    onPressed: () => _confirmExtinguish(context, notifier),
                    child: Text('Extinguish star', style: raleway(11.5)),
                  ),
                ),
              ] else
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: unlocked
                          ? color.withValues(alpha: 0.9)
                          : Colors.white.withValues(alpha: 0.06),
                      foregroundColor:
                          unlocked ? kSpaceBlack : Colors.white38,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: unlocked
                        ? () {
                            _persistSummary();
                            notifier.ignite(widget.skill, widget.node,
                                summary: _summary.text);
                            Navigator.of(context).pop(true);
                          }
                        : null,
                    child: Text(
                      unlocked
                          ? '✦  IGNITE STAR'
                          : '🔒  COMPLETE PREREQUISITES TO UNLOCK',
                      style: unlocked
                          ? cinzel(13, weight: 700, color: kSpaceBlack)
                          : raleway(11,
                              weight: 600, color: Colors.white38, spacing: 1),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmExtinguish(BuildContext context, ProgressNotifier notifier) {
    final impact =
        notifier.extinguishImpact(widget.skill, widget.node);
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
