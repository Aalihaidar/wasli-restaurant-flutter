import 'package:material_ui/material_ui.dart';

/// The ten text styles of the Ink & Mustard design, in the font Rubik.
///
/// Sizes, line heights and weights come from the design page. Colour is not set here: the text takes it from the theme.
/// Material's own widgets read the same styles through the `TextTheme` slots (see `buildTextTheme`); this class gives
/// the exact design name to the ones a slot does not name, such as `bodyStrong` for prices. Read it as
/// `context.wasliText.bodyStrong`.
@immutable
class WasliTextStyles extends ThemeExtension<WasliTextStyles> {
  /// Creates the set from its ten styles.
  const new({
    required this.display,
    required this.heading1,
    required this.heading2,
    required this.heading3,
    required this.body,
    required this.bodyStrong,
    required this.bodySmall,
    required this.label,
    required this.button,
    required this.caption,
  });

  /// 32/40, 700: the restaurant name, the title of an empty state.
  final TextStyle display;

  /// 24/32, 700: screen titles.
  final TextStyle heading1;

  /// 20/28, 600: section titles.
  final TextStyle heading2;

  /// 17/24, 600: card titles, item names.
  final TextStyle heading3;

  /// 16/24, 400: body text and chat.
  final TextStyle body;

  /// 16/24, 500: prices.
  final TextStyle bodyStrong;

  /// 14/20, 400: secondary text.
  final TextStyle bodySmall;

  /// 14/20, 500: labels, tabs and chips.
  final TextStyle label;

  /// 16/20, 600: buttons.
  final TextStyle button;

  /// 12/16, 400: timestamps and hints.
  final TextStyle caption;

  @override
  WasliTextStyles copyWith({
    TextStyle? display,
    TextStyle? heading1,
    TextStyle? heading2,
    TextStyle? heading3,
    TextStyle? body,
    TextStyle? bodyStrong,
    TextStyle? bodySmall,
    TextStyle? label,
    TextStyle? button,
    TextStyle? caption,
  }) {
    return WasliTextStyles(
      display: display ?? this.display,
      heading1: heading1 ?? this.heading1,
      heading2: heading2 ?? this.heading2,
      heading3: heading3 ?? this.heading3,
      body: body ?? this.body,
      bodyStrong: bodyStrong ?? this.bodyStrong,
      bodySmall: bodySmall ?? this.bodySmall,
      label: label ?? this.label,
      button: button ?? this.button,
      caption: caption ?? this.caption,
    );
  }

  @override
  WasliTextStyles lerp(WasliTextStyles? other, double t) {
    if (other == null) {
      return this;
    }
    TextStyle mix(TextStyle from, TextStyle to) => TextStyle.lerp(from, to, t)!;
    return WasliTextStyles(
      display: mix(display, other.display),
      heading1: mix(heading1, other.heading1),
      heading2: mix(heading2, other.heading2),
      heading3: mix(heading3, other.heading3),
      body: mix(body, other.body),
      bodyStrong: mix(bodyStrong, other.bodyStrong),
      bodySmall: mix(bodySmall, other.bodySmall),
      label: mix(label, other.label),
      button: mix(button, other.button),
      caption: mix(caption, other.caption),
    );
  }
}
