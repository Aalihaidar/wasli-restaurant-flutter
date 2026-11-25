import 'package:flutter_test/flutter_test.dart';
import 'package:wasli_restaurant/core/logging/sink_logger.dart';

void main() {
  late List<(LogLevel, String, StackTrace?)> written;

  void sink(LogLevel level, String line, StackTrace? stackTrace) => written.add((level, line, stackTrace));

  setUp(() => written = []);

  group('SinkLogger', () {
    test('writes each level with its message', () {
      SinkLogger(sink, minLevel: LogLevel.debug)
        ..debug('a')
        ..info('b')
        ..warning('c')
        ..error('d');

      expect(written.map((entry) => (entry.$1, entry.$2)), [
        (LogLevel.debug, 'a'),
        (LogLevel.info, 'b'),
        (LogLevel.warning, 'c'),
        (LogLevel.error, 'd'),
      ]);
    });

    test('skips what is below the minimum level', () {
      SinkLogger(sink)
        ..debug('dropped')
        ..info('kept')
        ..warning('kept too');

      expect(written.map((entry) => entry.$2), ['kept', 'kept too']);
    });

    test('a higher minimum drops the lower levels', () {
      SinkLogger(sink, minLevel: LogLevel.error)
        ..info('dropped')
        ..warning('dropped')
        ..error('kept');

      expect(written.map((entry) => entry.$2), ['kept']);
    });

    test('a failure is written with the type of the error and never its message', () {
      SinkLogger(sink)
          .error('Could not load the orders.', error: const FormatException('plate A 12345 at 25.0763,55.1345'));

      expect(written.single.$2, 'Could not load the orders. (FormatException)');
      expect(written.single.$2, isNot(contains('A 12345')));
      expect(written.single.$2, isNot(contains('25.0763')));
    });

    test('a failure without an error is just the message, and the stack trace is passed on', () {
      final stack = StackTrace.current;

      SinkLogger(sink).error('Something failed.', stackTrace: stack);

      expect(written.single.$2, 'Something failed.');
      expect(written.single.$3, same(stack));
    });
  });
}
