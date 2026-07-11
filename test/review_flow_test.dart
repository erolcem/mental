// The Review screen end-to-end: locked galaxy banner, quiz over a scripted
// Reviewer, pass unlocks the sky; honour mode self-attests.
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
import 'package:mental/ui/galaxy_screen.dart';
import 'package:mental/ui/review_screen.dart';
import 'package:mental/ui/theme.dart';

ProgressRepository repoWithDueReview() {
  final repo = InMemoryProgressRepository();
  repo.save(
      progressKey('maths', 'm1'),
      NodeProgress(
        completedAt: DateTime.now().subtract(const Duration(days: 10)),
        summary: 'Axler: vector spaces, eigenvalues without determinants.',
        nextReviewAt: DateTime.now().subtract(const Duration(days: 1)),
      ));
  return repo;
}

MentalApi reviewerApi({required bool pass}) => MentalApi(
      baseUrl: 'https://examiner.test',
      token: 't',
      client: MockClient((req) async {
        if (req.url.path == '/review/questions') {
          return http.Response(
              jsonEncode({
                'questions': [
                  'Explain eigenvalues à la Axler.',
                  'Apply rank-nullity.'
                ]
              }),
              200,
              headers: {'content-type': 'application/json'});
        }
        return http.Response(
            jsonEncode({
              'passed': pass,
              'feedback': pass ? 'Still alive.' : 'Faded.',
              'notes': ['a', 'b'],
            }),
            200,
            headers: {'content-type': 'application/json'});
      }),
    );

Widget app(ProgressRepository repo, MentalApi api, Widget home) =>
    ProviderScope(
      overrides: [
        repositoryProvider.overrideWithValue(repo),
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
  testWidgets('locked galaxy shows the banner; unlocked does not',
      (tester) async {
    phone(tester);
    await tester.pumpWidget(app(repoWithDueReview(),
        MentalApi(baseUrl: '', token: ''), const GalaxyScreen()));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.textContaining('SKY LOCKED'), findsOneWidget);

    await tester.pumpWidget(app(InMemoryProgressRepository(),
        MentalApi(baseUrl: '', token: ''), const GalaxyScreen()));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.textContaining('SKY LOCKED'), findsNothing);
  });

  testWidgets('quiz pass: interval climbs, sky unlocks', (tester) async {
    phone(tester);
    final repo = repoWithDueReview();
    await tester
        .pumpWidget(app(repo, reviewerApi(pass: true), const ReviewScreen()));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.textContaining('star demands review'), findsOneWidget);
    await tester.tap(find.textContaining('BEGIN THE REVIEW'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.textContaining('Explain eigenvalues'), findsOneWidget);
    final fields = find.byType(TextField);
    expect(fields, findsNWidgets(2));
    await tester.enterText(
        fields.at(0), 'Invariant subspaces replace determinants.');
    await tester.enterText(
        fields.at(1), 'Kernel dimension revealed a hidden constraint.');
    await tester.pump();
    await tester.tap(find.text('SUBMIT ANSWERS'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('THE STAR HOLDS ITS LIGHT'), findsOneWidget);
    final np = repo.load()[progressKey('maths', 'm1')]!;
    expect(np.reviewStage, 1);
    expect(np.nextReviewAt!.isAfter(DateTime.now()), isTrue);
    expect(skyLocked(repo.load(), DateTime.now()), isFalse);
    expect(find.text('RETURN TO THE UNLOCKED SKY'), findsOneWidget);
  });

  testWidgets('quiz fail: rung falls, star returns tomorrow, sky unlocked',
      (tester) async {
    phone(tester);
    final repo = repoWithDueReview();
    await tester
        .pumpWidget(app(repo, reviewerApi(pass: false), const ReviewScreen()));
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.textContaining('BEGIN THE REVIEW'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), 'um');
    await tester.enterText(fields.at(1), 'not sure');
    await tester.pump();
    await tester.tap(find.text('SUBMIT ANSWERS'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('THE LIGHT IS FADING'), findsOneWidget);
    final np = repo.load()[progressKey('maths', 'm1')]!;
    expect(np.reviewStage, 0);
    final hoursOut = np.nextReviewAt!.difference(DateTime.now()).inHours;
    expect(hoursOut, inInclusiveRange(20, 26)); // back tomorrow
    expect(skyLocked(repo.load(), DateTime.now()), isFalse,
        reason: 'a faced review unlocks even when failed');
  });

  testWidgets('honour mode: self-attest passes the review', (tester) async {
    phone(tester);
    final repo = repoWithDueReview();
    await tester.pumpWidget(
        app(repo, MentalApi(baseUrl: '', token: ''), const ReviewScreen()));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.textContaining('I HAVE REVIEWED THIS STAR'), findsOneWidget);
    await tester.tap(find.textContaining('I HAVE REVIEWED THIS STAR'));
    await tester.pump(const Duration(milliseconds: 100));

    expect(repo.load()[progressKey('maths', 'm1')]!.reviewStage, 1);
    expect(skyLocked(repo.load(), DateTime.now()), isFalse);
  });
}
