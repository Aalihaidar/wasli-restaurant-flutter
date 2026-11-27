import 'package:material_ui/material_ui.dart';

/// The first page until the staff login and the orders list exist.
///
/// It is empty: the app's name is already in the top bar of the shell it is shown in.
class HomePlaceholderPage extends StatelessWidget {
  /// Creates the page.
  const new({super.key});

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
