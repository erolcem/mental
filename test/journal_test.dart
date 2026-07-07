// Journal rules: the overdue lock, today's actions selection, toggling, and
// persistence round-trips.
import 'package:flutter_test/flutter_test.dart';
import 'package:mental/data/repository.dart';
import 'package:mental/data/skill_data.dart';
import 'package:mental/state/providers.dart';

void main() {
  final now = DateTime(2026, 7, 2, 21); // evening of 2 July
  const today = '2026-07-02';
  const yesterday = '2026-07-01';

  JournalEntry closed(String day, {List<ActionItem> actions = const []}) =>
      JournalEntry(
          day: day,
          transcript: const [JournalTurn('user', 'my day')],
          actions: actions,
          closedAt: DateTime(2026, 7, 2, 22));

  group('journalOverdue', () {
    test('never journaled → not locked (habit starts kindly)', () {
      expect(journalOverdue({}, now), isFalse);
    });

    test('journaled yesterday → not locked', () {
      expect(journalOverdue({yesterday: closed(yesterday)}, now), isFalse);
    });

    test('journaled today → not locked', () {
      expect(journalOverdue({today: closed(today)}, now), isFalse);
    });

    test('last closed two days ago → locked', () {
      expect(journalOverdue({'2026-06-30': closed('2026-06-30')}, now), isTrue);
    });

    test('open (unclosed) entry does not count', () {
      const draft = JournalEntry(
          day: today, transcript: [JournalTurn('user', 'hi')]);
      expect(
          journalOverdue(
              {'2026-06-29': closed('2026-06-29'), today: draft}, now),
          isTrue);
    });

    test('journaling today clears the lock immediately', () {
      final entries = {'2026-06-29': closed('2026-06-29')};
      expect(journalOverdue(entries, now), isTrue);
      entries[today] = closed(today);
      expect(journalOverdue(entries, now), isFalse);
    });
  });

  group('day keys', () {
    test('pads and rolls over month boundaries', () {
      expect(dayKey(DateTime(2026, 7, 2)), '2026-07-02');
      expect(yesterdayKey(DateTime(2026, 7, 1)), '2026-06-30');
      expect(yesterdayKey(DateTime(2026, 1, 1)), '2025-12-31');
    });
  });

  group('notifier', () {
    test('toggleAction flips and persists', () {
      final repo = InMemoryJournalRepository();
      final n = JournalNotifier(repo);
      n.save(closed(yesterday,
          actions: const [ActionItem('Do Anki'), ActionItem('Read Rudin')]));
      n.toggleAction(yesterday, 0);
      expect(n.state[yesterday]!.actions[0].done, isTrue);
      expect(n.state[yesterday]!.actions[1].done, isFalse);
      expect(repo.loadJournal()[yesterday]!.actions[0].done, isTrue);
      n.toggleAction(yesterday, 0);
      expect(n.state[yesterday]!.actions[0].done, isFalse);
      n.toggleAction(yesterday, 99); // out of range → no-op
    });
  });

  test('JournalEntry JSON round-trip', () {
    final e = JournalEntry(
      day: today,
      transcript: const [JournalTurn('ai', 'hi'), JournalTurn('user', 'day')],
      actions: const [ActionItem('A', done: true), ActionItem('B')],
      reflection: 'Guard the morning.',
      closedAt: DateTime(2026, 7, 2, 22, 15),
    );
    final back = JournalEntry.fromJson(e.toJson());
    expect(back.day, today);
    expect(back.transcript.length, 2);
    expect(back.transcript[1].role, 'user');
    expect(back.actions[0].done, isTrue);
    expect(back.actions[1].done, isFalse);
    expect(back.reflection, 'Guard the morning.');
    expect(back.closed, isTrue);
  });

  group('advisorHistory (the 365-day habit memory)', () {
    test('only closed days before today travel, oldest first', () {
      final entries = {
        today: closed(today), // tonight — excluded
        '2026-06-30': closed('2026-06-30',
            actions: const [ActionItem('Do Anki', done: true, why: 'streak')]),
        yesterday: closed(yesterday,
            actions: const [ActionItem('Read Rudin')]),
        '2026-06-28': const JournalEntry(
            day: '2026-06-28',
            transcript: [JournalTurn('user', 'never closed')]),
      };
      final h = advisorHistory(entries, today);
      expect([for (final e in h) e['day']], ['2026-06-30', yesterday]);
      final acts = h.first['actions'] as List;
      expect(acts.first, {'text': 'Do Anki', 'done': true});
    });

    test('caps at the most recent N days and truncates long reflections', () {
      final entries = <String, JournalEntry>{};
      for (var i = 1; i <= 30; i++) {
        final day = '2026-06-${i.toString().padLeft(2, '0')}';
        entries[day] = JournalEntry(
            day: day,
            reflection: 'r' * 500,
            closedAt: DateTime(2026, 6, i, 22));
      }
      final h = advisorHistory(entries, '2026-07-01', days: 7);
      expect(h.length, 7);
      expect(h.first['day'], '2026-06-24');
      expect(h.last['day'], '2026-06-30');
      expect((h.first['reflection'] as String).length, 380);
    });
  });

  test('ActionItem JSON round-trips the why and toggling keeps it', () {
    const a = ActionItem('20 reps', why: 'hit 6/7 — step up');
    final back = ActionItem.fromJson(a.toJson());
    expect(back.why, 'hit 6/7 — step up');
    expect(back.toggled().why, 'hit 6/7 — step up');
    expect(back.toggled().done, isTrue);
  });

  test('extraLock blocks ignition when journal is overdue', () {
    final maths = skillById('maths');
    var locked = true;
    final n = ProgressNotifier(InMemoryProgressRepository(),
        extraLock: () => locked);
    n.ignite(maths, maths.nodeById('m1'));
    expect(n.isComplete('maths', 'm1'), isFalse);
    locked = false;
    n.ignite(maths, maths.nodeById('m1'));
    expect(n.isComplete('maths', 'm1'), isTrue);
  });
}
