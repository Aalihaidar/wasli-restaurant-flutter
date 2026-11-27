import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wasli_restaurant/core/config/app_environment.dart';
import 'package:wasli_restaurant/core/config/app_environment_provider.dart';
import 'package:wasli_restaurant/core/l10n/app_locales.dart';
import 'package:wasli_restaurant/core/l10n/locale_controller.dart';
import 'package:wasli_restaurant/core/network/api_providers.dart';
import 'package:wasli_restaurant/core/storage/memory_token_store.dart';
import 'package:wasli_restaurant/core/storage/token_store_provider.dart';

import '../../support/fake_http_adapter.dart';

void main() {
  late MemoryTokenStore tokens;
  late FakeHttpAdapter adapter;
  late ProviderContainer container;

  setUp(() async {
    tokens = MemoryTokenStore();
    await tokens.write('secret-token');
    adapter = FakeHttpAdapter([
      jsonResponder({'ok': true}, headers: {'x-request-id': 'req-9'}),
    ]);
    container = ProviderContainer(
      overrides: [
        appEnvironmentProvider.overrideWithValue(AppEnvironment.parse(apiBaseUrl: 'https://api.example.test')),
        tokenStoreProvider.overrideWithValue(tokens),
      ],
    );
    addTearDown(container.dispose);
    container.read(dioProvider).httpClientAdapter = adapter;
  });

  test('calls go to the API base URL of the environment', () async {
    await container.read(dioProvider).get<dynamic>('/api/v1/config');

    expect(adapter.requests.single.uri.toString(), 'https://api.example.test/api/v1/config');
  });

  test('the public config is called without the token and the others with it', () async {
    final dio = container.read(dioProvider);

    await dio.get<dynamic>('/api/v1/config');
    await dio.get<dynamic>('/api/v1/staff/orders');

    expect(adapter.requests[0].headers['Authorization'], isNull);
    expect(adapter.requests[1].headers['Authorization'], 'Token secret-token');
  });

  test('the language of the app goes in Accept-Language, and follows a change of language', () async {
    final dio = container.read(dioProvider);

    await dio.get<dynamic>('/api/v1/config');
    container.read(localeProvider.notifier).setLocale(AppLocales.arabic);
    await dio.get<dynamic>('/api/v1/config');

    expect(adapter.requests[0].headers['Accept-Language'], 'en');
    expect(adapter.requests[1].headers['Accept-Language'], 'ar');
  });

  test('the request ID of the latest answer is kept', () async {
    await container.read(dioProvider).get<dynamic>('/api/v1/config');

    expect(container.read(requestIdRecorderProvider).last, 'req-9');
  });
}
