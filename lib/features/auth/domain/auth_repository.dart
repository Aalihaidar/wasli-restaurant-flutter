import 'package:wasli_restaurant/features/auth/domain/staff_session.dart';

/// Where the app signs staff in and out and finds out who is signed in.
///
/// Every method throws a `Failure` when the server cannot be reached or refuses, unless it says otherwise.
abstract interface class AuthRepository {
  /// Signs in with [username] and [password], keeps the token and returns the session.
  ///
  /// A wrong username or password is an `UnauthenticatedFailure`; an account without a restaurant is a
  /// `PermissionDeniedFailure`. In both cases nothing is kept.
  Future<StaffSession> signIn({required String username, required String password});

  /// The session of the stored token, or `null` when nobody is signed in or the server no longer accepts the token (the
  /// token is then removed). Throws when the server cannot be reached, so the app can offer to try again.
  Future<StaffSession?> restore();

  /// Ends the session on the server and removes the token. It never throws: the token is removed even when the server
  /// cannot be reached.
  Future<void> signOut();
}
