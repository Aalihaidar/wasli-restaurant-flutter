import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wasli_restaurant/app/app.dart';
import 'package:wasli_restaurant/app/config_error_app.dart';

import '../support/app_config_overrides.dart';
import '../support/session_overrides.dart';

void main() {
  testWidgets('shows the placeholder page through the router', (tester) async {
    await tester.pumpWidget(ProviderScope(overrides: [appConfigLoaded, signedIn], child: const App()));
    await tester.pump();

    expect(find.text('Wasli Restaurant'), findsWidgets);
    expect(find.text('This build is not configured correctly.'), findsNothing);
  });

  testWidgets('the configuration error screen shows the message', (tester) async {
    await tester.pumpWidget(const ConfigErrorApp(message: 'API_BASE_URL is not set.'));

    expect(find.textContaining('API_BASE_URL is not set.'), findsOneWidget);
  });
}
