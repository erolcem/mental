// ui/review_ledger.dart — the Review Ledger: every scheduled review, due and
// upcoming, with its position on the spaced-repetition ladder. Full
// transparency about when the sky will demand what.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repository.dart';
import '../state/providers.dart';
import 'review_screen.dart';
import 'theme.dart';

void showReviewLedger(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => const _ReviewLedger(),
  );
}

class _ReviewLedger extends ConsumerWidget {
  const _ReviewLedger();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final all = ref.watch(scheduledReviewsProvider);
    final now = DateTime.now();
    final dueCount = all.where((r) => r.progress.reviewDue(now)).length;

    return Container(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.75),
      decoration: BoxDecoration(
        color: const Color(0xF20B0E22),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border:
            Border(top: BorderSide(color: kGold.withValues(alpha: 0.35))),
      ),
      padding: const EdgeInsets.fromLTRB(22, 14, 22, 24),
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
          const SizedBox(height: 14),
          Row(
            children: [
              Text('THE REVIEW LEDGER',
                  style: cinzel(13, weight: 640, color: kGold, spacing: 2)),
              const Spacer(),
              if (dueCount > 0)
                Text('$dueCount DUE — SKY LOCKED',
                    style: raleway(8.5,
                        weight: 700,
                        color: const Color(0xFFF2B24A),
                        spacing: 1.5)),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Each pass climbs the ladder: '
            '${kReviewIntervalDays.join(' → ')} days. A fail falls one rung '
            'and returns tomorrow.',
            style: raleway(9.5,
                color: Colors.white.withValues(alpha: 0.4), height: 1.5),
          ),
          const SizedBox(height: 12),
          if (all.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text('No stars are lit yet — ignite one and its\n'
                    'first review comes ${kReviewIntervalDays.first} days later.',
                    textAlign: TextAlign.center,
                    style: raleway(11,
                        color: Colors.white.withValues(alpha: 0.45),
                        height: 1.6)),
              ),
            )
          else
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: all.length,
                itemBuilder: (_, i) => _row(context, all[i], now),
              ),
            ),
          if (dueCount > 0) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: kGold.withValues(alpha: 0.9),
                  foregroundColor: kSpaceBlack,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const ReviewScreen()));
                },
                child: Text('⚖  FACE THE DUE REVIEWS',
                    style: cinzel(12, weight: 700, color: kSpaceBlack)),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _row(BuildContext context, DueReview r, DateTime now) {
    final due = r.progress.reviewDue(now);
    final next = r.progress.nextReviewAt!;
    final stage = r.progress.reviewStage;
    final color = due ? const Color(0xFFF2B24A) : r.stat.color;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(due ? '✦' : '○',
              style: TextStyle(
                  fontSize: 13,
                  color: color.withValues(alpha: due ? 1 : 0.5))),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(r.node.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: raleway(11.5,
                        weight: due ? 600 : 400,
                        color: Colors.white
                            .withValues(alpha: due ? 0.95 : 0.7))),
                Text(
                  '${r.skill.label}  ·  rung ${stage + 1}/${kReviewIntervalDays.length}'
                  '  ·  interval ${kReviewIntervalDays[stage]}d',
                  style: raleway(8.5,
                      color: Colors.white.withValues(alpha: 0.35),
                      spacing: 0.5),
                ),
              ],
            ),
          ),
          Text(
            _when(next, now),
            style: raleway(9.5,
                weight: due ? 700 : 500,
                color: due ? color : Colors.white.withValues(alpha: 0.5)),
          ),
        ],
      ),
    );
  }

  static String _when(DateTime next, DateTime now) {
    if (!next.isAfter(now)) {
      final over = now.difference(next).inDays;
      return over == 0 ? 'DUE NOW' : 'OVERDUE ${over}d';
    }
    final d = next.difference(now);
    if (d.inHours < 24) return 'in ${d.inHours}h';
    if (d.inDays < 30) return 'in ${d.inDays}d';
    return 'in ${(d.inDays / 30).floor()}mo';
  }
}
