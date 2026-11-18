import 'package:material_ui/material_ui.dart';

/// Root widget of the restaurant app.
///
/// A placeholder until the theme, the router and the localisation exist.
class App extends StatelessWidget {
  /// Creates the root widget.
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Wasli Restaurant',
      home: Scaffold(body: Center(child: Text('Wasli Restaurant'))),
    );
  }
}
