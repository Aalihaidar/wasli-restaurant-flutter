import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:wasli_restaurant/app/app.dart';
import 'package:wasli_restaurant/app/config_error_app.dart';
import 'package:wasli_restaurant/core/config/app_config_exception.dart';
import 'package:wasli_restaurant/core/config/app_environment.dart';
import 'package:wasli_restaurant/core/config/app_environment_provider.dart';
import 'package:wasli_restaurant/core/logging/logging_providers.dart';
import 'package:wasli_restaurant/core/storage/platform_token_store.dart';
import 'package:wasli_restaurant/core/storage/token_store_provider.dart';
import 'package:wasli_restaurant/theme/font_licences.dart';

/// Prepares the app and runs the root widget.
///
/// Path URLs on the web (no `#`); the call does nothing on the other platforms. The build-time values are read once: a
/// wrong value shows [ConfigErrorApp] and the app does not start. Otherwise the app runs inside a [ProviderScope] with
/// the environment and the token store of the platform. Errors that nothing caught go to the logger and the crash reporter by type only, because the message
/// of an error could hold personal data.
void bootstrap() {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  registerFontLicences();

  AppEnvironment? environment;
  AppConfigException? configError;
  try {
    environment = AppEnvironment.fromBuild();
  } on AppConfigException catch (error) {
    configError = error;
  }

  final container = ProviderContainer(
    overrides: [
      if (environment != null) appEnvironmentProvider.overrideWithValue(environment),
      tokenStoreProvider.overrideWithValue(createPlatformTokenStore()),
    ],
  );
  _reportUncaughtErrors(container);

  if (configError != null) {
    container.read(loggerProvider).error('The build configuration is invalid.', error: configError);
    runApp(ConfigErrorApp(message: configError.message));
    return;
  }
  runApp(UncontrolledProviderScope(container: container, child: const App()));
}

/// Sends the errors of the framework and of the platform to the logger and the crash reporter, by type only.
void _reportUncaughtErrors(ProviderContainer container) {
  void report(Object error, StackTrace? stack) {
    container.read(loggerProvider).error('Uncaught error.', error: error, stackTrace: stack);
    container.read(crashReporterProvider).report(error.runtimeType.toString(), stackTrace: stack);
  }

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    report(details.exception, details.stack);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    report(error, stack);
    return true;
  };
}
