/// Where the staff token is kept between calls.
///
/// The token is the key to a restaurant's orders and to its customers' personal data, so it is only ever stored through
/// this interface and never in `shared_preferences`. There is one implementation per platform (the platform's secure
/// store on Android, iOS and Windows, the interim in-memory one on the web), chosen where the app is assembled; the rest
/// of the app does not know which one it has.
///
/// Nothing here logs, prints or exposes the token beyond [read]. It is cleared on logout, on a `401` and when the
/// session ends.
abstract interface class TokenStore {
  /// The stored token, or `null` when nobody is signed in.
  Future<String?> read();

  /// Stores [token], replacing any earlier one. Throws an [ArgumentError] for an empty token.
  Future<void> write(String token);

  /// Removes the token. Does nothing when there is none.
  Future<void> clear();
}
