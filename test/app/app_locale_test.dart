import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart' show MaterialLocalizations;
import 'package:wasli_restaurant/app/app.dart';
import 'package:wasli_restaurant/app/home_placeholder_page.dart';
import 'package:wasli_restaurant/core/l10n/locale_controller.dart';

TextDirection _directionOfPage(WidgetTester tester) =>
    Directionality.of(tester.element(find.byType(HomePlaceholderPage)));

void main() {
  testWidgets('starts in English, left to right', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: App()));

    expect(find.text('Wasli Restaurant'), findsOneWidget);
    expect(_directionOfPage(tester), TextDirection.ltr);
  });

  testWidgets('switching to Arabic changes the text and flips the layout to right to left', (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    await tester.pumpWidget(UncontrolledProviderScope(container: container, child: const App()));

    container.read(localeProvider.notifier).setLocale(const Locale('ar'));
    await tester.pumpAndSettle();

    expect(find.text('وصلي للمطاعم'), findsOneWidget);
    expect(find.text('Wasli Restaurant'), findsNothing);
    expect(_directionOfPage(tester), TextDirection.rtl);
  });

  testWidgets('the Material widgets get their own Arabic labels too', (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    await tester.pumpWidget(UncontrolledProviderScope(container: container, child: const App()));

    container.read(localeProvider.notifier).setLocale(const Locale('ar'));
    await tester.pumpAndSettle();

    final material = MaterialLocalizations.of(tester.element(find.byType(HomePlaceholderPage)));
    expect(material.cancelButtonLabel, isNot('Cancel'));
    expect(material.okButtonLabel, isNot('OK'));
  });

  testWidgets('switching back to English restores left to right', (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    await tester.pumpWidget(UncontrolledProviderScope(container: container, child: const App()));

    container.read(localeProvider.notifier).setLocale(const Locale('ar'));
    await tester.pumpAndSettle();
    container.read(localeProvider.notifier).setLocale(const Locale('en'));
    await tester.pumpAndSettle();

    expect(find.text('Wasli Restaurant'), findsOneWidget);
    expect(_directionOfPage(tester), TextDirection.ltr);
  });
}
