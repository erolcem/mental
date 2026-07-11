// The two locks, end to end: a due review seals the sky against ignition
// through the real skyLocked path, and a missed journal seals it through the
// real Riverpod wiring (journalProvider → extraLock → ignite). These are the
// guarantees the whole discipline loop rests on: you cannot use the nodes
// while yesterday's journal is unwritten or a review is due.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mental/data/repository.dart';
import 'package:mental/data/skill_data.dart';
import 'package:mental/state/providers.dart';

void main() {
  final maths = skillById('maths');

  test('a due review locks ignition everywhere until it is faced', () {
    final repo = InMemoryProgressRepository();
    // A star ignited long ago whose review date has passed.
    repo.save(
        progressKey('science', 'sc1'),
        NodeProgress(
          completedAt: DateTime.now().subtract(const Duration(days: 10)),
          summary: 'AP work done',
          nextReviewAt: DateTime.now().subtract(const Duration(days: 1)),
        ));
    final n = ProgressNotifier(repo);

    expect(skyLocked(n.state, DateTime.now()), isTrue);
    n.ignite(maths, maths.nodeById('m1'));
    expect(n.isComplete('maths', 'm1'), isFalse,
        reason: 'the sky is locked — no new ignitions');

    // Facing the review (even failing it) reschedules and unlocks the sky.
    n.recordReviewFail('science', 'sc1');
    expect(skyLocked(n.state, DateTime.now()), isFalse);
    n.ignite(maths, maths.nodeById('m1'));
    expect(n.isComplete('maths', 'm1'), isTrue);
  });

  test('missed journal locks ignition through the real provider wiring', () {
    final journalRepo = InMemoryJournalRepository();
    // The habit began three days ago and then went silent → overdue today.
    final past = dayKey(DateTime.now().subtract(const Duration(days: 3)));
    journalRepo.saveJournalEntry(JournalEntry(
      day: past,
      transcript: const [JournalTurn('user', 'my day')],
      actions: const [ActionItem('Do Anki')],
      closedAt: DateTime.now().subtract(const Duration(days: 3)),
    ));

    final container = ProviderContainer(overrides: [
      repositoryProvider.overrideWithValue(InMemoryProgressRepository()),
      journalRepositoryProvider.overrideWithValue(journalRepo),
    ]);
    addTearDown(container.dispose);

    expect(container.read(journalOverdueProvider), isTrue);
    final notifier = container.read(progressProvider.notifier);
    notifier.ignite(maths, maths.nodeById('m1'));
    expect(notifier.isComplete('maths', 'm1'), isFalse,
        reason: 'yesterday went unjournaled — the sky must refuse');

    // Closing today's session lifts the lock with no restart.
    final today = dayKey(DateTime.now());
    container.read(journalProvider.notifier).save(JournalEntry(
          day: today,
          transcript: const [JournalTurn('user', 'today')],
          actions: const [ActionItem('One thing')],
          closedAt: DateTime.now(),
        ));
    notifier.ignite(maths, maths.nodeById('m1'));
    expect(notifier.isComplete('maths', 'm1'), isTrue,
        reason: 'journal closed → the sky opens again');
  });

  test('both locks at once: clearing only one keeps the sky sealed', () {
    final progressRepo = InMemoryProgressRepository();
    progressRepo.save(
        progressKey('science', 'sc1'),
        NodeProgress(
          completedAt: DateTime.now().subtract(const Duration(days: 10)),
          nextReviewAt: DateTime.now().subtract(const Duration(hours: 2)),
        ));
    final journalRepo = InMemoryJournalRepository();
    final past = dayKey(DateTime.now().subtract(const Duration(days: 2)));
    journalRepo.saveJournalEntry(JournalEntry(
      day: past,
      transcript: const [JournalTurn('user', 'day')],
      closedAt: DateTime.now().subtract(const Duration(days: 2)),
    ));

    final container = ProviderContainer(overrides: [
      repositoryProvider.overrideWithValue(progressRepo),
      journalRepositoryProvider.overrideWithValue(journalRepo),
    ]);
    addTearDown(container.dispose);
    final notifier = container.read(progressProvider.notifier);

    // Face the review — the journal debt still seals the sky.
    notifier.recordReviewPass('science', 'sc1');
    notifier.ignite(maths, maths.nodeById('m1'));
    expect(notifier.isComplete('maths', 'm1'), isFalse);

    // Close today's journal too — now the sky opens.
    container.read(journalProvider.notifier).save(JournalEntry(
          day: dayKey(DateTime.now()),
          transcript: const [JournalTurn('user', 'today')],
          closedAt: DateTime.now(),
        ));
    notifier.ignite(maths, maths.nodeById('m1'));
    expect(notifier.isComplete('maths', 'm1'), isTrue);
  });
}
