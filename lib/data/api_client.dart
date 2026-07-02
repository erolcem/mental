// data/api_client.dart — thin HTTP client for the Mental backend (the
// Examiner), same shape as physical's api_client. The app stays fully usable
// with no backend configured: verification simply switches off.
//
// Configure at build time:
//   flutter build ... --dart-define=BACKEND_URL=https://... \
//                     --dart-define=APP_TOKEN=<same value as the backend env>
import 'dart:convert';

import 'package:http/http.dart' as http;

const String kBackendUrl = String.fromEnvironment('BACKEND_URL');
const String kAppToken = String.fromEnvironment('APP_TOKEN');

class ApiException implements Exception {
  final String message;
  final int? status;
  ApiException(this.message, [this.status]);
  @override
  String toString() => 'ApiException($status): $message';
}

/// The Examiner's judgement on one summary sheet.
class ExaminerVerdict {
  final bool passed;
  final double confidence;
  final String feedback;
  const ExaminerVerdict(
      {required this.passed, required this.confidence, required this.feedback});
}

/// The Reviewer's grade on a spaced-repetition quiz.
class ReviewGrade {
  final bool passed;
  final String feedback;
  final List<String> notes; // one short note per answer
  const ReviewGrade(
      {required this.passed, required this.feedback, this.notes = const []});
}

/// The Confidant's distillation of a closed journal session.
class JournalCloseResult {
  final List<String> actions; // 1–3 next-day items
  final String reflection;
  const JournalCloseResult({required this.actions, required this.reflection});
}

class MentalApi {
  final String baseUrl;
  final String token;
  final http.Client _client;

  MentalApi({this.baseUrl = kBackendUrl, this.token = kAppToken, http.Client? client})
      : _client = client ?? http.Client();

  /// False when the app was built without a BACKEND_URL — the sky then runs
  /// on the honour system (stage-1 behaviour).
  bool get configured => baseUrl.isNotEmpty;

  Future<ExaminerVerdict> verifySummary({
    required String stat,
    required String skill,
    required String goal,
    required String node,
    required int tier,
    required List<String> prerequisites,
    required String summary,
    String proof = '',
  }) async {
    final j = await _post('/verify', {
      'stat': stat,
      'skill': skill,
      'goal': goal,
      'node': node,
      'tier': tier,
      'prerequisites': prerequisites,
      'summary': summary,
      'proof': proof,
    });
    return ExaminerVerdict(
      passed: j['verdict'] == 'pass',
      confidence: (j['confidence'] as num?)?.toDouble() ?? 0.5,
      feedback: (j['feedback'] as String?) ?? '',
    );
  }

  /// Fetch review quiz questions for one ignited star.
  Future<List<String>> reviewQuestions({
    required String stat,
    required String skill,
    required String goal,
    required String node,
    required int tier,
    required String summary,
    String proof = '',
  }) async {
    final j = await _post('/review/questions', {
      'stat': stat,
      'skill': skill,
      'goal': goal,
      'node': node,
      'tier': tier,
      'summary': summary,
      'proof': proof,
    });
    return [for (final q in (j['questions'] as List? ?? [])) q.toString()];
  }

  /// Grade the quiz answers.
  Future<ReviewGrade> gradeReview({
    required String stat,
    required String skill,
    required String goal,
    required String node,
    required int tier,
    required String summary,
    required List<String> questions,
    required List<String> answers,
    String proof = '',
  }) async {
    final j = await _post('/review/grade', {
      'stat': stat,
      'skill': skill,
      'goal': goal,
      'node': node,
      'tier': tier,
      'summary': summary,
      'proof': proof,
      'questions': questions,
      'answers': answers,
    });
    return ReviewGrade(
      passed: j['passed'] == true,
      feedback: (j['feedback'] as String?) ?? '',
      notes: [for (final n in (j['notes'] as List? ?? [])) n.toString()],
    );
  }

  /// One conversational turn from the Confidant.
  Future<String> journalReply({
    required String day,
    required List<Map<String, String>> transcript, // {role, text}
    required List<Map<String, dynamic>> yesterdayActions, // {text, done}
  }) async {
    final j = await _post('/journal/reply', {
      'day': day,
      'transcript': transcript,
      'yesterday_actions': yesterdayActions,
    });
    return (j['reply'] as String?) ?? '';
  }

  /// Close tonight's session → 1–3 next-day actions + a reflection.
  Future<JournalCloseResult> journalClose({
    required String day,
    required List<Map<String, String>> transcript,
    required List<Map<String, dynamic>> yesterdayActions,
  }) async {
    final j = await _post('/journal/close', {
      'day': day,
      'transcript': transcript,
      'yesterday_actions': yesterdayActions,
    });
    return JournalCloseResult(
      actions: [for (final a in (j['actions'] as List? ?? [])) a.toString()],
      reflection: (j['reflection'] as String?) ?? '',
    );
  }

  Future<Map<String, dynamic>> _post(String path, Map<String, dynamic> body) async {
    final http.Response r;
    try {
      r = await _client
          .post(
            Uri.parse('$baseUrl$path'),
            headers: {
              'Content-Type': 'application/json',
              if (token.isNotEmpty) 'Authorization': 'Bearer $token',
            },
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 75));
    } catch (e) {
      throw ApiException('Could not reach the Examiner: $e');
    }
    if (r.statusCode != 200) {
      String detail = r.body;
      try {
        detail = (jsonDecode(r.body) as Map<String, dynamic>)['detail']?.toString() ?? r.body;
      } catch (_) {}
      throw ApiException(detail, r.statusCode);
    }
    return jsonDecode(r.body) as Map<String, dynamic>;
  }
}
