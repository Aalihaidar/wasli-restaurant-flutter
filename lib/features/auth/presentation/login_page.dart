import 'package:material_ui/material_ui.dart';
import 'package:wasli_restaurant/core/l10n/l10n.dart';
import 'package:wasli_restaurant/features/auth/presentation/login_form.dart';
import 'package:wasli_restaurant/theme/design_tokens.dart';
import 'package:wasli_restaurant/theme/wasli_theme.dart';

/// The staff sign-in screen: a heading and the form, in a column that is at most 420 wide.
class LoginPage extends StatelessWidget {
  /// Creates the page.
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsetsDirectional.symmetric(vertical: WasliSpacing.space6),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(context.l10n.loginTitle, style: context.wasliText.heading2),
              const SizedBox(height: WasliSpacing.space5),
              const LoginForm(),
            ],
          ),
        ),
      ),
    );
  }
}
