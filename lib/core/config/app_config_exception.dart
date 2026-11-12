/// Thrown at start-up when a build-time value is missing or invalid.
///
/// A broken build configuration is a developer or release mistake, not a runtime condition: the app stops at once with
/// a clear message instead of failing later on every request.
class AppConfigException implements Exception {
  /// Creates the exception with a message that names the value that is wrong.
  const new(this.message);

  /// What is wrong, naming the build-time value. Never contains a secret.
  final String message;

  @override
  String toString() => 'AppConfigException: $message';
}
