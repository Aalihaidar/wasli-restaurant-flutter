import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:wasli_restaurant/features/app_config/presentation/startup_error_view.dart';
import 'package:wasli_restaurant/features/app_config/presentation/startup_loading_view.dart';
import 'package:wasli_restaurant/features/auth/application/auth_providers.dart';

/// Shows [child] once the app knows whether somebody is signed in (a stored token is looked up on the server), and until
/// then the loading view or, after a failure, the error view with its retry button.
///
/// It sits inside the gate of the server settings, so the lookup starts when they have loaded.
class SessionGate extends ConsumerWidget {
  /// Creates the gate around [child].
  const new({required this.child, super.key});

  /// The app, shown when the session is known.
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return switch (ref.watch(sessionProvider)) {
      AsyncData() => child,
      AsyncError(:final error) => StartupErrorView(error: error, onRetry: () => ref.invalidate(sessionProvider)),
      _ => const StartupLoadingView(),
    };
  }
}
