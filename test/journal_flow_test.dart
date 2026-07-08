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

/// Captures each request body so tests can assert what the Confidant was
/// actually told (yesterday's loop, the habit ledger).
final List<Map<String, dynamic>> confidantSaw = [];

MentalApi confidantApi() => MentalApi(
      baseUrl: 'https://examiner.test',
      token: 't',
      client: MockClient((req) async {
        confidantSaw.add(jsonDecode(req.body) as Map<String, dynamic>);
        if (req.url.path == '/journal/reply') {
          return http.Response(
              jsonEncode({'reply': 'What broke the Anki streak today?'}), 200,
              headers: {'content-type': 'application/json'});
        }
        return http.Response(
            jsonEncode({
              'actions': ['Do 20 Anki reps before noon', 'Read Rudin 7.4'],
              'reflection': 'Guard the morning before the day claims it.',
              'rationale': 'Anki kept 6/7 — one notch up; Rudin continues.',
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
  testWidgets(
      'journal: greet → converse → close → actions + reflection + rationale, '
      'with the habit ledger on the wire', (tester) async {
    phone(tester);
    confidantSaw.clear();
    final repo = InMemoryJournalRepository();
    // Two closed days of history → the advisor must receive a ledger.
    final past = dayKey(DateTime.now().subtract(const Duration(days: 1)));
    repo.saveJournalEntry(JournalEntry(
      day: past,
      transcript: const [JournalTurn('user', 'day')],
      actions: const [
        ActionItem('Do 15 Anki reps', done: true),
        ActionItem('Run 5k'),
      ],
      rationale: 'Started small on purpose.',
      closedAt: DateTime.now().subtract(const Duration(days: 1)),
    ));
    await tester.pumpWidget(app(repo, confidantApi(), const JournalScreen()));
    await tester.pump(const Duration(milliseconds: 300));

    // The Confidant greets first (with yesterday's actions on the table).
    expect(find.textContaining('how did you fare'), findsOneWidget);

    await tester.enterText(find.byType(TextField),
        'Did 40 mins of Rudin but skipped Anki again.');
    await tester.pump();
    await tester.tap(find.byIcon(Icons.arrow_upward));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('What broke the Anki streak today?'), findsOneWidget);

    // The reply request carried the advisor's memory.
    final replyReq = confidantSaw.first;
    expect(replyReq['history'], contains('HABIT LEDGER'));
    expect(replyReq['history'], contains('[x] Do 15 Anki reps'));
    expect(replyReq['history'], contains('[ ] Run 5k'));
    expect(replyReq['history'], contains('advisor: Started small on purpose.'));

    await tester.tap(find.textContaining('CLOSE THE DAY'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.textContaining('Guard the morning'), findsOneWidget);
    expect(find.text('Do 20 Anki reps before noon'), findsOneWidget);
    // The advisor's reasoning is shown and remembered.
    expect(find.textContaining('one notch up'), findsOneWidget);
    expect(confidantSaw.last['history'], contains('HABIT LEDGER'));
    final today = dayKey(DateTime.now());
    final saved = repo.loadJournal()[today]!;
    expect(saved.closed, isTrue);
    expect(saved.actions.length, 2);
    expect(saved.rationale, contains('one notch up'));
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
