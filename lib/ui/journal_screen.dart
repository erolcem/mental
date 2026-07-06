// ui/journal_screen.dart — the nightly closed loop. Talk the day through with
// the Confidant (who knows yesterday's action items and asks about them),
// then CLOSE THE DAY: the session distills 1–3 concrete actions for tomorrow
// and one line of reflection. Skipping a day locks the sky the next morning.
// Without a backend: freeform entry + self-written actions (honour system).
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/api_client.dart';
import '../data/repository.dart';
import '../state/providers.dart';
import 'starfield.dart';
import 'theme.dart';

const Color kJournalViolet = Color(0xFFB79CFF);

class JournalScreen extends ConsumerStatefulWidget {
  const JournalScreen({super.key});

  @override
  ConsumerState<JournalScreen> createState() => _JournalScreenState();
}

/// Honour-mode close dialog — owns its controllers so they outlive the exit
/// animation. Pops with the non-empty action texts, or null on cancel.
class _HonourCloseDialog extends StatefulWidget {
  const _HonourCloseDialog();
  @override
  State<_HonourCloseDialog> createState() => _HonourCloseDialogState();
}

class _HonourCloseDialogState extends State<_HonourCloseDialog> {
  final _controllers = [for (var i = 0; i < 3; i++) TextEditingController()];

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF0D0F1A),
      title: Text('Tomorrow\'s actions', style: cinzel(15)),
      content: SizedBox(
        width: 320,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('The Confidant is offline — set 1–3 concrete actions yourself.',
                style: raleway(11, color: Colors.white54)),
            const SizedBox(height: 10),
            for (final c in _controllers)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: TextField(
                  controller: c,
                  style: raleway(12),
                  decoration: InputDecoration(
                    hintText: 'e.g. 20 Anki reps before noon',
                    hintStyle: raleway(11,
                        color: Colors.white.withValues(alpha: 0.25)),
                    isDense: true,
                  ),
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: raleway(12.5))),
        TextButton(
            onPressed: () => Navigator.pop(context, [
                  for (final c in _controllers)
                    if (c.text.trim().isNotEmpty) c.text.trim()
                ]),
            child: Text('Close the day',
                style: raleway(12.5, color: kJournalViolet))),
      ],
    );
  }
}

class _JournalScreenState extends ConsumerState<JournalScreen> {
  final _input = TextEditingController();
  final _scroll = ScrollController();
  bool _aiThinking = false;
  bool _closing = false;
  String? _error;

  String get _today => dayKey(DateTime.now());

  JournalEntry get _entry =>
      ref.watch(journalProvider)[_today] ?? JournalEntry(day: _today);

  List<Map<String, String>> get _wireTranscript => [
        for (final t in _entry.transcript.length > 16
            ? _entry.transcript.sublist(_entry.transcript.length - 16)
            : _entry.transcript)
          {'role': t.role, 'text': t.text}
      ];

  List<Map<String, dynamic>> get _wireYesterday {
    final y = ref.read(todayActionsProvider);
    return [
      for (final a in y?.actions ?? const <ActionItem>[])
        {'text': a.text, 'done': a.done}
    ];
  }

  /// The habit ledger: up to the last 365 closed days (excluding tonight),
  /// oldest first, trimmed to the backend's field caps. This is the
  /// Confidant's long memory — what was set, what was done, what was learned.
  List<Map<String, dynamic>> get _wireHistory {
    final entries = ref
        .read(journalProvider)
        .values
        .where((e) => e.closed && e.day.compareTo(_today) < 0)
        .toList()
      ..sort((a, b) => a.day.compareTo(b.day));
    final recent = entries.length > 365
        ? entries.sublist(entries.length - 365)
        : entries;
    String clip(String s, int n) => s.length > n ? s.substring(0, n) : s;
    return [
      for (final e in recent)
        {
          'day': e.day,
          'actions': [
            for (final a in e.actions.take(6))
              if (a.text.trim().isNotEmpty)
                {'text': clip(a.text, 200), 'done': a.done}
          ],
          'reflection': clip(e.reflection, 300),
        }
    ];
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _greetIfEmpty());
  }

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  /// Open the session with the Confidant's greeting (AI) or a static prompt.
  void _greetIfEmpty() {
    final notifier = ref.read(journalProvider.notifier);
    final e = notifier.entryFor(_today);
    if (e.transcript.isNotEmpty || e.closed) return;
    final yesterday = ref.read(todayActionsProvider);
    final greeting = yesterday == null
        ? 'The stars are out. Tell me about your day — what did you do, '
            'what went well, and what fell short?'
        : 'The stars are out. How did the day go — and how did you fare '
            'with what you set for yourself?';
    notifier.save(e.copyWith(transcript: [JournalTurn('ai', greeting)]));
  }

  Future<void> _send() async {
    final text = _input.text.trim();
    if (text.isEmpty || _aiThinking) return;
    final notifier = ref.read(journalProvider.notifier);
    final api = ref.read(apiProvider);
    var e = notifier.entryFor(_today);
    e = e.copyWith(transcript: [...e.transcript, JournalTurn('user', text)]);
    notifier.save(e);
    _input.clear();
    _scrollDown();
    if (!api.configured) return; // honour mode: monologue journal
    setState(() {
      _aiThinking = true;
      _error = null;
    });
    try {
      final reply = await api.journalReply(
        day: _today,
        transcript: _wireTranscript,
        yesterdayActions: _wireYesterday,
        history: _wireHistory,
      );
      if (!mounted) return;
      final cur = notifier.entryFor(_today);
      notifier.save(cur
          .copyWith(transcript: [...cur.transcript, JournalTurn('ai', reply)]));
      _scrollDown();
    } on ApiException catch (err) {
      if (!mounted) return;
      setState(() => _error = err.message);
    } finally {
      if (mounted) setState(() => _aiThinking = false);
    }
  }

  Future<void> _closeDay() async {
    final notifier = ref.read(journalProvider.notifier);
    final api = ref.read(apiProvider);
    setState(() {
      _closing = true;
      _error = null;
    });
    try {
      if (api.configured) {
        final res = await api.journalClose(
          day: _today,
          transcript: _wireTranscript,
          yesterdayActions: _wireYesterday,
          history: _wireHistory,
        );
        if (!mounted) return;
        final cur = notifier.entryFor(_today);
        notifier.save(cur.copyWith(
          actions: [for (final a in res.actions) ActionItem(a)],
          reflection: res.reflection,
          closedAt: DateTime.now(),
        ));
      } else {
        await _selfCloseDialog(notifier);
      }
    } on ApiException catch (err) {
      if (!mounted) return;
      setState(() => _error = err.message);
    } finally {
      if (mounted) setState(() => _closing = false);
    }
  }

  /// Honour mode: write your own 1–3 actions for tomorrow.
  Future<void> _selfCloseDialog(JournalNotifier notifier) async {
    final actions = await showDialog<List<String>>(
      context: context,
      builder: (_) => const _HonourCloseDialog(),
    );
    if (actions == null) return;
    final cur = notifier.entryFor(_today);
    notifier.save(cur.copyWith(
      actions: [for (final a in actions.take(3)) ActionItem(a)],
      reflection: 'Closed on the honour system.',
      closedAt: DateTime.now(),
    ));
  }

  void _scrollDown() => WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scroll.hasClients) {
          _scroll.animateTo(_scroll.position.maxScrollExtent + 80,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut);
        }
      });

  @override
  Widget build(BuildContext context) {
    final e = _entry;
    final api = ref.watch(apiProvider);
    final userSpoke = e.transcript.any((t) => t.role == 'user');

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const Starfield(nebulae: [kJournalViolet], starCount: 1200),
          SafeArea(
            child: Column(
              children: [
                _header(e),
                if (!api.configured)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 4, 18, 0),
                    child: Text(
                      '⚠ CONFIDANT OFFLINE — this build has no BACKEND_URL. '
                      'In Codemagic, the variables must live in a group the '
                      'workflow imports (see backend/DEPLOY.md).',
                      style: raleway(8.5,
                          color: const Color(0xFFFFC46B).withValues(alpha: 0.8),
                          height: 1.5),
                    ),
                  ),
                Expanded(
                  child: e.closed
                      ? _closedView(e)
                      : ListView(
                          controller: _scroll,
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
                          children: [
                            for (final t in e.transcript) _bubble(t),
                            if (_aiThinking)
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(children: [
                                  const SizedBox(
                                      width: 12,
                                      height: 12,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 1.5)),
                                  const SizedBox(width: 10),
                                  Text('The Confidant considers…',
                                      style: raleway(10.5,
                                          color: Colors.white38)),
                                ]),
                              ),
                            if (_error != null)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Text('⚠ $_error',
                                    style: raleway(10.5,
                                        color: const Color(0xFFFFC46B))),
                              ),
                          ],
                        ),
                ),
                if (!e.closed) _composer(api, userSpoke),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _header(JournalEntry e) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 8, 20, 4),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.of(context).pop(),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                border:
                    Border.all(color: kJournalViolet.withValues(alpha: 0.35)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text('← Sky',
                  style: cinzel(11, weight: 500, color: kJournalViolet)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('THE JOURNAL',
                    style: cinzel(15,
                        weight: 640, color: kJournalViolet, spacing: 3)),
                Text(
                  e.closed
                      ? 'Tonight is closed — the loop continues tomorrow'
                      : 'Close the loop: your day, its lessons, tomorrow\'s actions',
                  style: raleway(9.5, color: Colors.white.withValues(alpha: 0.5)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bubble(JournalTurn t) {
    final isUser = t.role == 'user';
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: const BoxConstraints(maxWidth: 300),
        decoration: BoxDecoration(
          color: isUser
              ? kJournalViolet.withValues(alpha: 0.16)
              : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(14),
            topRight: const Radius.circular(14),
            bottomLeft: Radius.circular(isUser ? 14 : 3),
            bottomRight: Radius.circular(isUser ? 3 : 14),
          ),
          border: Border.all(
              color: isUser
                  ? kJournalViolet.withValues(alpha: 0.3)
                  : Colors.white.withValues(alpha: 0.08)),
        ),
        child: Text(t.text, style: raleway(12.5, height: 1.5)),
      ),
    );
  }

  Widget _composer(MentalApi api, bool userSpoke) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 12),
      decoration: BoxDecoration(
        color: kSpaceDeep.withValues(alpha: 0.85),
        border: Border(
            top: BorderSide(color: kJournalViolet.withValues(alpha: 0.2))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _input,
                  minLines: 1,
                  maxLines: 4,
                  style: raleway(12.5, height: 1.4),
                  cursorColor: kJournalViolet,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Tell the Confidant about your day…',
                    hintStyle: raleway(11.5,
                        color: Colors.white.withValues(alpha: 0.25)),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.05),
                    isDense: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: Colors.white.withValues(alpha: 0.1)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: kJournalViolet.withValues(alpha: 0.5)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                style: IconButton.styleFrom(
                    backgroundColor: _input.text.trim().isEmpty || _aiThinking
                        ? Colors.white.withValues(alpha: 0.06)
                        : kJournalViolet.withValues(alpha: 0.85)),
                onPressed:
                    _input.text.trim().isEmpty || _aiThinking ? null : _send,
                icon: const Icon(Icons.arrow_upward, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 42,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: userSpoke && !_closing && !_aiThinking
                    ? kJournalViolet.withValues(alpha: 0.9)
                    : Colors.white.withValues(alpha: 0.06),
                foregroundColor:
                    userSpoke ? kSpaceBlack : Colors.white38,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed:
                  userSpoke && !_closing && !_aiThinking ? _closeDay : null,
              child: _closing
                  ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const SizedBox(
                          width: 13,
                          height: 13,
                          child: CircularProgressIndicator(strokeWidth: 2)),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text('DISTILLING ACTIONS…',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: raleway(10,
                                weight: 600,
                                color: Colors.white54,
                                spacing: 1)),
                      ),
                    ])
                  : Text(
                      userSpoke
                          ? '🌙  CLOSE THE DAY'
                          : 'SPEAK FIRST, THEN CLOSE THE DAY',
                      style: userSpoke
                          ? cinzel(12, weight: 700, color: kSpaceBlack)
                          : raleway(10,
                              weight: 600, color: Colors.white38, spacing: 1)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _closedView(JournalEntry e) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 30),
      children: [
        Center(
            child: Text('✦',
                style: TextStyle(
                    fontSize: 34,
                    color: kJournalViolet.withValues(alpha: 0.9)))),
        const SizedBox(height: 12),
        if (e.reflection.isNotEmpty) ...[
          Center(
            child: Text('"${e.reflection}"',
                textAlign: TextAlign.center,
                style: cinzel(13.5, weight: 500,
                    color: Colors.white.withValues(alpha: 0.9))),
          ),
          const SizedBox(height: 20),
        ],
        Text('TOMORROW\'S ACTIONS',
            style: raleway(8.5,
                color: Colors.white.withValues(alpha: 0.3), spacing: 2)),
        const SizedBox(height: 8),
        for (final a in e.actions)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('◈',
                    style: TextStyle(
                        fontSize: 12,
                        color: kJournalViolet.withValues(alpha: 0.8))),
                const SizedBox(width: 10),
                Expanded(
                    child: Text(a.text, style: raleway(12.5, height: 1.5))),
              ],
            ),
          ),
        const SizedBox(height: 24),
        Center(
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: kJournalViolet.withValues(alpha: 0.9),
              foregroundColor: kSpaceBlack,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              padding:
                  const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: Text('RETURN TO THE SKY',
                style: cinzel(12, weight: 700, color: kSpaceBlack)),
          ),
        ),
      ],
    );
  }
}
