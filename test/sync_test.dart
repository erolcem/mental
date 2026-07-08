// Sky Link: the key's hygiene, the conservative merge laws (nothing lit or
// written is ever lost), the snapshot round-trip, and the controller's full
// pull → merge → push pass against a mock backend.
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mental/data/api_client.dart';
import 'package:mental/data/repository.dart';
import 'package:mental/data/skill_data.dart';
import 'package:mental/data/sync.dart';
import 'package:mental/state/providers.dart';
import 'package:mental/state/sync_controller.dart';

void main() {
  group('sky keys', () {
    test('forged keys are long, in-alphabet, and unique', () {
      final a = newSkyKey(), b = newSkyKey();
      expect(a.length, kSkyKeyLength);
      expect(a, isNot(b));
      expect(RegExp(r'^[ABCDEFGHJKMNPQRSTVWXYZ0-9]+$').hasMatch(a), isTrue,
          reason: 'no confusable I/L/O/U glyphs');
    });

    test('normalize forgives dashes, case and confusables', () {
      final key = newSkyKey();
      expect(normalizeSkyKey(prettySkyKey(key).toLowerCase()), key);
      // o→0, i/l→1 on a key that contains 0 and 1.
      const withDigits = 'A0B1CDEFGH23456789JKMNPQ';
      expect(
          normalizeSkyKey('a<o>b<i>cdefgh23456789jkmnpq'
              .replaceAll('<o>', 'o')
              .replaceAll('<i>', 'i')),
          withDigits);
      expect(normalizeSkyKey('too-short'), '');
      expect(normalizeSkyKey(''), '');
    });
  });

  group('merge laws', () {
    final now = DateTime(2026, 7, 8, 12);

    test('light beats dark, but the dark side\'s sheet survives', () {
      final lit = NodeProgress(completedAt: now, reviewStage: 1);
      const draft = NodeProgress(summary: 'my offline draft');
      final m = mergeNode(draft, lit);
      expect(m.complete, isTrue);
      expect(m.summary, 'my offline draft');
      // Symmetric.
      expect(mergeNode(lit, draft).summary, 'my offline draft');
    });

    test('both lit: the higher review rung carries the schedule', () {
      final behind = NodeProgress(
          completedAt: now,
          reviewStage: 0,
          nextReviewAt: now.add(const Duration(days: 3)));
      final ahead = NodeProgress(
          completedAt: now,
          reviewStage: 3,
          nextReviewAt: now.add(const Duration(days: 30)));
      expect(mergeNode(behind, ahead).reviewStage, 3);
      expect(mergeNode(ahead, behind).reviewStage, 3);
    });

    test('closed beats open; ticks given anywhere stay given', () {
      const open = JournalEntry(
          day: '2026-07-07',
          transcript: [JournalTurn('user', 'hello')]);
      final closedA = JournalEntry(
        day: '2026-07-07',
        actions: const [ActionItem('Anki', done: true), ActionItem('Run')],
        closedAt: DateTime(2026, 7, 7, 22),
      );
      final closedB = JournalEntry(
        day: '2026-07-07',
        actions: const [ActionItem('Anki'), ActionItem('Run', done: true)],
        closedAt: DateTime(2026, 7, 7, 23),
      );
      expect(mergeDay(open, closedA).closed, isTrue);
      final m = mergeDay(closedA, closedB);
      expect(m.closedAt, closedB.closedAt);
      expect(m.actions.every((a) => a.done), isTrue,
          reason: 'done-union across devices');
    });

    test('snapshot survives the round trip; corrupt blobs return null', () {
      final progress = {
        progressKey('maths', 'm1'):
            NodeProgress(completedAt: now, summary: 'sheet'),
      };
      final journal = {
        '2026-07-07': JournalEntry(
            day: '2026-07-07',
            actions: const [ActionItem('A', done: true)],
            rationale: 'why',
            closedAt: now),
      };
      final decoded = decodeSnapshot(encodeSnapshot(progress, journal))!;
      expect(decoded.progress[progressKey('maths', 'm1')]!.summary, 'sheet');
      expect(decoded.journal['2026-07-07']!.rationale, 'why');
      expect(decodeSnapshot('not json'), isNull);
    });
  });

  group('sync controller', () {
    test('pull → merge → push unions two devices\' skies', () async {
      final maths = skillById('maths');
      // THIS device: m1 lit locally, one journal day.
      final progressRepo = InMemoryProgressRepository();
      progressRepo.save(progressKey('maths', 'm1'),
          NodeProgress(completedAt: DateTime(2026, 7, 1), summary: 'local'));
      final journalRepo = InMemoryJournalRepository();
      journalRepo.saveJournalEntry(JournalEntry(
          day: '2026-07-06',
          transcript: const [JournalTurn('user', 'local day')],
          closedAt: DateTime(2026, 7, 6, 22)));

      // The OTHER device's snapshot lives on the server: m2 lit, another day.
      final remote = encodeSnapshot({
        progressKey('maths', 'm2'):
            NodeProgress(completedAt: DateTime(2026, 7, 3), summary: 'remote'),
      }, {
        '2026-07-05': JournalEntry(
            day: '2026-07-05',
            actions: const [ActionItem('Remote thing', done: true)],
            closedAt: DateTime(2026, 7, 5, 22)),
      });

      String? pushedBody;
      final api = MentalApi(
        baseUrl: 'https://examiner.test',
        token: 't',
        client: MockClient((req) async {
          if (req.url.path == '/sync/pull') {
            return http.Response(
                jsonEncode({
                  'data': remote,
                  'updated_at': '2026-07-07T00:00:00Z',
                  'device': 'other'
                }),
                200,
                headers: {'content-type': 'application/json'});
          }
          pushedBody = req.body;
          return http.Response(
              jsonEncode({'updated_at': '2026-07-08T00:00:00Z'}), 200,
              headers: {'content-type': 'application/json'});
        }),
      );

      final store = InMemorySyncKeyStore()..key = newSkyKey();
      final container = ProviderContainer(overrides: [
        repositoryProvider.overrideWithValue(progressRepo),
        journalRepositoryProvider.overrideWithValue(journalRepo),
        apiProvider.overrideWithValue(api),
        syncKeyStoreProvider.overrideWithValue(store),
      ]);
      addTearDown(container.dispose);

      await container.read(syncControllerProvider.notifier).syncNow();

      final state = container.read(syncControllerProvider);
      expect(state.error, isNull);
      expect(state.lastSync, isNotNull);
      expect(state.lastPulled, 2, reason: 'one node + one day merged in');
      // Local state now holds the union…
      final progress = container.read(progressProvider);
      expect(progress[progressKey('maths', 'm1')]!.complete, isTrue);
      expect(progress[progressKey('maths', 'm2')]!.complete, isTrue);
      expect(container.read(journalProvider)['2026-07-05'], isNotNull);
      // …and the union (not just local) was pushed back.
      expect(pushedBody, isNotNull);
      final pushed = jsonDecode(pushedBody!) as Map<String, dynamic>;
      final data = pushed['data'] as String;
      expect(data, contains('maths.m1'));
      expect(data, contains('maths.m2'));
      expect(data, contains('2026-07-05'));
      expect(data, contains('2026-07-06'));
      // The persistent unlock rules still hold on merged state: m2's deps.
      final notifier = container.read(progressProvider.notifier);
      expect(notifier.isUnlocked(maths, maths.nodeById('m2')), isTrue);
    });

    test('unlinked or offline builds never touch the network', () async {
      var called = false;
      final api = MentalApi(
        baseUrl: '', // unconfigured
        token: '',
        client: MockClient((req) async {
          called = true;
          return http.Response('{}', 200);
        }),
      );
      final container = ProviderContainer(overrides: [
        repositoryProvider.overrideWithValue(InMemoryProgressRepository()),
        journalRepositoryProvider.overrideWithValue(InMemoryJournalRepository()),
        apiProvider.overrideWithValue(api),
        syncKeyStoreProvider
            .overrideWithValue(InMemorySyncKeyStore()..key = newSkyKey()),
      ]);
      addTearDown(container.dispose);
      await container.read(syncControllerProvider.notifier).syncNow();
      expect(called, isFalse);
      expect(container.read(syncControllerProvider).lastSync, isNull);
    });

    test('a pull error surfaces without corrupting local state', () async {
      final progressRepo = InMemoryProgressRepository();
      progressRepo.save(progressKey('maths', 'm1'),
          NodeProgress(completedAt: DateTime(2026, 7, 1)));
      final api = MentalApi(
        baseUrl: 'https://examiner.test',
        token: 't',
        client: MockClient(
            (req) async => http.Response('{"detail": "boom"}', 500)),
      );
      final container = ProviderContainer(overrides: [
        repositoryProvider.overrideWithValue(progressRepo),
        journalRepositoryProvider.overrideWithValue(InMemoryJournalRepository()),
        apiProvider.overrideWithValue(api),
        syncKeyStoreProvider
            .overrideWithValue(InMemorySyncKeyStore()..key = newSkyKey()),
      ]);
      addTearDown(container.dispose);
      await container.read(syncControllerProvider.notifier).syncNow();
      final state = container.read(syncControllerProvider);
      expect(state.error, isNotNull);
      expect(state.busy, isFalse);
      expect(container.read(progressProvider)[progressKey('maths', 'm1')]!
          .complete, isTrue);
    });
  });
}
