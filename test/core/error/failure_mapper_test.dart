import 'package:flutter_test/flutter_test.dart';
import 'package:wasli_restaurant/core/error/failure.dart';
import 'package:wasli_restaurant/core/error/failure_mapper.dart';

Map<String, dynamic> _body(String code, {String type = 'client_error', String? attr}) => {
  'type': type,
  'errors': [
    {'code': code, 'detail': 'Invented text.', 'attr': attr},
  ],
};

void main() {
  group('failureFromResponse', () {
    test('maps each status to its case', () {
      expect(failureFromResponse(statusCode: 400), isA<ValidationFailure>());
      expect(failureFromResponse(statusCode: 422), isA<ValidationFailure>());
      expect(failureFromResponse(statusCode: 401), isA<UnauthenticatedFailure>());
      expect(failureFromResponse(statusCode: 403), isA<PermissionDeniedFailure>());
      expect(failureFromResponse(statusCode: 404), isA<NotFoundFailure>());
      expect(failureFromResponse(statusCode: 409), isA<ConflictFailure>());
      expect(failureFromResponse(statusCode: 429), isA<ThrottledFailure>());
    });

    test('a 5xx is a server failure with its status', () {
      final failure = failureFromResponse(statusCode: 503);

      expect(failure, isA<ServerFailure>());
      expect((failure as ServerFailure).statusCode, 503);
    });

    test('any other status is an unknown failure with its status', () {
      final failure = failureFromResponse(statusCode: 418);

      expect(failure, isA<UnknownFailure>());
      expect((failure as UnknownFailure).statusCode, 418);
      expect(failureFromResponse(statusCode: 600), isA<UnknownFailure>());
    });

    test('carries the error entries and the request id', () {
      final failure = failureFromResponse(
        statusCode: 400,
        body: _body('blank', type: 'validation_error', attr: 'note'),
        requestId: 'req-123',
      );

      expect(failure.requestId, 'req-123');
      expect(failure.errors.single.code, 'blank');
      expect(failure.errors.single.attr, 'note');
    });

    test('hasCode finds a reported code', () {
      final failure = failureFromResponse(statusCode: 409, body: _body('order_invalid_transition'));

      expect(failure, isA<ConflictFailure>());
      expect(failure.hasCode('order_invalid_transition'), isTrue);
      expect(failure.hasCode('permission_denied'), isFalse);
    });

    test('an unknown code still gives the case of its status', () {
      final failure = failureFromResponse(statusCode: 403, body: _body('some_future_code'));

      expect(failure, isA<PermissionDeniedFailure>());
      expect(failure.hasCode('some_future_code'), isTrue);
    });

    test('a non-JSON body gives the case of the status with no entries', () {
      final failure = failureFromResponse(statusCode: 502, body: '<html>Bad gateway</html>');

      expect(failure, isA<ServerFailure>());
      expect(failure.errors, isEmpty);
    });

    group('Retry-After', () {
      test('reads whole seconds on a 429', () {
        final failure = failureFromResponse(statusCode: 429, retryAfter: ' 30 ');

        expect((failure as ThrottledFailure).retryAfter, const Duration(seconds: 30));
      });

      test('is null when missing, negative, a date or text', () {
        for (final value in [null, '', '-5', 'Wed, 21 Oct 2026 07:28:00 GMT', 'soon']) {
          final failure = failureFromResponse(statusCode: 429, retryAfter: value);

          expect((failure as ThrottledFailure).retryAfter, isNull, reason: 'value: $value');
        }
      });
    });
  });

  group('NetworkFailure', () {
    test('has no entries and no request id', () {
      const failure = NetworkFailure();

      expect(failure.errors, isEmpty);
      expect(failure.requestId, isNull);
    });
  });

  group('Failure', () {
    test('an exhaustive switch covers every case', () {
      String label(Failure failure) => switch (failure) {
        NetworkFailure() => 'network',
        ValidationFailure() => 'validation',
        UnauthenticatedFailure() => 'unauthenticated',
        PermissionDeniedFailure() => 'permission',
        NotFoundFailure() => 'not found',
        ConflictFailure() => 'conflict',
        ThrottledFailure() => 'throttled',
        ServerFailure() => 'server',
        UnknownFailure() => 'unknown',
      };

      expect(label(failureFromResponse(statusCode: 409)), 'conflict');
      expect(label(const NetworkFailure()), 'network');
    });
  });
}
