import 'package:material_ui/material_ui.dart';

/// Shown instead of the app when a build-time value is missing or wrong (for example `API_BASE_URL`).
///
/// It names the value that is wrong and never repeats it. It exists for the developer or the release that made the
/// build: a restaurant never sees it on a correct build.
class ConfigErrorApp extends StatelessWidget {
  /// Creates the screen with the [message] of the configuration error.
  const new({required this.message, super.key});

  /// What is wrong, naming the build-time value. Never contains a secret.
  final String message;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wasli Restaurant',
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsetsDirectional.all(24),
            child: Text('This build is not configured correctly.\n\n$message', textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }
}
