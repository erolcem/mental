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

  const NodeProgress(
      {this.completedAt,
      this.summary = '',
      this.verifiedAt,
      this.examinerNote = ''});

  bool get complete => completedAt != null;
  bool get verified => verifiedAt != null;

  NodeProgress copyWith(
          {DateTime? completedAt,
          String? summary,
          DateTime? verifiedAt,
          String? examinerNote,
          bool clearCompleted = false}) =>
      NodeProgress(
        completedAt: clearCompleted ? null : (completedAt ?? this.completedAt),
        summary: summary ?? this.summary,
        // A star that goes dark loses its verification too; the sheet stays.
        verifiedAt: clearCompleted ? null : (verifiedAt ?? this.verifiedAt),
        examinerNote: examinerNote ?? this.examinerNote,
      );

  Map<String, dynamic> toJson() => {
        if (completedAt != null) 'c': completedAt!.toIso8601String(),
        if (summary.isNotEmpty) 's': summary,
        if (verifiedAt != null) 'v': verifiedAt!.toIso8601String(),
        if (examinerNote.isNotEmpty) 'n': examinerNote,
      };

  static NodeProgress fromJson(Map<String, dynamic> j) => NodeProgress(
        completedAt: j['c'] == null ? null : DateTime.tryParse(j['c'] as String),
        summary: (j['s'] as String?) ?? '',
        verifiedAt: j['v'] == null ? null : DateTime.tryParse(j['v'] as String),
        examinerNote: (j['n'] as String?) ?? '',
      );
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
