import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:wasli_restaurant/theme/color_schemes.dart';
import 'package:wasli_restaurant/theme/wasli_colors.dart';
import 'package:wasli_restaurant/theme/wasli_theme.dart';

import 'contrast.dart';

void main() {
  group('contrast of the design colours', () {
    // Text needs 4.5:1; an input outline needs 3:1 (the design page, "RTL and accessibility").
    for (final (name, scheme, colors) in [
      ('light', lightColorScheme, WasliColors.light),
      ('dark', darkColorScheme, WasliColors.dark),
    ]) {
      group(name, () {
        test('body text on the page and on a card', () {
          expect(contrastRatio(scheme.onSurface, colors.background), greaterThanOrEqualTo(4.5));
          expect(contrastRatio(scheme.onSurface, scheme.surface), greaterThanOrEqualTo(4.5));
        });

        test('secondary text and links on the page and on a card', () {
          for (final background in [colors.background, scheme.surface]) {
            expect(contrastRatio(colors.textMuted, background), greaterThanOrEqualTo(4.5), reason: 'muted');
            expect(contrastRatio(colors.link, background), greaterThanOrEqualTo(4.5), reason: 'link');
          }
        });

        test('text on the primary fill, on the accent fill and on the error fill', () {
          expect(contrastRatio(scheme.onPrimary, scheme.primary), greaterThanOrEqualTo(4.5));
          expect(contrastRatio(colors.onAccent, colors.accent), greaterThanOrEqualTo(4.5));
          expect(contrastRatio(scheme.onError, scheme.error), greaterThanOrEqualTo(4.5));
        });

        test('the error colour as text on the page', () {
          expect(contrastRatio(scheme.error, colors.background), greaterThanOrEqualTo(4.5));
        });

        test('the four status pills', () {
          final pills = {
            'warn': (colors.statusWarnForeground, colors.statusWarnBackground),
            'info': (colors.statusInfoForeground, colors.statusInfoBackground),
            'ok': (colors.statusOkForeground, colors.statusOkBackground),
            'bad': (colors.statusBadForeground, colors.statusBadBackground),
          };
          for (final MapEntry(:key, value: (foreground, background)) in pills.entries) {
            expect(contrastRatio(foreground, background), greaterThanOrEqualTo(4.5), reason: key);
          }
        });

        test('the input outline and the focus ring', () {
          expect(contrastRatio(colors.borderInput, scheme.surface), greaterThanOrEqualTo(3), reason: 'input outline');
          expect(contrastRatio(colors.focusRing, colors.background), greaterThanOrEqualTo(3), reason: 'focus ring');
        });
      });
    }
  });

  group('the schemes', () {
    test('light and dark have their own brightness', () {
      expect(lightColorScheme.brightness, Brightness.light);
      expect(darkColorScheme.brightness, Brightness.dark);
    });

    test('the primary is ink in light and mustard in dark', () {
      expect(lightColorScheme.primary, const Color(0xFF1F2A44));
      expect(darkColorScheme.primary, const Color(0xFFF2B705));
    });

    test('the mustard is the secondary colour in both', () {
      expect(lightColorScheme.secondary, const Color(0xFFF2B705));
      expect(darkColorScheme.secondary, const Color(0xFFF2B705));
    });
  });

  group('WasliColors', () {
    test('copyWith changes only the colour it is given', () {
      final changed = WasliColors.light.copyWith(accent: const Color(0xFF000000));

      expect(changed.accent, const Color(0xFF000000));
      expect(changed.textMuted, WasliColors.light.textMuted);
      expect(changed.statusBadForeground, WasliColors.light.statusBadForeground);
    });

    test('lerp gives each end at 0 and 1, and the start when the other is null', () {
      expect(WasliColors.light.lerp(WasliColors.dark, 0).background, WasliColors.light.background);
      expect(WasliColors.light.lerp(WasliColors.dark, 1).background, WasliColors.dark.background);
      expect(WasliColors.light.lerp(null, 0.5), same(WasliColors.light));
    });
  });

  group('the themes', () {
    test('use Material 3, the page background and the matching extension', () {
      expect(lightTheme.useMaterial3, isTrue);
      expect(lightTheme.scaffoldBackgroundColor, WasliColors.light.background);
      expect(lightTheme.extension<WasliColors>(), same(WasliColors.light));
      expect(darkTheme.scaffoldBackgroundColor, WasliColors.dark.background);
      expect(darkTheme.extension<WasliColors>(), same(WasliColors.dark));
    });

    testWidgets('context.wasli reads the colours of the active theme', (tester) async {
      late WasliColors read;
      await tester.pumpWidget(
        MaterialApp(
          theme: darkTheme,
          home: Builder(
            builder: (context) {
              read = context.wasli;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(read, same(WasliColors.dark));
    });
  });
}
