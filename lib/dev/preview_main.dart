// dev/preview_main.dart — development-only entrypoint for visual review and
// screenshots. Not shipped: the app builds from lib/main.dart.
//
//   flutter build linux -t lib/dev/preview_main.dart \
//     --dart-define=PREVIEW=constellation
//
// PREVIEW = galaxy | constellation | sheet | verify | locked | review | journal
//   (default: galaxy)
// verify = the node sheet against a fake Examiner that always fails.
// locked = the galaxy with overdue reviews (lock banner).
// review = the Review screen against a fake Reviewer (questions + pass).
// journal = the Journal mid-conversation against a fake Confidant.
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import '../data/api_client.dart';
import '../data/repository.dart';
import '../data/skill_data.dart';
import '../state/providers.dart';
import '../ui/constellation_screen.dart';
import '../ui/galaxy_screen.dart';
import '../ui/journal_screen.dart';
import '../ui/node_sheet.dart';
import '../ui/review_ledger.dart';
import '../ui/review_screen.dart';
import '../ui/theme.dart';

const _preview = String.fromEnvironment('PREVIEW', defaultValue: 'galaxy');

MentalApi _failingExaminer() => MentalApi(
      baseUrl: 'https://examiner.preview',
      token: 'preview',
      client: MockClient((_) async {
        await Future<void>.delayed(const Duration(milliseconds: 1500));
        return http.Response(
            jsonEncode({
              'verdict': 'fail',
              'confidence': 0.86,
              'feedback':
                  'You describe finishing Dummit & Foote but name no actual '
                      'structures — which groups did you classify, and what made '
                      'the Sylow theorems click for you? Show one proof you are '
                      'proud of.',
            }),
            200,
            headers: {'content-type': 'application/json'});
      }),
    );

MentalApi _fakeReviewer() => MentalApi(
      baseUrl: 'https://examiner.preview',
      token: 'preview',
      client: MockClient((req) async {
        await Future<void>.delayed(const Duration(milliseconds: 1200));
        final body = req.url.path.endsWith('/review/questions')
            ? {
                'questions': [
                  'Without notes: explain why eigenvalues can be developed '
                      'without determinants, as Axler does. What replaces them?',
                  'Give one concrete situation where the rank-nullity theorem '
                      'told you something non-obvious about a linear map.',
                ]
              }
            : {
                'passed': true,
                'feedback':
                    'The Axler viewpoint survived the gap — invariant subspaces '
                        'came back cleanly and your rank-nullity example was your '
                        'own. This light holds.',
                'notes': ['Clean and specific.', 'Own example — convincing.'],
              };
        return http.Response(jsonEncode(body), 200,
            headers: {'content-type': 'application/json'});
      }),
    );

MentalApi _fakeConfidant() => MentalApi(
      baseUrl: 'https://examiner.preview',
      token: 'preview',
      client: MockClient((req) async {
        await Future<void>.delayed(const Duration(milliseconds: 1000));
        final body = req.url.path.endsWith('/journal/reply')
            ? {
                'reply': 'Rudin held but Anki slipped for the second night — '
                    'the pattern is the evening, not the will. What could you '
                    'move so the reps happen before the day gets loud?'
              }
            : {
                'actions': [
                  'Do 20 Anki reps of the m4 deck before noon',
                  'Read Rudin 7.4 and write the sup-norm summary paragraph',
                ],
                'reflection': 'Guard the morning before the day claims it.',
              };
        return http.Response(jsonEncode(body), 200,
            headers: {'content-type': 'application/json'});
      }),
    );

void main() {
  // Seed a believable mid-journey state: the first chunk of maths ignited,
  // a couple of roots elsewhere.
  final repo = InMemoryProgressRepository();
  void lit(String skillId, String nodeId) => repo.save(
      progressKey(skillId, nodeId),
      NodeProgress(
          completedAt: DateTime(2026, 6, 1),
          summary: 'Seeded preview progress.'));
  for (final id in ['m1', 'm2', 'm3', 'm4', 'm5', 'm6', 'm7', 'm23', 'm22']) {
    lit('maths', id);
  }
  lit('science', 'sc1');
  lit('piano', 'p1');
  lit('karate', 'k1');
  lit('karate', 'k2');
  // A draft summary on the next frontier node so the verify preview opens
  // with a submittable sheet.
  repo.save(
      progressKey('maths', 'm8'),
      const NodeProgress(
          summary: 'Finished Dummit & Foote parts I-II: groups through Galois '
              'basics. Proved all of chapter 4\'s Sylow exercises and built a '
              'cheat-sheet of the isomorphism theorems from memory.'));

  // Locked/review modes: two stars overdue for review.
  if (_preview == 'locked' || _preview == 'review' || _preview == 'ledger') {
    final overdue = DateTime.now().subtract(const Duration(days: 2));
    for (final id in ['m4', 'm7']) {
      repo.save(
          progressKey('maths', id),
          repo
              .load()[progressKey('maths', id)]!
              .copyWith(nextReviewAt: overdue));
    }
  }

  // Journal state: yesterday's closed session set two actions (one done),
  // and tonight's session has begun.
  final journalRepo = InMemoryJournalRepository();
  final now = DateTime.now();
  String dk(DateTime t) =>
      '${t.year.toString().padLeft(4, '0')}-${t.month.toString().padLeft(2, '0')}-${t.day.toString().padLeft(2, '0')}';
  journalRepo.saveJournalEntry(JournalEntry(
    day: dk(now.subtract(const Duration(days: 1))),
    transcript: const [JournalTurn('user', 'yesterday')],
    actions: const [
      ActionItem('Do 20 Anki reps of the m4 deck', done: true),
      ActionItem('Read Rudin 7.3 before dinner'),
    ],
    reflection: 'Consistency beats intensity.',
    closedAt: now.subtract(const Duration(days: 1)),
  ));
  if (_preview == 'journal') {
    journalRepo.saveJournalEntry(JournalEntry(
      day: dk(now),
      transcript: const [
        JournalTurn('ai',
            'The stars are out. How did the day go — and how did you fare with what you set for yourself?'),
        JournalTurn('user',
            'Anki done before breakfast for once. Rudin only got 30 minutes though — dinner ran long and I lost the evening.'),
      ],
    ));
  }

  runApp(ProviderScope(
    overrides: [
      repositoryProvider.overrideWithValue(repo),
      journalRepositoryProvider.overrideWithValue(journalRepo),
      if (_preview == 'verify')
        apiProvider.overrideWithValue(_failingExaminer()),
      if (_preview == 'review') apiProvider.overrideWithValue(_fakeReviewer()),
      if (_preview == 'journal')
        apiProvider.overrideWithValue(_fakeConfidant()),
    ],
    child: MaterialApp(
      title: 'Mental (preview)',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: switch (_preview) {
        'constellation' =>
          const ConstellationScreen(statId: 'INT', skillId: 'maths'),
        'sheet' || 'verify' => const _SheetPreview(),
        'review' => const ReviewScreen(),
        'journal' => const JournalScreen(),
        'ledger' => const _LedgerPreview(),
        _ => const GalaxyScreen(),
      },
    ),
  ));
}

/// Opens the Review Ledger over the galaxy.
class _LedgerPreview extends StatefulWidget {
  const _LedgerPreview();
  @override
  State<_LedgerPreview> createState() => _LedgerPreviewState();
}

class _LedgerPreviewState extends State<_LedgerPreview> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => showReviewLedger(context));
  }

  @override
  Widget build(BuildContext context) => const GalaxyScreen();
}

/// Opens the maths m8 node sheet (unlocked, unlit) over its constellation.
class _SheetPreview extends ConsumerStatefulWidget {
  const _SheetPreview();
  @override
  ConsumerState<_SheetPreview> createState() => _SheetPreviewState();
}

class _SheetPreviewState extends ConsumerState<_SheetPreview> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final skill = skillById('maths');
      showNodeSheet(context, ref,
          stat: statById('INT'), skill: skill, node: skill.nodeById('m8'));
    });
  }

  @override
  Widget build(BuildContext context) =>
      const ConstellationScreen(statId: 'INT', skillId: 'maths');
}
