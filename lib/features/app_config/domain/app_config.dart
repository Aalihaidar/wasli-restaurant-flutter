/// The server settings this app uses, from `GET /config`.
final class AppConfig {
  /// Creates the settings.
  const new({required this.pollInterval});

  /// How often the orders screen asks for new orders while it is visible.
  final Duration pollInterval;
}
