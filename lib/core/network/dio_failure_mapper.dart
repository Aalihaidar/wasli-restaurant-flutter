import 'package:dio/dio.dart';
import 'package:wasli_restaurant/core/error/failure.dart';
import 'package:wasli_restaurant/core/error/failure_mapper.dart';

/// Header the server sets on every response so a problem can be traced.
const String requestIdHeader = 'x-request-id';

/// Turns a failed Dio call into a [Failure].
///
/// A response from the server is mapped by its status (`failureFromResponse`); a call that got no usable response
/// (offline, dropped, timed out, refused certificate) is a [NetworkFailure].
Failure failureFromDioException(DioException exception) {
  final response = exception.response;
  if (exception.type == DioExceptionType.badResponse && response != null) {
    return failureFromResponse(
      statusCode: response.statusCode ?? 0,
      body: response.data,
      requestId: response.headers.value(requestIdHeader),
      retryAfter: response.headers.value('retry-after'),
    );
  }
  return const NetworkFailure();
}

/// Runs one API [request] and throws a [Failure] instead of a [DioException].
///
/// Repositories wrap every generated client call in it, so nothing above the data layer sees Dio. A call that was
/// cancelled on purpose is not a failure: its exception is passed on unchanged for the caller to ignore.
Future<T> guardRequest<T>(Future<T> Function() request) async {
  try {
    return await request();
  } on DioException catch (exception) {
    if (exception.type == DioExceptionType.cancel) {
      rethrow;
    }
    throw failureFromDioException(exception);
  }
}
