// ui/sky_link_sheet.dart — Sky Link: carry one sky across every device.
// Forge a Sky Key here, enter it on the next device, and both skies merge
// and stay in step (pull → merge → push; the union never loses a lit star
// or a journaled day).
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/sync.dart';
import '../state/providers.dart';
import '../state/sync_controller.dart';
import 'theme.dart';

const Color kLinkTeal = Color(0xFF7FE7D2);

void showSkyLinkSheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => const _SkyLinkSheet(),
  );
}

class _SkyLinkSheet extends ConsumerStatefulWidget {
  const _SkyLinkSheet();

  @override
  ConsumerState<_SkyLinkSheet> createState() => _SkyLinkSheetState();
}

class _SkyLinkSheetState extends ConsumerState<_SkyLinkSheet> {
  final _keyInput = TextEditingController();
  String? _linkError;
  bool _copied = false;

  @override
  void dispose() {
    _keyInput.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sync = ref.watch(syncControllerProvider);
    final api = ref.watch(apiProvider);

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Container(
        constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.8),
        decoration: BoxDecoration(
          color: const Color(0xF20B0E22),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border:
              Border(top: BorderSide(color: kLinkTeal.withValues(alpha: 0.35))),
        ),
        padding: const EdgeInsets.fromLTRB(22, 14, 22, 28),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 14),
              Text('SKY LINK',
                  style: cinzel(13, weight: 640, color: kLinkTeal, spacing: 2)),
              const SizedBox(height: 4),
              Text(
                'One sky, every device. Your Sky Key names your sky on the '
                'backend; enter the same key on another device and the two '
                'merge — no star, sheet or journaled day is ever lost by a '
                'sync. Keep the key like a password: anyone holding it '
                'holds your sky, and there is no recovery if it is lost.',
                style: raleway(9.5,
                    color: Colors.white.withValues(alpha: 0.45), height: 1.55),
              ),
              const SizedBox(height: 14),
              if (!api.configured)
                Text(
                  '⚠ SKY LINK NEEDS THE BACKEND — this build has no '
                  'BACKEND_URL, so nothing can sync. See backend/DEPLOY.md.',
                  style: raleway(9,
                      color: const Color(0xFFFFC46B).withValues(alpha: 0.85),
                      height: 1.5),
                )
              else if (!sync.linked)
                ..._unlinked()
              else
                ..._linked(sync),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _unlinked() {
    return [
      SizedBox(
        width: double.infinity,
        height: 46,
        child: FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: kLinkTeal.withValues(alpha: 0.9),
            foregroundColor: kSpaceBlack,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () =>
              ref.read(syncControllerProvider.notifier).forgeKey(),
          child: Text('✦  FORGE A NEW SKY KEY',
              style: cinzel(12, weight: 700, color: kSpaceBlack)),
        ),
      ),
      const SizedBox(height: 18),
      Text('OR LINK TO A SKY YOU ALREADY HAVE',
          style: raleway(8,
              color: Colors.white.withValues(alpha: 0.3), spacing: 2)),
      const SizedBox(height: 8),
      TextField(
        controller: _keyInput,
        style: raleway(12, spacing: 1),
        cursorColor: kLinkTeal,
        textCapitalization: TextCapitalization.characters,
        decoration: InputDecoration(
          hintText: 'XXXX-XXXX-XXXX-XXXX-XXXX-XXXX',
          hintStyle:
              raleway(11, color: Colors.white.withValues(alpha: 0.2)),
          errorText: _linkError,
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.05),
          isDense: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: kLinkTeal.withValues(alpha: 0.5)),
          ),
        ),
      ),
      const SizedBox(height: 8),
      SizedBox(
        width: double.infinity,
        height: 42,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: kLinkTeal.withValues(alpha: 0.45)),
            foregroundColor: kLinkTeal,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () {
            final ok = ref
                .read(syncControllerProvider.notifier)
                .linkKey(_keyInput.text);
            setState(() => _linkError =
                ok ? null : 'That is not a Sky Key — 24 letters/digits.');
          },
          child: Text('LINK THIS DEVICE',
              style: raleway(10.5, weight: 700, spacing: 1)),
        ),
      ),
    ];
  }

  List<Widget> _linked(SyncState sync) {
    return [
      Text('THIS SKY\'S KEY',
          style: raleway(8,
              color: Colors.white.withValues(alpha: 0.3), spacing: 2)),
      const SizedBox(height: 6),
      InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          await Clipboard.setData(ClipboardData(text: sync.key));
          if (mounted) setState(() => _copied = true);
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: kLinkTeal.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: kLinkTeal.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(prettySkyKey(sync.key),
                  style: raleway(13, weight: 600, spacing: 1.2,
                      color: Colors.white.withValues(alpha: 0.9))),
              const SizedBox(height: 4),
              Text(_copied ? 'COPIED ✓' : 'TAP TO COPY',
                  style: raleway(7.5,
                      weight: 700,
                      color: kLinkTeal.withValues(alpha: 0.7),
                      spacing: 1.5)),
            ],
          ),
        ),
      ),
      const SizedBox(height: 12),
      Text(
        sync.busy
            ? 'Syncing…'
            : sync.error != null
                ? '⚠ ${sync.error}'
                : sync.lastSync == null
                    ? 'Not yet synced from this device.'
                    : 'Synced ${_ago(sync.lastSync!)}'
                        '${sync.lastPulled > 0 ? ' · merged in ${sync.lastPulled} record${sync.lastPulled == 1 ? '' : 's'}' : ''}.',
        style: raleway(9.5,
            color: sync.error != null
                ? const Color(0xFFFFC46B)
                : Colors.white.withValues(alpha: 0.5),
            height: 1.5),
      ),
      const SizedBox(height: 12),
      SizedBox(
        width: double.infinity,
        height: 46,
        child: FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: sync.busy
                ? Colors.white.withValues(alpha: 0.06)
                : kLinkTeal.withValues(alpha: 0.9),
            foregroundColor: sync.busy ? Colors.white38 : kSpaceBlack,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: sync.busy
              ? null
              : () => ref.read(syncControllerProvider.notifier).syncNow(),
          child: Text(sync.busy ? 'SYNCING…' : '✦  SYNC NOW',
              style: sync.busy
                  ? raleway(10.5, weight: 600, color: Colors.white38)
                  : cinzel(12, weight: 700, color: kSpaceBlack)),
        ),
      ),
      const SizedBox(height: 8),
      Center(
        child: TextButton(
          onPressed: () {
            ref.read(syncControllerProvider.notifier).unlink();
          },
          child: Text('Unlink this device (local progress stays)',
              style: raleway(10.5, color: Colors.white38)),
        ),
      ),
    ];
  }

  static String _ago(DateTime t) {
    final d = DateTime.now().difference(t);
    if (d.inSeconds < 90) return 'moments ago';
    if (d.inMinutes < 60) return '${d.inMinutes} min ago';
    if (d.inHours < 24) return '${d.inHours} h ago';
    return '${d.inDays} d ago';
  }
}
