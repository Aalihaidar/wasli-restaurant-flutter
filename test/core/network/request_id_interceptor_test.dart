import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wasli_restaurant/core/network/dio_factory.dart';
import 'package:wasli_restaurant/core/network/request_id_interceptor.dart';
import 'package:wasli_restaurant/core/network/request_id_recorder.dart';

import '../../support/fake_http_adapter.dart';

void main() {
  group('RequestIdInterceptor', () {
    test('records the ID of a successful response', () async {
      final recorder = RequestIdRecorder();
      final dio = createDio(
        baseUrl: Uri.parse('https://api.example.test'),
        interceptors: [RequestIdInterceptor(recorder)],
        adapter: FakeHttpAdapter([
          jsonResponder({}, headers: {'X-Request-ID': 'req-1'}),
        ]),
      );

      await dio.get<dynamic>('/api/v1/config');

      expect(recorder.last, 'req-1');
    });

    test('records the ID of an error response', () async {
      final recorder = RequestIdRecorder();
      final dio = createDio(
        baseUrl: Uri.parse('https://api.example.test'),
        interceptors: [RequestIdInterceptor(recorder)],
        adapter: FakeHttpAdapter([
          jsonResponder({}, status: 500, headers: {'X-Request-ID': 'req-2'}),
        ]),
      );

      await expectLater(dio.get<dynamic>('/api/v1/config'), throwsA(isA<DioException>()));

      expect(recorder.last, 'req-2');
    });

    test('keeps the previous ID when a response has none', () async {
      final recorder = RequestIdRecorder()..last = 'req-old';
      final dio = createDio(
        baseUrl: Uri.parse('https://api.example.test'),
        interceptors: [RequestIdInterceptor(recorder)],
        adapter: FakeHttpAdapter([jsonResponder({})]),
      );

      await dio.get<dynamic>('/api/v1/config');

      expect(recorder.last, 'req-old');
    });
  });
}
