import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wasli_restaurant/core/error/failure.dart';
import 'package:wasli_restaurant/core/network/dio_factory.dart';
import 'package:wasli_restaurant/core/network/dio_failure_mapper.dart';

import '../../support/fake_http_adapter.dart';

Dio _dio(FakeResponder responder) =>
    createDio(baseUrl: Uri.parse('https://api.example.test'), adapter: FakeHttpAdapter([responder]));

Future<Failure> _failureOf(Dio dio) async {
  try {
    await guardRequest(() => dio.get<dynamic>('/api/v1/staff/orders'));
  } on Failure catch (failure) {
    return failure;
  }
  throw StateError('the call did not fail');
}

void main() {
  group('guardRequest', () {
    test('returns the result of a successful call', () async {
      final dio = _dio(jsonResponder({'ok': true}));

      final response = await guardRequest(() => dio.get<dynamic>('/api/v1/config'));

      expect(response.statusCode, 200);
    });

    test('maps an error response by its status, with the request ID and the codes', () async {
      final dio = _dio(
        jsonResponder(
          {
            'type': 'client_error',
            'errors': [
              {'code': 'permission_denied', 'detail': 'Invented text.', 'attr': null},
            ],
          },
          status: 403,
          headers: {'X-Request-ID': 'req-42'},
        ),
      );

      final failure = await _failureOf(dio);

      expect(failure, isA<PermissionDeniedFailure>());
      expect(failure.requestId, 'req-42');
      expect(failure.hasCode('permission_denied'), isTrue);
    });

    test('reads Retry-After on a 429', () async {
      final dio = _dio(jsonResponder({'errors': <Object>[]}, status: 429, headers: {'Retry-After': '30'}));

      final failure = await _failureOf(dio);

      expect((failure as ThrottledFailure).retryAfter, const Duration(seconds: 30));
    });

    test('a proxy error page is a failure of its status with no entries', () async {
      final dio = _dio(textResponder('<html>Bad gateway</html>', status: 502));

      final failure = await _failureOf(dio);

      expect(failure, isA<ServerFailure>());
      expect(failure.errors, isEmpty);
    });

    test('a call without a response is a network failure', () async {
      for (final type in [
        DioExceptionType.connectionTimeout,
        DioExceptionType.sendTimeout,
        DioExceptionType.receiveTimeout,
        DioExceptionType.connectionError,
        DioExceptionType.badCertificate,
      ]) {
        final failure = await _failureOf(_dio(failingResponder(type)));

        expect(failure, isA<NetworkFailure>(), reason: type.name);
      }
    });

    test('a cancelled call is passed on unchanged', () async {
      final dio = _dio(failingResponder(DioExceptionType.cancel));

      await expectLater(
        guardRequest(() => dio.get<dynamic>('/api/v1/config')),
        throwsA(isA<DioException>().having((e) => e.type, 'type', DioExceptionType.cancel)),
      );
    });
  });
}
