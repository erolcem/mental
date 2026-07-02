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
  }) async {
    final http.Response r;
    try {
      r = await _client
          .post(
            Uri.parse('$baseUrl/verify'),
            headers: {
              'Content-Type': 'application/json',
              if (token.isNotEmpty) 'Authorization': 'Bearer $token',
            },
            body: jsonEncode({
              'stat': stat,
              'skill': skill,
              'goal': goal,
              'node': node,
              'tier': tier,
              'prerequisites': prerequisites,
              'summary': summary,
            }),
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
    final j = jsonDecode(r.body) as Map<String, dynamic>;
    return ExaminerVerdict(
      passed: j['verdict'] == 'pass',
      confidence: (j['confidence'] as num?)?.toDouble() ?? 0.5,
      feedback: (j['feedback'] as String?) ?? '',
    );
  }
}
