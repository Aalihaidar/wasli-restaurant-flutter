import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wasli_restaurant/core/error/failure.dart';
import 'package:wasli_restaurant/core/network/session_expiry.dart';
import 'package:wasli_restaurant/features/auth/application/auth_providers.dart';

import '../../../support/fake_auth_repository.dart';

ProviderContainer _container(FakeAuthRepository repository) {
  final container = ProviderContainer(overrides: [authRepositoryProvider.overrideWithValue(repository)]);
  addTearDown(container.dispose);
  return container;
}

void main() {
  group('SessionNotifier', () {
    test('starts by looking up the stored token: nobody', () async {
      final container = _container(FakeAuthRepository());

      expect(await container.read(sessionProvider.future), isNull);
    });

    test('starts by looking up the stored token: a member', () async {
      final container = _container(FakeAuthRepository(restored: testSession));

      expect(await container.read(sessionProvider.future), testSession);
    });

    test('a lookup that failed is an error and is not retried by itself', () async {
      final repository = FakeAuthRepository()..restoreError = const NetworkFailure();
      final container = _container(repository);

      await expectLater(container.read(sessionProvider.future), throwsA(isA<NetworkFailure>()));

      expect(container.read(sessionProvider).hasError, isTrue);
    });

    test('signing in keeps the session', () async {
      final repository = FakeAuthRepository();
      final container = _container(repository);
      await container.read(sessionProvider.future);

      await container.read(sessionProvider.notifier).signIn(username: 'sara.cashier', password: 'pw-1');

      expect(container.read(sessionProvider).value, testSession);
      expect(repository.signIns, [('sara.cashier', 'pw-1')]);
    });

    test('a failed sign-in is thrown to the caller and the session stays as it was', () async {
      final repository = FakeAuthRepository()..signInError = const UnauthenticatedFailure();
      final container = _container(repository);
      await container.read(sessionProvider.future);

      await expectLater(
        container.read(sessionProvider.notifier).signIn(username: 'sara.cashier', password: 'wrong'),
        throwsA(isA<UnauthenticatedFailure>()),
      );

      expect(container.read(sessionProvider).value, isNull);
      expect(container.read(sessionProvider).hasError, isFalse);
    });

    test('signing out asks the repository and clears the session', () async {
      final repository = FakeAuthRepository(restored: testSession);
      final container = _container(repository);
      await container.read(sessionProvider.future);

      await container.read(sessionProvider.notifier).signOut();

      expect(container.read(sessionProvider).value, isNull);
      expect(repository.signOuts, 1);
    });

    test('a token the server refused (the expiry signal) ends the session', () async {
      final container = _container(FakeAuthRepository(restored: testSession));
      await container.read(sessionProvider.future);

      container.read(sessionExpiryProvider.notifier).signal();

      expect(container.read(sessionProvider).value, isNull);
    });
  });
}
