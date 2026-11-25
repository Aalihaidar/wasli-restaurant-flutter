/// The hook where a crash-reporting service is connected once one is chosen.
///
/// What it receives holds no personal data: the kind of failure (an error's type name) and its stack trace, which has
/// file names and line numbers only. A report never carries a message, a request, a response, a position or a token.
abstract interface class CrashReporter {
  /// Sends the failure of [kind] to the service.
  void report(String kind, {StackTrace? stackTrace});
}

/// The reporter until a service is chosen: it sends nothing.
class NoopCrashReporter implements CrashReporter {
  /// Creates the reporter.
  const new();

  @override
  void report(String kind, {StackTrace? stackTrace}) {}
}
