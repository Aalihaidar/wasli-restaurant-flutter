import 'dart:ui' show Locale;

import 'package:flutter_test/flutter_test.dart';
import 'package:wasli_restaurant/core/format/money_format.dart';

void main() {
  const en = Locale('en');
  const ar = Locale('ar');

  String english(int minor, [String currency = 'AED']) => formatMoney(minor, currency: currency, locale: en);
  String arabic(int minor, [String currency = 'AED']) => formatMoney(minor, currency: currency, locale: ar);

  group('English', () {
    test('puts the currency first and always shows two decimals', () {
      expect(english(1250), 'AED 12.50');
      expect(english(600), 'AED 6.00');
      expect(english(5), 'AED 0.05');
      expect(english(0), 'AED 0.00');
    });

    test('groups thousands', () {
      expect(english(123456), 'AED 1,234.56');
      expect(english(100000000), 'AED 1,000,000.00');
      expect(english(99999), 'AED 999.99');
    });

    test('keeps the sign of a reduction in front of the number', () {
      expect(english(-50), 'AED -0.50');
      expect(english(-123456), 'AED -1,234.56');
    });

    test('prints a currency it has no symbol for as its code', () {
      expect(english(1250, 'USD'), 'USD 12.50');
    });
  });

  group('Arabic', () {
    test('puts the dirham after the amount, with Western digits', () {
      expect(arabic(1250), '12.50 د.إ');
      expect(arabic(5), '0.05 د.إ');
      expect(arabic(123456), '1,234.56 د.إ');
    });

    test('keeps the sign of a reduction in front of the number', () {
      expect(arabic(-50), '-0.50 د.إ');
    });

    test('prints a currency it has no symbol for as its code', () {
      expect(arabic(1250, 'USD'), '12.50 USD');
    });
  });

  test('never prints a digit outside 0-9', () {
    for (final minor in [0, 7, 1250, 987654321]) {
      expect(english(minor), isNot(matches(RegExp('[٠-٩]'))));
      expect(arabic(minor), isNot(matches(RegExp('[٠-٩]'))));
    }
  });

  test('another language than Arabic reads as English', () {
    expect(formatMoney(1250, currency: 'AED', locale: const Locale('fr')), 'AED 12.50');
  });
}
