import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wasli_restaurant/core/network/api_providers.dart';
import 'package:wasli_restaurant/core/network/session_expiry.dart';
import 'package:wasli_restaurant/core/storage/token_store_provider.dart';
import 'package:wasli_restaurant/features/auth/data/auth_repository_impl.dart';
import 'package:wasli_restaurant/features/auth/domain/auth_repository.dart';
import 'package:wasli_restaurant/features/auth/domain/staff_session.dart';

/// The repository that signs staff in and out.
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl.fromDio(ref.watch(dioProvider), ref.watch(tokenStoreProvider)),
  name: 'authRepository',
);

/// Who is signed in: the [StaffSession], or `null` when nobody is.
///
/// It starts by looking up the stored token; a failure is not retried by the provider (the start screen offers a button).
/// A token that the server refuses ends the session by itself, once, and the router sends the user to the login.
class SessionNotifier extends AsyncNotifier<StaffSession?> {
  @override
  Future<StaffSession?> build() {
    ref.listen(sessionExpiryProvider, (previous, next) => state = const AsyncData(null));
    return ref.watch(authRepositoryProvider).restore();
  }

  /// Signs in and keeps the session. A failure is thrown to the caller (the login form shows it); the session stays as
  /// it was.
  Future<void> signIn({required String username, required String password}) async {
    final session = await ref.read(authRepositoryProvider).signIn(username: username, password: password);
    state = AsyncData(session);
  }

  /// Signs out, on the server and on this device, and clears the session.
  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).signOut();
    state = const AsyncData(null);
  }
}

/// The session of this run.
final sessionProvider = AsyncNotifierProvider<SessionNotifier, StaffSession?>(
  SessionNotifier.new,
  retry: (retryCount, error) => null,
  name: 'session',
);
