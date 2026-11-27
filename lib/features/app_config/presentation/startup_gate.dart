import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:wasli_restaurant/features/app_config/application/app_config_provider.dart';
import 'package:wasli_restaurant/features/app_config/presentation/startup_error_view.dart';
import 'package:wasli_restaurant/features/app_config/presentation/startup_loading_view.dart';

/// Shows [child] once the server settings have loaded, and until then the loading view or, after a failure, the error
/// view with its retry button.
class StartupGate extends ConsumerWidget {
  /// Creates the gate around [child].
  const new({required this.child, super.key});

  /// The app, shown when the settings are loaded.
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return switch (ref.watch(appConfigProvider)) {
      AsyncData() => child,
      AsyncError(:final error) => StartupErrorView(error: error, onRetry: () => ref.invalidate(appConfigProvider)),
      _ => const StartupLoadingView(),
    };
  }
}
