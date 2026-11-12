/// The deployment stage the app was built for.
enum AppStage {
  /// The staging site and API. Also the safe fallback for anything unrecognised.
  staging,

  /// The production site and API.
  production;

  /// Picks the stage from the build-time values.
  ///
  /// The first non-empty value of [appEnv] (`--dart-define=APP_ENV`) and then [flavor] (the Android flavor) decides.
  /// Only `production` selects [production]; any other value, including a misspelt one, or no value at all, counts as
  /// [staging], so a mistake never points a test build at production.
  static AppStage resolve({String? appEnv, String? flavor}) {
    for (final value in [appEnv, flavor]) {
      final name = value?.trim().toLowerCase() ?? '';
      if (name.isNotEmpty) {
        return name == 'production' ? AppStage.production : AppStage.staging;
      }
    }
    return AppStage.staging;
  }
}
