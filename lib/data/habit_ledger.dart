// data/habit_ledger.dart — the Disciplined Advisor's memory.
//
// A pure digest of up to a year of journal evidence: what was prescribed,
// what was actually done and not done, the nightly lessons, and the
// advisor's own past reasoning. The app sends this with every Confidant
// request so tomorrow's prescription ITERATES on the record instead of
// reinventing it — and the Habit Ledger sheet shows the same evidence to
// the student.
//
// Shape (most recent first, so attention lands on the live campaign):
//
//   HABIT LEDGER — the last 365 days, most recent first.
//   Journaled 142 days · actions kept 214/351 (61%) · streak 9d · best 23d
//
//   RECENT DAYS
//   2026-07-07 · kept 2/3
//     [x] Do 20 Anki reps before noon
//     [ ] Run 5k
//     lesson: Guard the morning before the day claims it.
//     advisor: Anki held six days → nudged volume one notch.
//
//   EARLIER, BY MONTH
//   2026-06 · journaled 26 days · kept 48/71
//
// Deliberately pure Dart (no Flutter imports) and deterministic — tested in
// plain unit tests, bounded by a character budget so the request can never
// bloat past the backend's cap.
import 'repository.dart';

/// Matches the backend's MAX_HISTORY_CHARS (routers/journal.py).
const int kLedgerCharBudget = 24000;

/// Days rendered in full detail before the ledger rolls up by month.
const int kLedgerRecentDays = 21;

/// Aggregate follow-through stats over the ledger window — shared by the
/// digest header and the Habit Ledger sheet.
class HabitStats {
  final int daysJournaled;
  final int actionsSet;
  final int actionsKept;
  final int currentStreak; // consecutive closed days ending today/yesterday
  final int bestStreak;
  const HabitStats(
      {this.daysJournaled = 0,
      this.actionsSet = 0,
      this.actionsKept = 0,
      this.currentStreak = 0,
      this.bestStreak = 0});

  double get keptRate => actionsSet == 0 ? 0 : actionsKept / actionsSet;
}

/// Closed entries strictly BEFORE today (tonight's open session is not yet
/// evidence), inside the window, most recent first.
List<JournalEntry> ledgerDays(
    Map<String, JournalEntry> entries, DateTime now,
    {int windowDays = 365}) {
  final today = dayKey(now);
  final cutoff =
      dayKey(DateTime(now.year, now.month, now.day - windowDays));
  final days = [
    for (final e in entries.values)
      if (e.closed &&
          e.day.compareTo(today) < 0 &&
          e.day.compareTo(cutoff) >= 0)
        e
  ]..sort((a, b) => b.day.compareTo(a.day));
  return days;
}

HabitStats habitStats(Map<String, JournalEntry> entries, DateTime now,
    {int windowDays = 365}) {
  final days = ledgerDays(entries, now, windowDays: windowDays);
  var set = 0, kept = 0;
  for (final e in days) {
    set += e.actions.length;
    kept += e.actions.where((a) => a.done).length;
  }
  final have = {for (final e in days) e.day};
  // Current streak: walk back from yesterday (an unclosed today doesn't
  // break the run — the night is young).
  var current = 0;
  var d = DateTime(now.year, now.month, now.day - 1);
  while (have.contains(dayKey(d))) {
    current++;
    d = DateTime(d.year, d.month, d.day - 1);
  }
  // Best streak: longest run of consecutive calendar days in the window.
  var best = 0, run = 0;
  DateTime? prev;
  for (final e in days.reversed) {
    final t = DateTime.parse(e.day);
    run = (prev != null && t.difference(prev).inDays == 1) ? run + 1 : 1;
    if (run > best) best = run;
    prev = t;
  }
  return HabitStats(
      daysJournaled: days.length,
      actionsSet: set,
      actionsKept: kept,
      currentStreak: current,
      bestStreak: best);
}

/// Build the digest the Confidant reads. Empty string when there is no
/// history yet (the habit begins tonight — nothing to iterate on).
String buildHabitLedger(Map<String, JournalEntry> entries, DateTime now,
    {int windowDays = 365,
    int recentDays = kLedgerRecentDays,
    int charBudget = kLedgerCharBudget}) {
  final days = ledgerDays(entries, now, windowDays: windowDays);
  if (days.isEmpty) return '';
  final stats = habitStats(entries, now, windowDays: windowDays);

  final b = StringBuffer()
    ..writeln('HABIT LEDGER — the last $windowDays days, most recent first.')
    ..writeln('Journaled ${stats.daysJournaled} days · actions kept '
        '${stats.actionsKept}/${stats.actionsSet}'
        '${stats.actionsSet > 0 ? ' (${(stats.keptRate * 100).round()}%)' : ''}'
        ' · current streak ${stats.currentStreak}d · best ${stats.bestStreak}d')
    ..writeln()
    ..writeln('RECENT DAYS');

  // Verbose blocks for the freshest days; the rest rolls up by month.
  var verbose = 0;
  final monthly = <String, List<JournalEntry>>{};
  for (final e in days) {
    if (verbose < recentDays && b.length < charBudget * 3 ~/ 4) {
      _dayBlock(b, e);
      verbose++;
    } else {
      monthly.putIfAbsent(e.day.substring(0, 7), () => []).add(e);
    }
  }

  if (monthly.isNotEmpty) {
    b
      ..writeln()
      ..writeln('EARLIER, BY MONTH');
    final months = monthly.keys.toList()..sort((a, c) => c.compareTo(a));
    for (final m in months) {
      final es = monthly[m]!;
      var set = 0, kept = 0;
      for (final e in es) {
        set += e.actions.length;
        kept += e.actions.where((a) => a.done).length;
      }
      b.writeln('$m · journaled ${es.length} days · kept $kept/$set');
      if (b.length > charBudget) break;
    }
  }

  var out = b.toString().trimRight();
  if (out.length > charBudget) {
    // Cut at the last whole line inside the budget.
    final cut = out.lastIndexOf('\n', charBudget);
    out = out.substring(0, cut > 0 ? cut : charBudget);
  }
  return out;
}

void _dayBlock(StringBuffer b, JournalEntry e) {
  final kept = e.actions.where((a) => a.done).length;
  b.writeln('${e.day} · kept $kept/${e.actions.length}');
  for (final a in e.actions) {
    b.writeln('  [${a.done ? 'x' : ' '}] ${_clip(a.text, 120)}');
  }
  if (e.reflection.isNotEmpty) {
    b.writeln('  lesson: ${_clip(e.reflection, 160)}');
  }
  if (e.rationale.isNotEmpty) {
    b.writeln('  advisor: ${_clip(e.rationale, 220)}');
  }
}

String _clip(String s, int max) {
  final t = s.replaceAll('\n', ' ').trim();
  return t.length <= max ? t : '${t.substring(0, max - 1)}…';
}
