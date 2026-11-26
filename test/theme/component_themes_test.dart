import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:wasli_restaurant/core/l10n/app_locales.dart';
import 'package:wasli_restaurant/theme/button_styles.dart';
import 'package:wasli_restaurant/theme/color_schemes.dart';
import 'package:wasli_restaurant/theme/wasli_colors.dart';
import 'package:wasli_restaurant/theme/wasli_theme.dart';

/// Shows [child] in the light or dark theme, for the tests that read sizes and colours from the tree.
Future<void> _pump(WidgetTester tester, Widget child, {Brightness brightness = Brightness.light}) {
  final theme = brightness == Brightness.light ? lightTheme(AppLocales.english) : darkTheme(AppLocales.english);
  return tester.pumpWidget(
    MaterialApp(
      theme: theme,
      home: Scaffold(body: Center(child: child)),
    ),
  );
}

Set<WidgetState> _states(WidgetState state) => {state};

void main() {
  group('buttons', () {
    testWidgets('a primary, a secondary and a tertiary button are 48 high', (tester) async {
      await _pump(
        tester,
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FilledButton(onPressed: () {}, child: const Text('Accept')),
            OutlinedButton(onPressed: () {}, child: const Text('Back')),
            TextButton(onPressed: () {}, child: const Text('Later')),
          ],
        ),
      );
      for (final type in [FilledButton, OutlinedButton, TextButton]) {
        expect(tester.getSize(find.byType(type)).height, 48, reason: '$type');
      }
    });

    testWidgets('the large style makes a button 56 high', (tester) async {
      await _pump(tester, FilledButton(onPressed: () {}, style: WasliButtonStyles.large, child: const Text('Accept')));
      expect(tester.getSize(find.byType(FilledButton)).height, 56);
    });

    testWidgets('the label has 20 of padding on both sides', (tester) async {
      await _pump(tester, FilledButton(onPressed: () {}, child: const Text('Accept')));
      final button = tester.getRect(find.byType(FilledButton));
      final label = tester.getRect(find.text('Accept'));
      expect(label.left - button.left, 20);
      expect(button.right - label.right, 20);
    });

    for (final (name, brightness, scheme, colors) in [
      ('light', Brightness.light, lightColorScheme, WasliColors.light),
      ('dark', Brightness.dark, darkColorScheme, WasliColors.dark),
    ]) {
      group(name, () {
        testWidgets('the primary button is primary, primary_dark when pressed, 38 % when disabled', (tester) async {
          await _pump(
            tester,
            FilledButton(onPressed: () {}, child: const Text('Accept')),
            brightness: brightness,
          );
          final theme = Theme.of(tester.element(find.byType(FilledButton))).filledButtonTheme.style!;
          expect(theme.backgroundColor!.resolve({}), scheme.primary);
          expect(theme.backgroundColor!.resolve(_states(WidgetState.pressed)), colors.primaryDark);
          expect(theme.backgroundColor!.resolve(_states(WidgetState.disabled))!.a, closeTo(0.38, 0.01));
          expect(theme.foregroundColor!.resolve({}), scheme.onPrimary);
        });

        testWidgets('the secondary button has a 1.5 px primary border and a 2 px ring when focused', (tester) async {
          await _pump(
            tester,
            OutlinedButton(onPressed: () {}, child: const Text('Back')),
            brightness: brightness,
          );
          final theme = Theme.of(tester.element(find.byType(OutlinedButton))).outlinedButtonTheme.style!;
          expect(theme.side!.resolve({}), BorderSide(color: scheme.primary, width: 1.5));
          expect(theme.side!.resolve(_states(WidgetState.focused)), BorderSide(color: colors.focusRing, width: 2));
          expect(theme.backgroundColor!.resolve({}), scheme.surface);
        });

        testWidgets('a primary button shows the focus ring when focused and no border otherwise', (tester) async {
          await _pump(
            tester,
            FilledButton(onPressed: () {}, child: const Text('Accept')),
            brightness: brightness,
          );
          final theme = Theme.of(tester.element(find.byType(FilledButton))).filledButtonTheme.style!;
          expect(theme.side!.resolve({}), isNull);
          expect(theme.side!.resolve(_states(WidgetState.focused)), BorderSide(color: colors.focusRing, width: 2));
        });

        test('the destructive button has the error fill', () {
          final destructive = WasliButtonStyles.destructive(scheme);
          expect(destructive.backgroundColor!.resolve({}), scheme.error);
          expect(destructive.foregroundColor!.resolve({}), scheme.onError);
        });
      });
    }
  });

  group('text field', () {
    testWidgets('is 52 high with a 1.5 px border_input outline', (tester) async {
      await _pump(
        tester,
        const SizedBox(
          width: 300,
          child: TextField(decoration: InputDecoration(labelText: 'Username')),
        ),
      );
      expect(tester.getSize(find.byType(TextField)).height, 52);
      final theme = Theme.of(tester.element(find.byType(TextField))).inputDecorationTheme;
      expect(
        (theme.enabledBorder! as OutlineInputBorder).borderSide,
        BorderSide(color: WasliColors.light.borderInput, width: 1.5),
      );
    });

    test('is 2 px primary when focused and error-coloured when invalid', () {
      final theme = lightTheme(AppLocales.english).inputDecorationTheme;
      expect(
        (theme.focusedBorder! as OutlineInputBorder).borderSide,
        BorderSide(color: lightColorScheme.primary, width: 2),
      );
      expect(
        (theme.errorBorder! as OutlineInputBorder).borderSide,
        BorderSide(color: lightColorScheme.error, width: 1.5),
      );
      expect(
        (theme.focusedErrorBorder! as OutlineInputBorder).borderSide,
        BorderSide(color: lightColorScheme.error, width: 2),
      );
    });

    test('always shows its label, so a field is never named by its hint alone', () {
      expect(lightTheme(AppLocales.english).inputDecorationTheme.floatingLabelBehavior, FloatingLabelBehavior.always);
    });
  });

  group('card, bar, tabs and dialog', () {
    for (final (name, brightness, scheme, colors) in [
      ('light', Brightness.light, lightColorScheme, WasliColors.light),
      ('dark', Brightness.dark, darkColorScheme, WasliColors.dark),
    ]) {
      test('$name: the card is the surface with a 1 px border_subtle line, no shadow', () {
        final card =
            (brightness == Brightness.light ? lightTheme(AppLocales.english) : darkTheme(AppLocales.english)).cardTheme;
        final shape = card.shape! as RoundedRectangleBorder;
        expect(card.color, scheme.surface);
        expect(card.elevation, 0);
        expect(shape.borderRadius, BorderRadius.circular(12));
        expect(shape.side, BorderSide(color: colors.borderSubtle));
      });

      test('$name: the dialog has 16 corners and a border_subtle line', () {
        final dialog = (brightness == Brightness.light ? lightTheme(AppLocales.english) : darkTheme(AppLocales.english))
            .dialogTheme;
        final shape = dialog.shape! as RoundedRectangleBorder;
        expect(dialog.backgroundColor, scheme.surface);
        expect(shape.borderRadius, BorderRadius.circular(16));
        expect(shape.side, BorderSide(color: colors.borderSubtle));
      });

      test('$name: the active tab has a 3 px accent underline', () {
        final tabs = (brightness == Brightness.light ? lightTheme(AppLocales.english) : darkTheme(AppLocales.english))
            .tabBarTheme;
        final indicator = tabs.indicator! as UnderlineTabIndicator;
        expect(indicator.borderSide, BorderSide(color: colors.accent, width: 3));
        expect(tabs.labelColor, scheme.onSurface);
        expect(tabs.unselectedLabelColor, colors.textMuted);
      });
    }

    testWidgets('the top bar is the primary colour and 56 high', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: lightTheme(AppLocales.english),
          home: Scaffold(appBar: AppBar(title: const Text('Orders'))),
        ),
      );
      expect(tester.getSize(find.byType(AppBar)).height, 56);
      final bar = Theme.of(tester.element(find.byType(AppBar))).appBarTheme;
      expect(bar.backgroundColor, lightColorScheme.primary);
      expect(bar.foregroundColor, lightColorScheme.onPrimary);
    });
  });
}
