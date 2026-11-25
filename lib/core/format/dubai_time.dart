/// The offset of Asia/Dubai from UTC. The UAE has no daylight saving time, so the offset is the same all year and no
/// time-zone database is needed.
const Duration dubaiOffset = Duration(hours: 4);

/// Converts an instant to the wall-clock time in Asia/Dubai, for display only.
///
/// The server sends UTC; the app keeps UTC everywhere and converts here, once, at the edge. The result is a [DateTime]
/// whose fields (hour, day, ...) are the Dubai wall clock. It is flagged UTC only so that it carries no machine offset;
/// never compare it with a real instant, and never send it back to the server.
DateTime toDubai(DateTime instant) => instant.toUtc().add(dubaiOffset);

/// The Dubai wall-clock time of [instant] as `HH:mm`, 24-hour, Western digits in every language.
String formatDubaiClock(DateTime instant) {
  final local = toDubai(instant);
  return '${_two(local.hour)}:${_two(local.minute)}';
}

/// The Dubai calendar date of [instant] as `YYYY-MM-DD`, Western digits in every language.
String formatDubaiDate(DateTime instant) {
  final local = toDubai(instant);
  return '${local.year.toString().padLeft(4, '0')}-${_two(local.month)}-${_two(local.day)}';
}

String _two(int value) => value.toString().padLeft(2, '0');
