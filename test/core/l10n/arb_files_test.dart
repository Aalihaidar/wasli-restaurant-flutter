import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

Map<String, Object?> _read(String path) => jsonDecode(File(path).readAsStringSync()) as Map<String, Object?>;

Set<String> _messageKeys(Map<String, Object?> arb) => arb.keys.where((key) => !key.startsWith('@')).toSet();

/// The `{name}` placeholders of a message.
Set<String> _placeholders(Object? message) =>
    RegExp(r'\{(\w+)').allMatches(message! as String).map((match) => match.group(1)!).toSet();

void main() {
  final english = _read('l10n/app_en.arb');
  final arabic = _read('l10n/app_ar.arb');

  group('ARB files', () {
    test('Arabic has exactly the messages English has', () {
      expect(_messageKeys(arabic), _messageKeys(english));
    });

    test('every English message has a description for the translator', () {
      for (final key in _messageKeys(english)) {
        final attributes = english['@$key'] as Map<String, Object?>?;
        expect(attributes?['description'], isA<String>(), reason: key);
        expect((attributes!['description']! as String).trim(), isNotEmpty, reason: key);
      }
    });

    test('both languages use the same placeholders in every message', () {
      for (final key in _messageKeys(english)) {
        expect(_placeholders(arabic[key]), _placeholders(english[key]), reason: key);
      }
    });

    test('no message is empty', () {
      for (final arb in [english, arabic]) {
        for (final key in _messageKeys(arb)) {
          expect((arb[key]! as String).trim(), isNotEmpty, reason: key);
        }
      }
    });
  });
}
