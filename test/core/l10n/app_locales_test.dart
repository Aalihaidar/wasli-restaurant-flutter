import 'dart:ui' show Locale, TextDirection;

import 'package:flutter_test/flutter_test.dart';
import 'package:wasli_restaurant/core/l10n/app_locales.dart';

void main() {
  group('AppLocales', () {
    test('supports English and Arabic, English first', () {
      expect(AppLocales.supported, [const Locale('en'), const Locale('ar')]);
      expect(AppLocales.fallback, AppLocales.english);
    });

    test('normalises a locale with a country or a script to the supported one', () {
      expect(AppLocales.normalize(const Locale('ar', 'AE')), AppLocales.arabic);
      expect(AppLocales.normalize(const Locale('en', 'GB')), AppLocales.english);
      expect(AppLocales.normalize(const Locale.fromSubtags(languageCode: 'ar', scriptCode: 'Arab')), AppLocales.arabic);
    });

    test('returns null for a language the app does not have', () {
      expect(AppLocales.normalize(const Locale('fr')), isNull);
      expect(AppLocales.normalize(const Locale('ur')), isNull);
    });

    test('Arabic reads right to left and English left to right', () {
      expect(AppLocales.directionOf(AppLocales.arabic), TextDirection.rtl);
      expect(AppLocales.directionOf(AppLocales.english), TextDirection.ltr);
      expect(AppLocales.directionOf(const Locale('ar', 'AE')), TextDirection.rtl);
    });
  });
}
