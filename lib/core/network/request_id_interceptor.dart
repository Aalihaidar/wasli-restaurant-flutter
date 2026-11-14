import 'package:dio/dio.dart';
import 'package:wasli_restaurant/core/network/dio_failure_mapper.dart';
import 'package:wasli_restaurant/core/network/request_id_recorder.dart';

/// Records the `X-Request-ID` of every response, successful or not, in a [RequestIdRecorder].
class RequestIdInterceptor extends Interceptor {
  /// Creates the interceptor that writes into [recorder].
  new(this.recorder);

  /// Where the latest ID is kept.
  final RequestIdRecorder recorder;

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    _record(response);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _record(err.response);
    handler.next(err);
  }

  void _record(Response<dynamic>? response) {
    final id = response?.headers.value(requestIdHeader);
    if (id != null && id.isNotEmpty) {
      recorder.last = id;
    }
  }
}
