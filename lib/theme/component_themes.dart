import 'package:material_ui/material_ui.dart';
import 'package:wasli_restaurant/theme/design_tokens.dart';
import 'package:wasli_restaurant/theme/wasli_colors.dart';
import 'package:wasli_restaurant/theme/wasli_text_styles.dart';

/// The text field: 52 high, a surface fill and a 1.5 px `border_input` outline that is 2 px primary when focused and
/// error-coloured when invalid. The label always sits on the border, so a field is never labelled by its hint alone.
InputDecorationThemeData buildInputTheme(ColorScheme scheme, WasliColors colors, WasliTextStyles styles) {
  OutlineInputBorder outline(Color color, double width) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(WasliRadius.md),
    borderSide: BorderSide(color: color, width: width),
  );
  // 14 above and below a 24 high line makes the 52 of the design.
  const padding = EdgeInsetsDirectional.fromSTEB(
    WasliSpacing.space4,
    (WasliSizes.inputHeight - 24) / 2,
    WasliSpacing.space4,
    (WasliSizes.inputHeight - 24) / 2,
  );
  return InputDecorationThemeData(
    filled: true,
    fillColor: scheme.surface,
    contentPadding: padding,
    floatingLabelBehavior: FloatingLabelBehavior.always,
    labelStyle: styles.label.copyWith(color: colors.textMuted),
    floatingLabelStyle: styles.label.copyWith(color: scheme.onSurface),
    hintStyle: styles.body.copyWith(color: colors.textMuted),
    helperStyle: styles.caption.copyWith(color: colors.textMuted),
    errorStyle: styles.caption.copyWith(color: scheme.error),
    border: outline(colors.borderInput, WasliSizes.borderWidth),
    enabledBorder: outline(colors.borderInput, WasliSizes.borderWidth),
    focusedBorder: outline(scheme.primary, WasliSizes.focusWidth),
    errorBorder: outline(scheme.error, WasliSizes.borderWidth),
    focusedErrorBorder: outline(scheme.error, WasliSizes.focusWidth),
    disabledBorder: outline(colors.borderSubtle, WasliSizes.borderWidth),
  );
}

/// The card: the surface colour, a 1 px `border_subtle` line, `radius_md` corners and no shadow.
CardThemeData buildCardTheme(ColorScheme scheme, WasliColors colors) {
  return CardThemeData(
    color: scheme.surface,
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(WasliRadius.md),
      side: BorderSide(color: colors.borderSubtle), // 1 px, the default width
    ),
  );
}

/// The top bar: the primary colour, 56 high, flat.
AppBarTheme buildAppBarTheme(ColorScheme scheme, WasliTextStyles styles) {
  return AppBarTheme(
    backgroundColor: scheme.primary,
    foregroundColor: scheme.onPrimary,
    surfaceTintColor: Colors.transparent,
    toolbarHeight: WasliSizes.buttonHeightLarge,
    elevation: 0,
    scrolledUnderElevation: 0,
    centerTitle: false,
    titleTextStyle: styles.heading2.copyWith(color: scheme.onPrimary),
  );
}

/// The tab bar: a 3 px accent underline under the active tab, and a quiet line under the bar.
TabBarThemeData buildTabBarTheme(ColorScheme scheme, WasliColors colors, WasliTextStyles styles) {
  return TabBarThemeData(
    indicator: UnderlineTabIndicator(
      borderSide: BorderSide(color: colors.accent, width: WasliSizes.tabIndicatorHeight),
    ),
    indicatorSize: TabBarIndicatorSize.tab,
    labelColor: scheme.onSurface,
    unselectedLabelColor: colors.textMuted,
    labelStyle: styles.label,
    unselectedLabelStyle: styles.label,
    dividerColor: colors.borderSubtle,
    dividerHeight: WasliSizes.hairline,
  );
}

/// The dialog: the surface colour, `radius_lg` corners and a `border_subtle` line instead of a shadow.
DialogThemeData buildDialogTheme(ColorScheme scheme, WasliColors colors, WasliTextStyles styles) {
  return DialogThemeData(
    backgroundColor: scheme.surface,
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(WasliRadius.lg),
      side: BorderSide(color: colors.borderSubtle), // 1 px, the default width
    ),
    titleTextStyle: styles.heading2.copyWith(color: scheme.onSurface),
    contentTextStyle: styles.body.copyWith(color: scheme.onSurface),
  );
}
