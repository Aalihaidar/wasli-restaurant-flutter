import 'dart:ui' show Locale;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wasli_restaurant/core/l10n/app_locales.dart';

/// The language the app shows: English until the user chooses another one, then that choice.
final localeProvider = NotifierProvider<LocaleController, Locale>(LocaleController.new, name: 'locale');

/// Holds the active [Locale], always one of [AppLocales.supported].
///
/// The app starts in English whatever language the device uses, like the customer app. The choice is not remembered
/// between runs yet.
class LocaleController extends Notifier<Locale> {
  @override
  Locale build() => AppLocales.fallback;

  /// Switches the app to [locale]'s language.
  ///
  /// Throws an [ArgumentError] when the app has no translation for it: the language list only offers supported ones, so
  /// anything else is a programming error.
  void setLocale(Locale locale) {
    final supported = AppLocales.normalize(locale);
    if (supported == null) {
      throw ArgumentError.value(locale, 'locale', 'is not a supported language');
    }
    state = supported;
  }
}
