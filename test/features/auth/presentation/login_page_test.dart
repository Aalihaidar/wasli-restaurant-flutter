import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:wasli_restaurant/core/error/failure.dart';
import 'package:wasli_restaurant/core/l10n/app_locales.dart';
import 'package:wasli_restaurant/core/l10n/localization_delegates.dart';
import 'package:wasli_restaurant/features/auth/application/auth_providers.dart';
import 'package:wasli_restaurant/features/auth/presentation/login_page.dart';
import 'package:wasli_restaurant/theme/wasli_theme.dart';

import '../../../support/fake_auth_repository.dart';

Future<void> _pump(WidgetTester tester, FakeAuthRepository repository, {Locale locale = AppLocales.english}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [authRepositoryProvider.overrideWithValue(repository)],
      child: MaterialApp(
        theme: lightTheme(locale),
        locale: locale,
        supportedLocales: AppLocales.supported,
        localizationsDelegates: appLocalizationsDelegates,
        home: const Scaffold(body: LoginPage()),
      ),
    ),
  );
  await tester.pump();
}

Finder get _username => find.widgetWithText(TextFormField, 'Username');
Finder get _password => find.widgetWithText(TextFormField, 'Password');
Finder get _submit => find.widgetWithText(FilledButton, 'Sign in');

void main() {
  testWidgets('shows the heading, the two fields and the button', (tester) async {
    await _pump(tester, FakeAuthRepository());

    expect(find.text('Staff sign in'), findsOneWidget);
    expect(_username, findsOneWidget);
    expect(_password, findsOneWidget);
    expect(_submit, findsOneWidget);
  });

  testWidgets('asks the device not to fill, remember or suggest, and hides the password', (tester) async {
    await _pump(tester, FakeAuthRepository());

    final username = tester.widget<TextField>(find.descendant(of: _username, matching: find.byType(TextField)));
    final password = tester.widget<TextField>(find.descendant(of: _password, matching: find.byType(TextField)));
    for (final field in [username, password]) {
      expect(field.autofillHints, isEmpty);
      expect(field.autocorrect, isFalse);
      expect(field.enableSuggestions, isFalse);
    }
    expect(username.obscureText, isFalse);
    expect(password.obscureText, isTrue);
  });

  testWidgets('empty fields show what is missing and send nothing', (tester) async {
    final repository = FakeAuthRepository();
    await _pump(tester, repository);

    await tester.tap(_submit);
    await tester.pump();

    expect(find.text('This field is required.'), findsNWidgets(2));
    expect(repository.signIns, isEmpty);
  });

  testWidgets('a username of spaces counts as empty', (tester) async {
    final repository = FakeAuthRepository();
    await _pump(tester, repository);

    await tester.enterText(_username, '   ');
    await tester.enterText(_password, 'pw-1');
    await tester.tap(_submit);
    await tester.pump();

    expect(find.text('This field is required.'), findsOneWidget);
    expect(repository.signIns, isEmpty);
  });

  testWidgets('sends the username without surrounding spaces and the password as typed', (tester) async {
    final repository = FakeAuthRepository();
    await _pump(tester, repository);

    await tester.enterText(_username, '  sara.cashier ');
    await tester.enterText(_password, ' pw 1 ');
    await tester.tap(_submit);
    await tester.pump();

    expect(repository.signIns, [('sara.cashier', ' pw 1 ')]);
  });

  testWidgets('the keyboard action on the password field signs in too', (tester) async {
    final repository = FakeAuthRepository();
    await _pump(tester, repository);

    await tester.enterText(_username, 'sara.cashier');
    await tester.enterText(_password, 'pw-1');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    expect(repository.signIns, hasLength(1));
  });

  testWidgets('while a sign-in is on its way the button is disabled, shows progress, and one tap sends one request', (
    tester,
  ) async {
    final hold = Completer<void>();
    final repository = FakeAuthRepository()..signInHold = hold;
    await _pump(tester, repository);
    await tester.enterText(_username, 'sara.cashier');
    await tester.enterText(_password, 'pw-1');

    await tester.tap(_submit);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(tester.widget<FilledButton>(find.byType(FilledButton)).onPressed, isNull);
    await tester.tap(find.byType(FilledButton), warnIfMissed: false);
    await tester.pump();
    expect(repository.signIns, hasLength(1));

    hold.complete();
    await tester.pumpAndSettle();
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('a wrong username or password says so, and the button works again', (tester) async {
    final repository = FakeAuthRepository()..signInError = const UnauthenticatedFailure();
    await _pump(tester, repository);
    await tester.enterText(_username, 'sara.cashier');
    await tester.enterText(_password, 'wrong');

    await tester.tap(_submit);
    await tester.pumpAndSettle();

    expect(find.text('Wrong username or password.'), findsOneWidget);
    expect(tester.widget<FilledButton>(find.byType(FilledButton)).onPressed, isNotNull);
  });

  for (final (failure, message) in <(Failure, String)>[
    (const PermissionDeniedFailure(), 'This account is not linked to a restaurant.'),
    (const NetworkFailure(), "Can't reach the server. Check the connection and try again."),
    (const ThrottledFailure(), 'Too many requests. Wait a moment and try again.'),
    (const ServerFailure(statusCode: 500), 'The server had a problem. Try again in a moment.'),
  ]) {
    testWidgets('a ${failure.runtimeType} shows its own message', (tester) async {
      final repository = FakeAuthRepository()..signInError = failure;
      await _pump(tester, repository);
      await tester.enterText(_username, 'sara.cashier');
      await tester.enterText(_password, 'pw-1');

      await tester.tap(_submit);
      await tester.pumpAndSettle();

      expect(find.text(message), findsOneWidget);
    });
  }

  testWidgets('a failure nobody expected shows the generic message and does not leave the form stuck', (tester) async {
    final repository = FakeAuthRepository()..signInError = StateError('boom');
    await _pump(tester, repository);
    await tester.enterText(_username, 'sara.cashier');
    await tester.enterText(_password, 'pw-1');

    await tester.tap(_submit);
    await tester.pumpAndSettle();

    expect(find.text('Something went wrong. Try again.'), findsOneWidget);
    expect(tester.widget<FilledButton>(find.byType(FilledButton)).onPressed, isNotNull);
  });

  testWidgets('in Arabic the labels are Arabic and the layout runs right to left', (tester) async {
    await _pump(tester, FakeAuthRepository(), locale: AppLocales.arabic);

    expect(find.text('دخول الموظفين'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'اسم المستخدم'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'كلمة المرور'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'تسجيل الدخول'), findsOneWidget);
    expect(Directionality.of(tester.element(find.byType(LoginPage))), TextDirection.rtl);
  });
}
