import 'package:dio/dio.dart';

/// Retries a read that failed for a reason that is likely to pass: no connection, a timeout, or a gateway error.
///
/// Only `GET` and `HEAD` are retried. A call that changes something (accept, reject, ready, login, logout) is never
/// retried here: it may have reached the server, so the caller refetches the resource and shows its real state. A `429`
/// is never retried either, because the server asked the app to wait.
class RetryInterceptor extends Interceptor {
  /// Creates the interceptor for the client [dio].
  ///
  /// A read is retried at most [maxRetries] times, after [baseDelay], then twice as long, and so on. [sleep] replaces the
  /// waiting and exists for tests.
  new({
    required this.dio,
    this.maxRetries = 2,
    this.baseDelay = const Duration(milliseconds: 300),
    Future<void> Function(Duration delay)? sleep,
  }) : _sleep = sleep ?? Future<void>.delayed;

  static const String _attemptExtra = 'wasli.retries';
  static const Set<int> _retryStatuses = {502, 503, 504};
  static const Set<DioExceptionType> _retryTypes = {
    DioExceptionType.connectionTimeout,
    DioExceptionType.sendTimeout,
    DioExceptionType.receiveTimeout,
    DioExceptionType.connectionError,
  };

  /// The client whose failed reads are sent again.
  final Dio dio;

  /// How many times a read is sent again after its first failure.
  final int maxRetries;

  /// The wait before the first retry; each further retry waits twice as long.
  final Duration baseDelay;

  final Future<void> Function(Duration delay) _sleep;

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final options = err.requestOptions;
    final attempt = options.extra[_attemptExtra];
    final done = attempt is int ? attempt : 0;
    if (!_isRetryable(err) || done >= maxRetries) {
      handler.next(err);
      return;
    }
    await _sleep(baseDelay * (1 << done));
    options.extra[_attemptExtra] = done + 1;
    try {
      handler.resolve(await dio.fetch<dynamic>(options));
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }

  bool _isRetryable(DioException err) {
    final method = err.requestOptions.method.toUpperCase();
    if (method != 'GET' && method != 'HEAD') {
      return false;
    }
    if (err.type == DioExceptionType.badResponse) {
      return _retryStatuses.contains(err.response?.statusCode);
    }
    return _retryTypes.contains(err.type);
  }
}
