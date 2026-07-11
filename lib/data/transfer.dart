// data/transfer.dart — carry the sky between devices without accounts: the
// whole state (progress + journal) serialises to one JSON blob that travels
// via the clipboard (AirDrop a note, message yourself, paste on the new
// phone). Import MERGES: for every star/day the newer record wins, so
// exporting from an old phone can never erase what the new one has done.
//
// Real sign-in sync would follow physical's JWT+Postgres pattern on the
// backend; until that exists this makes progress durable and portable today.
import 'dart:convert';

import 'repository.dart';

const int kTransferVersion = 1;

/// Everything the app remembers, as one pastable JSON string.
String exportBlob(
    Map<String, NodeProgress> progress, Map<String, JournalEntry> journal) {
  return jsonEncode({
    'app': 'mental',
    'v': kTransferVersion,
    'exported': DateTime.now().toIso8601String(),
    'progress': {for (final e in progress.entries) e.key: e.value.toJson()},
    'journal': {for (final e in journal.entries) e.key: e.value.toJson()},
  });
}

class TransferPayload {
  final Map<String, NodeProgress> progress;
  final Map<String, JournalEntry> journal;
  const TransferPayload(this.progress, this.journal);
}

/// Parse an exported blob. Throws [FormatException] on anything that is not
/// a Mental export.
TransferPayload parseBlob(String raw) {
  final dynamic j;
  try {
    j = jsonDecode(raw.trim());
  } on FormatException {
    throw const FormatException('That is not a Mental export (not JSON).');
  }
  if (j is! Map<String, dynamic> || j['app'] != 'mental') {
    throw const FormatException('That is not a Mental export.');
  }
  if ((j['v'] as num? ?? 0) > kTransferVersion) {
    throw const FormatException(
        'This export came from a newer version of Mental — update this app.');
  }
  final progress = <String, NodeProgress>{};
  for (final e in (j['progress'] as Map<String, dynamic>? ?? {}).entries) {
    progress[e.key] = NodeProgress.fromJson(e.value as Map<String, dynamic>);
  }
  final journal = <String, JournalEntry>{};
  for (final e in (j['journal'] as Map<String, dynamic>? ?? {}).entries) {
    journal[e.key] = JournalEntry.fromJson(e.value as Map<String, dynamic>);
  }
  return TransferPayload(progress, journal);
}

/// Merge [incoming] into [local]: per star, the record with the later
/// activity wins; a lit star always beats an unlit one. Returns the merged
/// map (inputs untouched).
Map<String, NodeProgress> mergeProgress(
    Map<String, NodeProgress> local, Map<String, NodeProgress> incoming) {
  final out = Map<String, NodeProgress>.of(local);
  incoming.forEach((key, inc) {
    final cur = out[key];
    if (cur == null || _progressWins(inc, cur)) out[key] = inc;
  });
  return out;
}

bool _progressWins(NodeProgress a, NodeProgress b) {
  // Completion beats non-completion (never dim a star by importing).
  if (a.complete != b.complete) return a.complete;
  // Both complete (or both not): later activity wins; summaries ride along.
  return _activity(a).isAfter(_activity(b));
}

DateTime _activity(NodeProgress p) {
  var t = DateTime.fromMillisecondsSinceEpoch(0);
  for (final d in [p.completedAt, p.verifiedAt, p.nextReviewAt]) {
    if (d != null && d.isAfter(t)) t = d;
  }
  return t;
}

/// Merge journals: per day, a closed entry beats an open one; two closed
/// entries resolve to the later close.
Map<String, JournalEntry> mergeJournal(
    Map<String, JournalEntry> local, Map<String, JournalEntry> incoming) {
  final out = Map<String, JournalEntry>.of(local);
  incoming.forEach((day, inc) {
    final cur = out[day];
    if (cur == null) {
      out[day] = inc;
    } else if (inc.closed && !cur.closed) {
      out[day] = inc;
    } else if (inc.closed &&
        cur.closed &&
        inc.closedAt!.isAfter(cur.closedAt!)) {
      out[day] = inc;
    }
  });
  return out;
}
