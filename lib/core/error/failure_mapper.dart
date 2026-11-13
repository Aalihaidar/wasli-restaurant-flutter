import 'package:wasli_restaurant/core/error/error_body_parser.dart';
import 'package:wasli_restaurant/core/error/failure.dart';

/// Turns an error response into a [Failure].
///
/// The HTTP [statusCode] picks the case; the [body] only adds the error entries. That is why an unknown error code, or
/// a body that is not JSON, still gives the right case for its status. [requestId] is the `X-Request-ID` header and
/// [retryAfter] the `Retry-After` header, both as sent (or `null`).
Failure failureFromResponse({required int statusCode, Object? body, String? requestId, String? retryAfter}) {
  final errors = parseApiErrors(body);
  return switch (statusCode) {
    400 || 422 => ValidationFailure(errors: errors, requestId: requestId),
    401 => UnauthenticatedFailure(errors: errors, requestId: requestId),
    403 => PermissionDeniedFailure(errors: errors, requestId: requestId),
    404 => NotFoundFailure(errors: errors, requestId: requestId),
    409 => ConflictFailure(errors: errors, requestId: requestId),
    429 => ThrottledFailure(retryAfter: _parseRetryAfter(retryAfter), errors: errors, requestId: requestId),
    >= 500 && < 600 => ServerFailure(statusCode: statusCode, errors: errors, requestId: requestId),
    _ => UnknownFailure(statusCode: statusCode, errors: errors, requestId: requestId),
  };
}

/// Reads `Retry-After` as a whole number of seconds. The HTTP-date form, a negative number or text gives `null`.
Duration? _parseRetryAfter(String? value) {
  final seconds = int.tryParse(value?.trim() ?? '');
  return seconds == null || seconds < 0 ? null : Duration(seconds: seconds);
}
