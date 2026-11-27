import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:wasli_restaurant/core/l10n/l10n.dart';
import 'package:wasli_restaurant/features/auth/application/login_controller.dart';
import 'package:wasli_restaurant/features/auth/presentation/login_error_message.dart';
import 'package:wasli_restaurant/theme/button_styles.dart';
import 'package:wasli_restaurant/theme/design_tokens.dart';

/// The username and password fields with the sign-in button and the reason a sign-in failed.
///
/// The browser and the device are asked not to fill, remember or suggest anything: a shared laptop or tablet is the
/// normal case. The checks here only spare a round trip; the server decides.
class LoginForm extends ConsumerStatefulWidget {
  /// Creates the form.
  const new({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    unawaited(ref.read(loginControllerProvider.notifier).submit(username: _username.text, password: _password.text));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = ref.watch(loginControllerProvider);
    String? required(String? value) => (value ?? '').trim().isEmpty ? l10n.loginFieldRequired : null;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _username,
            decoration: InputDecoration(labelText: l10n.loginUsername),
            autofillHints: const [],
            autocorrect: false,
            enableSuggestions: false,
            textInputAction: TextInputAction.next,
            validator: required,
          ),
          const SizedBox(height: WasliSpacing.space4),
          TextFormField(
            controller: _password,
            decoration: InputDecoration(labelText: l10n.loginPassword),
            autofillHints: const [],
            autocorrect: false,
            enableSuggestions: false,
            obscureText: true,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => state.submitting ? null : _submit(),
            validator: (value) => (value ?? '').isEmpty ? l10n.loginFieldRequired : null,
          ),
          if (state.error != null) ...[
            const SizedBox(height: WasliSpacing.space4),
            Semantics(
              liveRegion: true,
              child: Text(
                loginErrorMessage(l10n, state.error!),
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ],
          const SizedBox(height: WasliSpacing.space5),
          FilledButton(
            style: WasliButtonStyles.large,
            onPressed: state.submitting ? null : _submit,
            child: state.submitting
                ? SizedBox.square(
                    dimension: WasliSpacing.space5,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Theme.of(context).colorScheme.onPrimary,
                      semanticsLabel: l10n.loginSigningIn,
                    ),
                  )
                : Text(l10n.loginSubmit),
          ),
        ],
      ),
    );
  }
}
