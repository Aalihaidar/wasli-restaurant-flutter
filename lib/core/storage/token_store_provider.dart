import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wasli_restaurant/core/storage/memory_token_store.dart';
import 'package:wasli_restaurant/core/storage/token_store.dart';

/// The token store of this run.
///
/// It is the in-memory store unless the app overrides it where it is assembled: `bootstrap` gives it the store of the
/// platform (`createPlatformTokenStore`), and tests override it with their own.
final tokenStoreProvider = Provider<TokenStore>((ref) => MemoryTokenStore(), name: 'tokenStore');
