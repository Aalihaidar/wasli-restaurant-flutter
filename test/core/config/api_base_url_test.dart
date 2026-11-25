import 'package:flutter_test/flutter_test.dart';
import 'package:wasli_restaurant/api/config/config_client.dart';
import 'package:wasli_restaurant/core/config/app_environment.dart';
import 'package:wasli_restaurant/core/network/dio_factory.dart';

import '../../support/fake_http_adapter.dart';

/// A `GET /config` answer with invented values, as in the contract example.
const Map<String, Object> _configBody = {
  'location_check': 'warn',
  'require_screen_online': true,
  'ai_enabled': true,
  'languages': ['en', 'ar'],
  'poll_interval_seconds': 3,
};

void main() {
  group('API_BASE_URL joined with the generated paths', () {
    // Every accepted spelling of the same server must reach the same URL, and none may repeat /api/v1.
    for (final (value, expected) in [
      ('https://api.example.test', 'https://api.example.test/api/v1/config'),
      ('https://api.example.test/', 'https://api.example.test/api/v1/config'),
      ('  https://api.example.test  ', 'https://api.example.test/api/v1/config'),
      ('https://api.example.test:8443', 'https://api.example.test:8443/api/v1/config'),
      ('http://10.0.2.2:8000', 'http://10.0.2.2:8000/api/v1/config'),
      ('http://localhost:8000/', 'http://localhost:8000/api/v1/config'),
    ]) {
      test('"$value" calls $expected', () async {
        final environment = AppEnvironment.parse(apiBaseUrl: value);
        final adapter = FakeHttpAdapter([jsonResponder(_configBody)]);
        final client = ConfigClient(createDio(baseUrl: environment.apiBaseUrl, adapter: adapter));

        final config = await client.configRetrieve();

        expect(adapter.requests.single.uri.toString(), expected);
        expect(config.pollIntervalSeconds, 3);
      });
    }
  });
}
