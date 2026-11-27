import 'package:wasli_restaurant/core/error/failure.dart';
import 'package:wasli_restaurant/core/l10n/l10n.dart';

/// The message to show for a failed call, in the active language.
///
/// The case of the [Failure] decides the text; the server's own words are never shown. Anything that is not a [Failure]
/// gets the generic message.
String failureMessage(AppLocalizations l10n, Object error) => switch (error) {
  NetworkFailure() => l10n.failureNetwork,
  ServerFailure() => l10n.failureServer,
  ThrottledFailure() => l10n.failureThrottled,
  _ => l10n.failureGeneric,
};
