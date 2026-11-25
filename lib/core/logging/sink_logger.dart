import 'package:wasli_restaurant/core/logging/app_logger.dart';

/// How serious a log entry is. The order is the order of importance.
enum LogLevel {
  /// Detail for a developer.
  debug,

  /// A normal event.
  info,

  /// Something unexpected that was recovered from.
  warning,

  /// A failure.
  error,
}

/// Where a finished log line goes: the developer console in the app, a list in a test.
typedef LogSink = void Function(LogLevel level, String line, StackTrace? stackTrace);

/// An [AppLogger] that writes one line per call to a [LogSink], skipping entries below [minLevel].
///
/// A failure line is the message followed by the type of the error in parentheses; the error's own message is never
/// written (see [AppLogger.error]).
class SinkLogger implements AppLogger {
  /// Creates the logger.
  const new(this._sink, {this.minLevel = LogLevel.info});

  final LogSink _sink;

  /// The lowest level that is written.
  final LogLevel minLevel;

  @override
  void debug(String message) => _write(LogLevel.debug, message);

  @override
  void info(String message) => _write(LogLevel.info, message);

  @override
  void warning(String message) => _write(LogLevel.warning, message);

  @override
  void error(String message, {Object? error, StackTrace? stackTrace}) {
    _write(LogLevel.error, error == null ? message : '$message (${error.runtimeType})', stackTrace);
  }

  void _write(LogLevel level, String line, [StackTrace? stackTrace]) {
    if (level.index >= minLevel.index) {
      _sink(level, line, stackTrace);
    }
  }
}
