import 'package:flutter_test/flutter_test.dart';
import 'package:wasli_restaurant/core/error/error_body_parser.dart';

void main() {
  group('parseApiErrors', () {
    test('reads code and attr from a decoded standard body and ignores type and detail', () {
      final errors = parseApiErrors({
        'type': 'validation_error',
        'errors': [
          {'code': 'blank', 'detail': 'This field may not be blank.', 'attr': 'note'},
          {'code': 'required', 'detail': 'Required.', 'attr': 'items.0.quantity'},
        ],
      });

      expect(errors.map((e) => e.code), ['blank', 'required']);
      expect(errors.map((e) => e.attr), ['note', 'items.0.quantity']);
    });

    test('a null attr means the error is not about a field', () {
      final errors = parseApiErrors({
        'type': 'client_error',
        'errors': [
          {'code': 'permission_denied', 'detail': 'No.', 'attr': null},
        ],
      });

      expect(errors.single.code, 'permission_denied');
      expect(errors.single.attr, isNull);
    });

    test('decodes a JSON string body', () {
      final errors = parseApiErrors('{"type":"client_error","errors":[{"code":"not_found","detail":"x","attr":null}]}');

      expect(errors.single.code, 'not_found');
    });

    test('keeps a code the app does not know', () {
      final errors = parseApiErrors({
        'errors': [
          {'code': 'some_future_code'},
        ],
      });

      expect(errors.single.code, 'some_future_code');
    });

    test('skips entries without a string code and treats a non-string attr as no field', () {
      final errors = parseApiErrors({
        'errors': [
          {'detail': 'no code'},
          {'code': 42},
          'not a map',
          {'code': 'invalid', 'attr': 7},
        ],
      });

      expect(errors, hasLength(1));
      expect(errors.single.code, 'invalid');
      expect(errors.single.attr, isNull);
    });

    test('anything that is not the standard shape gives an empty list', () {
      expect(parseApiErrors(null), isEmpty);
      expect(parseApiErrors(''), isEmpty);
      expect(parseApiErrors('<html><body>Bad gateway</body></html>'), isEmpty);
      expect(parseApiErrors('[1, 2]'), isEmpty);
      expect(parseApiErrors(<String, dynamic>{}), isEmpty);
      expect(parseApiErrors({'errors': 'nope'}), isEmpty);
      expect(parseApiErrors(42), isEmpty);
    });
  });
}
