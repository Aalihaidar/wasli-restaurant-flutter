import 'package:material_ui/material_ui.dart';
import 'package:wasli_restaurant/theme/color_schemes.dart';
import 'package:wasli_restaurant/theme/wasli_colors.dart';

/// The light theme of the app, built once.
final ThemeData lightTheme = _build(lightColorScheme, WasliColors.light);

/// The dark theme of the app, built once.
final ThemeData darkTheme = _build(darkColorScheme, WasliColors.dark);

ThemeData _build(ColorScheme scheme, WasliColors colors) {
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: colors.background,
    extensions: [colors],
  );
}

/// Reads the app's own colours: `context.wasli.statusWarnBackground`.
extension WasliThemeContext on BuildContext {
  /// The colours of the active theme that `ColorScheme` has no slot for.
  WasliColors get wasli => Theme.of(this).extension<WasliColors>()!;
}
