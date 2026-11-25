import 'dart:ui' show Locale;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wasli_restaurant/core/l10n/app_locales.dart';
import 'package:wasli_restaurant/core/l10n/locale_controller.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
    addTearDown(container.dispose);
  });

  group('LocaleController', () {
    test('starts in English whatever the device language is', () {
      expect(container.read(localeProvider), AppLocales.english);
    });

    test('switches to Arabic and back', () {
      container.read(localeProvider.notifier).setLocale(const Locale('ar'));
      expect(container.read(localeProvider), AppLocales.arabic);

      container.read(localeProvider.notifier).setLocale(const Locale('en'));
      expect(container.read(localeProvider), AppLocales.english);
    });

    test('keeps only the language of a locale with a country', () {
      container.read(localeProvider.notifier).setLocale(const Locale('ar', 'AE'));

      expect(container.read(localeProvider), AppLocales.arabic);
    });

    test('refuses a language the app does not have and keeps the current one', () {
      final controller = container.read(localeProvider.notifier);

      expect(() => controller.setLocale(const Locale('fr')), throwsArgumentError);
      expect(container.read(localeProvider), AppLocales.english);
    });
  });
}
