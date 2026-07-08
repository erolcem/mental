// ui/habit_ledger_sheet.dart — the Habit Ledger: the advisor's memory made
// visible. Every past day's prescription with what was kept and what
// slipped, the nightly lesson, and the advisor's reasoning — the same
// evidence the Confidant iterates on each night.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/habit_ledger.dart';
import '../data/repository.dart';
import '../state/providers.dart';
import 'journal_screen.dart' show kJournalViolet;
import 'theme.dart';

void showHabitLedger(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => const _HabitLedgerSheet(),
  );
}

class _HabitLedgerSheet extends ConsumerWidget {
  const _HabitLedgerSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(journalProvider);
    final now = DateTime.now();
    final days = ledgerDays(entries, now);
    final stats = habitStats(entries, now);

    return Container(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.8),
      decoration: BoxDecoration(
        color: const Color(0xF20B0E22),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(
            top: BorderSide(color: kJournalViolet.withValues(alpha: 0.35))),
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
          Text('THE HABIT LEDGER',
              style:
                  cinzel(13, weight: 640, color: kJournalViolet, spacing: 2)),
          const SizedBox(height: 4),
          Text(
            'What you did and what you didn\'t — the advisor reads this '
            'every night and iterates: keep what works, shrink what fails, '
            'one notch at a time.',
            style: raleway(9.5,
                color: Colors.white.withValues(alpha: 0.4), height: 1.5),
          ),
          if (days.isNotEmpty) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                _stat('${stats.daysJournaled}', 'DAYS'),
                _stat(
                    stats.actionsSet == 0
                        ? '—'
                        : '${(stats.keptRate * 100).round()}%',
                    'KEPT (${stats.actionsKept}/${stats.actionsSet})'),
                _stat('${stats.currentStreak}d', 'STREAK'),
                _stat('${stats.bestStreak}d', 'BEST'),
              ],
            ),
          ],
          const SizedBox(height: 12),
          if (days.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                    'No history yet — close tonight\'s journal and the\n'
                    'ledger begins. Every kept and missed action lands here.',
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
                itemCount: days.length,
                itemBuilder: (_, i) => _dayCard(days[i]),
              ),
            ),
        ],
      ),
    );
  }

  Widget _stat(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: raleway(15, weight: 700, color: kJournalViolet)),
          const SizedBox(height: 2),
          Text(label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: raleway(6.5,
                  color: Colors.white.withValues(alpha: 0.35), spacing: 1)),
        ],
      ),
    );
  }

  Widget _dayCard(JournalEntry entry) {
    final kept = entry.actions.where((a) => a.done).length;
    final total = entry.actions.length;
    final allKept = total > 0 && kept == total;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.fromLTRB(12, 9, 12, 9),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: kJournalViolet.withValues(alpha: allKept ? 0.3 : 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(_prettyDay(entry.day),
                  style: raleway(10,
                      weight: 700,
                      color: Colors.white.withValues(alpha: 0.75),
                      spacing: 1)),
              const Spacer(),
              Text(total == 0 ? 'JOURNALED' : 'KEPT $kept/$total',
                  style: raleway(8.5,
                      weight: 700,
                      spacing: 1,
                      color: allKept
                          ? kJournalViolet
                          : Colors.white.withValues(alpha: 0.4))),
            ],
          ),
          const SizedBox(height: 5),
          for (final a in entry.actions)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 1.5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(a.done ? '✦' : '○',
                      style: TextStyle(
                          fontSize: 11,
                          color: a.done
                              ? kJournalViolet
                              : Colors.white.withValues(alpha: 0.3))),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(a.text,
                        style: raleway(10.5,
                            height: 1.35,
                            color: Colors.white
                                .withValues(alpha: a.done ? 0.75 : 0.45))),
                  ),
                ],
              ),
            ),
          if (entry.rationale.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text('advisor · ${entry.rationale}',
                style: raleway(9,
                    height: 1.4,
                    color: kJournalViolet.withValues(alpha: 0.55))),
          ] else if (entry.reflection.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text('“${entry.reflection}”',
                style: raleway(9,
                    height: 1.4,
                    color: Colors.white.withValues(alpha: 0.35))),
          ],
        ],
      ),
    );
  }

  static String _prettyDay(String day) {
    final d = DateTime.tryParse(day);
    if (d == null) return day;
    const wk = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    const mo = [
      'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
      'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'
    ];
    return '${wk[d.weekday - 1]} ${d.day} ${mo[d.month - 1]}';
  }
}
