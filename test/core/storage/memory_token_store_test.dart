import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wasli_restaurant/core/storage/memory_token_store.dart';
import 'package:wasli_restaurant/core/storage/token_store_provider.dart';

void main() {
  group('MemoryTokenStore', () {
    test('starts empty', () async {
      expect(await MemoryTokenStore().read(), isNull);
    });

    test('gives back what was written', () async {
      final store = MemoryTokenStore();

      await store.write('token-one');

      expect(await store.read(), 'token-one');
    });

    test('a second write replaces the first', () async {
      final store = MemoryTokenStore();

      await store.write('token-one');
      await store.write('token-two');

      expect(await store.read(), 'token-two');
    });

    test('clear removes the token, and clearing twice is harmless', () async {
      final store = MemoryTokenStore();
      await store.write('token-one');

      await store.clear();
      await store.clear();

      expect(await store.read(), isNull);
    });

    test('refuses an empty token and keeps the earlier one', () async {
      final store = MemoryTokenStore();
      await store.write('token-one');

      await expectLater(store.write(''), throwsArgumentError);

      expect(await store.read(), 'token-one');
    });

    test('two stores do not share a token', () async {
      final first = MemoryTokenStore();
      final second = MemoryTokenStore();

      await first.write('token-one');

      expect(await second.read(), isNull);
    });

    test('never prints the token', () async {
      final store = MemoryTokenStore();
      await store.write('secret-token-value');

      expect(store.toString(), isNot(contains('secret-token-value')));
      expect(store.toString(), contains('holding a token'));
    });
  });

  group('tokenStoreProvider', () {
    test('is the in-memory store by default, kept for the whole run', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final store = container.read(tokenStoreProvider);
      await store.write('token-one');

      expect(store, isA<MemoryTokenStore>());
      expect(await container.read(tokenStoreProvider).read(), 'token-one');
    });
  });
}
