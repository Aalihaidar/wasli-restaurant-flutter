import 'dart:developer' as developer;

import 'package:wasli_restaurant/core/logging/sink_logger.dart';

/// The numeric levels of `package:logging`, which the developer tools understand.
const Map<LogLevel, int> _severity = {
  LogLevel.debug: 500,
  LogLevel.info: 800,
  LogLevel.warning: 900,
  LogLevel.error: 1000,
};

/// Writes a line to the developer console (DevTools and the IDE's debug console) under the name `wasli`.
void developerLogSink(LogLevel level, String line, StackTrace? stackTrace) {
  developer.log(line, name: 'wasli', level: _severity[level]!, stackTrace: stackTrace);
}
