import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wasli_restaurant/app/app.dart';
import 'package:wasli_restaurant/app/config_error_app.dart';

void main() {
  testWidgets('shows the placeholder page through the router', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: App()));

    expect(find.text('Wasli Restaurant'), findsWidgets);
    expect(find.text('This build is not configured correctly.'), findsNothing);
  });

  testWidgets('the configuration error screen shows the message', (tester) async {
    await tester.pumpWidget(const ConfigErrorApp(message: 'API_BASE_URL is not set.'));

    expect(find.textContaining('API_BASE_URL is not set.'), findsOneWidget);
  });
}
