import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:wasli_restaurant/app/app.dart';
import 'package:wasli_restaurant/app/router/app_router.dart';
import 'package:wasli_restaurant/core/error/failure.dart';
import 'package:wasli_restaurant/core/l10n/locale_controller.dart';
import 'package:wasli_restaurant/core/network/session_expiry.dart';
import 'package:wasli_restaurant/features/auth/application/auth_providers.dart';

import '../support/app_config_overrides.dart';
import '../support/fake_auth_repository.dart';

/// Runs the whole app with [repository] as the sign-in backend, and gives back the container to drive it.
Future<ProviderContainer> _pumpApp(WidgetTester tester, FakeAuthRepository repository) async {
  final container = ProviderContainer(
    overrides: [appConfigLoaded, authRepositoryProvider.overrideWithValue(repository)],
  );
  addTearDown(container.dispose);
  await tester.pumpWidget(UncontrolledProviderScope(container: container, child: const App()));
  await tester.pump();
  return container;
}

const _loginHeading = 'Staff sign in';

void main() {
  group('nobody is signed in', () {
    testWidgets('the app opens on the sign-in screen, under the top bar', (tester) async {
      await _pumpApp(tester, FakeAuthRepository());

      expect(find.text(_loginHeading), findsOneWidget);
      expect(find.descendant(of: find.byType(AppBar), matching: find.text('Wasli Restaurant')), findsOneWidget);
      expect(find.text('Demo Grill'), findsNothing);
    });

    testWidgets('signing in with the form lands on the first screen', (tester) async {
      final repository = FakeAuthRepository();
      await _pumpApp(tester, repository);

      await tester.enterText(find.widgetWithText(TextFormField, 'Username'), 'sara.cashier');
      await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'pw-1');
      await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
      await tester.pumpAndSettle();

      expect(find.text(_loginHeading), findsNothing);
      expect(find.text('Demo Grill'), findsOneWidget);
      expect(find.text('Signed in as Sara Tester'), findsOneWidget);
      expect(find.text('Cashier'), findsOneWidget);
    });

    testWidgets('a wrong password stays on the sign-in screen with the message', (tester) async {
      final repository = FakeAuthRepository()..signInError = const UnauthenticatedFailure();
      await _pumpApp(tester, repository);

      await tester.enterText(find.widgetWithText(TextFormField, 'Username'), 'sara.cashier');
      await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'wrong');
      await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
      await tester.pumpAndSettle();

      expect(find.text(_loginHeading), findsOneWidget);
      expect(find.text('Wrong username or password.'), findsOneWidget);
    });
  });

  group('somebody is signed in', () {
    testWidgets('the app opens on the first screen with the restaurant and the member', (tester) async {
      await _pumpApp(tester, FakeAuthRepository(restored: testSession));

      expect(find.text('Demo Grill'), findsOneWidget);
      expect(find.text('Signed in as Sara Tester'), findsOneWidget);
      expect(find.text('Cashier'), findsOneWidget);
      expect(find.text(_loginHeading), findsNothing);
    });

    testWidgets('in Arabic the restaurant, the role and the layout are Arabic', (tester) async {
      final container = await _pumpApp(tester, FakeAuthRepository(restored: testSession));

      container.read(localeProvider.notifier).setLocale(const Locale('ar'));
      await tester.pumpAndSettle();

      expect(find.text('مشويات تجريبية'), findsOneWidget);
      expect(find.text('أمين الصندوق'), findsOneWidget);
      expect(find.text('تسجيل الخروج'), findsOneWidget);
    });

    testWidgets('Sign out tells the repository and returns to the sign-in screen', (tester) async {
      final repository = FakeAuthRepository(restored: testSession);
      await _pumpApp(tester, repository);

      await tester.tap(find.widgetWithText(OutlinedButton, 'Sign out'));
      await tester.pumpAndSettle();

      expect(repository.signOuts, 1);
      expect(find.text(_loginHeading), findsOneWidget);
      expect(find.text('Demo Grill'), findsNothing);
    });

    testWidgets('a token the server refuses returns to the sign-in screen', (tester) async {
      final container = await _pumpApp(tester, FakeAuthRepository(restored: testSession));

      container.read(sessionExpiryProvider.notifier).signal();
      await tester.pumpAndSettle();

      expect(find.text(_loginHeading), findsOneWidget);
      expect(find.text('Demo Grill'), findsNothing);
    });

    testWidgets('opening the sign-in address sends a signed-in member to the first screen', (tester) async {
      final container = await _pumpApp(tester, FakeAuthRepository(restored: testSession));

      container.read(appRouterProvider).go(loginPath);
      await tester.pumpAndSettle();

      expect(find.text(_loginHeading), findsNothing);
      expect(find.text('Demo Grill'), findsOneWidget);
    });
  });

  group('the start-up lookup of the session', () {
    testWidgets('shows progress and no screen until the lookup is done', (tester) async {
      final never = Completer<void>();
      final repository = _SlowAuthRepository(never);
      await _pumpApp(tester, repository);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text(_loginHeading), findsNothing);
      expect(find.byType(AppBar), findsNothing);
    });

    testWidgets('a failed lookup shows the message with Try again, and trying again opens the app', (tester) async {
      final repository = FakeAuthRepository(restored: testSession)..restoreError = const NetworkFailure();
      await _pumpApp(tester, repository);

      expect(find.text("Can't reach the server. Check the connection and try again."), findsOneWidget);
      expect(find.text('Demo Grill'), findsNothing);

      repository.restoreError = null;
      await tester.tap(find.widgetWithText(FilledButton, 'Try again'));
      await tester.pumpAndSettle();

      expect(find.text('Demo Grill'), findsOneWidget);
    });
  });
}

/// A repository whose lookup of the stored token never ends.
class _SlowAuthRepository extends FakeAuthRepository {
  new(this._never);

  final Completer<void> _never;

  @override
  Future<Never> restore() async {
    await _never.future;
    throw StateError('never reached');
  }
}
