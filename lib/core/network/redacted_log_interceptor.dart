import 'package:dio/dio.dart';

/// Logs one line per call that holds nothing private: the method, the path, the status and the time it took.
///
/// It never writes headers (the token), bodies (a customer's plate, location and notes) or the query string (the
/// nearby search carries a position). A failure that got no response is logged by its kind only, because the message
/// of a Dio exception can repeat the full URL.
class RedactedLogInterceptor extends Interceptor {
  /// Creates the interceptor; each line goes to [log].
  new(this.log);

  static const String _startExtra = 'wasli.started';

  /// Receives each log line.
  final void Function(String line) log;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra[_startExtra] = DateTime.now().millisecondsSinceEpoch;
    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    log('${_describe(response.requestOptions)} ${response.statusCode}${_elapsed(response.requestOptions)}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final status = err.response?.statusCode;
    final outcome = status == null ? err.type.name : '$status';
    log('${_describe(err.requestOptions)} $outcome${_elapsed(err.requestOptions)}');
    handler.next(err);
  }

  String _describe(RequestOptions options) => '${options.method} ${Uri.parse(options.path).path}';

  String _elapsed(RequestOptions options) {
    final started = options.extra[_startExtra];
    if (started is! int) {
      return '';
    }
    return ' (${DateTime.now().millisecondsSinceEpoch - started} ms)';
  }
}
