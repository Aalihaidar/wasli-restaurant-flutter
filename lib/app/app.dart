import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:wasli_restaurant/app/router/app_router.dart';
import 'package:wasli_restaurant/core/l10n/app_locales.dart';
import 'package:wasli_restaurant/core/l10n/l10n.dart';
import 'package:wasli_restaurant/core/l10n/locale_controller.dart';
import 'package:wasli_restaurant/core/l10n/localization_delegates.dart';

/// Root widget of the restaurant app.
///
/// It shows the router's pages in the active language; Arabic flips the whole layout to right to left. The theme is
/// added when it exists.
class App extends ConsumerWidget {
  /// Creates the root widget.
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      onGenerateTitle: (context) => context.l10n.appTitle,
      routerConfig: ref.watch(appRouterProvider),
      locale: ref.watch(localeProvider),
      supportedLocales: AppLocales.supported,
      localizationsDelegates: appLocalizationsDelegates,
    );
  }
}
