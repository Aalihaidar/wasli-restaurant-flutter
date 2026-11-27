import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wasli_restaurant/app/app_shell.dart';
import 'package:wasli_restaurant/app/home_placeholder_page.dart';

/// The path of the first screen.
const String homePath = '/';

/// The app's router. It lives as long as the app, so a rebuild of the root widget keeps the current page.
///
/// Every page is shown inside the [AppShell]. Only the placeholder route exists. The staff login and the orders
/// screens add their routes, with the redirect that sends a signed-out user to the login, when their features are
/// built; the login will sit outside the shell if its design asks for it.
final appRouterProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: homePath,
    routes: [
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [GoRoute(path: homePath, builder: (context, state) => const HomePlaceholderPage())],
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
}, name: 'appRouter');
