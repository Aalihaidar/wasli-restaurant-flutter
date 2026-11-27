import 'dart:ui' show Locale;

import 'package:flutter_test/flutter_test.dart';
import 'package:wasli_restaurant/core/error/failure.dart';
import 'package:wasli_restaurant/core/l10n/failure_message.dart';
import 'package:wasli_restaurant/core/l10n/generated/app_localizations.dart';

void main() {
  for (final language in ['en', 'ar']) {
    group('in $language', () {
      final l10n = lookupAppLocalizations(Locale(language));

      test('each kind of failure has its own message', () {
        expect(failureMessage(l10n, const NetworkFailure()), l10n.failureNetwork);
        expect(failureMessage(l10n, const ServerFailure(statusCode: 500)), l10n.failureServer);
        expect(failureMessage(l10n, const ThrottledFailure()), l10n.failureThrottled);
      });

      test('every other failure, and anything that is not a failure, gets the generic message', () {
        for (final error in <Object>[
          const ValidationFailure(),
          const UnauthenticatedFailure(),
          const PermissionDeniedFailure(),
          const NotFoundFailure(),
          const ConflictFailure(),
          const UnknownFailure(statusCode: 418),
          StateError('not a failure'),
        ]) {
          expect(failureMessage(l10n, error), l10n.failureGeneric, reason: '$error');
        }
      });

      test('the four messages differ from each other', () {
        final messages = {l10n.failureNetwork, l10n.failureServer, l10n.failureThrottled, l10n.failureGeneric};
        expect(messages, hasLength(4));
      });
    });
  }
}
