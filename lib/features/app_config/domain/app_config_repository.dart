import 'package:wasli_restaurant/features/app_config/domain/app_config.dart';

/// Where the app gets the server settings.
abstract interface class AppConfigRepository {
  /// Reads the settings; throws a `Failure` when the server cannot be reached or refuses.
  Future<AppConfig> load();
}
