import 'package:flutter_test/flutter_test.dart';
import 'package:wasli_restaurant/core/format/dubai_time.dart';

void main() {
  group('Asia/Dubai display', () {
    test('adds four hours to a UTC instant', () {
      final instant = DateTime.utc(2026, 12, 1, 10, 19, 10);

      expect(formatDubaiClock(instant), '14:19');
      expect(formatDubaiDate(instant), '2026-12-01');
    });

    test('moves to the next day after 20:00 UTC', () {
      final instant = DateTime.utc(2026, 12, 31, 21, 30);

      expect(formatDubaiClock(instant), '01:30');
      expect(formatDubaiDate(instant), '2027-01-01');
    });

    test('pads hours, minutes, month and day', () {
      final instant = DateTime.utc(2026, 3, 5, 0, 5);

      expect(formatDubaiClock(instant), '04:05');
      expect(formatDubaiDate(instant), '2026-03-05');
    });

    test('has the same offset in summer, because the UAE has no daylight saving time', () {
      expect(formatDubaiClock(DateTime.utc(2026, 7, 1, 12)), '16:00');
      expect(formatDubaiClock(DateTime.utc(2026, 1, 1, 12)), '16:00');
    });

    test('gives the same result for the same instant, whatever the zone of the DateTime', () {
      final utc = DateTime.utc(2026, 12, 1, 10, 19);
      final local = utc.toLocal();

      expect(formatDubaiClock(local), formatDubaiClock(utc));
      expect(formatDubaiDate(local), formatDubaiDate(utc));
    });
  });
}
