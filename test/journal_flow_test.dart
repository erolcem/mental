// The Journal screen end-to-end: converse with a scripted Confidant, close
// the day into actions, and verify the galaxy's banner/bar react.
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mental/data/api_client.dart';
import 'package:mental/data/repository.dart';
import 'package:mental/state/providers.dart';
import 'package:mental/ui/galaxy_screen.dart';
import 'package:mental/ui/journal_screen.dart';
import 'package:mental/ui/theme.dart';

MentalApi confidantApi() => MentalApi(
      baseUrl: 'https://examiner.test',
      token: 't',
      client: MockClient((req) async {
        if (req.url.path == '/journal/reply') {
          return http.Response(
              jsonEncode({'reply': 'What broke the Anki streak today?'}), 200,
              headers: {'content-type': 'application/json'});
        }
        return http.Response(
            jsonEncode({
              'actions': ['Do 20 Anki reps before noon', 'Read Rudin 7.4'],
              'reflection': 'Guard the morning before the day claims it.',
            }),
            200,
            headers: {'content-type': 'application/json'});
      }),
    );

Widget app(JournalRepository journal, MentalApi api, Widget home) =>
    ProviderScope(
      overrides: [
        repositoryProvider.overrideWithValue(InMemoryProgressRepository()),
        journalRepositoryProvider.overrideWithValue(journal),
        apiProvider.overrideWithValue(api),
      ],
      child: MaterialApp(theme: buildTheme(), home: home),
    );

void phone(WidgetTester tester) {
  tester.view.physicalSize = const Size(1170, 2532);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
}

void main() {
  testWidgets('journal: greet → converse → close → actions + reflection',
      (tester) async {
    phone(tester);
    final repo = InMemoryJournalRepository();
    await tester.pumpWidget(app(repo, confidantApi(), const JournalScreen()));
    await tester.pump(const Duration(milliseconds: 300));

    // The Confidant greets first.
    expect(find.textContaining('Tell me about your day'), findsOneWidget);

    await tester.enterText(find.byType(TextField),
        'Did 40 mins of Rudin but skipped Anki again.');
    await tester.pump();
    await tester.tap(find.byIcon(Icons.arrow_upward));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('What broke the Anki streak today?'), findsOneWidget);

    await tester.tap(find.textContaining('CLOSE THE DAY'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.textContaining('Guard the morning'), findsOneWidget);
    expect(find.text('Do 20 Anki reps before noon'), findsOneWidget);
    final today = dayKey(DateTime.now());
    final saved = repo.loadJournal()[today]!;
    expect(saved.closed, isTrue);
    expect(saved.actions.length, 2);
    expect(saved.transcript.length, 3); // greet + user + reply
  });

  testWidgets('galaxy: journal banner when overdue; bottom bar toggles action',
      (tester) async {
    phone(tester);
    final repo = InMemoryJournalRepository();
    // Last closed session two days ago with actions → overdue AND today-list.
    final twoDaysAgo = dayKey(DateTime.now().subtract(const Duration(days: 2)));
    repo.saveJournalEntry(JournalEntry(
      day: twoDaysAgo,
      transcript: const [JournalTurn('user', 'day')],
      actions: const [ActionItem('Do Anki')],
      closedAt: DateTime.now().subtract(const Duration(days: 2)),
    ));
    await tester.pumpWidget(
        app(repo, MentalApi(baseUrl: '', token: ''), const GalaxyScreen()));
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.textContaining('JOURNAL WENT UNWRITTEN'), findsOneWidget);
    expect(find.textContaining('TODAY\'S ACTIONS   0 / 1'), findsOneWidget);

    await tester.tap(find.textContaining('TODAY\'S ACTIONS'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.tap(find.text('Do Anki'));
    await tester.pump(const Duration(milliseconds: 100));
    expect(repo.loadJournal()[twoDaysAgo]!.actions[0].done, isTrue);
  });

  testWidgets('honour mode: self-written actions close the day',
      (tester) async {
    phone(tester);
    final repo = InMemoryJournalRepository();
    await tester.pumpWidget(
        app(repo, MentalApi(baseUrl: '', token: ''), const JournalScreen()));
    await tester.pump(const Duration(milliseconds: 300));

    await tester.enterText(
        find.byType(TextField).first, 'Solid day, mostly deep work.');
    await tester.pump();
    await tester.tap(find.byIcon(Icons.arrow_upward));
    await tester.pump(const Duration(milliseconds: 100));

    await tester.tap(find.textContaining('CLOSE THE DAY'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    // Honour dialog: write one action, confirm.
    expect(find.textContaining('set 1–3 concrete actions'), findsOneWidget);
    await tester.enterText(
        find.byType(TextField).at(1), 'Ship the report draft');
    await tester.tap(find.text('Close the day'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400)); // dialog exit anim
    await tester.pump(const Duration(milliseconds: 400));

    final saved = repo.loadJournal()[dayKey(DateTime.now())]!;
    expect(saved.closed, isTrue);
    expect(saved.actions.single.text, 'Ship the report draft');
    expect(find.text('Ship the report draft'), findsOneWidget);
  });
}
