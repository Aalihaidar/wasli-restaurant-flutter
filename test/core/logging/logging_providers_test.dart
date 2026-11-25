import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wasli_restaurant/core/logging/crash_reporter.dart';
import 'package:wasli_restaurant/core/logging/logging_providers.dart';
import 'package:wasli_restaurant/core/logging/sink_logger.dart';

class _RecordingReporter implements CrashReporter {
  final List<String> kinds = [];

  @override
  void report(String kind, {StackTrace? stackTrace}) => kinds.add(kind);
}

void main() {
  test('the default logger is a sink logger and the default reporter sends nothing', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(container.read(loggerProvider), isA<SinkLogger>());
    expect(container.read(crashReporterProvider), isA<NoopCrashReporter>());
    // Neither call may throw.
    container.read(loggerProvider).error('A failure.', error: StateError('x'));
    container.read(crashReporterProvider).report('StateError');
  });

  test('a test can replace the crash reporter', () {
    final reporter = _RecordingReporter();
    final container = ProviderContainer(overrides: [crashReporterProvider.overrideWithValue(reporter)]);
    addTearDown(container.dispose);

    container.read(crashReporterProvider).report('StateError');

    expect(reporter.kinds, ['StateError']);
  });
}
