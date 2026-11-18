import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wasli_restaurant/core/network/dio_factory.dart';

import '../../support/fake_http_adapter.dart';

void main() {
  group('createDio', () {
    test('sets the base URL, the three timeouts and the JSON accept header', () {
      final dio = createDio(baseUrl: Uri.parse('https://api.example.test'));

      expect(dio.options.baseUrl, 'https://api.example.test');
      expect(dio.options.connectTimeout, connectTimeout);
      expect(dio.options.sendTimeout, sendTimeout);
      expect(dio.options.receiveTimeout, receiveTimeout);
      expect(dio.options.headers[Headers.acceptHeader], Headers.jsonContentType);
    });

    test('joins the base URL with a generated path that starts with /api/v1', () async {
      final adapter = FakeHttpAdapter([jsonResponder({})]);
      final dio = createDio(baseUrl: Uri.parse('https://api.example.test'), adapter: adapter);

      await dio.get<dynamic>('/api/v1/config');

      expect(adapter.requests.single.uri.toString(), 'https://api.example.test/api/v1/config');
    });

    test('adds the interceptors in the given order after the built-in one', () {
      final first = InterceptorsWrapper();
      final second = InterceptorsWrapper();

      final dio = createDio(baseUrl: Uri.parse('https://api.example.test'), interceptors: [first, second]);

      expect(dio.interceptors.indexOf(first), lessThan(dio.interceptors.indexOf(second)));
    });
  });
}
