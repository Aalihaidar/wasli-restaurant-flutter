import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wasli_restaurant/core/config/app_environment.dart';
import 'package:wasli_restaurant/core/config/app_environment_provider.dart';

void main() {
  test('gives the environment it was overridden with', () {
    final environment = AppEnvironment.parse(apiBaseUrl: 'https://api.example.test');
    final container = ProviderContainer(overrides: [appEnvironmentProvider.overrideWithValue(environment)]);
    addTearDown(container.dispose);

    expect(container.read(appEnvironmentProvider), same(environment));
  });

  test('reading it without an override fails loudly', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(() => container.read(appEnvironmentProvider), throwsA(anything));
  });
}
