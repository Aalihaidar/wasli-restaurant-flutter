import 'package:wasli_restaurant/core/error/api_error.dart';

/// Why a request did not give the app what it asked for.
///
/// A repository returns data or throws one of these; the UI maps each case to a localized message with an exhaustive
/// `switch` and never shows server text. The HTTP status decides the case; the [errors] only refine it. An
/// unknown code is not a problem in itself, it just means the generic message of the case is shown.
sealed class Failure {
  const new({this.errors = const [], this.requestId});

  /// The entries of the server's error body, empty when the body was missing or not the standard shape.
  final List<ApiError> errors;

  /// The `X-Request-ID` of the response, shown on a generic error screen so a problem can be traced. `null` when the
  /// request never got a response.
  final String? requestId;

  /// Whether the server reported [code] among its errors.
  bool hasCode(String code) => errors.any((error) => error.code == code);

  @override
  String toString() => 'Failure(${errors.map((error) => error.code).join(', ')})';
}

/// No usable response: the device is offline, the connection dropped or the request timed out.
final class NetworkFailure extends Failure {
  /// Creates the failure.
  const new();
}

/// `400`/`422`: the server refused the input. [errors] carry a code and the field of each problem.
final class ValidationFailure extends Failure {
  /// Creates the failure.
  const new({super.errors, super.requestId});
}

/// `401`: no valid session. The app clears it and returns to the login screen.
final class UnauthenticatedFailure extends Failure {
  /// Creates the failure.
  const new({super.errors, super.requestId});
}

/// `403`: the signed-in role may not do this. The server is the authority on permissions.
final class PermissionDeniedFailure extends Failure {
  /// Creates the failure.
  const new({super.errors, super.requestId});
}

/// `404`: the resource does not exist, or belongs to another restaurant (the server answers the same for both).
final class NotFoundFailure extends Failure {
  /// Creates the failure.
  const new({super.errors, super.requestId});
}

/// `409`: the resource is no longer in the state the request assumed, for example an order that was already decided.
/// The caller refetches the resource and shows its real state.
final class ConflictFailure extends Failure {
  /// Creates the failure.
  const new({super.errors, super.requestId});
}

/// `429`: too many requests. The caller waits [retryAfter] (when the server said how long) before it tries again and
/// never retries at once.
final class ThrottledFailure extends Failure {
  /// Creates the failure.
  const new({this.retryAfter, super.errors, super.requestId});

  /// The wait the server asked for in `Retry-After`, or `null` when it sent none or one that cannot be read.
  final Duration? retryAfter;
}

/// `5xx`: the server failed. Reads may be retried with a back-off; a state-changing call is not.
final class ServerFailure extends Failure {
  /// Creates the failure.
  const new({required this.statusCode, super.errors, super.requestId});

  /// The HTTP status, in the `500` range.
  final int statusCode;
}

/// Any other status, or a status the app does not know what to do with.
final class UnknownFailure extends Failure {
  /// Creates the failure.
  const new({required this.statusCode, super.errors, super.requestId});

  /// The HTTP status.
  final int statusCode;
}
