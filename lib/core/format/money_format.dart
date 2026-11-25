import 'dart:ui' show Locale;

/// The Arabic form of the dirham, printed after the amount.
const String _dirhamAr = 'د.إ';

/// Formats an amount of integer minor units (fils, 100 to the dirham) for display.
///
/// The server sends money as integers and the app never computes with floats: the amount is split into whole units and
/// two decimals with integer arithmetic only. Digits are always Western (0-9), in every language. English prints the
/// currency first (`AED 12.50`); Arabic prints it after the amount (`12.50 د.إ`). A currency this app has no symbol for
/// is printed as its code. A negative amount, such as a price reduction, keeps its sign in front of the number.
///
/// The prices already include VAT as printed on the menu, so nothing is added here.
String formatMoney(int minorUnits, {required String currency, required Locale locale}) {
  final negative = minorUnits < 0;
  final absolute = minorUnits.abs();
  final whole = _groupThousands((absolute ~/ 100).toString());
  final decimals = (absolute % 100).toString().padLeft(2, '0');
  final number = '${negative ? '-' : ''}$whole.$decimals';

  if (locale.languageCode == 'ar') {
    final symbol = currency == 'AED' ? _dirhamAr : currency;
    return '$number $symbol';
  }
  return '$currency $number';
}

String _groupThousands(String digits) {
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(digits[i]);
  }
  return buffer.toString();
}
