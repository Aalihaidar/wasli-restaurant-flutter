import 'package:flutter/services.dart' show PlatformException;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wasli_restaurant/core/storage/token_store.dart';

/// A [TokenStore] that keeps the token in the platform's secure store: the Keychain on iOS, Keystore-backed encryption
/// on Android and the credential protection of Windows.
///
/// The token is the only value kept, under one key. On iOS it is readable after the first unlock and never leaves the
/// device (no iCloud sync, no move to a new device). On Android the app's backup is switched off in the manifest, so
/// the encrypted value is never restored on a device whose key cannot open it. The web does not use this class: a page's
/// scripts have no secure place for a secret, so it uses the in-memory store (`security-privacy.md`).
class SecureTokenStore implements TokenStore {
  /// Creates the store over `storage`. The default has the options described above; a test passes its own.
  const new({
    this._storage = const FlutterSecureStorage(
      iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock_this_device),
    ),
  });

  /// The key of the token in the secure store.
  static const String key = 'wasli.staff_token';

  final FlutterSecureStorage _storage;

  /// The stored token, or `null` when there is none.
  ///
  /// A value the platform cannot read (for example a key that was lost after a restore or a system update) counts as no
  /// token: it is removed and the user signs in again, instead of the app failing at start.
  @override
  Future<String?> read() async {
    try {
      return await _storage.read(key: key);
    } on PlatformException {
      await _discard();
      return null;
    }
  }

  /// Stores [token], replacing any earlier one. Throws an [ArgumentError] for an empty token, and a
  /// [PlatformException] when the platform refuses to store it (the caller treats that as a failed sign-in).
  @override
  Future<void> write(String token) async {
    if (token.isEmpty) {
      throw ArgumentError.value(token.length, 'token', 'A token cannot be empty.');
    }
    await _storage.write(key: key, value: token);
  }

  @override
  Future<void> clear() => _storage.delete(key: key);

  Future<void> _discard() async {
    try {
      await _storage.delete(key: key);
    } on PlatformException {
      // The value stays unreadable and the next sign-in replaces it.
    }
  }

  /// Never prints the token.
  @override
  String toString() => 'SecureTokenStore()';
}
