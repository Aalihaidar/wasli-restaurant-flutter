import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:wasli_restaurant/app/app.dart';
import 'package:wasli_restaurant/app/home_placeholder_page.dart';
import 'package:wasli_restaurant/theme/wasli_colors.dart';
import 'package:wasli_restaurant/theme/wasli_theme.dart';

Theme _themeOfPage(WidgetTester tester) =>
    tester.widget<Theme>(find.ancestor(of: find.byType(HomePlaceholderPage), matching: find.byType(Theme)).first);

void main() {
  testWidgets('follows the system: light by default, dark when the system is dark', (tester) async {
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);

    tester.platformDispatcher.platformBrightnessTestValue = Brightness.light;
    await tester.pumpWidget(const ProviderScope(child: App()));
    expect(_themeOfPage(tester).data.extension<WasliColors>(), same(WasliColors.light));
    expect(_themeOfPage(tester).data.colorScheme.primary, lightTheme.colorScheme.primary);

    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    await tester.pumpAndSettle();
    expect(_themeOfPage(tester).data.extension<WasliColors>(), same(WasliColors.dark));
    expect(_themeOfPage(tester).data.colorScheme.primary, darkTheme.colorScheme.primary);
  });
}
