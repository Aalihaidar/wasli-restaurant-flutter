import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Counts the times the server refused the signed-in token (`401`), so the session of the app can end.
///
/// The network layer raises it and knows nothing of who listens: the sign-in feature listens and returns to the login
/// screen. The value only changes, its number means nothing.
class SessionExpiry extends Notifier<int> {
  @override
  int build() => 0;

  /// Tells the listeners that the token was refused.
  void signal() => state++;
}

/// The signal that the server no longer accepts the stored token.
final sessionExpiryProvider = NotifierProvider<SessionExpiry, int>(SessionExpiry.new, name: 'sessionExpiry');
