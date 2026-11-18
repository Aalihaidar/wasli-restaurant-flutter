import 'package:flutter/widgets.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:wasli_restaurant/app/app.dart';

/// Prepares the app and runs the root widget.
///
/// Path URLs on the web (no `#`); the call does nothing on the other platforms. The environment, the provider scope
/// and the error zone are added here as the app foundation is built.
void bootstrap() {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  runApp(const App());
}
