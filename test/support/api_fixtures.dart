import 'dart:convert';
import 'dart:io';

/// Reads the JSON fixture `test/support/fixtures/api/<name>.json` (a name may start with `errors/`).
///
/// Fixtures hold invented values shaped like the responses of the pinned backend contract (`api/openapi.yaml`).
/// The error bodies named in the contract are copied from its examples and live in `errors/`. `flutter test` runs from
/// the package root.
Map<String, Object?> readApiFixture(String name) {
  final text = File('test/support/fixtures/api/$name.json').readAsStringSync();
  return jsonDecode(text) as Map<String, Object?>;
}
