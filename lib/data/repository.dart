// data/repository.dart — progress persistence behind an interface, mirroring
// physical's repository pattern: an in-memory implementation for tests/dev and
// a shared_preferences one for devices (persistent_repository.dart).
//
// NodeProgress is deliberately future-proof: stage 2 adds AI verification of
// the summary sheet, stage 3 adds spaced-repetition review scheduling — both
// extend this record without a schema break.

/// Everything the app remembers about one node, keyed by `skillId.nodeId`.
class NodeProgress {
  /// When the star was ignited (node completed). Null = not complete.
  final DateTime? completedAt;

  /// The mastery summary sheet the user wrote for this node. Kept forever —
  /// it is what the AI Examiner verifies and what review quizzes draw from.
  final String summary;

  /// When the Examiner passed this node's sheet. Null = never verified
  /// (honour-system ignition while no backend is configured).
  final DateTime? verifiedAt;

  /// The Examiner's feedback on the passing sheet.
  final String examinerNote;

  /// Spaced-repetition ladder position — index into [kReviewIntervalDays]
  /// giving the gap that produced [nextReviewAt]. Climbs on a passed review,
  /// falls on a failed one.
  final int reviewStage;

  /// When this star next demands review. Any star past this instant locks
  /// the whole sky until reviewed. Null = no schedule (star unlit).
  final DateTime? nextReviewAt;

  const NodeProgress(
      {this.completedAt,
      this.summary = '',
      this.verifiedAt,
      this.examinerNote = '',
      this.reviewStage = 0,
      this.nextReviewAt});

  bool get complete => completedAt != null;
  bool get verified => verifiedAt != null;
  bool reviewDue(DateTime now) =>
      complete && nextReviewAt != null && !nextReviewAt!.isAfter(now);

  NodeProgress copyWith(
          {DateTime? completedAt,
          String? summary,
          DateTime? verifiedAt,
          String? examinerNote,
          int? reviewStage,
          DateTime? nextReviewAt,
          bool clearCompleted = false}) =>
      NodeProgress(
        completedAt: clearCompleted ? null : (completedAt ?? this.completedAt),
        summary: summary ?? this.summary,
        // A star that goes dark loses its verification and schedule too; the
        // sheet stays.
        verifiedAt: clearCompleted ? null : (verifiedAt ?? this.verifiedAt),
        examinerNote: examinerNote ?? this.examinerNote,
        reviewStage: clearCompleted ? 0 : (reviewStage ?? this.reviewStage),
        nextReviewAt:
            clearCompleted ? null : (nextReviewAt ?? this.nextReviewAt),
      );

  Map<String, dynamic> toJson() => {
        if (completedAt != null) 'c': completedAt!.toIso8601String(),
        if (summary.isNotEmpty) 's': summary,
        if (verifiedAt != null) 'v': verifiedAt!.toIso8601String(),
        if (examinerNote.isNotEmpty) 'n': examinerNote,
        if (reviewStage != 0) 'rs': reviewStage,
        if (nextReviewAt != null) 'nr': nextReviewAt!.toIso8601String(),
      };

  static NodeProgress fromJson(Map<String, dynamic> j) => NodeProgress(
        completedAt: j['c'] == null ? null : DateTime.tryParse(j['c'] as String),
        summary: (j['s'] as String?) ?? '',
        verifiedAt: j['v'] == null ? null : DateTime.tryParse(j['v'] as String),
        examinerNote: (j['n'] as String?) ?? '',
        reviewStage: (j['rs'] as num?)?.toInt() ?? 0,
        nextReviewAt:
            j['nr'] == null ? null : DateTime.tryParse(j['nr'] as String),
      );
}

/// Expanding spaced-repetition gaps (days). A passed review climbs one rung;
/// a failed review falls one rung and comes back in [kFailedReviewRetryDays].
const List<int> kReviewIntervalDays = [3, 7, 14, 30, 60, 120, 240];
const int kFailedReviewRetryDays = 1;

// ---------------------------------------------------------------------------
// The nightly journal (stage 4).

class JournalTurn {
  final String role; // 'user' | 'ai'
  final String text;
  const JournalTurn(this.role, this.text);
  Map<String, dynamic> toJson() => {'r': role, 't': text};
  static JournalTurn fromJson(Map<String, dynamic> j) =>
      JournalTurn((j['r'] as String?) ?? 'user', (j['t'] as String?) ?? '');
}

class ActionItem {
  final String text;
  final bool done;

  /// The advisor's evidence for prescribing this action ("hit 6/7 this week —
  /// stepping up"). Shown beside the checkbox; teaches the method.
  final String why;
  const ActionItem(this.text, {this.done = false, this.why = ''});
  ActionItem toggled() => ActionItem(text, done: !done, why: why);
  Map<String, dynamic> toJson() =>
      {'t': text, if (done) 'd': true, if (why.isNotEmpty) 'w': why};
  static ActionItem fromJson(Map<String, dynamic> j) => ActionItem(
      (j['t'] as String?) ?? '',
      done: j['d'] == true,
      why: (j['w'] as String?) ?? '');
}

/// One day's journal: the conversation, and the 1–3 actions it distilled for
/// the FOLLOWING day. An entry with [closedAt] set counts as "journaled".
class JournalEntry {
  final String day; // local yyyy-mm-dd
  final List<JournalTurn> transcript;
  final List<ActionItem> actions;
  final String reflection;
  final DateTime? closedAt;
  const JournalEntry({
    required this.day,
    this.transcript = const [],
    this.actions = const [],
    this.reflection = '',
    this.closedAt,
  });

  bool get closed => closedAt != null;

  JournalEntry copyWith(
          {List<JournalTurn>? transcript,
          List<ActionItem>? actions,
          String? reflection,
          DateTime? closedAt}) =>
      JournalEntry(
        day: day,
        transcript: transcript ?? this.transcript,
        actions: actions ?? this.actions,
        reflection: reflection ?? this.reflection,
        closedAt: closedAt ?? this.closedAt,
      );

  Map<String, dynamic> toJson() => {
        'day': day,
        if (transcript.isNotEmpty)
          'tr': [for (final t in transcript) t.toJson()],
        if (actions.isNotEmpty) 'a': [for (final a in actions) a.toJson()],
        if (reflection.isNotEmpty) 'rf': reflection,
        if (closedAt != null) 'c': closedAt!.toIso8601String(),
      };

  static JournalEntry fromJson(Map<String, dynamic> j) => JournalEntry(
        day: (j['day'] as String?) ?? '',
        transcript: [
          for (final t in (j['tr'] as List? ?? []))
            JournalTurn.fromJson(t as Map<String, dynamic>)
        ],
        actions: [
          for (final a in (j['a'] as List? ?? []))
            ActionItem.fromJson(a as Map<String, dynamic>)
        ],
        reflection: (j['rf'] as String?) ?? '',
        closedAt: j['c'] == null ? null : DateTime.tryParse(j['c'] as String),
      );
}

abstract class JournalRepository {
  /// All entries keyed by local day (yyyy-mm-dd).
  Map<String, JournalEntry> loadJournal();
  void saveJournalEntry(JournalEntry entry);
  void clearJournal();
}

class InMemoryJournalRepository implements JournalRepository {
  final Map<String, JournalEntry> _store = {};
  @override
  Map<String, JournalEntry> loadJournal() => Map.of(_store);
  @override
  void saveJournalEntry(JournalEntry entry) => _store[entry.day] = entry;
  @override
  void clearJournal() => _store.clear();
}

abstract class ProgressRepository {
  /// Full progress map, keyed by `skillId.nodeId`.
  Map<String, NodeProgress> load();
  void save(String key, NodeProgress progress);
  void clear();
}

class InMemoryProgressRepository implements ProgressRepository {
  final Map<String, NodeProgress> _store = {};
  @override
  Map<String, NodeProgress> load() => Map.of(_store);
  @override
  void save(String key, NodeProgress progress) => _store[key] = progress;
  @override
  void clear() => _store.clear();
}
