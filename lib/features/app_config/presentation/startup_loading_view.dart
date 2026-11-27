import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:wasli_restaurant/core/l10n/l10n.dart';
import 'package:wasli_restaurant/theme/design_tokens.dart';
import 'package:wasli_restaurant/theme/wasli_theme.dart';

/// How long the app waits for the server before it says that the server is waking up.
const Duration wakingNoticeDelay = Duration(seconds: 3);

/// The start screen while the settings load: a progress indicator, and after [wakingNoticeDelay] a notice that the
/// server may need up to a minute (a free server sleeps when nobody uses it).
class StartupLoadingView extends StatefulWidget {
  /// Creates the view.
  const new({super.key});

  @override
  State<StartupLoadingView> createState() => _StartupLoadingViewState();
}

class _StartupLoadingViewState extends State<StartupLoadingView> {
  Timer? _timer;
  bool _waking = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer(wakingNoticeDelay, () => setState(() => _waking = true));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsetsDirectional.all(WasliSpacing.space5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(semanticsLabel: context.l10n.startupLoading),
              if (_waking) ...[
                const SizedBox(height: WasliSpacing.space5),
                Text(context.l10n.startupWakingServer, textAlign: TextAlign.center, style: context.wasliText.body),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
