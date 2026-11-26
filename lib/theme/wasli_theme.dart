import 'package:material_ui/material_ui.dart';
import 'package:wasli_restaurant/theme/button_styles.dart';
import 'package:wasli_restaurant/theme/color_schemes.dart';
import 'package:wasli_restaurant/theme/component_themes.dart';
import 'package:wasli_restaurant/theme/typography.dart';
import 'package:wasli_restaurant/theme/wasli_colors.dart';
import 'package:wasli_restaurant/theme/wasli_text_styles.dart';

final Map<(Brightness, String), ThemeData> _themes = {};

/// The light theme for [locale]'s language. The text styles depend on the language (Arabic has its own spacing and line
/// height), so there is one theme per language; each is built once.
ThemeData lightTheme(Locale locale) => _themeFor(Brightness.light, locale);

/// The dark theme for [locale]'s language, built once.
ThemeData darkTheme(Locale locale) => _themeFor(Brightness.dark, locale);

ThemeData _themeFor(Brightness brightness, Locale locale) {
  return _themes.putIfAbsent((brightness, locale.languageCode), () {
    final light = brightness == Brightness.light;
    return _build(
      light ? lightColorScheme : darkColorScheme,
      light ? WasliColors.light : WasliColors.dark,
      buildTextStyles(locale),
    );
  });
}

ThemeData _build(ColorScheme scheme, WasliColors colors, WasliTextStyles styles) {
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: colors.background,
    fontFamily: wasliFontFamily,
    textTheme: buildTextTheme(styles),
    filledButtonTheme: WasliButtonStyles.filled(scheme, colors, styles),
    outlinedButtonTheme: WasliButtonStyles.outlined(scheme, colors, styles),
    textButtonTheme: WasliButtonStyles.text(scheme, colors, styles),
    inputDecorationTheme: buildInputTheme(scheme, colors, styles),
    cardTheme: buildCardTheme(scheme, colors),
    appBarTheme: buildAppBarTheme(scheme, styles),
    tabBarTheme: buildTabBarTheme(scheme, colors, styles),
    dialogTheme: buildDialogTheme(scheme, colors, styles),
    extensions: [colors, styles],
  );
}

/// Reads the app's own colours and text styles: `context.wasli.statusWarnBackground`, `context.wasliText.bodyStrong`.
extension WasliThemeContext on BuildContext {
  /// The colours of the active theme that `ColorScheme` has no slot for.
  WasliColors get wasli => Theme.of(this).extension<WasliColors>()!;

  /// The ten text styles of the design, in the active language.
  WasliTextStyles get wasliText => Theme.of(this).extension<WasliTextStyles>()!;
}
