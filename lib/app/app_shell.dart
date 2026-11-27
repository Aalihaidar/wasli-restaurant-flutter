import 'package:material_ui/material_ui.dart';
import 'package:wasli_restaurant/core/l10n/l10n.dart';
import 'package:wasli_restaurant/theme/wasli_content_frame.dart';

/// The frame every page of the app sits in: the top bar with the app's name, and below it the page in the content
/// frame (the gutter of the window's size class, at most 1200 wide, centred on a wider window).
///
/// It has no navigation yet. The orders screen is the only destination, so the navigation arrives with the screens that
/// need it. The page decides its own layout inside the frame, by the window size class.
class AppShell extends StatelessWidget {
  /// Creates the shell around the current [child] page.
  const new({required this.child, super.key});

  /// The page of the current route.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.appTitle)),
      body: SafeArea(top: false, child: WasliContentFrame(child: child)),
    );
  }
}
