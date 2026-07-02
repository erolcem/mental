// ui/review_screen.dart — the Review: every star past its review date must
// be faced before the sky unlocks. With a backend, the Reviewer asks two
// probing questions per star and grades the answers (pass → the interval
// climbs; fail → restudy, return tomorrow). Without one, reviews are
// self-attested on the honour system.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/api_client.dart';
import '../state/providers.dart';
import 'starfield.dart';
import 'theme.dart';

class ReviewScreen extends ConsumerStatefulWidget {
  const ReviewScreen({super.key});

  @override
  ConsumerState<ReviewScreen> createState() => _ReviewScreenState();
}

enum _Phase { intro, loading, quiz, grading, verdict }

class _ReviewScreenState extends ConsumerState<ReviewScreen> {
  _Phase _phase = _Phase.intro;
  List<String> _questions = [];
  List<TextEditingController> _answers = [];
  ReviewGrade? _grade;
  String? _error;
  int _doneCount = 0; // stars faced this session (for the header)

  /// The star being examined. Frozen once a review begins — recording the
  /// grade removes it from the due list, but the verdict must still speak
  /// about THIS star.
  DueReview? _active;

  DueReview? _sessionNode(List<DueReview> due) {
    if (_phase == _Phase.intro) return due.isEmpty ? null : due.first;
    return _active;
  }

  @override
  void dispose() {
    for (final c in _answers) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _begin(DueReview r) async {
    final api = ref.read(apiProvider);
    if (!api.configured) return; // honour mode uses its own button
    setState(() {
      _active = r;
      _phase = _Phase.loading;
      _error = null;
    });
    try {
      final qs = await api.reviewQuestions(
        stat: r.stat.label,
        skill: r.skill.label,
        goal: r.skill.goal,
        node: r.node.label,
        tier: r.node.tier,
        summary: r.progress.summary,
        proof: r.node.proof,
      );
      if (!mounted) return;
      setState(() {
        _questions = qs;
        for (final c in _answers) {
          c.dispose();
        }
        _answers = [for (final _ in qs) TextEditingController()];
        _phase = _Phase.quiz;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _phase = _Phase.intro;
        _error = e.message;
      });
    }
  }

  Future<void> _submit(DueReview r) async {
    final api = ref.read(apiProvider);
    setState(() {
      _phase = _Phase.grading;
      _error = null;
    });
    try {
      final grade = await api.gradeReview(
        stat: r.stat.label,
        skill: r.skill.label,
        goal: r.skill.goal,
        node: r.node.label,
        tier: r.node.tier,
        summary: r.progress.summary,
        proof: r.node.proof,
        questions: _questions,
        answers: [for (final c in _answers) c.text],
      );
      if (!mounted) return;
      final notifier = ref.read(progressProvider.notifier);
      if (grade.passed) {
        notifier.recordReviewPass(r.skill.id, r.node.id);
      } else {
        notifier.recordReviewFail(r.skill.id, r.node.id);
      }
      setState(() {
        _grade = grade;
        _doneCount++;
        _phase = _Phase.verdict;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _phase = _Phase.quiz; // answers are kept — retry submission
        _error = e.message;
      });
    }
  }

  void _selfAttest(DueReview r) {
    ref.read(progressProvider.notifier).recordReviewPass(r.skill.id, r.node.id);
    setState(() {
      _active = r;
      _grade = const ReviewGrade(
          passed: true,
          feedback: 'Reviewed on the honour system — the Examiner was offline.');
      _doneCount++;
      _phase = _Phase.verdict;
    });
  }

  void _next() {
    setState(() {
      _phase = _Phase.intro;
      _active = null;
      _grade = null;
      _questions = [];
      _error = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final due = ref.watch(dueReviewsProvider);
    final current = _sessionNode(due);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Starfield(
              nebulae: [if (current != null) current.stat.color else kGold],
              starCount: 1200),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _header(due.length),
                Expanded(
                  child: current == null
                      ? _allClear()
                      : SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(22, 8, 22, 30),
                          child: _body(current, due.length),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _header(int remaining) {
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
                border: Border.all(color: kGold.withValues(alpha: 0.35)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text('← Sky', style: cinzel(11, weight: 500, color: kGold)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('THE REVIEW', style: cinzel(15, weight: 640, color: kGold, spacing: 3)),
                Text(
                  remaining == 0
                      ? 'The sky is unlocked'
                      : '$remaining ${remaining == 1 ? 'star demands' : 'stars demand'} review — the sky is locked',
                  style: raleway(9.5, color: Colors.white.withValues(alpha: 0.5)),
                ),
              ],
            ),
          ),
          if (_doneCount > 0)
            Text('$_doneCount faced',
                style: raleway(9.5, color: kGold.withValues(alpha: 0.7))),
        ],
      ),
    );
  }

  Widget _allClear() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('✦', style: TextStyle(fontSize: 42, color: kGold.withValues(alpha: 0.9))),
          const SizedBox(height: 14),
          Text('EVERY STAR HOLDS ITS LIGHT', style: cinzel(15, weight: 640, spacing: 2)),
          const SizedBox(height: 8),
          Text('The sky is unlocked. Return when the next review is due.',
              style: raleway(11.5, color: Colors.white.withValues(alpha: 0.5))),
          const SizedBox(height: 22),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: kGold.withValues(alpha: 0.9),
              foregroundColor: kSpaceBlack,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: Text('RETURN TO THE SKY', style: cinzel(12, weight: 700, color: kSpaceBlack)),
          ),
        ],
      ),
    );
  }

  Widget _body(DueReview r, int remaining) {
    final color = r.stat.color;
    final api = ref.watch(apiProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 10),
        // The star under review.
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              Text(r.skill.icon, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r.node.label, style: cinzel(14, weight: 640)),
                    const SizedBox(height: 2),
                    Text('${r.skill.label}  ·  ignited ${_ago(r.progress.completedAt)}',
                        style: raleway(9.5, color: color.withValues(alpha: 0.8))),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        if (_error != null) ...[
          _panel(const Color(0xFFFFC46B), 'THE EXAMINER COULD NOT BE REACHED', _error!),
          const SizedBox(height: 14),
        ],
        ...switch (_phase) {
          _Phase.intro => _intro(r, api),
          _Phase.loading => _waiting('The Examiner is preparing your questions…'),
          _Phase.quiz => _quiz(r),
          _Phase.grading => _waiting('The Examiner is weighing your answers…'),
          _Phase.verdict => _verdict(r, remaining),
        },
      ],
    );
  }

  List<Widget> _intro(DueReview r, MentalApi api) => [
        Text(
          api.configured
              ? "Answer the Examiner's questions from memory — no notes, no "
                  "searching. Pass and this star's next review moves further out; "
                  'fail and it returns tomorrow after you restudy.'
              : 'The Examiner is offline. Restudy your summary sheet, then attest '
                  'on your honour that you reviewed this star.',
          style: raleway(11.5, color: Colors.white.withValues(alpha: 0.6), height: 1.6),
        ),
        const SizedBox(height: 18),
        SizedBox(
          height: 48,
          child: FilledButton(
            style: _buttonStyle(r.stat.color),
            onPressed: () => api.configured ? _begin(r) : _selfAttest(r),
            child: Text(api.configured ? '⚖  BEGIN THE REVIEW' : '✦  I HAVE REVIEWED THIS STAR',
                style: cinzel(12.5, weight: 700, color: kSpaceBlack)),
          ),
        ),
      ];

  List<Widget> _waiting(String message) => [
        const SizedBox(height: 30),
        const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        const SizedBox(height: 14),
        Center(
            child: Text(message,
                style: raleway(11, color: Colors.white.withValues(alpha: 0.5)))),
        const SizedBox(height: 30),
      ];

  List<Widget> _quiz(DueReview r) => [
        for (var i = 0; i < _questions.length; i++) ...[
          Text('QUESTION ${i + 1} OF ${_questions.length}',
              style: raleway(8.5, color: r.stat.color.withValues(alpha: 0.7), spacing: 2)),
          const SizedBox(height: 6),
          Text(_questions[i], style: raleway(13, weight: 600, height: 1.5)),
          const SizedBox(height: 8),
          TextField(
            controller: _answers[i],
            maxLines: 5,
            minLines: 3,
            style: raleway(12.5, height: 1.5),
            cursorColor: r.stat.color,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Answer from memory…',
              hintStyle: raleway(11.5, color: Colors.white.withValues(alpha: 0.25)),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.05),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: r.stat.color.withValues(alpha: 0.5)),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
        SizedBox(
          height: 48,
          child: FilledButton(
            style: _buttonStyle(r.stat.color),
            onPressed: _answers.every((c) => c.text.trim().isNotEmpty)
                ? () => _submit(r)
                : null,
            child: Text('SUBMIT ANSWERS', style: cinzel(12.5, weight: 700, color: kSpaceBlack)),
          ),
        ),
      ];

  List<Widget> _verdict(DueReview r, int remaining) {
    final g = _grade!;
    final color = g.passed ? r.stat.color : const Color(0xFFFF8A7A);
    return [
      _panel(
        color,
        g.passed ? 'THE STAR HOLDS ITS LIGHT' : 'THE LIGHT IS FADING',
        g.feedback,
      ),
      if (g.notes.isNotEmpty) ...[
        const SizedBox(height: 10),
        for (var i = 0; i < g.notes.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Text('Q${i + 1}: ${g.notes[i]}',
                style: raleway(10.5, color: Colors.white.withValues(alpha: 0.55))),
          ),
      ],
      const SizedBox(height: 8),
      Text(
        g.passed
            ? 'Next review climbs the ladder.'
            : 'This star returns tomorrow — restudy your summary sheet tonight.',
        style: raleway(10.5, color: Colors.white.withValues(alpha: 0.45)),
      ),
      const SizedBox(height: 18),
      SizedBox(
        height: 48,
        child: FilledButton(
          style: _buttonStyle(remaining > 0 ? r.stat.color : kGold),
          onPressed: remaining > 0 ? _next : () => Navigator.of(context).pop(),
          child: Text(
            remaining > 0 ? 'NEXT STAR  ($remaining LEFT)' : 'RETURN TO THE UNLOCKED SKY',
            style: cinzel(12.5, weight: 700, color: kSpaceBlack),
          ),
        ),
      ),
    ];
  }

  ButtonStyle _buttonStyle(Color color) => FilledButton.styleFrom(
        backgroundColor: color.withValues(alpha: 0.9),
        foregroundColor: kSpaceBlack,
        disabledBackgroundColor: Colors.white.withValues(alpha: 0.06),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      );

  Widget _panel(Color color, String title, String body) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.35)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: raleway(8.5, weight: 700, color: color.withValues(alpha: 0.9), spacing: 2)),
            const SizedBox(height: 5),
            Text(body,
                style: raleway(11.5, color: Colors.white.withValues(alpha: 0.85), height: 1.5)),
          ],
        ),
      );

  static String _ago(DateTime? d) {
    if (d == null) return 'long ago';
    final days = DateTime.now().difference(d).inDays;
    if (days <= 0) return 'today';
    if (days == 1) return 'yesterday';
    if (days < 30) return '$days days ago';
    final months = (days / 30).floor();
    return months == 1 ? 'a month ago' : '$months months ago';
  }
}
