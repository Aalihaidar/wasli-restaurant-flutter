import 'package:wasli_restaurant/core/error/failure.dart';
import 'package:wasli_restaurant/core/l10n/failure_message.dart';
import 'package:wasli_restaurant/core/l10n/l10n.dart';

/// The message for a failed sign-in, in the active language.
///
/// A `401` is a wrong username or password (the server does not say which, nor whether the account exists) and a `403`
/// is an account without a restaurant; every other failure has the usual message of its kind.
String loginErrorMessage(AppLocalizations l10n, Object error) => switch (error) {
  UnauthenticatedFailure() => l10n.loginWrongCredentials,
  PermissionDeniedFailure() => l10n.loginNoRestaurant,
  _ => failureMessage(l10n, error),
};
