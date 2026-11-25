import 'package:material_ui/material_ui.dart';

/// The first screen until the staff login and the orders list exist.
class HomePlaceholderPage extends StatelessWidget {
  /// Creates the page.
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Wasli Restaurant')));
  }
}
