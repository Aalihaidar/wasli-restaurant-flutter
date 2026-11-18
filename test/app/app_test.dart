import 'package:flutter_test/flutter_test.dart';
import 'package:wasli_restaurant/app/app.dart';

void main() {
  testWidgets('shows the placeholder page', (tester) async {
    await tester.pumpWidget(const App());

    expect(find.text('Wasli Restaurant'), findsOneWidget);
  });
}
