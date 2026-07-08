// state/sync_controller.dart — Sky Link orchestration.
//
// Every sync is pull → merge → push: fetch the remote snapshot, merge it
// conservatively into local state (union — nothing lit or written is ever
// lost), then push the merged whole back. The server stays a dumb blob
// store; convergence lives here.
import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/api_client.dart';
import '../data/sync.dart';
import 'providers.dart';

/// Overridden in main() with the persistent (shared_preferences) store.
final syncKeyStoreProvider =
    Provider<SyncKeyStore>((ref) => InMemorySyncKeyStore());

class SyncState {
  final String key; // '' = unlinked
  final bool busy;
  final String? error;
  final DateTime? lastSync;

  /// Records merged in from remote on the last sync (0 = already current).
  final int lastPulled;
  const SyncState(
      {this.key = '',
      this.busy = false,
      this.error,
      this.lastSync,
      this.lastPulled = 0});

  bool get linked => key.isNotEmpty;

  SyncState copyWith(
          {String? key,
          bool? busy,
          String? error,
          bool clearError = false,
          DateTime? lastSync,
          int? lastPulled}) =>
      SyncState(
        key: key ?? this.key,
        busy: busy ?? this.busy,
        error: clearError ? null : (error ?? this.error),
        lastSync: lastSync ?? this.lastSync,
        lastPulled: lastPulled ?? this.lastPulled,
      );
}

final syncControllerProvider =
    StateNotifierProvider<SyncController, SyncState>((ref) {
  final store = ref.watch(syncKeyStoreProvider);
  return SyncController(ref, store);
});

class SyncController extends StateNotifier<SyncState> {
  final Ref _ref;
  final SyncKeyStore _store;
  Timer? _debounce;

  /// True while adoptMerged() is writing sync results into the notifiers —
  /// their change events must not schedule another sync (feedback loop).
  bool _applying = false;

  SyncController(this._ref, this._store)
      : super(SyncState(key: _store.key, lastSync: _store.lastSync));

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  MentalApi get _api => _ref.read(apiProvider);

  bool get _ready => state.linked && _api.configured;

  /// Mint a fresh Sky Key for this device (does not touch the server until
  /// the first sync).
  String forgeKey() {
    final key = newSkyKey();
    _store.key = key;
    state = state.copyWith(key: key, clearError: true);
    scheduleSync();
    return key;
  }

  /// Link this device to an existing sky. Returns false when the code is
  /// not a plausible key.
  bool linkKey(String raw) {
    final key = normalizeSkyKey(raw);
    if (key.isEmpty) return false;
    _store.key = key;
    state = state.copyWith(key: key, clearError: true);
    unawaited(syncNow());
    return true;
  }

  /// Forget the key on this device. Local progress stays; the server copy
  /// stays for other devices.
  void unlink() {
    _store.key = '';
    _store.lastSync = null;
    state = const SyncState();
  }

  /// Called on local changes: coalesce a burst of edits into one sync.
  void scheduleSync() {
    if (!_ready || _applying) return;
    _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 6), () => unawaited(syncNow()));
  }

  /// One full pull → merge → push pass. Errors land in state, never throw.
  Future<void> syncNow() async {
    if (!_ready || state.busy) return;
    state = state.copyWith(busy: true, clearError: true);
    try {
      final progress = _ref.read(progressProvider.notifier);
      final journal = _ref.read(journalProvider.notifier);

      final remote = await _api.syncPull(key: state.key);
      var pulled = 0;
      if (remote.data != null) {
        final decoded = decodeSnapshot(remote.data!);
        if (decoded != null) {
          final merged = mergeSnapshots(
            localProgress: _ref.read(progressProvider),
            localJournal: _ref.read(journalProvider),
            remoteProgress: decoded.progress,
            remoteJournal: decoded.journal,
          );
          pulled = merged.changed;
          if (merged.changed > 0) {
            _applying = true;
            try {
              progress.adoptMerged(merged.progress);
              journal.adoptMerged(merged.journal);
            } finally {
              _applying = false;
            }
          }
        }
      }

      await _api.syncPush(
        key: state.key,
        data: encodeSnapshot(
            _ref.read(progressProvider), _ref.read(journalProvider)),
        device: _deviceName(),
      );
      final now = DateTime.now();
      _store.lastSync = now;
      state = state.copyWith(busy: false, lastSync: now, lastPulled: pulled);
    } on ApiException catch (e) {
      state = state.copyWith(busy: false, error: e.message);
    } catch (e) {
      state = state.copyWith(busy: false, error: 'Sync failed: $e');
    }
  }

  static String _deviceName() {
    try {
      return Platform.operatingSystem; // ios / android / linux / macos
    } catch (_) {
      return 'device'; // web or restricted platforms
    }
  }
}
