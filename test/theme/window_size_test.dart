import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:wasli_restaurant/theme/design_tokens.dart';
import 'package:wasli_restaurant/theme/wasli_content_frame.dart';
import 'package:wasli_restaurant/theme/window_size.dart';

/// Shows a frame around a box that fills the width it is given, in a window of [width] and in [direction].
Future<Rect> _boxRect(WidgetTester tester, double width, TextDirection direction) async {
  tester.view
    ..physicalSize = Size(width, 800)
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MediaQuery.fromView(
      view: tester.view,
      child: Directionality(
        textDirection: direction,
        child: const WasliContentFrame(
          child: SizedBox(key: Key('box'), height: 10, width: double.infinity),
        ),
      ),
    ),
  );
  return tester.getRect(find.byKey(const Key('box')));
}

void main() {
  group('WindowSize.fromWidth', () {
    final table = <(double, WindowSize)>[
      (320, WindowSize.compact),
      (599.9, WindowSize.compact),
      (600, WindowSize.medium),
      (839.9, WindowSize.medium),
      (840, WindowSize.expanded),
      (1920, WindowSize.expanded),
    ];
    for (final (width, expected) in table) {
      test('$width is ${expected.name}', () => expect(WindowSize.fromWidth(width), expected));
    }
  });

  test('the gutter is 16 on a compact window and 24 on the others', () {
    expect(WindowSize.compact.gutter, 16);
    expect(WindowSize.medium.gutter, 24);
    expect(WindowSize.expanded.gutter, 24);
  });

  test('a list and its detail go side by side from the medium class', () {
    expect(WindowSize.compact.isTwoPane, isFalse);
    expect(WindowSize.medium.isTwoPane, isTrue);
    expect(WindowSize.expanded.isTwoPane, isTrue);
  });

  for (final direction in TextDirection.values) {
    group('WasliContentFrame in ${direction.name}', () {
      testWidgets('keeps a 16 gutter on a 400 wide window', (tester) async {
        final box = await _boxRect(tester, 400, direction);
        expect(box.left, 16);
        expect(box.right, 384);
      });

      testWidgets('keeps a 24 gutter on a 1000 wide window', (tester) async {
        final box = await _boxRect(tester, 1000, direction);
        expect(box.left, 24);
        expect(box.right, 976);
      });

      testWidgets('is 1200 wide and centred on a 1600 wide window', (tester) async {
        final box = await _boxRect(tester, 1600, direction);
        expect(box.width, WasliLayout.contentMaxWidth);
        expect(box.left, 200);
        expect(box.right, 1400);
      });
    });
  }
}
