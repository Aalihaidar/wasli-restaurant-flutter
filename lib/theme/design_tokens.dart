import 'package:flutter/animation.dart';

/// The spacing scale: `space_1` to `space_8` of the design (4, 8, 12, 16, 24, 32, 48 and 64 logical pixels).
abstract final class WasliSpacing {
  /// 4.
  static const double space1 = 4;

  /// 8.
  static const double space2 = 8;

  /// 12.
  static const double space3 = 12;

  /// 16.
  static const double space4 = 16;

  /// 24.
  static const double space5 = 24;

  /// 32.
  static const double space6 = 32;

  /// 48.
  static const double space7 = 48;

  /// 64.
  static const double space8 = 64;

  /// The page gutter on a phone.
  static const double gutterPhone = 16;

  /// The page gutter on a tablet and wider.
  static const double gutterTablet = 24;
}

/// The corner radii of the design.
abstract final class WasliRadius {
  /// 8: small chips and fields inside a card.
  static const double sm = 8;

  /// 12: buttons, inputs and cards.
  static const double md = 12;

  /// 16: sheets, dialogs and bubbles.
  static const double lg = 16;

  /// A full pill.
  static const double full = 999;
}

/// The durations and curve of the design's motion. With reduced motion the app fades instead of moving.
abstract final class WasliMotion {
  /// 120 ms: small state changes.
  static const Duration fast = Duration(milliseconds: 120);

  /// 200 ms: the usual transition.
  static const Duration standard = Duration(milliseconds: 200);

  /// 300 ms: a sheet.
  static const Duration sheet = Duration(milliseconds: 300);

  /// The standard curve, `cubic-bezier(.2, 0, 0, 1)`.
  static const Curve curve = Cubic(0.2, 0, 0, 1);
}

/// The widths of the responsive layout: the Material 3 window size classes and the widest content column.
abstract final class WasliLayout {
  /// 600: the first width of the medium class (a window narrower than this is compact).
  static const double mediumFrom = 600;

  /// 840: the first width of the expanded class.
  static const double expandedFrom = 840;

  /// 1200: the widest content column of the restaurant app; a wider window centres it.
  static const double contentMaxWidth = 1200;
}

/// The sizes of the controls of the design.
abstract final class WasliSizes {
  /// 48: the height of a button and the smallest tap target.
  static const double buttonHeight = 48;

  /// 56: the height of the action buttons on the orders screen (accept and reject) and of the top bar.
  static const double buttonHeightLarge = 56;

  /// 20: the horizontal padding inside a button.
  static const double buttonPaddingX = 20;

  /// 52: the height of a text field.
  static const double inputHeight = 52;

  /// 1.5: the border of a secondary button and of a text field.
  static const double borderWidth = 1.5;

  /// 1: the line of a card.
  static const double hairline = 1;

  /// 2: the focus outline, and the border of a focused text field.
  static const double focusWidth = 2;

  /// 3: the underline of the active tab.
  static const double tabIndicatorHeight = 3;

  /// 0.38: how opaque a disabled control is.
  static const double disabledOpacity = 0.38;
}
