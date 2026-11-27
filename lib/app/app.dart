import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:wasli_restaurant/app/router/app_router.dart';
import 'package:wasli_restaurant/core/l10n/app_locales.dart';
import 'package:wasli_restaurant/core/l10n/l10n.dart';
import 'package:wasli_restaurant/core/l10n/locale_controller.dart';
import 'package:wasli_restaurant/core/l10n/localization_delegates.dart';
import 'package:wasli_restaurant/features/app_config/presentation/startup_gate.dart';
import 'package:wasli_restaurant/theme/wasli_theme.dart';

/// Root widget of the restaurant app.
///
/// It shows the router's pages once the server settings have loaded (`StartupGate`), in the active language (Arabic
/// flips the whole layout to right to left) and follows the system's light or dark setting.
class App extends ConsumerWidget {
  /// Creates the root widget.
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    return MaterialApp.router(
      onGenerateTitle: (context) => context.l10n.appTitle,
      routerConfig: ref.watch(appRouterProvider),
      builder: (context, child) => StartupGate(child: child ?? const SizedBox.shrink()),
      theme: lightTheme(locale),
      darkTheme: darkTheme(locale),
      locale: locale,
      supportedLocales: AppLocales.supported,
      localizationsDelegates: appLocalizationsDelegates,
    );
  }
}
