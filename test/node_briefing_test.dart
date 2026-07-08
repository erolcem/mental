// Every star must read as a legible quest: road, briefing, standard,
// prerequisites, what its light opens, and the rite — all computed from
// catalog structure, for all 431 stars.
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

  test('unlockedBy inverts requires for every star of every tree', () {
    for (final stat in catalog) {
      for (final sk in stat.skills) {
        for (final n in sk.tree) {
          for (final dep in sk.unlockedBy(n.id)) {
            expect(dep.requires, contains(n.id));
          }
        }
      }
    }
  });

  test('briefings: root, mid-braid and crown all read distinctly', () {
    final root = starBriefing(maths, maths.nodeById('m1'));
    expect(root, contains('begins here, with no prerequisites'));
    expect(root, contains('hours of deliberate work'));

    final mid = starBriefing(maths, maths.nodeById('m7')); // Real Analysis
    expect(mid, contains('Analysis branch'));
    expect(mid, contains('Tier'));

    // The crown: max tier, unlocks nothing.
    final crown = maths.tree.firstWhere((n) =>
        n.tier == maths.maxTier && maths.unlockedBy(n.id).isEmpty);
    expect(starBriefing(maths, crown), contains('crown of Mathematics'));

    // Every star in the whole catalog gets a non-empty briefing.
    for (final stat in catalog) {
      for (final sk in stat.skills) {
        for (final n in sk.tree) {
          expect(starBriefing(sk, n), isNotEmpty,
              reason: '${sk.id}.${n.id} must brief');
        }
      }
    }
  });

  testWidgets('the node sheet shows road, briefing, unlocks and the rite',
      (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(ProviderScope(
      overrides: [
        repositoryProvider.overrideWithValue(InMemoryProgressRepository()),
        apiProvider.overrideWithValue(MentalApi(baseUrl: '', token: '')),
      ],
      child: MaterialApp(
          theme: buildTheme(),
          home: _Harness(skill: maths, node: maths.nodeById('m1'))),
    ));
    await tester.tap(find.text('open'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.textContaining('THE ROAD ·'), findsOneWidget);
    expect(find.textContaining('PROVE AND PUBLISH'), findsOneWidget);
    expect(find.textContaining('begins here, with no prerequisites'),
        findsOneWidget);
    expect(find.textContaining('COMPLETION STANDARD'), findsOneWidget);
    expect(find.text('ITS LIGHT OPENS THE WAY TO'), findsOneWidget);
    // m1 opens m2 and m3 in the maths tree.
    expect(find.textContaining('Logic & Proofs'), findsOneWidget);
    expect(find.text('THE RITE OF IGNITION'), findsOneWidget);
    expect(find.textContaining('mastery sheet'), findsWidgets);
  });
}
