import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:wasli_restaurant/core/error/failure.dart';
import 'package:wasli_restaurant/core/l10n/app_locales.dart';
import 'package:wasli_restaurant/core/l10n/localization_delegates.dart';
import 'package:wasli_restaurant/features/app_config/application/app_config_provider.dart';
import 'package:wasli_restaurant/features/app_config/domain/app_config.dart';
import 'package:wasli_restaurant/features/app_config/presentation/startup_gate.dart';
import 'package:wasli_restaurant/features/app_config/presentation/startup_loading_view.dart';
import 'package:wasli_restaurant/theme/wasli_theme.dart';

const _config = AppConfig(pollInterval: Duration(seconds: 3));
const _waking = 'Waking up the server. This can take up to a minute.';

/// Shows the gate around a text, in [locale], with the settings loaded by [load] (called again on each retry).
Future<void> _pumpGate(WidgetTester tester, Future<AppConfig> Function() load, {Locale locale = AppLocales.english}) {
  final override = appConfigProvider.overrideWith((ref) => load());
  return tester.pumpWidget(
    ProviderScope(
      overrides: [override],
      child: MaterialApp(
        theme: lightTheme(locale),
        locale: locale,
        supportedLocales: AppLocales.supported,
        localizationsDelegates: appLocalizationsDelegates,
        home: const StartupGate(child: Text('the app')),
      ),
    ),
  );
}

void main() {
  testWidgets('shows a progress indicator, and the waking notice only after 3 seconds', (tester) async {
    final never = Completer<AppConfig>();
    await _pumpGate(tester, () => never.future);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text(_waking), findsNothing);
    expect(find.text('the app'), findsNothing);

    await tester.pump(wakingNoticeDelay - const Duration(milliseconds: 1));
    expect(find.text(_waking), findsNothing);

    await tester.pump(const Duration(milliseconds: 1));
    expect(find.text(_waking), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows the app once the settings have loaded', (tester) async {
    await _pumpGate(tester, () async => _config);
    await tester.pump();

    expect(find.text('the app'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('leaving the loading view before 3 seconds leaves no timer behind', (tester) async {
    final slow = Completer<AppConfig>();
    await _pumpGate(tester, () => slow.future);

    slow.complete(_config);
    await tester.pump();
    await tester.pump(const Duration(seconds: 5));

    expect(find.text('the app'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a failure shows its message, and Try again loads the settings again', (tester) async {
    var calls = 0;
    await _pumpGate(tester, () async {
      calls++;
      if (calls == 1) throw const NetworkFailure();
      return _config;
    });
    await tester.pump();

    expect(find.text("Can't reach the server. Check the connection and try again."), findsOneWidget);
    expect(find.text('the app'), findsNothing);

    await tester.tap(find.text('Try again'));
    await tester.pump();
    await tester.pump();

    expect(calls, 2);
    expect(find.text('the app'), findsOneWidget);
  });

  testWidgets('a server failure shows its request ID, never the server text', (tester) async {
    await _pumpGate(tester, () async => throw const ServerFailure(statusCode: 503, requestId: 'req-42'));
    await tester.pump();

    expect(find.text('The server had a problem. Try again in a moment.'), findsOneWidget);
    expect(find.text('Request ID'), findsOneWidget);
    expect(find.text('req-42'), findsOneWidget);
  });

  testWidgets('a failure without a request ID shows no ID line', (tester) async {
    await _pumpGate(tester, () async => throw const NetworkFailure());
    await tester.pump();

    expect(find.text('Request ID'), findsNothing);
  });

  testWidgets('in Arabic the failure screen reads right to left and keeps the ID left to right', (tester) async {
    await _pumpGate(
      tester,
      () async => throw const ServerFailure(statusCode: 500, requestId: 'req-7'),
      locale: AppLocales.arabic,
    );
    await tester.pump();

    expect(find.text('حدثت مشكلة في الخادم. حاول مرة أخرى بعد قليل.'), findsOneWidget);
    expect(find.text('حاول مرة أخرى'), findsOneWidget);
    expect(Directionality.of(tester.element(find.text('حاول مرة أخرى'))), TextDirection.rtl);
    expect(Directionality.of(tester.element(find.text('req-7'))), TextDirection.ltr);
  });

  testWidgets('in Arabic the waking notice is Arabic', (tester) async {
    final never = Completer<AppConfig>();
    await _pumpGate(tester, () => never.future, locale: AppLocales.arabic);

    await tester.pump(wakingNoticeDelay);

    expect(find.text('جارٍ تشغيل الخادم. قد يستغرق ذلك حتى دقيقة.'), findsOneWidget);
  });
}
