import 'package:flutter_test/flutter_test.dart';
import 'package:wasli_restaurant/core/network/dio_factory.dart';
import 'package:wasli_restaurant/core/network/locale_interceptor.dart';

import '../../support/fake_http_adapter.dart';

void main() {
  group('LocaleInterceptor', () {
    test('sends the current language on every call', () async {
      var language = 'en';
      final adapter = FakeHttpAdapter([jsonResponder({})]);
      final dio = createDio(
        baseUrl: Uri.parse('https://api.example.test'),
        interceptors: [LocaleInterceptor(() => language)],
        adapter: adapter,
      );

      await dio.get<dynamic>('/api/v1/config');
      language = 'ar';
      await dio.get<dynamic>('/api/v1/config');

      expect(adapter.requests.map((r) => r.headers['Accept-Language']), ['en', 'ar']);
    });
  });
}
