import 'package:material_ui/material_ui.dart';
import 'package:wasli_restaurant/theme/design_tokens.dart';
import 'package:wasli_restaurant/theme/window_size.dart';

/// Puts [child] in the page column: the gutter of the window's size class on both sides, and at most
/// [WasliLayout.contentMaxWidth] wide, centred when the window is wider.
class WasliContentFrame extends StatelessWidget {
  /// Creates the frame around [child].
  const new({required this.child, super.key});

  /// The page content.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final gutter = context.windowSize.gutter;
    return Padding(
      padding: EdgeInsetsDirectional.only(start: gutter, end: gutter),
      child: Align(
        alignment: AlignmentDirectional.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: WasliLayout.contentMaxWidth),
          child: child,
        ),
      ),
    );
  }
}
