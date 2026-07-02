// End-to-end widget smoke: the galaxy renders, a constellation opens, and
// igniting a root star updates mastery on screen and in the repository.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mental/data/repository.dart';
import 'package:mental/data/skill_data.dart';
import 'package:mental/state/providers.dart';
import 'package:mental/ui/constellation_screen.dart';
import 'package:mental/ui/galaxy_screen.dart';
import 'package:mental/ui/theme.dart';

Widget app(ProgressRepository repo, Widget home) => ProviderScope(
      overrides: [repositoryProvider.overrideWithValue(repo)],
      child: MaterialApp(theme: buildTheme(), home: home),
    );

void phoneViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(1170, 2532); // iPhone-ish
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
}

void main() {
  testWidgets('galaxy shows all four stat orbs and skill stars',
      (tester) async {
    phoneViewport(tester);
    await tester
        .pumpWidget(app(InMemoryProgressRepository(), const GalaxyScreen()));
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('✦ MENTAL'), findsOneWidget);
    for (final id in ['INTELLIGENCE', 'WISDOM', 'CHARISMA', 'DEXTERITY']) {
      expect(find.text(id), findsOneWidget);
    }
    expect(find.text('MATHEMATICS'), findsOneWidget);
    expect(find.text('KARATE'), findsOneWidget);
  });

  testWidgets('tapping a skill star opens its constellation', (tester) async {
    phoneViewport(tester);
    await tester
        .pumpWidget(app(InMemoryProgressRepository(), const GalaxyScreen()));
    await tester.pump(const Duration(milliseconds: 400));

    await tester.tap(find.text('MATHEMATICS'));
    // Two pumps: one to insert the pushed route, one to run its transition.
    // (pumpAndSettle would never settle — the starfield animates forever.)
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text('Fields Medal / Proof Mastery'), findsOneWidget);
    expect(find.text('MASTERY'), findsOneWidget);
  });

  testWidgets('igniting a root star updates mastery and persists',
      (tester) async {
    phoneViewport(tester);
    final repo = InMemoryProgressRepository();
    await tester.pumpWidget(
        app(repo, const ConstellationScreen(statId: 'INT', skillId: 'maths')));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('0%'), findsOneWidget);

    // The node sheet's Ignite button calls exactly this notifier method.
    final ctx = tester.element(find.byType(ConstellationScreen));
    final container = ProviderScope.containerOf(ctx, listen: false);
    final maths = skillById('maths');
    container
        .read(progressProvider.notifier)
        .ignite(maths, maths.nodeById('m1'), summary: 'precalc mastered');
    await tester.pump(const Duration(milliseconds: 900));

    expect(find.text('6%'), findsOneWidget); // 1/18 nodes
    final saved = repo.load()[progressKey('maths', 'm1')];
    expect(saved, isNotNull);
    expect(saved!.complete, isTrue);
    expect(saved.summary, 'precalc mastered');
  });
}
