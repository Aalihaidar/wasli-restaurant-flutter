import 'package:material_ui/material_ui.dart';
import 'package:wasli_restaurant/theme/design_tokens.dart';
import 'package:wasli_restaurant/theme/wasli_colors.dart';
import 'package:wasli_restaurant/theme/wasli_text_styles.dart';

/// The four buttons of the design: primary (`FilledButton`), secondary (`OutlinedButton`), tertiary (`TextButton`) and
/// destructive (`FilledButton` with [destructive]).
///
/// They are 48 high with 20 of padding, `radius_md` corners and the `button` text style. A disabled button is 38 % opaque
/// and a focused one has the 2 px focus ring. The orders screen's accept and reject buttons add [large] (56 high).
abstract final class WasliButtonStyles {
  /// The primary button: the primary fill, `primary_dark` while pressed.
  static FilledButtonThemeData filled(ColorScheme scheme, WasliColors colors, WasliTextStyles styles) {
    return FilledButtonThemeData(
      style: _base(styles, colors).copyWith(
        backgroundColor: _fill(scheme.primary, pressed: colors.primaryDark),
        foregroundColor: _fill(scheme.onPrimary),
      ),
    );
  }

  /// The secondary button: the surface fill and a 1.5 px primary border.
  static OutlinedButtonThemeData outlined(ColorScheme scheme, WasliColors colors, WasliTextStyles styles) {
    return OutlinedButtonThemeData(
      style: _base(styles, colors).copyWith(
        backgroundColor: _fill(scheme.surface),
        foregroundColor: _fill(scheme.primary),
        side: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.focused)) return _focusRing(colors);
          final color = states.contains(WidgetState.disabled)
              ? scheme.primary.withValues(alpha: WasliSizes.disabledOpacity)
              : scheme.primary;
          return BorderSide(color: color, width: WasliSizes.borderWidth);
        }),
      ),
    );
  }

  /// The tertiary button: no fill, the primary colour for the label.
  static TextButtonThemeData text(ColorScheme scheme, WasliColors colors, WasliTextStyles styles) {
    return TextButtonThemeData(style: _base(styles, colors).copyWith(foregroundColor: _fill(scheme.primary)));
  }

  /// The destructive button: the error fill. Use it as `FilledButton(style: WasliButtonStyles.destructive(scheme), ...)`.
  static ButtonStyle destructive(ColorScheme scheme) {
    return ButtonStyle(backgroundColor: _fill(scheme.error), foregroundColor: _fill(scheme.onError));
  }

  /// The 56 high size of the accept and reject buttons. Add it with `style: WasliButtonStyles.large`.
  static final ButtonStyle large = ButtonStyle(
    minimumSize: WidgetStateProperty.all(const Size(0, WasliSizes.buttonHeightLarge)),
  );

  static ButtonStyle _base(WasliTextStyles styles, WasliColors colors) {
    return ButtonStyle(
      minimumSize: WidgetStateProperty.all(const Size(0, WasliSizes.buttonHeight)),
      padding: WidgetStateProperty.all(
        const EdgeInsetsDirectional.only(start: WasliSizes.buttonPaddingX, end: WasliSizes.buttonPaddingX),
      ),
      shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(WasliRadius.md))),
      textStyle: WidgetStateProperty.all(styles.button),
      elevation: WidgetStateProperty.all(0),
      side: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.focused) ? _focusRing(colors) : null,
      ),
    );
  }

  static BorderSide _focusRing(WasliColors colors) => BorderSide(color: colors.focusRing, width: WasliSizes.focusWidth);

  /// [color], 38 % opaque when disabled, and [pressed] while pressed when it is given.
  static WidgetStateProperty<Color?> _fill(Color color, {Color? pressed}) {
    return WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) return color.withValues(alpha: WasliSizes.disabledOpacity);
      if (pressed != null && states.contains(WidgetState.pressed)) return pressed;
      return color;
    });
  }
}
