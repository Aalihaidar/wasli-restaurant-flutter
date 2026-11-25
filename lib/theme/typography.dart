import 'package:material_ui/material_ui.dart';
import 'package:wasli_restaurant/theme/wasli_text_styles.dart';

/// The one font family of the app, for Latin and Arabic. It is bundled in `assets/fonts/` (`pubspec.yaml`).
const String wasliFontFamily = 'Rubik';

/// Added to the line height of every Arabic style. The design asks for it "if it clips": Arabic marks above and below
/// the line need more room than Latin. One constant, so it can be removed if a check on a real screen shows no clipping.
const double arabicLineHeightBoost = 0.1;

/// Builds one style of the design.
///
/// [size] and [line] are the design's font size and line height in logical pixels; Flutter wants the height as a multiple
/// of the size. Rubik is a variable font, so the weight is also given on its `wght` axis (the engine picks it from
/// there). Arabic gets no letter spacing and a taller line; Latin [tightLatin] styles (the display and the first heading)
/// get `-0.01em`. Never italic, never all-caps (the design forbids both).
TextStyle _style({
  required Locale locale,
  required double size,
  required double line,
  required int weight,
  bool tightLatin = false,
}) {
  final arabic = locale.languageCode == 'ar';
  return TextStyle(
    fontFamily: wasliFontFamily,
    fontSize: size,
    height: line / size + (arabic ? arabicLineHeightBoost : 0),
    fontWeight: FontWeight.values[(weight ~/ 100) - 1],
    fontVariations: [FontVariation('wght', weight.toDouble())],
    letterSpacing: !arabic && tightLatin ? -0.01 * size : 0,
  );
}

/// The ten text styles of the design for [locale].
WasliTextStyles buildTextStyles(Locale locale) {
  TextStyle make(double size, double line, int weight, {bool tightLatin = false}) =>
      _style(locale: locale, size: size, line: line, weight: weight, tightLatin: tightLatin);
  return WasliTextStyles(
    display: make(32, 40, 700, tightLatin: true),
    heading1: make(24, 32, 700, tightLatin: true),
    heading2: make(20, 28, 600),
    heading3: make(17, 24, 600),
    body: make(16, 24, 400),
    bodyStrong: make(16, 24, 500),
    bodySmall: make(14, 20, 400),
    label: make(14, 20, 500),
    button: make(16, 20, 600),
    caption: make(12, 16, 400),
  );
}

/// Maps the design's styles onto the 15 slots of Material's `TextTheme`, so the framework's widgets use them too.
///
/// A dialog or an app bar title is a screen title (`heading1`), a list tile's title and the default text are `body`, a
/// button is `button`, a tab or a chip is `label`. No slot keeps a Material default size.
TextTheme buildTextTheme(WasliTextStyles styles) {
  return TextTheme(
    displayLarge: styles.display,
    displayMedium: styles.display,
    displaySmall: styles.display,
    headlineLarge: styles.heading1,
    headlineMedium: styles.heading1,
    headlineSmall: styles.heading2,
    titleLarge: styles.heading1,
    titleMedium: styles.heading3,
    titleSmall: styles.label,
    bodyLarge: styles.body,
    bodyMedium: styles.body,
    bodySmall: styles.bodySmall,
    labelLarge: styles.button,
    labelMedium: styles.label,
    labelSmall: styles.caption,
  );
}
