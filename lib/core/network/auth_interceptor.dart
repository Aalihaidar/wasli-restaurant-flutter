import 'package:dio/dio.dart';

/// Paths that are called without a token: the public config and the login itself.
const Set<String> publicPaths = {'/api/v1/config', '/api/v1/auth/login'};

/// Adds `Authorization: Token <token>` to every call except the public ones, and reports a `401` once.
///
/// It only knows how to read the token and whom to tell; storing it is the token store's job. A `401` on an
/// authenticated call means the session is gone: `onUnauthenticated` is called so the app clears it and returns to the
/// login screen. It is called only when the token the call used is still the current one, so several calls that fail
/// together, or a call that fails after the session was already cleared or replaced, cannot loop.
class AuthInterceptor extends Interceptor {
  /// Creates the interceptor.
  new({required this.readToken, required this.onUnauthenticated, this.paths = publicPaths});

  static const String _tokenExtra = 'wasli.token';

  /// Returns the current token, or `null` when nobody is signed in.
  final Future<String?> Function() readToken;

  /// Called when an authenticated call is refused with a `401`.
  final void Function() onUnauthenticated;

  /// The paths that never get a token.
  final Set<String> paths;

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers.remove('Authorization');
    if (!paths.contains(_pathOf(options))) {
      final token = await readToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Token $token';
        options.extra[_tokenExtra] = token;
      }
    }
    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final usedToken = err.requestOptions.extra[_tokenExtra];
    if (err.response?.statusCode == 401 && usedToken is String && usedToken == await readToken()) {
      onUnauthenticated();
    }
    handler.next(err);
  }

  String _pathOf(RequestOptions options) => Uri.parse(options.path).path;
}
