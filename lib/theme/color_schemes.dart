import 'package:material_ui/material_ui.dart';

/// The light `ColorScheme` of the Ink & Mustard design: ink-blue primary, mustard secondary.
///
/// `outline` is the input border (3:1 against the surface) and `outlineVariant` the quiet card line. The colours with no
/// slot here are in `WasliColors`.
const ColorScheme lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF1F2A44),
  onPrimary: Color(0xFFFFFFFF),
  secondary: Color(0xFFF2B705),
  onSecondary: Color(0xFF121A2E),
  error: Color(0xFFB3261E),
  onError: Color(0xFFFFFFFF),
  surface: Color(0xFFFFFFFF),
  onSurface: Color(0xFF121A2E),
  outline: Color(0xFF7E869A),
  outlineVariant: Color(0xFFE3E4E0),
);

/// The dark `ColorScheme`: in dark the mustard is the main action colour.
const ColorScheme darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFFF2B705),
  onPrimary: Color(0xFF121A2E),
  secondary: Color(0xFFF2B705),
  onSecondary: Color(0xFF121A2E),
  error: Color(0xFFFFB4AB),
  onError: Color(0xFF4D1410),
  surface: Color(0xFF182036),
  onSurface: Color(0xFFF2F1EC),
  outline: Color(0xFF7B849C),
  outlineVariant: Color(0xFF2A3550),
);
