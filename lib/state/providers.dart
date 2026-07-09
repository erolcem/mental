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

/// Overridden in main() with the persistent journal repository.
final journalRepositoryProvider =
    Provider<JournalRepository>((ref) => InMemoryJournalRepository());

/// The Examiner backend. Reads BACKEND_URL/APP_TOKEN dart-defines by default;
/// overridden in tests and previews with fakes.
final apiProvider = Provider<MentalApi>((ref) => MentalApi());

final progressProvider =
    StateNotifierProvider<ProgressNotifier, Map<String, NodeProgress>>((ref) =>
        ProgressNotifier(ref.watch(repositoryProvider),
            extraLock: () => journalOverdue(
                ref.read(journalProvider), DateTime.now())));

class ProgressNotifier extends StateNotifier<Map<String, NodeProgress>> {
  final ProgressRepository repo;

  /// Additional lock source beyond overdue reviews (the journal). Injected so
  /// this notifier stays testable without the journal wired up.
  final bool Function() extraLock;
  ProgressNotifier(this.repo, {bool Function()? extraLock})
      : extraLock = extraLock ?? (() => false),
        super(repo.load());

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
    if (skyLocked(state, DateTime.now()) || extraLock()) return;
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

  /// Adopt a Sky-Link-merged progress map wholesale: persist every record
  /// and swap state in one step.
  void adoptMerged(Map<String, NodeProgress> merged) {
    for (final e in merged.entries) {
      repo.save(e.key, e.value);
    }
    state = Map.of(merged);
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

/// The lockout: overdue reviews OR a missed journal seal the sky against new
/// ignitions.
final skyLockedProvider = Provider<bool>((ref) =>
    ref.watch(dueReviewsProvider).isNotEmpty ||
    ref.watch(journalOverdueProvider));

// ---------------------------------------------------------------------------
// The nightly journal (stage 4).

final journalProvider =
    StateNotifierProvider<JournalNotifier, Map<String, JournalEntry>>(
        (ref) => JournalNotifier(ref.watch(journalRepositoryProvider)));

class JournalNotifier extends StateNotifier<Map<String, JournalEntry>> {
  final JournalRepository repo;
  JournalNotifier(this.repo) : super(repo.loadJournal());

  JournalEntry entryFor(String day) =>
      state[day] ?? JournalEntry(day: day);

  void save(JournalEntry entry) {
    repo.saveJournalEntry(entry);
    state = {...state, entry.day: entry};
  }

  /// Tick/untick one of the action items set by [day]'s session.
  void toggleAction(String day, int index) {
    final e = state[day];
    if (e == null || index < 0 || index >= e.actions.length) return;
    final actions = List.of(e.actions);
    actions[index] = actions[index].toggled();
    save(e.copyWith(actions: actions));
  }

  /// Adopt a Sky-Link-merged journal wholesale.
  void adoptMerged(Map<String, JournalEntry> merged) {
    for (final e in merged.entries) {
      repo.saveJournalEntry(e.value);
    }
    state = Map.of(merged);
  }

  void wipe() {
    repo.clearJournal();
    state = repo.loadJournal();
  }
}

/// The journal lock: once the habit has begun (≥1 closed entry), a day
/// without journaling locks the NEXT day until today's session is closed.
/// Never journaled at all → unlocked (the habit starts tonight, not with a
/// punishment).
bool journalOverdue(Map<String, JournalEntry> entries, DateTime now) {
  final closedDays = [
    for (final e in entries.values)
      if (e.closed) e.day
  ];
  if (closedDays.isEmpty) return false;
  closedDays.sort();
  return closedDays.last.compareTo(yesterdayKey(now)) < 0;
}

final journalOverdueProvider = Provider<bool>((ref) =>
    journalOverdue(ref.watch(journalProvider), DateTime.now()));

/// Whether tonight's session is already closed.
final journaledTodayProvider = Provider<bool>((ref) =>
    ref.watch(journalProvider)[dayKey(DateTime.now())]?.closed ?? false);

/// The action items to live by today: distilled by the most recent closed
/// session BEFORE today. (Tonight's session writes tomorrow's list.)
final todayActionsProvider = Provider<JournalEntry?>((ref) {
  final entries = ref.watch(journalProvider);
  final today = dayKey(DateTime.now());
  JournalEntry? best;
  for (final e in entries.values) {
    if (!e.closed || e.actions.isEmpty) continue;
    if (e.day.compareTo(today) >= 0) continue;
    if (best == null || e.day.compareTo(best.day) > 0) best = e;
  }
  return best;
});

/// Every scheduled review — due and upcoming — soonest first. Powers the
/// Review Ledger so the whole spaced-repetition future is transparent.
List<DueReview> scheduledReviews(Map<String, NodeProgress> progress) {
  final all = <DueReview>[];
  for (final stat in catalog) {
    for (final sk in stat.skills) {
      for (final n in sk.tree) {
        final p = progress[progressKey(sk.id, n.id)];
        if (p != null && p.complete && p.nextReviewAt != null) {
          all.add(DueReview(stat, sk, n, p));
        }
      }
    }
  }
  all.sort(
      (a, b) => a.progress.nextReviewAt!.compareTo(b.progress.nextReviewAt!));
  return all;
}

final scheduledReviewsProvider = Provider<List<DueReview>>(
    (ref) => scheduledReviews(ref.watch(progressProvider)));

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

/// XP: effort-weighted — a star pays what it costs. The researched hour
/// estimate carries the weight; tier adds a small depth bonus so summit
/// stars still outshine equal-effort foundations. (Mirrored in
/// tool/analyze_catalog.dart, which cannot import Flutter code.)
int xpForNode(SkillNode n) => n.hours + n.tier * 10;

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

/// The XP at which [level] begins — the inverse of [levelForXp].
int xpForLevel(int level) =>
    (_maxXp * math.pow(((level - 1) / 98).clamp(0.0, 1.0), 2)).round();

/// Progress through the current level, 0–1 (1.0 at the summit, level 99).
double levelProgress(int xp) {
  final lvl = levelForXp(xp);
  if (lvl >= 99) return 1.0;
  final lo = xpForLevel(lvl), hi = xpForLevel(lvl + 1);
  return hi <= lo ? 1.0 : ((xp - lo) / (hi - lo)).clamp(0.0, 1.0);
}

/// XP still owed to reach the next level (0 at the summit).
int xpToNextLevel(int xp) {
  final lvl = levelForXp(xp);
  return lvl >= 99 ? 0 : (xpForLevel(lvl + 1) - xp).clamp(0, 1 << 30);
}
