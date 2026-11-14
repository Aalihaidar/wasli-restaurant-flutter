import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wasli_restaurant/core/network/dio_factory.dart';
import 'package:wasli_restaurant/core/network/retry_interceptor.dart';

import '../../support/fake_http_adapter.dart';

void main() {
  late List<Duration> sleeps;

  setUp(() => sleeps = []);

  (Dio, FakeHttpAdapter) build(List<FakeResponder> script, {int maxRetries = 2}) {
    final adapter = FakeHttpAdapter(script);
    final dio = createDio(baseUrl: Uri.parse('https://api.example.test'), adapter: adapter);
    dio.interceptors.add(RetryInterceptor(dio: dio, maxRetries: maxRetries, sleep: (delay) async => sleeps.add(delay)));
    return (dio, adapter);
  }

  group('RetryInterceptor', () {
    test('retries a read after a connection error and returns the later success', () async {
      final (dio, adapter) = build([
        failingResponder(DioExceptionType.connectionError),
        jsonResponder({'ok': true}),
      ]);

      final response = await dio.get<dynamic>('/api/v1/staff/orders');

      expect(response.statusCode, 200);
      expect(adapter.requests, hasLength(2));
      expect(sleeps, [const Duration(milliseconds: 300)]);
    });

    test('waits twice as long before each further attempt and gives up after the maximum', () async {
      final (dio, adapter) = build([failingResponder(DioExceptionType.receiveTimeout)]);

      await expectLater(
        dio.get<dynamic>('/api/v1/staff/orders'),
        throwsA(isA<DioException>().having((e) => e.type, 'type', DioExceptionType.receiveTimeout)),
      );

      expect(adapter.requests, hasLength(3));
      expect(sleeps, [const Duration(milliseconds: 300), const Duration(milliseconds: 600)]);
    });

    test('retries a gateway error', () async {
      for (final status in [502, 503, 504]) {
        sleeps.clear();
        final (dio, adapter) = build([jsonResponder({}, status: status), jsonResponder({})]);

        final response = await dio.get<dynamic>('/api/v1/staff/orders');

        expect(response.statusCode, 200, reason: '$status');
        expect(adapter.requests, hasLength(2), reason: '$status');
      }
    });

    test('never retries a call that changes something', () async {
      for (final send in <Future<Response<dynamic>> Function(Dio)>[
        (dio) => dio.post<dynamic>('/api/v1/staff/orders/1/accept'),
        (dio) => dio.put<dynamic>('/api/v1/staff/orders/1'),
        (dio) => dio.patch<dynamic>('/api/v1/staff/orders/1'),
        (dio) => dio.delete<dynamic>('/api/v1/auth/logout'),
      ]) {
        final (dio, adapter) = build([failingResponder(DioExceptionType.connectionTimeout), jsonResponder({})]);

        await expectLater(send(dio), throwsA(isA<DioException>()));

        expect(adapter.requests, hasLength(1));
      }
      expect(sleeps, isEmpty);
    });

    test('never retries a 429, a 500 or a client error', () async {
      for (final status in [400, 401, 403, 404, 409, 429, 500]) {
        final (dio, adapter) = build([jsonResponder({}, status: status), jsonResponder({})]);

        await expectLater(dio.get<dynamic>('/api/v1/staff/orders'), throwsA(isA<DioException>()));

        expect(adapter.requests, hasLength(1), reason: '$status');
      }
      expect(sleeps, isEmpty);
    });

    test('never retries a cancelled call', () async {
      final (dio, adapter) = build([failingResponder(DioExceptionType.cancel), jsonResponder({})]);

      await expectLater(dio.get<dynamic>('/api/v1/staff/orders'), throwsA(isA<DioException>()));

      expect(adapter.requests, hasLength(1));
    });

    test('a maximum of zero turns retrying off', () async {
      final (dio, adapter) = build([
        failingResponder(DioExceptionType.connectionError),
        jsonResponder({}),
      ], maxRetries: 0);

      await expectLater(dio.get<dynamic>('/api/v1/staff/orders'), throwsA(isA<DioException>()));

      expect(adapter.requests, hasLength(1));
    });
  });
}
