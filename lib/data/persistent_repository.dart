// data/persistent_repository.dart — on-device persistence, same idiom as
// physical: reads are synchronous from an in-memory cache loaded once at
// startup; writes are write-through async (fire-and-forget).
import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'repository.dart';

class PersistentProgressRepository implements ProgressRepository {
  static const _key = 'mental_progress_v1';
  final SharedPreferences _prefs;
  final Map<String, NodeProgress> _cache;

  PersistentProgressRepository._(this._prefs, this._cache);

  static Future<PersistentProgressRepository> create() async {
    final prefs = await SharedPreferences.getInstance();
    return PersistentProgressRepository._(
        prefs, _decode(prefs.getString(_key)));
  }

  @override
  Map<String, NodeProgress> load() => Map.of(_cache);

  @override
  void save(String key, NodeProgress progress) {
    _cache[key] = progress;
    _persist();
  }

  @override
  void clear() {
    _cache.clear();
    _persist();
  }

  void _persist() => unawaited(_prefs.setString(_key,
      jsonEncode({for (final e in _cache.entries) e.key: e.value.toJson()})));

  static Map<String, NodeProgress> _decode(String? raw) {
    if (raw == null) return {};
    try {
      final j = jsonDecode(raw) as Map<String, dynamic>;
      final out = <String, NodeProgress>{};
      for (final e in j.entries) {
        // Per-entry tolerance: one corrupt record (say, written by an older
        // or newer build) must never take the rest of the sky down with it.
        try {
          out[e.key] = NodeProgress.fromJson(e.value as Map<String, dynamic>);
        } catch (_) {}
      }
      return out;
    } catch (_) {
      return {}; // an unreadable blob must never brick startup
    }
  }
}

class PersistentJournalRepository implements JournalRepository {
  static const _key = 'mental_journal_v1';
  final SharedPreferences _prefs;
  final Map<String, JournalEntry> _cache;

  PersistentJournalRepository._(this._prefs, this._cache);

  static Future<PersistentJournalRepository> create() async {
    final prefs = await SharedPreferences.getInstance();
    return PersistentJournalRepository._(prefs, _decode(prefs.getString(_key)));
  }

  @override
  Map<String, JournalEntry> loadJournal() => Map.of(_cache);

  @override
  void saveJournalEntry(JournalEntry entry) {
    _cache[entry.day] = entry;
    _persist();
  }

  @override
  void clearJournal() {
    _cache.clear();
    _persist();
  }

  void _persist() => unawaited(_prefs.setString(_key,
      jsonEncode({for (final e in _cache.entries) e.key: e.value.toJson()})));

  static Map<String, JournalEntry> _decode(String? raw) {
    if (raw == null) return {};
    try {
      final j = jsonDecode(raw) as Map<String, dynamic>;
      final out = <String, JournalEntry>{};
      for (final e in j.entries) {
        // One corrupt day must never cost the rest of the journal.
        try {
          out[e.key] = JournalEntry.fromJson(e.value as Map<String, dynamic>);
        } catch (_) {}
      }
      return out;
    } catch (_) {
      return {};
    }
  }
}
