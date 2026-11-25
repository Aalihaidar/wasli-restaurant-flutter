import 'package:material_ui/material_ui.dart';

/// The colours of the Ink & Mustard design that `ColorScheme` has no slot for: the accent, the muted and border colours,
/// the link and focus colours and the four status pills.
///
/// The values are copied by hand from the design page (the single source); a new colour is added there first, with its
/// contrast check. Read it in a widget as `context.wasli.statusWarnBackground`. A status colour is always shown with a
/// text label, never alone.
@immutable
class WasliColors extends ThemeExtension<WasliColors> {
  /// Creates the set of colours of one brightness.
  const new({
    required this.background,
    required this.primaryDark,
    required this.accent,
    required this.onAccent,
    required this.textMuted,
    required this.borderSubtle,
    required this.borderInput,
    required this.link,
    required this.focusRing,
    required this.statusWarnBackground,
    required this.statusWarnForeground,
    required this.statusInfoBackground,
    required this.statusInfoForeground,
    required this.statusOkBackground,
    required this.statusOkForeground,
    required this.statusBadBackground,
    required this.statusBadForeground,
  });

  /// The light colours.
  static const WasliColors light = WasliColors(
    background: Color(0xFFFAFAF7),
    primaryDark: Color(0xFF121A2E),
    accent: Color(0xFFF2B705),
    onAccent: Color(0xFF121A2E),
    textMuted: Color(0xFF5B6475),
    borderSubtle: Color(0xFFE3E4E0),
    borderInput: Color(0xFF7E869A),
    link: Color(0xFF2C4FA3),
    focusRing: Color(0xFF1F2A44),
    statusWarnBackground: Color(0xFFFDF0D0),
    statusWarnForeground: Color(0xFF7A4B00),
    statusInfoBackground: Color(0xFFDBEAFE),
    statusInfoForeground: Color(0xFF1E3A8A),
    statusOkBackground: Color(0xFFDFF3E4),
    statusOkForeground: Color(0xFF14532D),
    statusBadBackground: Color(0xFFFDE2E0),
    statusBadForeground: Color(0xFF8A1C14),
  );

  /// The dark colours.
  static const WasliColors dark = WasliColors(
    background: Color(0xFF0F1626),
    primaryDark: Color(0xFFC99700),
    accent: Color(0xFFF2B705),
    onAccent: Color(0xFF121A2E),
    textMuted: Color(0xFFA9B0C0),
    borderSubtle: Color(0xFF2A3550),
    borderInput: Color(0xFF7B849C),
    link: Color(0xFF8FB0FF),
    focusRing: Color(0xFFF2B705),
    statusWarnBackground: Color(0xFF4A3300),
    statusWarnForeground: Color(0xFFFFDF9B),
    statusInfoBackground: Color(0xFF14305F),
    statusInfoForeground: Color(0xFFBCD4FF),
    statusOkBackground: Color(0xFF123D24),
    statusOkForeground: Color(0xFFB7EFC8),
    statusBadBackground: Color(0xFF4D1410),
    statusBadForeground: Color(0xFFFFC6C0),
  );

  /// The page background.
  final Color background;

  /// The pressed colour of the primary fill. Not a text colour in dark.
  final Color primaryDark;

  /// Mustard: badges, progress, the active tab. A fill or highlight, never text on a light background.
  final Color accent;

  /// Text and icons on [accent].
  final Color onAccent;

  /// Secondary text.
  final Color textMuted;

  /// The lines of cards (decoration).
  final Color borderSubtle;

  /// The outlines of inputs, at least 3:1 against the surface.
  final Color borderInput;

  /// Links.
  final Color link;

  /// The 2 px focus outline.
  final Color focusRing;

  /// Background of the "placed" pill.
  final Color statusWarnBackground;

  /// Text of the "placed" pill.
  final Color statusWarnForeground;

  /// Background of the "accepted" pill.
  final Color statusInfoBackground;

  /// Text of the "accepted" pill.
  final Color statusInfoForeground;

  /// Background of the "ready" pill.
  final Color statusOkBackground;

  /// Text of the "ready" pill.
  final Color statusOkForeground;

  /// Background of the "rejected" pill.
  final Color statusBadBackground;

  /// Text of the "rejected" pill.
  final Color statusBadForeground;

  @override
  WasliColors copyWith({
    Color? background,
    Color? primaryDark,
    Color? accent,
    Color? onAccent,
    Color? textMuted,
    Color? borderSubtle,
    Color? borderInput,
    Color? link,
    Color? focusRing,
    Color? statusWarnBackground,
    Color? statusWarnForeground,
    Color? statusInfoBackground,
    Color? statusInfoForeground,
    Color? statusOkBackground,
    Color? statusOkForeground,
    Color? statusBadBackground,
    Color? statusBadForeground,
  }) {
    return WasliColors(
      background: background ?? this.background,
      primaryDark: primaryDark ?? this.primaryDark,
      accent: accent ?? this.accent,
      onAccent: onAccent ?? this.onAccent,
      textMuted: textMuted ?? this.textMuted,
      borderSubtle: borderSubtle ?? this.borderSubtle,
      borderInput: borderInput ?? this.borderInput,
      link: link ?? this.link,
      focusRing: focusRing ?? this.focusRing,
      statusWarnBackground: statusWarnBackground ?? this.statusWarnBackground,
      statusWarnForeground: statusWarnForeground ?? this.statusWarnForeground,
      statusInfoBackground: statusInfoBackground ?? this.statusInfoBackground,
      statusInfoForeground: statusInfoForeground ?? this.statusInfoForeground,
      statusOkBackground: statusOkBackground ?? this.statusOkBackground,
      statusOkForeground: statusOkForeground ?? this.statusOkForeground,
      statusBadBackground: statusBadBackground ?? this.statusBadBackground,
      statusBadForeground: statusBadForeground ?? this.statusBadForeground,
    );
  }

  @override
  WasliColors lerp(WasliColors? other, double t) {
    if (other == null) {
      return this;
    }
    Color mix(Color from, Color to) => Color.lerp(from, to, t)!;
    return WasliColors(
      background: mix(background, other.background),
      primaryDark: mix(primaryDark, other.primaryDark),
      accent: mix(accent, other.accent),
      onAccent: mix(onAccent, other.onAccent),
      textMuted: mix(textMuted, other.textMuted),
      borderSubtle: mix(borderSubtle, other.borderSubtle),
      borderInput: mix(borderInput, other.borderInput),
      link: mix(link, other.link),
      focusRing: mix(focusRing, other.focusRing),
      statusWarnBackground: mix(statusWarnBackground, other.statusWarnBackground),
      statusWarnForeground: mix(statusWarnForeground, other.statusWarnForeground),
      statusInfoBackground: mix(statusInfoBackground, other.statusInfoBackground),
      statusInfoForeground: mix(statusInfoForeground, other.statusInfoForeground),
      statusOkBackground: mix(statusOkBackground, other.statusOkBackground),
      statusOkForeground: mix(statusOkForeground, other.statusOkForeground),
      statusBadBackground: mix(statusBadBackground, other.statusBadBackground),
      statusBadForeground: mix(statusBadForeground, other.statusBadForeground),
    );
  }
}
