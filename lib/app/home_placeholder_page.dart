import 'package:material_ui/material_ui.dart';
import 'package:wasli_restaurant/core/l10n/l10n.dart';

/// The first screen until the staff login and the orders list exist.
class HomePlaceholderPage extends StatelessWidget {
  /// Creates the page.
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(context.l10n.appTitle)));
  }
}
