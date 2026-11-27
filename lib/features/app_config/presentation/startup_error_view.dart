import 'package:material_ui/material_ui.dart';
import 'package:wasli_restaurant/core/error/failure.dart';
import 'package:wasli_restaurant/core/l10n/failure_message.dart';
import 'package:wasli_restaurant/core/l10n/l10n.dart';
import 'package:wasli_restaurant/theme/design_tokens.dart';
import 'package:wasli_restaurant/theme/wasli_theme.dart';

/// The start screen after the settings failed to load: a message for the kind of failure, the request ID when the server
/// sent one, and a button to try again.
class StartupErrorView extends StatelessWidget {
  /// Creates the view for [error]; [onRetry] runs when the button is pressed.
  const new({required this.error, required this.onRetry, super.key});

  /// What went wrong.
  final Object error;

  /// Tries to load the settings again.
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final requestId = error is Failure ? (error as Failure).requestId : null;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsetsDirectional.all(WasliSpacing.space5),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(failureMessage(l10n, error), textAlign: TextAlign.center, style: context.wasliText.heading3),
                if (requestId != null) ...[
                  const SizedBox(height: WasliSpacing.space3),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: WasliSpacing.space2,
                    children: [
                      Text(l10n.requestIdLabel, style: context.wasliText.caption),
                      // An ID is Latin letters and digits: it reads left to right inside Arabic text.
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: SelectableText(requestId, style: context.wasliText.caption),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: WasliSpacing.space5),
                FilledButton(onPressed: onRetry, child: Text(l10n.retry)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
