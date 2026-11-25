import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wasli_restaurant/core/storage/memory_token_store.dart';
import 'package:wasli_restaurant/core/storage/token_store.dart';

/// The token store of this run.
///
/// It is the in-memory store until the platform stores exist. The app overrides it where it is assembled (for example
/// with the secure store on Android), and tests override it with their own.
final tokenStoreProvider = Provider<TokenStore>((ref) => MemoryTokenStore(), name: 'tokenStore');
