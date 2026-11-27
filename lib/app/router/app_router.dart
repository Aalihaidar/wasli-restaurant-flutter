import 'package:flutter/foundation.dart' show ValueNotifier;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wasli_restaurant/app/app_shell.dart';
import 'package:wasli_restaurant/app/home_placeholder_page.dart';
import 'package:wasli_restaurant/features/auth/application/auth_providers.dart';
import 'package:wasli_restaurant/features/auth/presentation/login_page.dart';

/// The path of the first screen after signing in.
const String homePath = '/';

/// The path of the staff sign-in screen.
const String loginPath = '/login';

/// The app's router. It lives as long as the app, so a rebuild of the root widget keeps the current page.
///
/// Every page is shown inside the [AppShell]. Nobody signed in is sent to the sign-in screen, and somebody signed in who
/// opens it is sent to the first screen. The check runs again whenever somebody signs in or the session ends (signing
/// out, or a token the server refused). While the session is still being looked up, or failed to load, nobody is
/// redirected: the session gate in front of the router shows the loading or error view. The orders screens add their
/// routes here when they are built.
final appRouterProvider = Provider<GoRouter>((ref) {
  final changes = ValueNotifier<int>(0);
  ref.listen(sessionProvider.select((state) => state.value != null), (previous, next) => changes.value++);
  final router = GoRouter(
    initialLocation: homePath,
    refreshListenable: changes,
    redirect: (context, state) {
      final session = ref.read(sessionProvider);
      if (!session.hasValue) return null;
      final atLogin = state.matchedLocation == loginPath;
      if (session.value == null) return atLogin ? null : loginPath;
      return atLogin ? homePath : null;
    },
    routes: [
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(path: homePath, builder: (context, state) => const HomePlaceholderPage()),
          GoRoute(path: loginPath, builder: (context, state) => const LoginPage()),
        ],
      ),
    ],
  );
  ref.onDispose(() {
    router.dispose();
    changes.dispose();
  });
  return router;
}, name: 'appRouter');
