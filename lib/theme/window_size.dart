import 'package:material_ui/material_ui.dart';
import 'package:wasli_restaurant/theme/design_tokens.dart';

/// The Material 3 window size classes. Layouts choose by these and never by the kind of device.
enum WindowSize {
  /// Narrower than 600: one column (a phone).
  compact,

  /// 600 to 839: a list beside its detail fits.
  medium,

  /// 840 and wider.
  expanded;

  /// The class of a window [width] in logical pixels.
  static WindowSize fromWidth(double width) {
    if (width < WasliLayout.mediumFrom) return compact;
    if (width < WasliLayout.expandedFrom) return medium;
    return expanded;
  }

  /// The page gutter of this class: 16 on a compact window, 24 on the others.
  double get gutter => this == compact ? WasliSpacing.gutterPhone : WasliSpacing.gutterTablet;

  /// Whether a list and its detail are shown side by side (medium and expanded).
  bool get isTwoPane => this != compact;
}

/// Reads the size class of the window: `context.windowSize`.
extension WindowSizeContext on BuildContext {
  /// The size class of the window. A widget that reads it rebuilds only when the class changes.
  WindowSize get windowSize => WindowSize.fromWidth(MediaQuery.sizeOf(this).width);
}
