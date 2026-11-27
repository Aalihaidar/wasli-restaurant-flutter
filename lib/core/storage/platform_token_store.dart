import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:wasli_restaurant/core/storage/memory_token_store.dart';
import 'package:wasli_restaurant/core/storage/secure_token_store.dart';
import 'package:wasli_restaurant/core/storage/token_store.dart';

/// The token store of the platform the app runs on, for the place where the app is assembled.
///
/// The web gets the in-memory store (the token is gone when the page reloads) until a cookie session replaces it;
/// Android, iOS and Windows get the platform's secure store. [isWeb] is only for tests.
TokenStore createPlatformTokenStore({bool isWeb = kIsWeb}) => isWeb ? MemoryTokenStore() : const SecureTokenStore();
