// The two seals on the sky, verified end-to-end through the REAL provider
// wiring (no injected fakes): a journal missed yesterday or a review past due
// must (a) swap the node sheet's ignite button for the lock, (b) make
// ProgressNotifier.ignite a no-op, and (c) lift the moment the debt is paid.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mental/data/api_client.dart';
import 'package:mental/data/repository.dart';
import 'package:mental/data/skill_data.dart';
import 'package:mental/state/providers.dart';
import 'package:mental/ui/node_sheet.dart';
import 'package:mental/ui/theme.dart';

class _Harness extends ConsumerWidget {
  final Skill skill;
  final SkillNode node;
  const _Harness({required this.skill, required this.node});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => showNodeSheet(context, ref,
              stat: statById('INT'), skill: skill, node: node),
          child: const Text('open'),
        ),
      ),
    );
  }
}

void main() {
  final maths = skillById('maths');

  JournalEntry closedOn(String day) => JournalEntry(
      day: day,
      transcript: const [JournalTurn('user', 'my day')],
      closedAt: DateTime.now());

  Future<ProviderContainer> pump(
    WidgetTester tester, {
    required ProgressRepository progressRepo,
    required JournalRepository journalRepo,
    String nodeId = 'm1',
  }) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(ProviderScope(
      overrides: [
        repositoryProvider.overrideWithValue(progressRepo),
        journalRepositoryProvider.overrideWithValue(journalRepo),
        apiProvider.overrideWithValue(MentalApi(baseUrl: '', token: '')),
      ],
      child: MaterialApp(
          theme: buildTheme(),
          home: _Harness(skill: maths, node: maths.nodeById(nodeId))),
    ));
    await tester.tap(find.text('open'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    final ctx = tester.element(find.byType(_Harness));
    return ProviderScope.containerOf(ctx, listen: false);
  }

  testWidgets(
      'journal missed yesterday → sheet shows the journal seal and '
      'ignition refuses; journaling today lifts it', (tester) async {
    final journalRepo = InMemoryJournalRepository();
    // The habit began two days ago and yesterday went unwritten.
    final twoDaysAgo = dayKey(DateTime.now().subtract(const Duration(days: 2)));
    journalRepo.saveJournalEntry(closedOn(twoDaysAgo));

    final container = await pump(tester,
        progressRepo: InMemoryProgressRepository(), journalRepo: journalRepo);

    expect(container.read(journalOverdueProvider), isTrue);
    expect(container.read(skyLockedProvider), isTrue);
    expect(find.textContaining('JOURNAL YOUR DAY'), findsOneWidget);
    expect(find.textContaining('IGNITE STAR'), findsNothing);

    // Even a direct ignite call must refuse while the seal holds.
    container
        .read(progressProvider.notifier)
        .ignite(maths, maths.nodeById('m1'));
    expect(
        container.read(progressProvider)[progressKey('maths', 'm1')]?.complete ??
            false,
        isFalse);

    // Tonight's journal closes → the seal lifts and ignition works.
    container
        .read(journalProvider.notifier)
        .save(closedOn(dayKey(DateTime.now())));
    expect(container.read(journalOverdueProvider), isFalse);
    expect(container.read(skyLockedProvider), isFalse);
    container
        .read(progressProvider.notifier)
        .ignite(maths, maths.nodeById('m1'));
    expect(
        container.read(progressProvider)[progressKey('maths', 'm1')]!.complete,
        isTrue);
  });

  testWidgets(
      'review past due → sheet shows the review seal and ignition refuses; '
      'passing the review lifts it', (tester) async {
    final progressRepo = InMemoryProgressRepository();
    // m1 was ignited long ago and its review date has passed.
    progressRepo.save(
        progressKey('maths', 'm1'),
        NodeProgress(
            completedAt: DateTime.now().subtract(const Duration(days: 10)),
            reviewStage: 0,
            nextReviewAt: DateTime.now().subtract(const Duration(days: 2))));

    // m2 is unlocked (its prerequisite m1 is lit) but the sky is sealed.
    final container = await pump(tester,
        progressRepo: progressRepo,
        journalRepo: InMemoryJournalRepository(),
        nodeId: 'm2');

    expect(container.read(dueReviewsProvider), isNotEmpty);
    expect(container.read(skyLockedProvider), isTrue);
    expect(find.textContaining('FACE YOUR REVIEWS'), findsOneWidget);
    expect(find.textContaining('IGNITE STAR'), findsNothing);

    container
        .read(progressProvider.notifier)
        .ignite(maths, maths.nodeById('m2'));
    expect(
        container.read(progressProvider)[progressKey('maths', 'm2')]?.complete ??
            false,
        isFalse);

    // Facing the review (a pass) reschedules it and unseals the sky.
    container.read(progressProvider.notifier).recordReviewPass('maths', 'm1');
    container.invalidate(dueReviewsProvider);
    expect(container.read(skyLockedProvider), isFalse);
    container
        .read(progressProvider.notifier)
        .ignite(maths, maths.nodeById('m2'));
    expect(
        container.read(progressProvider)[progressKey('maths', 'm2')]!.complete,
        isTrue);
  });

  testWidgets('reviews take precedence over the journal when both block',
      (tester) async {
    final progressRepo = InMemoryProgressRepository();
    progressRepo.save(
        progressKey('maths', 'm1'),
        NodeProgress(
            completedAt: DateTime.now().subtract(const Duration(days: 10)),
            nextReviewAt: DateTime.now().subtract(const Duration(days: 1))));
    final journalRepo = InMemoryJournalRepository();
    journalRepo.saveJournalEntry(
        closedOn(dayKey(DateTime.now().subtract(const Duration(days: 3)))));

    await pump(tester,
        progressRepo: progressRepo, journalRepo: journalRepo, nodeId: 'm2');
    expect(find.textContaining('FACE YOUR REVIEWS'), findsOneWidget);
  });

  testWidgets('a fresh sky (no journal habit, no reviews) is unsealed',
      (tester) async {
    final container = await pump(tester,
        progressRepo: InMemoryProgressRepository(),
        journalRepo: InMemoryJournalRepository());
    expect(container.read(skyLockedProvider), isFalse);
    expect(find.textContaining('IGNITE STAR'), findsOneWidget);
  });
}
