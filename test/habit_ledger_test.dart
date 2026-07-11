// The Disciplined Advisor's memory: the habit ledger digest must carry a
// year of kept/missed evidence, stay deterministic, respect its budget, and
// never leak tonight's unfinished session into the record.
import 'package:flutter_test/flutter_test.dart';
import 'package:mental/data/habit_ledger.dart';
import 'package:mental/data/repository.dart';

void main() {
  final now = DateTime(2026, 7, 8, 21); // evening of 8 July

  JournalEntry day(String d,
          {List<ActionItem> actions = const [],
          String reflection = '',
          String rationale = '',
          bool closed = true}) =>
      JournalEntry(
        day: d,
        transcript: const [JournalTurn('user', 'my day')],
        actions: actions,
        reflection: reflection,
        rationale: rationale,
        closedAt: closed ? DateTime.parse('$d 22:00:00') : null,
      );

  test('empty history → empty ledger (the habit starts kindly)', () {
    expect(buildHabitLedger({}, now), '');
    // An unclosed draft and today's own session are not yet evidence.
    final entries = {
      '2026-07-08':
          day('2026-07-08', actions: [const ActionItem('Tonight thing')]),
      '2026-07-07': day('2026-07-07', closed: false),
    };
    expect(buildHabitLedger(entries, now), '');
  });

  test('recent days appear verbose with kept/missed marks and reasoning', () {
    final entries = {
      '2026-07-07': day('2026-07-07',
          actions: [
            const ActionItem('Do 20 Anki reps before noon', done: true),
            const ActionItem('Run 5k'),
          ],
          reflection: 'Guard the morning.',
          rationale: 'Anki held six days, nudged one notch.'),
      '2026-07-06': day('2026-07-06',
          actions: [const ActionItem('Read Rudin 7.4', done: true)]),
    };
    final ledger = buildHabitLedger(entries, now);
    expect(ledger, contains('HABIT LEDGER — the last 365 days'));
    expect(ledger, contains('2026-07-07 · kept 1/2'));
    expect(ledger, contains('[x] Do 20 Anki reps before noon'));
    expect(ledger, contains('[ ] Run 5k'));
    expect(ledger, contains('lesson: Guard the morning.'));
    expect(ledger, contains('advisor: Anki held six days, nudged one notch.'));
    // Most recent first.
    expect(
        ledger.indexOf('2026-07-07'), lessThan(ledger.indexOf('2026-07-06')));
    // Deterministic.
    expect(buildHabitLedger(entries, now), ledger);
  });

  test('header stats: follow-through, current and best streak', () {
    final entries = <String, JournalEntry>{
      // 3-day live run: 5,6,7 July (today the 8th is open — streak holds).
      for (final d in ['2026-07-05', '2026-07-06', '2026-07-07'])
        d: day(d, actions: [
          const ActionItem('A', done: true),
          const ActionItem('B'),
        ]),
      // An older, longer run: 10–14 June (5 days).
      for (final d in [
        '2026-06-10',
        '2026-06-11',
        '2026-06-12',
        '2026-06-13',
        '2026-06-14'
      ])
        d: day(d, actions: [const ActionItem('C', done: true)]),
    };
    final stats = habitStats(entries, now);
    expect(stats.daysJournaled, 8);
    expect(stats.actionsSet, 11);
    expect(stats.actionsKept, 8);
    expect(stats.currentStreak, 3);
    expect(stats.bestStreak, 5);
    final ledger = buildHabitLedger(entries, now);
    expect(ledger, contains('actions kept 8/11 (73%)'));
    expect(ledger, contains('current streak 3d'));
    expect(ledger, contains('best 5d'));
  });

  test('old days roll up by month; window excludes >365d', () {
    final entries = <String, JournalEntry>{};
    // 40 recent days → 21 verbose + the rest monthly.
    for (var i = 1; i <= 40; i++) {
      final d = dayKey(DateTime(2026, 7, 8 - i));
      entries[d] = day(d, actions: [const ActionItem('X', done: true)]);
    }
    // Ancient history outside the window must not appear at all.
    entries['2025-06-01'] =
        day('2025-06-01', actions: [const ActionItem('Ancient')]);
    final ledger = buildHabitLedger(entries, now);
    expect(ledger, contains('EARLIER, BY MONTH'));
    expect(ledger, contains(RegExp(r'2026-0[56] · journaled')));
    expect(ledger, isNot(contains('2025-06-01')));
    expect(ledger, isNot(contains('Ancient')));
  });

  test('the budget holds even against a hostile year', () {
    final entries = <String, JournalEntry>{};
    final noise = List.generate(30, (i) => 'word$i').join(' ');
    for (var i = 1; i <= 365; i++) {
      final d = dayKey(DateTime(2026, 7, 8 - i));
      entries[d] = day(d,
          actions: [
            ActionItem('Long action $noise', done: i.isEven),
            ActionItem('Second $noise'),
            ActionItem('Third $noise', done: true),
          ],
          reflection: 'Reflection $noise',
          rationale: 'Rationale $noise $noise');
    }
    final ledger = buildHabitLedger(entries, now);
    expect(ledger.length, lessThanOrEqualTo(kLedgerCharBudget));
    expect(ledger, contains('RECENT DAYS'));
    expect(ledger, contains('EARLIER, BY MONTH'));
  });

  test('JournalEntry rationale survives the JSON round-trip', () {
    final e = day('2026-07-07',
        actions: [const ActionItem('A', done: true)],
        rationale: 'Kept 6/7 → one notch up.');
    final back = JournalEntry.fromJson(e.toJson());
    expect(back.rationale, 'Kept 6/7 → one notch up.');
    // Entries saved before the advisor existed decode with an empty one.
    final legacy = JournalEntry.fromJson({'day': '2026-01-01'});
    expect(legacy.rationale, '');
  });
}
