import 'dart:developer' as developer;
import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:wasli_restaurant/app/app.dart';
import 'package:wasli_restaurant/app/config_error_app.dart';
import 'package:wasli_restaurant/core/config/app_config_exception.dart';
import 'package:wasli_restaurant/core/config/app_environment.dart';
import 'package:wasli_restaurant/core/config/app_environment_provider.dart';

/// Prepares the app and runs the root widget.
///
/// Path URLs on the web (no `#`); the call does nothing on the other platforms. The build-time values are read once: a
/// wrong value shows [ConfigErrorApp] and the app does not start. Otherwise the app runs inside a [ProviderScope] with
/// the environment, and errors that nothing caught are reported without their message, which could hold personal data.
void bootstrap() {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  _reportUncaughtErrors();

  final AppEnvironment environment;
  try {
    environment = AppEnvironment.fromBuild();
  } on AppConfigException catch (error) {
    runApp(ConfigErrorApp(message: error.message));
    return;
  }
  runApp(ProviderScope(overrides: [appEnvironmentProvider.overrideWithValue(environment)], child: const App()));
}

/// Sends the errors of the framework and of the platform to one place that logs the kind of error and nothing else.
void _reportUncaughtErrors() {
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    _report(details.exception, details.stack);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    _report(error, stack);
    return true;
  };
}

void _report(Object error, StackTrace? stack) {
  developer.log(
    'Uncaught ${error.runtimeType}',
    name: 'wasli.app',
    error: error.runtimeType.toString(),
    stackTrace: stack,
  );
}
