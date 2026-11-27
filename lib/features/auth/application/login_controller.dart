import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wasli_restaurant/features/auth/application/auth_providers.dart';

/// What the sign-in form shows: whether a sign-in is on its way, and why the last one failed.
class LoginState {
  /// Creates the state.
  const new({this.submitting = false, this.error});

  /// Whether a sign-in is being sent. The button is disabled meanwhile, so one tap sends one request.
  final bool submitting;

  /// What went wrong with the last attempt (a `Failure`), or `null`.
  final Object? error;
}

/// Sends the sign-in of the form and keeps its state. It lives while the sign-in screen is shown.
class LoginController extends Notifier<LoginState> {
  @override
  LoginState build() => const LoginState();

  /// Signs in. A second call while one is on its way does nothing. On success the session changes and the router leaves
  /// the sign-in screen; on a failure [LoginState.error] says why and the form stays as it is.
  Future<void> submit({required String username, required String password}) async {
    if (state.submitting) return;
    state = const LoginState(submitting: true);
    try {
      await ref.read(sessionProvider.notifier).signIn(username: username.trim(), password: password);
      if (ref.mounted) state = const LoginState();
    } on Object catch (error) {
      if (ref.mounted) state = LoginState(error: error);
    }
  }
}

/// The state of the sign-in form.
final NotifierProvider<LoginController, LoginState> loginControllerProvider =
    NotifierProvider.autoDispose<LoginController, LoginState>(LoginController.new, name: 'loginController');
