import 'dart:convert';
import 'dart:io';

/// Reads the JSON fixture `test/support/fixtures/api/<name>.json`.
///
/// Fixtures hold invented values shaped like the responses of the pinned backend contract (`api/openapi.yaml`).
/// `flutter test` runs from the package root.
Map<String, Object?> readApiFixture(String name) {
  final text = File('test/support/fixtures/api/$name.json').readAsStringSync();
  return jsonDecode(text) as Map<String, Object?>;
}
