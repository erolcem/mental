// Cross-device transfer: export → parse round-trip, hostile input rejection,
// and the merge rules (newer wins; a lit star never goes dark on import).
import 'package:flutter_test/flutter_test.dart';
import 'package:mental/data/repository.dart';
import 'package:mental/data/transfer.dart';

void main() {
  final t0 = DateTime(2026, 6, 1);
  final t1 = DateTime(2026, 7, 1);

  test('export → parse round-trips progress and journal', () {
    final progress = {
      'maths.m1': NodeProgress(
          completedAt: t0,
          summary: 'Did the work',
          verifiedAt: t0,
          examinerNote: 'Convincing.',
          reviewStage: 2,
          nextReviewAt: t1),
    };
    final journal = {
      '2026-06-30': JournalEntry(
          day: '2026-06-30',
          transcript: const [JournalTurn('user', 'my day')],
          actions: const [ActionItem('Do X', done: true, why: 'streak')],
          reflection: 'Keep going.',
          closedAt: t1),
    };
    final back = parseBlob(exportBlob(progress, journal));
    expect(back.progress['maths.m1']!.summary, 'Did the work');
    expect(back.progress['maths.m1']!.reviewStage, 2);
    expect(back.journal['2026-06-30']!.actions.single.why, 'streak');
    expect(back.journal['2026-06-30']!.closed, isTrue);
  });

  test('parse rejects non-JSON, foreign JSON, and future versions', () {
    expect(() => parseBlob('hello'), throwsFormatException);
    expect(() => parseBlob('{"app": "other"}'), throwsFormatException);
    expect(
        () => parseBlob('{"app": "mental", "v": 99}'), throwsFormatException);
  });

  test('merge: a lit star never goes dark; newer completion wins', () {
    final localLit = {
      'a': NodeProgress(completedAt: t1, summary: 'local'),
    };
    final incomingDark = {'a': const NodeProgress(summary: 'incoming')};
    expect(mergeProgress(localLit, incomingDark)['a']!.complete, isTrue);
    expect(mergeProgress(incomingDark, localLit)['a']!.complete, isTrue);

    final older = {'b': NodeProgress(completedAt: t0, summary: 'old')};
    final newer = {'b': NodeProgress(completedAt: t1, summary: 'new')};
    expect(mergeProgress(older, newer)['b']!.summary, 'new');
    expect(mergeProgress(newer, older)['b']!.summary, 'new');
  });

  test('merge: later review activity wins between two lit stars', () {
    final reviewedLater = {
      'a': NodeProgress(completedAt: t0, reviewStage: 3, nextReviewAt: t1),
    };
    final reviewedEarlier = {
      'a': NodeProgress(completedAt: t0, reviewStage: 1, nextReviewAt: t0),
    };
    expect(mergeProgress(reviewedEarlier, reviewedLater)['a']!.reviewStage, 3);
    expect(mergeProgress(reviewedLater, reviewedEarlier)['a']!.reviewStage, 3);
  });

  test('merge: disjoint keys union; journal closed beats open', () {
    final p = mergeProgress({'a': NodeProgress(completedAt: t0)},
        {'b': NodeProgress(completedAt: t1)});
    expect(p.keys, containsAll(['a', 'b']));

    final open = {
      'd1': const JournalEntry(
          day: 'd1', transcript: [JournalTurn('user', 'draft')])
    };
    final closed = {
      'd1': JournalEntry(day: 'd1', closedAt: t0),
      'd2': JournalEntry(day: 'd2', closedAt: t1),
    };
    final j = mergeJournal(open, closed);
    expect(j['d1']!.closed, isTrue);
    expect(j.length, 2);
    // Reversed: the closed local entry survives an open import.
    expect(mergeJournal(closed, open)['d1']!.closed, isTrue);
  });
}
