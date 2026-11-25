import 'package:flutter/widgets.dart';
import 'package:wasli_restaurant/core/l10n/generated/app_localizations.dart';

export 'package:wasli_restaurant/core/l10n/generated/app_localizations.dart';

/// Reads the translated labels of the active language: `context.l10n.appTitle`.
extension AppLocalizationsContext on BuildContext {
  /// The app's own labels in the active language. Chat text is not here: the backend writes it.
  AppLocalizations get l10n => AppLocalizations.of(this);
}
