// Spaced-repetition rules: scheduling on ignition, ladder climb/fall, the sky
// lockout, and the upgrade migration for pre-review stars.
import 'package:flutter_test/flutter_test.dart';
import 'package:mental/data/repository.dart';
import 'package:mental/data/skill_data.dart';
import 'package:mental/state/providers.dart';

void main() {
  final maths = skillById('maths');
  SkillNode node(String id) => maths.nodeById(id);
  ProgressNotifier fresh([ProgressRepository? repo]) =>
      ProgressNotifier(repo ?? InMemoryProgressRepository());

  NodeProgress p(ProgressNotifier n, String id) =>
      n.state[progressKey('maths', id)]!;

  test('ignition starts the review clock at the first interval', () {
    final n = fresh();
    final before = DateTime.now();
    n.ignite(maths, node('m1'));
    final np = p(n, 'm1');
    expect(np.reviewStage, 0);
    expect(np.nextReviewAt, isNotNull);
    final days = np.nextReviewAt!.difference(before).inHours / 24.0;
    expect(days, closeTo(kReviewIntervalDays[0], 0.1));
  });

  test('passing climbs the ladder; the top rung repeats', () {
    final n = fresh();
    n.ignite(maths, node('m1'));
    final t = DateTime(2026, 7, 2);
    for (var i = 1; i < kReviewIntervalDays.length; i++) {
      n.recordReviewPass('maths', 'm1', now: t);
      expect(p(n, 'm1').reviewStage, i);
      expect(p(n, 'm1').nextReviewAt,
          t.add(Duration(days: kReviewIntervalDays[i])));
    }
    n.recordReviewPass('maths', 'm1', now: t); // beyond the top
    expect(p(n, 'm1').reviewStage, kReviewIntervalDays.length - 1);
  });

  test('failing falls one rung and returns tomorrow', () {
    final n = fresh();
    n.ignite(maths, node('m1'));
    final t = DateTime(2026, 7, 2);
    n.recordReviewPass('maths', 'm1', now: t); // stage 1
    n.recordReviewPass('maths', 'm1', now: t); // stage 2
    n.recordReviewFail('maths', 'm1', now: t);
    expect(p(n, 'm1').reviewStage, 1);
    expect(p(n, 'm1').nextReviewAt,
        t.add(const Duration(days: kFailedReviewRetryDays)));
    n.recordReviewFail('maths', 'm1', now: t);
    n.recordReviewFail('maths', 'm1', now: t); // floor at 0
    expect(p(n, 'm1').reviewStage, 0);
  });

  test('overdue review locks the sky and blocks new ignitions', () {
    final n = fresh();
    n.ignite(maths, node('m1'));
    expect(skyLocked(n.state, DateTime.now()), isFalse);

    // Time-travel: force the review overdue.
    final key = progressKey('maths', 'm1');
    n.repo.save(
        key,
        n.state[key]!.copyWith(
            nextReviewAt: DateTime.now().subtract(const Duration(days: 1))));
    final n2 = ProgressNotifier(n.repo);
    expect(skyLocked(n2.state, DateTime.now()), isTrue);
    expect(dueReviews(n2.state, DateTime.now()).single.node.id, 'm1');

    n2.ignite(maths, node('m2')); // m1 complete → m2 unlocked, but sky locked
    expect(n2.isComplete('maths', 'm2'), isFalse);

    n2.recordReviewPass('maths', 'm1');
    expect(skyLocked(n2.state, DateTime.now()), isFalse);
    n2.ignite(maths, node('m2'));
    expect(n2.isComplete('maths', 'm2'), isTrue);
  });

  test('extinguish clears the review schedule; re-ignition restarts it', () {
    final n = fresh();
    n.ignite(maths, node('m1'));
    n.recordReviewPass('maths', 'm1');
    n.extinguish(maths, node('m1'));
    expect(p(n, 'm1').nextReviewAt, isNull);
    expect(p(n, 'm1').reviewStage, 0);
    n.ignite(maths, node('m1'));
    expect(p(n, 'm1').nextReviewAt, isNotNull);
  });

  test('backfill gives pre-review stars a schedule from now, not ignition', () {
    final repo = InMemoryProgressRepository();
    // A star ignited "months ago" by the stage-1 build: no schedule fields.
    repo.save(progressKey('maths', 'm1'),
        NodeProgress(completedAt: DateTime(2026, 1, 1), summary: 'old'));
    final now = DateTime(2026, 7, 2);
    backfillReviewSchedules(repo, now: now);
    final np = repo.load()[progressKey('maths', 'm1')]!;
    expect(np.nextReviewAt, now.add(Duration(days: kReviewIntervalDays[0])));
    expect(skyLocked(repo.load(), now), isFalse,
        reason: 'upgrade must not greet the user with a lockout');
    // Idempotent: running again must not push the date further out.
    backfillReviewSchedules(repo, now: now.add(const Duration(days: 1)));
    expect(
        repo.load()[progressKey('maths', 'm1')]!.nextReviewAt, np.nextReviewAt);
  });

  test('review fields survive the JSON round-trip', () {
    final np = NodeProgress(
        completedAt: DateTime(2026, 7, 1),
        reviewStage: 3,
        nextReviewAt: DateTime(2026, 8, 1));
    final back = NodeProgress.fromJson(np.toJson());
    expect(back.reviewStage, 3);
    expect(back.nextReviewAt, DateTime(2026, 8, 1));
    expect(back.reviewDue(DateTime(2026, 8, 2)), isTrue);
    expect(back.reviewDue(DateTime(2026, 7, 20)), isFalse);
  });
}
