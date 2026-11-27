import 'package:flutter_test/flutter_test.dart';
import 'package:wasli_restaurant/core/storage/memory_token_store.dart';
import 'package:wasli_restaurant/core/storage/platform_token_store.dart';
import 'package:wasli_restaurant/core/storage/secure_token_store.dart';

void main() {
  test('the web keeps the token in memory only', () {
    expect(createPlatformTokenStore(isWeb: true), isA<MemoryTokenStore>());
  });

  test('the other platforms use the secure store', () {
    expect(createPlatformTokenStore(isWeb: false), isA<SecureTokenStore>());
  });

  test('the secure store is chosen when nothing says otherwise outside the web', () {
    // The test VM is not the web, so the default is the secure store.
    expect(createPlatformTokenStore(), isA<SecureTokenStore>());
  });
}
