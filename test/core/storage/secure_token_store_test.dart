import 'package:flutter/services.dart' show PlatformException;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wasli_restaurant/core/storage/secure_token_store.dart';

/// A secure store whose platform cannot read the value, as after a lost key.
class _UnreadableStorage extends FlutterSecureStorage {
  new({this.deleteFails = false});

  final bool deleteFails;
  int deletes = 0;

  @override
  Future<String?> read({
    required String key,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) => throw PlatformException(code: 'unreadable');

  @override
  Future<void> delete({
    required String key,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    deletes++;
    if (deleteFails) throw PlatformException(code: 'locked');
  }
}

void main() {
  late Map<String, String> platformValues;

  setUp(() {
    platformValues = {};
    FlutterSecureStorage.setMockInitialValues(platformValues);
  });

  group('SecureTokenStore', () {
    test('starts empty', () async {
      expect(await const SecureTokenStore().read(), isNull);
    });

    test('gives back what was written, under one key and nowhere else', () async {
      const store = SecureTokenStore();

      await store.write('token-one');

      expect(await store.read(), 'token-one');
      expect(platformValues, {SecureTokenStore.key: 'token-one'});
    });

    test('a second write replaces the first', () async {
      const store = SecureTokenStore();

      await store.write('token-one');
      await store.write('token-two');

      expect(await store.read(), 'token-two');
      expect(platformValues, hasLength(1));
    });

    test('clear removes the token from the platform store, and clearing twice is harmless', () async {
      const store = SecureTokenStore();
      await store.write('token-one');

      await store.clear();
      await store.clear();

      expect(await store.read(), isNull);
      expect(platformValues, isEmpty);
    });

    test('refuses an empty token and keeps the earlier one', () async {
      const store = SecureTokenStore();
      await store.write('token-one');

      await expectLater(store.write(''), throwsArgumentError);

      expect(await store.read(), 'token-one');
    });

    test('a token the platform cannot read counts as no token and is removed', () async {
      final storage = _UnreadableStorage();

      expect(await SecureTokenStore(storage: storage).read(), isNull);
      expect(storage.deletes, 1);
    });

    test('a token that cannot be read or removed still counts as no token', () async {
      final storage = _UnreadableStorage(deleteFails: true);

      expect(await SecureTokenStore(storage: storage).read(), isNull);
      expect(storage.deletes, 1);
    });

    test('never prints the token', () async {
      const store = SecureTokenStore();
      await store.write('secret-token');

      expect(store.toString(), isNot(contains('secret-token')));
    });
  });
}
