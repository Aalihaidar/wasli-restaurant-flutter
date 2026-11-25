import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:wasli_restaurant/app/router/app_router.dart';

/// Root widget of the restaurant app.
///
/// It shows the router's pages. The theme and the localisation are added when they exist.
class App extends ConsumerWidget {
  /// Creates the root widget.
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(title: 'Wasli Restaurant', routerConfig: ref.watch(appRouterProvider));
  }
}
