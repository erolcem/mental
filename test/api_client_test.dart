// MentalApi contract: request shape, auth header, verdict parsing, errors.
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mental/data/api_client.dart';

void main() {
  MentalApi api(Future<http.Response> Function(http.Request) handler) =>
      MentalApi(
          baseUrl: 'https://examiner.test',
          token: 'tok-123',
          client: MockClient(handler));

  Future<ExaminerVerdict> callVerify(MentalApi a) => a.verifySummary(
        stat: 'Intelligence',
        skill: 'Mathematics',
        goal: 'Fields Medal / Proof Mastery',
        node: 'Real Analysis I (Baby Rudin)',
        tier: 5,
        prerequisites: ['Calculus I-III (Stewart)'],
        summary: 'Worked through Rudin ch 1-7…',
      );

  test('unconfigured when BACKEND_URL is empty', () {
    expect(MentalApi(baseUrl: '', token: '').configured, isFalse);
    expect(MentalApi(baseUrl: 'https://x', token: '').configured, isTrue);
  });

  test('sends node context + bearer token, parses a pass', () async {
    late http.Request seen;
    final a = api((req) async {
      seen = req;
      return http.Response(
          jsonEncode({'verdict': 'pass', 'confidence': 0.9, 'feedback': 'Convincing.'}),
          200,
          headers: {'content-type': 'application/json'});
    });
    final v = await callVerify(a);
    expect(v.passed, isTrue);
    expect(v.confidence, 0.9);
    expect(v.feedback, 'Convincing.');
    expect(seen.url.path, '/verify');
    expect(seen.headers['Authorization'], 'Bearer tok-123');
    final body = jsonDecode(seen.body) as Map<String, dynamic>;
    expect(body['node'], 'Real Analysis I (Baby Rudin)');
    expect(body['tier'], 5);
    expect(body['prerequisites'], ['Calculus I-III (Stewart)']);
  });

  test('parses a fail verdict', () async {
    final a = api((_) async => http.Response(
        jsonEncode({'verdict': 'fail', 'confidence': 0.8, 'feedback': 'Too vague.'}),
        200,
        headers: {'content-type': 'application/json'}));
    final v = await callVerify(a);
    expect(v.passed, isFalse);
    expect(v.feedback, 'Too vague.');
  });

  test('non-200 surfaces the backend detail as ApiException', () async {
    final a = api((_) async => http.Response(
        jsonEncode({'detail': 'Examiner unavailable: boom'}), 502,
        headers: {'content-type': 'application/json'}));
    expect(
        callVerify(a),
        throwsA(isA<ApiException>().having(
            (e) => e.message, 'message', contains('Examiner unavailable'))));
  });

  test('network failure becomes ApiException', () async {
    final a = api((_) async => throw Exception('connection refused'));
    expect(callVerify(a), throwsA(isA<ApiException>()));
  });
}
