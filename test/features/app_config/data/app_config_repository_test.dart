import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wasli_restaurant/api/api.dart';
import 'package:wasli_restaurant/core/error/failure.dart';
import 'package:wasli_restaurant/core/network/dio_factory.dart';
import 'package:wasli_restaurant/features/app_config/data/app_config_mapper.dart';
import 'package:wasli_restaurant/features/app_config/data/app_config_repository_impl.dart';

import '../../../support/api_fixtures.dart';
import '../../../support/fake_http_adapter.dart';

/// The `GET /config` fixture, with the poll interval changed for the tests that need another one.
Map<String, Object?> configJson({int pollIntervalSeconds = 3}) => {
  ...readApiFixture('config_200'),
  'poll_interval_seconds': pollIntervalSeconds,
};

AppConfigRepositoryImpl _repository(FakeHttpAdapter adapter) {
  final dio = createDio(baseUrl: Uri.parse('https://api.example.test'), adapter: adapter);
  return AppConfigRepositoryImpl(Api(dio).config);
}

void main() {
  group('AppConfigRepositoryImpl', () {
    test('asks GET /api/v1/config and reads the poll interval', () async {
      final adapter = FakeHttpAdapter([jsonResponder(configJson(pollIntervalSeconds: 5))]);

      final config = await _repository(adapter).load();

      expect(config.pollInterval, const Duration(seconds: 5));
      expect(adapter.requests.single.method, 'GET');
      expect(adapter.requests.single.uri.toString(), 'https://api.example.test/api/v1/config');
    });

    test('a call that got no answer is a NetworkFailure', () async {
      final adapter = FakeHttpAdapter([failingResponder(DioExceptionType.connectionError)]);

      await expectLater(_repository(adapter).load(), throwsA(isA<NetworkFailure>()));
    });

    test('a 503 is a ServerFailure with its status', () async {
      final adapter = FakeHttpAdapter([
        jsonResponder({'type': 'server_error', 'errors': <Object>[]}, status: 503, headers: {'x-request-id': 'req-1'}),
      ]);

      await expectLater(
        _repository(adapter).load(),
        throwsA(isA<ServerFailure>().having((f) => f.requestId, 'requestId', 'req-1')),
      );
    });
  });

  group('appConfigFromDto', () {
    for (final (seconds, expected) in [(3, 3), (1, 1), (0, minPollIntervalSeconds), (-2, minPollIntervalSeconds)]) {
      test('$seconds seconds gives a poll interval of $expected', () {
        final dto = Config.fromJson(configJson(pollIntervalSeconds: seconds));

        expect(appConfigFromDto(dto).pollInterval, Duration(seconds: expected));
      });
    }
  });
}
