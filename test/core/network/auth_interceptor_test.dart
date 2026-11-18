import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wasli_restaurant/core/network/auth_interceptor.dart';
import 'package:wasli_restaurant/core/network/dio_factory.dart';

import '../../support/fake_http_adapter.dart';

void main() {
  late String? token;
  late int unauthenticatedCalls;

  setUp(() {
    token = 'invented-token';
    unauthenticatedCalls = 0;
  });

  Dio build(FakeHttpAdapter adapter) => createDio(
    baseUrl: Uri.parse('https://api.example.test'),
    adapter: adapter,
    interceptors: [AuthInterceptor(readToken: () async => token, onUnauthenticated: () => unauthenticatedCalls++)],
  );

  group('AuthInterceptor', () {
    test('adds the Token header to an authenticated call', () async {
      final adapter = FakeHttpAdapter([jsonResponder({})]);

      await build(adapter).get<dynamic>('/api/v1/staff/orders');

      expect(adapter.requests.single.headers['Authorization'], 'Token invented-token');
    });

    test('adds no header on the public config and login calls', () async {
      final adapter = FakeHttpAdapter([jsonResponder({})]);
      final dio = build(adapter);

      await dio.get<dynamic>('/api/v1/config');
      await dio.post<dynamic>('/api/v1/auth/login', data: {'username': 'u', 'password': 'p'});

      expect(adapter.requests.map((r) => r.headers.containsKey('Authorization')), [false, false]);
    });

    test('removes an Authorization header set by the caller on a public path', () async {
      final adapter = FakeHttpAdapter([jsonResponder({})]);

      await build(adapter).get<dynamic>('/api/v1/config', options: Options(headers: {'Authorization': 'Token other'}));

      expect(adapter.requests.single.headers.containsKey('Authorization'), isFalse);
    });

    test('adds no header when nobody is signed in', () async {
      token = null;
      final adapter = FakeHttpAdapter([jsonResponder({})]);

      await build(adapter).get<dynamic>('/api/v1/staff/orders');

      expect(adapter.requests.single.headers.containsKey('Authorization'), isFalse);
    });

    test('a 401 on an authenticated call reports the lost session', () async {
      final dio = build(
        FakeHttpAdapter([
          jsonResponder({'errors': <Object>[]}, status: 401),
        ]),
      );

      await expectLater(dio.get<dynamic>('/api/v1/staff/orders'), throwsA(isA<DioException>()));

      expect(unauthenticatedCalls, 1);
    });

    test('a 401 after the session was cleared or replaced is not reported again', () async {
      final dio = build(
        FakeHttpAdapter([
          (options) {
            token = null;
            return jsonResponder({'errors': <Object>[]}, status: 401)(options);
          },
        ]),
      );

      await expectLater(dio.get<dynamic>('/api/v1/staff/orders'), throwsA(isA<DioException>()));

      expect(unauthenticatedCalls, 0);
    });

    test('a 401 on the login call is a wrong password, not a lost session', () async {
      final dio = build(
        FakeHttpAdapter([
          jsonResponder({'errors': <Object>[]}, status: 401),
        ]),
      );

      await expectLater(dio.post<dynamic>('/api/v1/auth/login'), throwsA(isA<DioException>()));

      expect(unauthenticatedCalls, 0);
    });

    test('other errors do not report a lost session', () async {
      final dio = build(
        FakeHttpAdapter([
          jsonResponder({'errors': <Object>[]}, status: 403),
        ]),
      );

      await expectLater(dio.get<dynamic>('/api/v1/staff/orders'), throwsA(isA<DioException>()));

      expect(unauthenticatedCalls, 0);
    });
  });
}
