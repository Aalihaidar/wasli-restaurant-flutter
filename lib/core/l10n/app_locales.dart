import 'dart:ui' show Locale, TextDirection;

/// The languages of the app and how one is chosen: English and Arabic only.
///
/// Every locale the app holds is one of [supported] (a language without a country), so a comparison never depends on a
/// region such as `ar_AE` against `ar`.
abstract final class AppLocales {
  /// English, left to right.
  static const Locale english = Locale('en');

  /// Arabic, right to left.
  static const Locale arabic = Locale('ar');

  /// The languages the app is translated into, English first.
  static const List<Locale> supported = [english, arabic];

  /// The language used until the user chooses another one.
  static const Locale fallback = english;

  /// The supported locale that has [locale]'s language, or `null` when the language is not supported.
  static Locale? normalize(Locale locale) {
    for (final candidate in supported) {
      if (candidate.languageCode == locale.languageCode) {
        return candidate;
      }
    }
    return null;
  }

  /// The reading direction of [locale]: Arabic is right to left, every other supported language left to right.
  static TextDirection directionOf(Locale locale) =>
      locale.languageCode == arabic.languageCode ? TextDirection.rtl : TextDirection.ltr;
}
