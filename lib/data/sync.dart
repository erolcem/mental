// data/sync.dart — Sky Link: one sky across every device.
//
// The design is deliberately humble: the backend stores ONE opaque snapshot
// per Sky Key (see backend/app/sync.py); every device syncs by
// pull → merge → push, and the merge is CONSERVATIVE — a union that never
// silently discards an ignited star, a written sheet, or a journaled day.
// The Sky Key is a 24-character code generated on-device; the server only
// ever sees it hashed into an account id, and the existing APP_TOKEN still
// guards the route. Losing the key means minting a new sky; there is no
// recovery by design (no accounts, no email, nothing to phish).
import 'dart:convert';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

import 'repository.dart';

/// Crockford-style alphabet: no I/L/O/U so keys survive handwriting.
const String _alphabet = 'ABCDEFGHJKMNPQRSTVWXYZ0123456789';
const int kSkyKeyLength = 24; // 24 chars × 5 bits = 120 bits of key space

String newSkyKey() {
  final rnd = Random.secure();
  return List.generate(
      kSkyKeyLength, (_) => _alphabet[rnd.nextInt(_alphabet.length)]).join();
}

/// Uppercase, strip separators/spaces, forgive the confusable glyphs the
/// alphabet excludes. Returns '' when what remains is not a plausible key.
String normalizeSkyKey(String raw) {
  var s = raw.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
  s = s
      .replaceAll('O', '0')
      .replaceAll('I', '1')
      .replaceAll('L', '1')
      .replaceAll('U', 'V');
  if (s.length != kSkyKeyLength) return '';
  if (s.split('').any((c) => !_alphabet.contains(c))) return '';
  return s;
}

/// XXXX-XXXX-… for human eyes.
String prettySkyKey(String key) => [
      for (var i = 0; i < key.length; i += 4)
        key.substring(i, i + 4 > key.length ? key.length : i + 4)
    ].join('-');

// ---------------------------------------------------------------------------
// Snapshot: everything one device knows, as one JSON blob.

String encodeSnapshot(Map<String, NodeProgress> progress,
        Map<String, JournalEntry> journal) =>
    jsonEncode({
      'v': 1,
      'progress': {for (final e in progress.entries) e.key: e.value.toJson()},
      'journal': {for (final e in journal.entries) e.key: e.value.toJson()},
    });

({Map<String, NodeProgress> progress, Map<String, JournalEntry> journal})?
    decodeSnapshot(String data) {
  try {
    final j = jsonDecode(data) as Map<String, dynamic>;
    final p = (j['progress'] as Map<String, dynamic>? ?? {});
    final d = (j['journal'] as Map<String, dynamic>? ?? {});
    return (
      progress: {
        for (final e in p.entries)
          e.key: NodeProgress.fromJson(e.value as Map<String, dynamic>)
      },
      journal: {
        for (final e in d.entries)
          e.key: JournalEntry.fromJson(e.value as Map<String, dynamic>)
      },
    );
  } catch (_) {
    return null; // a corrupt remote blob must never brick a device
  }
}

// ---------------------------------------------------------------------------
// The conservative merge. Union semantics: light beats dark, closed beats
// open, further-along beats earlier, and written sheets are never dropped.

NodeProgress mergeNode(NodeProgress local, NodeProgress remote) {
  if (local.complete != remote.complete) {
    final lit = local.complete ? local : remote;
    final dark = local.complete ? remote : local;
    // The dark side may hold a sheet drafted offline — keep the words.
    return (lit.summary.isEmpty && dark.summary.isNotEmpty)
        ? lit.copyWith(summary: dark.summary)
        : lit;
  }
  if (local.complete && remote.complete) {
    // Both lit: whichever is further up the review ladder carries the truth
    // of the schedule; ties fall to the later review date, then local.
    if (local.reviewStage != remote.reviewStage) {
      return local.reviewStage > remote.reviewStage ? local : remote;
    }
    final ln = local.nextReviewAt, rn = remote.nextReviewAt;
    if (ln != null && rn != null && !ln.isAtSameMomentAs(rn)) {
      return ln.isAfter(rn) ? local : remote;
    }
    return local;
  }
  // Both dark: keep the richer draft sheet.
  return remote.summary.length > local.summary.length ? remote : local;
}

JournalEntry mergeDay(JournalEntry local, JournalEntry remote) {
  if (local.closed != remote.closed) return local.closed ? local : remote;
  if (local.closed && remote.closed) {
    // Same night closed on two devices (rare): later close wins the words,
    // but a tick given on EITHER device stays given.
    final winner = remote.closedAt!.isAfter(local.closedAt!) ? remote : local;
    final other = identical(winner, local) ? remote : local;
    final doneByText = {
      for (final a in other.actions)
        if (a.done) a.text: true
    };
    return winner.copyWith(actions: [
      for (final a in winner.actions)
        a.done || doneByText[a.text] == true
            ? ActionItem(a.text, done: true)
            : a
    ]);
  }
  // Both open: the longer conversation is the real one.
  return remote.transcript.length > local.transcript.length ? remote : local;
}

class MergeResult {
  final Map<String, NodeProgress> progress;
  final Map<String, JournalEntry> journal;

  /// How many local records the merge actually changed — 0 means the local
  /// sky already contained everything the remote knew.
  final int changed;
  const MergeResult(this.progress, this.journal, this.changed);
}

MergeResult mergeSnapshots({
  required Map<String, NodeProgress> localProgress,
  required Map<String, JournalEntry> localJournal,
  required Map<String, NodeProgress> remoteProgress,
  required Map<String, JournalEntry> remoteJournal,
}) {
  var changed = 0;
  final p = Map<String, NodeProgress>.of(localProgress);
  for (final e in remoteProgress.entries) {
    final local = p[e.key];
    final merged = local == null ? e.value : mergeNode(local, e.value);
    if (local == null ||
        jsonEncode(merged.toJson()) != jsonEncode(local.toJson())) {
      changed++;
    }
    p[e.key] = merged;
  }
  final d = Map<String, JournalEntry>.of(localJournal);
  for (final e in remoteJournal.entries) {
    final local = d[e.key];
    final merged = local == null ? e.value : mergeDay(local, e.value);
    if (local == null ||
        jsonEncode(merged.toJson()) != jsonEncode(local.toJson())) {
      changed++;
    }
    d[e.key] = merged;
  }
  return MergeResult(p, d, changed);
}

// ---------------------------------------------------------------------------
// Where the key lives on this device.

abstract class SyncKeyStore {
  String get key; // '' = unlinked
  set key(String v);
  DateTime? get lastSync;
  set lastSync(DateTime? t);
}

class InMemorySyncKeyStore implements SyncKeyStore {
  @override
  String key = '';
  @override
  DateTime? lastSync;
}

class PrefsSyncKeyStore implements SyncKeyStore {
  static const _kKey = 'mental_sky_key_v1';
  static const _kLast = 'mental_sky_last_sync_v1';
  final SharedPreferences _prefs;
  PrefsSyncKeyStore._(this._prefs);

  static Future<PrefsSyncKeyStore> create() async =>
      PrefsSyncKeyStore._(await SharedPreferences.getInstance());

  @override
  String get key => _prefs.getString(_kKey) ?? '';
  @override
  set key(String v) =>
      v.isEmpty ? _prefs.remove(_kKey) : _prefs.setString(_kKey, v);

  @override
  DateTime? get lastSync {
    final raw = _prefs.getString(_kLast);
    return raw == null ? null : DateTime.tryParse(raw);
  }

  @override
  set lastSync(DateTime? t) => t == null
      ? _prefs.remove(_kLast)
      : _prefs.setString(_kLast, t.toIso8601String());
}
