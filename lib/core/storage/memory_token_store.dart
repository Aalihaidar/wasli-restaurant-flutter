import 'package:wasli_restaurant/core/storage/token_store.dart';

/// A [TokenStore] that keeps the token in memory only.
///
/// It is the interim store on the web: a page's scripts have no secure place to keep a secret, so the token is not
/// written anywhere and is gone when the page reloads or closes (the user signs in again). It is also the store the
/// tests use. A hardened persistent store, and later an `HttpOnly` cookie session, replace it without changing callers.
class MemoryTokenStore implements TokenStore {
  String? _token;

  @override
  Future<String?> read() async => _token;

  @override
  Future<void> write(String token) async {
    if (token.isEmpty) {
      throw ArgumentError.value(token.length, 'token', 'A token cannot be empty.');
    }
    _token = token;
  }

  @override
  Future<void> clear() async => _token = null;

  /// Never prints the token.
  @override
  String toString() => 'MemoryTokenStore(${_token == null ? 'empty' : 'holding a token'})';
}
