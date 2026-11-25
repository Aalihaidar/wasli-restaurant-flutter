import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show GlobalMaterialLocalizations;
import 'package:wasli_restaurant/core/l10n/generated/app_localizations.dart';

/// The delegates of the app: its own labels, then the framework's labels for Material and basic widgets.
///
/// The generated `AppLocalizations.localizationsDelegates` is not used because it takes the Material delegate from
/// `flutter_localizations`, which serves the old Material library. This app uses `material_ui` (Flutter 3.50), which has
/// its own `MaterialLocalizations`; without its delegates, Arabic would show a warning and every Material widget
/// (dialogs, pickers, tooltips) would lack its Arabic labels. `GlobalMaterialLocalizations.delegates` also declares the
/// Cupertino and widget labels that `MaterialApp` asks for.
const List<LocalizationsDelegate<dynamic>> appLocalizationsDelegates = <LocalizationsDelegate<dynamic>>[
  AppLocalizations.delegate,
  ...GlobalMaterialLocalizations.delegates,
];
