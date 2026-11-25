import 'package:flutter/foundation.dart' show LicenseRegistry;
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:wasli_restaurant/core/l10n/app_locales.dart';
import 'package:wasli_restaurant/theme/font_licences.dart';
import 'package:wasli_restaurant/theme/typography.dart';
import 'package:wasli_restaurant/theme/wasli_text_styles.dart';
import 'package:wasli_restaurant/theme/wasli_theme.dart';

/// The line height in logical pixels that a style gives.
double _line(TextStyle style) => style.fontSize! * style.height!;

void main() {
  final english = buildTextStyles(AppLocales.english);
  final arabic = buildTextStyles(AppLocales.arabic);

  group('the ten styles of the design, in English', () {
    // name, style, size, line height, weight
    final table = <(String, TextStyle, double, double, FontWeight)>[
      ('display', english.display, 32, 40, FontWeight.w700),
      ('heading1', english.heading1, 24, 32, FontWeight.w700),
      ('heading2', english.heading2, 20, 28, FontWeight.w600),
      ('heading3', english.heading3, 17, 24, FontWeight.w600),
      ('body', english.body, 16, 24, FontWeight.w400),
      ('bodyStrong', english.bodyStrong, 16, 24, FontWeight.w500),
      ('bodySmall', english.bodySmall, 14, 20, FontWeight.w400),
      ('label', english.label, 14, 20, FontWeight.w500),
      ('button', english.button, 16, 20, FontWeight.w600),
      ('caption', english.caption, 12, 16, FontWeight.w400),
    ];

    for (final (name, style, size, line, weight) in table) {
      test('$name is $size/$line at $weight in Rubik', () {
        expect(style.fontFamily, wasliFontFamily);
        expect(style.fontSize, size);
        expect(_line(style), closeTo(line, 0.001));
        expect(style.fontWeight, weight);
        expect(style.fontVariations!.single.axis, 'wght');
        expect(style.fontVariations!.single.value, weight.value.toDouble());
        expect(style.fontStyle, isNull, reason: 'the design has no italic');
      });
    }

    test('only the display and the first heading are tightened, by 0.01 em', () {
      expect(english.display.letterSpacing, closeTo(-0.32, 0.0001));
      expect(english.heading1.letterSpacing, closeTo(-0.24, 0.0001));
      for (final style in [english.heading2, english.heading3, english.body, english.button, english.caption]) {
        expect(style.letterSpacing, 0);
      }
    });
  });

  group('Arabic', () {
    test('has no letter spacing anywhere', () {
      for (final style in [arabic.display, arabic.heading1, arabic.heading2, arabic.body, arabic.caption]) {
        expect(style.letterSpacing, 0);
      }
    });

    test('has taller lines, by the one boost, and the same sizes and weights', () {
      expect(arabicLineHeightBoost, 0.1);
      for (final (a, e) in [
        (arabic.display, english.display),
        (arabic.body, english.body),
        (arabic.caption, english.caption),
      ]) {
        expect(a.height, closeTo(e.height! + arabicLineHeightBoost, 0.0001));
        expect(a.fontSize, e.fontSize);
        expect(a.fontWeight, e.fontWeight);
      }
    });
  });

  group('the Material slots', () {
    final theme = buildTextTheme(english);

    test('every one of the 15 slots is one of the design styles, none keeps a Material default', () {
      final slots = [
        theme.displayLarge,
        theme.displayMedium,
        theme.displaySmall,
        theme.headlineLarge,
        theme.headlineMedium,
        theme.headlineSmall,
        theme.titleLarge,
        theme.titleMedium,
        theme.titleSmall,
        theme.bodyLarge,
        theme.bodyMedium,
        theme.bodySmall,
        theme.labelLarge,
        theme.labelMedium,
        theme.labelSmall,
      ];
      for (final slot in slots) {
        expect(slot, isNotNull);
        expect(slot!.fontFamily, wasliFontFamily);
      }
    });

    test('the default text is the body, a screen title is heading 1 and a button is the button style', () {
      expect(theme.bodyMedium, english.body);
      expect(theme.titleLarge, english.heading1);
      expect(theme.labelLarge, english.button);
      expect(theme.bodySmall, english.bodySmall);
      expect(theme.labelSmall, english.caption);
    });
  });

  group('the themes', () {
    test('carry the styles of their language, and the same theme is returned for the same language', () {
      expect(lightTheme(AppLocales.english).extension<WasliTextStyles>()!.body.height, english.body.height);
      expect(darkTheme(AppLocales.arabic).extension<WasliTextStyles>()!.body.height, arabic.body.height);
      expect(lightTheme(AppLocales.english), same(lightTheme(AppLocales.english)));
      expect(lightTheme(const Locale('ar', 'AE')), same(lightTheme(AppLocales.arabic)));
    });

    test('use Rubik for the whole text theme', () {
      expect(lightTheme(AppLocales.english).textTheme.bodyMedium!.fontFamily, wasliFontFamily);
      expect(darkTheme(AppLocales.arabic).textTheme.titleLarge!.fontFamily, wasliFontFamily);
    });
  });

  group('the bundled font', () {
    TestWidgetsFlutterBinding.ensureInitialized();

    test('is declared in the font manifest', () async {
      final manifest = await rootBundle.loadString('FontManifest.json');

      expect(manifest, contains('"family":"Rubik"'));
      expect(manifest, contains('Rubik-VariableFont_wght.ttf'));
    });

    test('has its licence on the licence page', () async {
      registerFontLicences();

      final entries = await LicenseRegistry.licenses.toList();
      final rubik = entries.where((entry) => entry.packages.contains('Rubik')).toList();

      expect(rubik, hasLength(1));
      final text = rubik.single.paragraphs.map((paragraph) => paragraph.text).join('\n');
      expect(text, contains('SIL OPEN FONT LICENSE Version 1.1'));
      expect(text, contains('The Rubik Project Authors'));
    });
  });
}
