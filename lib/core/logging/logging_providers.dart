import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wasli_restaurant/core/logging/app_logger.dart';
import 'package:wasli_restaurant/core/logging/crash_reporter.dart';
import 'package:wasli_restaurant/core/logging/developer_log_sink.dart';
import 'package:wasli_restaurant/core/logging/sink_logger.dart';

/// The logger of this run: everything in a debug build, `info` and above in a release build. Tests override it.
final loggerProvider = Provider<AppLogger>(
  (ref) => const SinkLogger(developerLogSink, minLevel: kDebugMode ? LogLevel.debug : LogLevel.info),
  name: 'logger',
);

/// The crash reporter of this run: it sends nothing until a reporting service is chosen. Tests override it.
final crashReporterProvider = Provider<CrashReporter>((ref) => const NoopCrashReporter(), name: 'crashReporter');
