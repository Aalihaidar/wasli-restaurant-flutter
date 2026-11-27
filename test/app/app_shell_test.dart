import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:wasli_restaurant/app/app.dart';
import 'package:wasli_restaurant/app/app_shell.dart';
import 'package:wasli_restaurant/core/l10n/app_locales.dart';
import 'package:wasli_restaurant/core/l10n/localization_delegates.dart';
import 'package:wasli_restaurant/theme/design_tokens.dart';
import 'package:wasli_restaurant/theme/wasli_theme.dart';

import '../support/app_config_overrides.dart';

const _box = Key('page');

/// Shows an [AppShell] around a full-width box, in a window [width] wide, and gives back where the box is.
Future<Rect> _pageRect(WidgetTester tester, double width, Locale locale) async {
  tester.view.physicalSize = Size(width, 800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      theme: lightTheme(locale),
      locale: locale,
      supportedLocales: AppLocales.supported,
      localizationsDelegates: appLocalizationsDelegates,
      home: const AppShell(
        child: SizedBox(key: _box, height: 10, width: double.infinity),
      ),
    ),
  );
  return tester.getRect(find.byKey(_box));
}

void main() {
  for (final locale in AppLocales.supported) {
    group('AppShell in ${locale.languageCode}', () {
      testWidgets('shows the app name in a 56 high top bar in the primary colour', (tester) async {
        await _pageRect(tester, 1000, locale);

        final bar = tester.widget<AppBar>(find.byType(AppBar));
        expect(tester.getSize(find.byType(AppBar)).height, WasliSizes.buttonHeightLarge);
        expect(bar.title, isA<Text>());
        expect(find.descendant(of: find.byType(AppBar), matching: find.byType(Text)), findsOneWidget);
        expect(
          tester
              .widget<Material>(find.descendant(of: find.byType(AppBar), matching: find.byType(Material)).first)
              .color,
          lightTheme(locale).colorScheme.primary,
        );
      });

      testWidgets('puts the page right under the top bar, with a 16 gutter on a 400 wide window', (tester) async {
        final page = await _pageRect(tester, 400, locale);

        expect(page.top, WasliSizes.buttonHeightLarge);
        expect(page.left, 16);
        expect(page.right, 384);
      });

      testWidgets('keeps a 24 gutter on a 1000 wide window', (tester) async {
        final page = await _pageRect(tester, 1000, locale);

        expect(page.left, 24);
        expect(page.right, 976);
      });

      testWidgets('keeps the page 1200 wide and centred on a 1600 wide window', (tester) async {
        final page = await _pageRect(tester, 1600, locale);

        expect(page.width, WasliLayout.contentMaxWidth);
        expect(page.left, 200);
        expect(page.right, 1400);
      });
    });
  }

  testWidgets('the app shows its first page inside the shell, with the name in the top bar', (tester) async {
    await tester.pumpWidget(ProviderScope(overrides: [appConfigLoaded], child: const App()));

    expect(find.byType(AppShell), findsOneWidget);
    expect(find.descendant(of: find.byType(AppBar), matching: find.text('Wasli Restaurant')), findsOneWidget);
  });
}
