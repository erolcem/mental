// The examiner flow inside the node sheet: fail → feedback shown, star stays
// dark; pass → star ignites verified with the examiner's note stored.
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mental/data/api_client.dart';
import 'package:mental/data/repository.dart';
import 'package:mental/data/skill_data.dart';
import 'package:mental/state/providers.dart';
import 'package:mental/ui/node_sheet.dart';
import 'package:mental/ui/theme.dart';

/// A real MentalApi over a scripted MockClient — exercises the full HTTP path.
MentalApi scriptedApi(List<Map<String, dynamic>> verdicts) {
  var i = 0;
  return MentalApi(
    baseUrl: 'https://examiner.test',
    token: 't',
    client: MockClient((_) async => http.Response(
        jsonEncode(verdicts[i++ % verdicts.length]), 200,
        headers: {'content-type': 'application/json'})),
  );
}

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
  const longSummary =
      'Worked through Stewart chapters on limits, derivatives, integrals and '
      'series; solved ~400 problems, the hardest being volume integrals via '
      'shells. Epsilon arguments finally make sense to me now.';

  Future<ProviderContainer> pumpSheet(
      WidgetTester tester, MentalApi api, ProgressRepository repo) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(ProviderScope(
      overrides: [
        repositoryProvider.overrideWithValue(repo),
        apiProvider.overrideWithValue(api),
      ],
      child: MaterialApp(
          theme: buildTheme(),
          home: _Harness(skill: maths, node: maths.nodeById('m1'))),
    ));
    await tester.tap(find.text('open'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    final ctx = tester.element(find.byType(_Harness));
    return ProviderScope.containerOf(ctx, listen: false);
  }

  testWidgets('fail: feedback panel shows, star stays dark', (tester) async {
    final repo = InMemoryProgressRepository();
    final api = scriptedApi([
      {'verdict': 'fail', 'confidence': 0.9, 'feedback': 'Name the theorems you proved.'}
    ]);
    final container = await pumpSheet(tester, api, repo);

    await tester.enterText(find.byType(TextField), longSummary);
    await tester.pump();
    // The quest briefing sections make the sheet scroll on a phone.
    await tester.ensureVisible(find.textContaining('SUBMIT TO THE EXAMINER'));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.textContaining('SUBMIT TO THE EXAMINER'));
    await tester.pump(); // start async
    await tester.pump(const Duration(milliseconds: 100)); // resolve mock

    expect(find.text('THE EXAMINER IS NOT CONVINCED'), findsOneWidget);
    expect(find.text('Name the theorems you proved.'), findsOneWidget);
    expect(find.textContaining('RESUBMIT'), findsOneWidget);
    expect(
        container.read(progressProvider)[progressKey('maths', 'm1')]?.complete ??
            false,
        isFalse);
  });

  testWidgets('pass: sheet closes, star ignites verified with note',
      (tester) async {
    final repo = InMemoryProgressRepository();
    final api = scriptedApi([
      {'verdict': 'pass', 'confidence': 0.95, 'feedback': 'Specific and convincing.'}
    ]);
    final container = await pumpSheet(tester, api, repo);

    await tester.enterText(find.byType(TextField), longSummary);
    await tester.pump();
    await tester.ensureVisible(find.textContaining('SUBMIT TO THE EXAMINER'));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.textContaining('SUBMIT TO THE EXAMINER'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 400)); // sheet dismiss anim

    final np = container.read(progressProvider)[progressKey('maths', 'm1')];
    expect(np?.complete, isTrue);
    expect(np?.verified, isTrue);
    expect(np?.examinerNote, 'Specific and convincing.');
    expect(repo.load()[progressKey('maths', 'm1')]?.verified, isTrue);
  });

  testWidgets('submit disabled until the sheet meets the minimum length',
      (tester) async {
    final api = scriptedApi([
      {'verdict': 'pass', 'confidence': 1.0, 'feedback': 'ok'}
    ]);
    await pumpSheet(tester, api, InMemoryProgressRepository());

    await tester.enterText(find.byType(TextField), 'too short');
    await tester.pump();
    final button = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(button.onPressed, isNull);
    expect(find.textContaining('/ $kMinSummaryChars'), findsOneWidget);
  });

  testWidgets('offline (unconfigured api): honour-system ignite still works',
      (tester) async {
    final repo = InMemoryProgressRepository();
    final api = MentalApi(baseUrl: '', token: '');
    final container = await pumpSheet(tester, api, repo);

    expect(find.textContaining('IGNITE STAR'), findsOneWidget);
    await tester.ensureVisible(find.textContaining('IGNITE STAR'));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.textContaining('IGNITE STAR'));
    await tester.pump(const Duration(milliseconds: 400));

    final np = container.read(progressProvider)[progressKey('maths', 'm1')];
    expect(np?.complete, isTrue);
    expect(np?.verified, isFalse);
  });
}
