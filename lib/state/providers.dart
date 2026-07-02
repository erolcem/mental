// state/providers.dart — Riverpod wiring: the progress map plus everything
// derived from it (unlock state, mastery fractions, XP, level).
import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/api_client.dart';
import '../data/repository.dart';
import '../data/skill_data.dart';

/// Overridden in main() with the persistent repository.
final repositoryProvider =
    Provider<ProgressRepository>((ref) => InMemoryProgressRepository());

/// The Examiner backend. Reads BACKEND_URL/APP_TOKEN dart-defines by default;
/// overridden in tests and previews with fakes.
final apiProvider = Provider<MentalApi>((ref) => MentalApi());

final progressProvider =
    StateNotifierProvider<ProgressNotifier, Map<String, NodeProgress>>(
        (ref) => ProgressNotifier(ref.watch(repositoryProvider)));

class ProgressNotifier extends StateNotifier<Map<String, NodeProgress>> {
  final ProgressRepository repo;
  ProgressNotifier(this.repo) : super(repo.load());

  NodeProgress _get(String key) => state[key] ?? const NodeProgress();

  bool isComplete(String skillId, String nodeId) =>
      _get(progressKey(skillId, nodeId)).complete;

  /// A node is unlocked when every prerequisite in its tree is complete.
  bool isUnlocked(Skill skill, SkillNode node) =>
      node.requires.every((r) => isComplete(skill.id, r));

  /// Complete a node ("ignite its star"). No-op if locked, already lit, or
  /// while the sky is locked by overdue reviews. When the Examiner passed the
  /// sheet, [verified] carries its note; without a backend the star ignites
  /// unverified (honour system). Ignition starts the review clock.
  void ignite(Skill skill, SkillNode node,
      {String? summary, String? examinerNote, bool verified = false}) {
    if (!isUnlocked(skill, node)) return;
    if (skyLocked(state, DateTime.now())) return;
    final key = progressKey(skill.id, node.id);
    if (_get(key).complete) return;
    final now = DateTime.now();
    _write(
        key,
        _get(key).copyWith(
            completedAt: now,
            summary: summary,
            verifiedAt: verified ? now : null,
            examinerNote: examinerNote,
            reviewStage: 0,
            nextReviewAt: now.add(Duration(days: kReviewIntervalDays[0]))));
  }

  /// A passed review climbs the spaced-repetition ladder.
  void recordReviewPass(String skillId, String nodeId, {DateTime? now}) {
    final key = progressKey(skillId, nodeId);
    final p = _get(key);
    if (!p.complete) return;
    final t = now ?? DateTime.now();
    final stage =
        (p.reviewStage + 1).clamp(0, kReviewIntervalDays.length - 1);
    _write(
        key,
        p.copyWith(
            reviewStage: stage,
            nextReviewAt: t.add(Duration(days: kReviewIntervalDays[stage]))));
  }

  /// A failed review falls one rung and returns tomorrow. The attempt still
  /// unlocks the sky — lockout demands you FACE every due review, not that
  /// you ace it on the spot.
  void recordReviewFail(String skillId, String nodeId, {DateTime? now}) {
    final key = progressKey(skillId, nodeId);
    final p = _get(key);
    if (!p.complete) return;
    final t = now ?? DateTime.now();
    _write(
        key,
        p.copyWith(
            reviewStage: (p.reviewStage - 1).clamp(0, kReviewIntervalDays.length - 1),
            nextReviewAt: t.add(const Duration(days: kFailedReviewRetryDays))));
  }

  /// Undo a completion. Any completed descendants that depended on it go dark
  /// too — the tree must never claim a star whose prerequisites are unlit.
  void extinguish(Skill skill, SkillNode node) {
    final darkened = <String>{node.id};
    var grew = true;
    while (grew) {
      grew = false;
      for (final n in skill.tree) {
        if (darkened.contains(n.id)) continue;
        final key = progressKey(skill.id, n.id);
        if (_get(key).complete && n.requires.any(darkened.contains)) {
          darkened.add(n.id);
          grew = true;
        }
      }
    }
    for (final id in darkened) {
      final key = progressKey(skill.id, id);
      if (_get(key).complete) {
        _write(key, _get(key).copyWith(clearCompleted: true));
      }
    }
  }

  /// How many completed stars would go dark if [node] were extinguished
  /// (itself included) — surfaced in the confirm dialog.
  int extinguishImpact(Skill skill, SkillNode node) {
    final darkened = <String>{node.id};
    var grew = true;
    while (grew) {
      grew = false;
      for (final n in skill.tree) {
        if (darkened.contains(n.id)) continue;
        if (isComplete(skill.id, n.id) && n.requires.any(darkened.contains)) {
          darkened.add(n.id);
          grew = true;
        }
      }
    }
    return darkened.where((id) => isComplete(skill.id, id)).length;
  }

  void saveSummary(Skill skill, SkillNode node, String text) =>
      _write(progressKey(skill.id, node.id),
          _get(progressKey(skill.id, node.id)).copyWith(summary: text));

  void wipe() {
    repo.clear();
    state = repo.load();
  }

  void _write(String key, NodeProgress p) {
    repo.save(key, p);
    state = {...state, key: p};
  }
}

/// One star demanding review.
class DueReview {
  final StatDomain stat;
  final Skill skill;
  final SkillNode node;
  final NodeProgress progress;
  const DueReview(this.stat, this.skill, this.node, this.progress);
}

/// Stars past their review date, oldest overdue first. "Now" is captured at
/// (re)computation — screens that idle run a widget-owned minute timer that
/// invalidates this provider (a provider-owned periodic stream would leak
/// timers into widget tests).
final dueReviewsProvider = Provider<List<DueReview>>(
    (ref) => dueReviews(ref.watch(progressProvider), DateTime.now()));

/// The lockout: any overdue review seals the sky against new ignitions.
final skyLockedProvider =
    Provider<bool>((ref) => ref.watch(dueReviewsProvider).isNotEmpty);

List<DueReview> dueReviews(Map<String, NodeProgress> progress, DateTime now) {
  final due = <DueReview>[];
  for (final stat in catalog) {
    for (final sk in stat.skills) {
      for (final n in sk.tree) {
        final p = progress[progressKey(sk.id, n.id)];
        if (p != null && p.reviewDue(now)) {
          due.add(DueReview(stat, sk, n, p));
        }
      }
    }
  }
  due.sort((a, b) => a.progress.nextReviewAt!.compareTo(b.progress.nextReviewAt!));
  return due;
}

bool skyLocked(Map<String, NodeProgress> progress, DateTime now) {
  for (final e in progress.entries) {
    if (e.value.reviewDue(now)) return true;
  }
  return false;
}

/// Migration: stars ignited before the review system existed get a schedule
/// starting from now (not from their ignition date — that would greet the
/// upgrade with an instant lockout). Called once at startup, like physical's
/// backfills.
void backfillReviewSchedules(ProgressRepository repo, {DateTime? now}) {
  final t = now ?? DateTime.now();
  for (final e in repo.load().entries) {
    if (e.value.complete && e.value.nextReviewAt == null) {
      repo.save(
          e.key,
          e.value.copyWith(
              reviewStage: 0,
              nextReviewAt: t.add(Duration(days: kReviewIntervalDays[0]))));
    }
  }
}

// ---------------------------------------------------------------------------
// Derived views (pure functions of the progress map — cheap at this scale).

bool nodeComplete(Map<String, NodeProgress> progress, String skillId, String nodeId) =>
    progress[progressKey(skillId, nodeId)]?.complete ?? false;

bool nodeUnlocked(Map<String, NodeProgress> progress, Skill skill, SkillNode node) =>
    node.requires.every((r) => nodeComplete(progress, skill.id, r));

/// Fraction of a skill's stars that are lit.
double skillMastery(Map<String, NodeProgress> progress, Skill skill) {
  if (skill.tree.isEmpty) return 0;
  final done =
      skill.tree.where((n) => nodeComplete(progress, skill.id, n.id)).length;
  return done / skill.tree.length;
}

/// Equal-weight average of the stat's skill masteries (matches the prototype).
double statMastery(Map<String, NodeProgress> progress, StatDomain stat) {
  if (stat.skills.isEmpty) return 0;
  return stat.skills.map((sk) => skillMastery(progress, sk)).reduce((a, b) => a + b) /
      stat.skills.length;
}

double overallMastery(Map<String, NodeProgress> progress) {
  var done = 0;
  for (final stat in catalog) {
    for (final sk in stat.skills) {
      done += sk.tree.where((n) => nodeComplete(progress, sk.id, n.id)).length;
    }
  }
  return totalNodeCount == 0 ? 0 : done / totalNodeCount;
}

/// XP: deeper stars are worth more (tier × 10).
int xpForNode(SkillNode n) => n.tier * 10;

int totalXp(Map<String, NodeProgress> progress) {
  var xp = 0;
  for (final stat in catalog) {
    for (final sk in stat.skills) {
      for (final n in sk.tree) {
        if (nodeComplete(progress, sk.id, n.id)) xp += xpForNode(n);
      }
    }
  }
  return xp;
}

final int _maxXp = () {
  var xp = 0;
  for (final stat in catalog) {
    for (final sk in stat.skills) {
      for (final n in sk.tree) {
        xp += xpForNode(n);
      }
    }
  }
  return xp;
}();

/// Level 1–99. Square-root curve: early stars level you fast, the summit is
/// earned. Full completion of every constellation = level 99.
int levelForXp(int xp) {
  if (_maxXp == 0) return 1;
  final f = (xp / _maxXp).clamp(0.0, 1.0);
  return 1 + (98 * math.sqrt(f)).floor();
}
