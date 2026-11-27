import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:wasli_restaurant/features/app_config/application/app_config_provider.dart';
import 'package:wasli_restaurant/features/app_config/domain/app_config.dart';

/// The settings the tests that show the whole app run with: the server is never asked.
const AppConfig testAppConfig = AppConfig(pollInterval: Duration(seconds: 3));

/// Gives the app its settings at once, so a test of the app does not wait at the start screen.
final Override appConfigLoaded = appConfigProvider.overrideWith((ref) => testAppConfig);
