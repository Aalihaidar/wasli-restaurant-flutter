import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wasli_restaurant/core/network/dio_factory.dart';
import 'package:wasli_restaurant/core/network/redacted_log_interceptor.dart';

import '../../support/fake_http_adapter.dart';

void main() {
  late List<String> lines;

  setUp(() => lines = []);

  Dio build(FakeResponder responder) => createDio(
    baseUrl: Uri.parse('https://api.example.test'),
    interceptors: [RedactedLogInterceptor(lines.add)],
    adapter: FakeHttpAdapter([responder]),
  );

  group('RedactedLogInterceptor', () {
    test('logs the method, the path and the status', () async {
      await build(jsonResponder({})).get<dynamic>('/api/v1/config');

      expect(lines.single, matches(RegExp(r'^GET /api/v1/config 200 \(\d+ ms\)$')));
    });

    test('never logs the query string, the headers or the body', () async {
      await build(jsonResponder({'plate': 'INVENTED-123'})).post<dynamic>(
        '/api/v1/staff/orders?lat=25.1&lng=55.2',
        data: {'note': 'invented customer note'},
        options: Options(headers: {'Authorization': 'Token invented-token'}),
      );

      final logged = lines.join('\n');
      expect(logged, contains('POST /api/v1/staff/orders 200'));
      for (final secret in ['lat=', 'lng=', 'invented-token', 'invented customer note', 'INVENTED-123', 'Token']) {
        expect(logged, isNot(contains(secret)));
      }
    });

    test('logs an error response by its status', () async {
      await expectLater(
        build(jsonResponder({}, status: 403)).get<dynamic>('/api/v1/staff/orders'),
        throwsA(isA<DioException>()),
      );

      expect(lines.single, startsWith('GET /api/v1/staff/orders 403'));
    });

    test('logs a call without a response by its kind only', () async {
      await expectLater(
        build(failingResponder(DioExceptionType.connectionTimeout)).get<dynamic>('/api/v1/staff/orders'),
        throwsA(isA<DioException>()),
      );

      expect(lines.single, startsWith('GET /api/v1/staff/orders connectionTimeout'));
      expect(lines.single, isNot(contains('api.example.test')));
    });
  });
}
