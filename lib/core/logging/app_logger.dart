/// Writes what happened in the app, without personal data.
///
/// The app handles customers' positions, plates, notes and phone numbers and the staff token, and none of it may reach a
/// log. So the interface takes a message the caller writes (a fixed sentence that names the event, never a value from a
/// request or a response) and, for a failure, only the error itself: [error] records its type and never its message,
/// because the message of an exception can repeat a URL, a body or an input.
abstract interface class AppLogger {
  /// Detail that helps a developer; dropped in a release build.
  void debug(String message);

  /// A normal event worth knowing about.
  void info(String message);

  /// Something unexpected that the app recovered from.
  void warning(String message);

  /// A failure. Only the type of [error] is written, never its message; [stackTrace] is kept for the developer.
  void error(String message, {Object? error, StackTrace? stackTrace});
}
