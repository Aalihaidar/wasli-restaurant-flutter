/// One entry of the `errors` list in the API's standard error body.
///
/// Only the machine-readable parts are kept. The server's `detail` text is written for developers and is never shown
/// to the user, so it is dropped at the door and cannot leak into the UI or a log by accident.
class ApiError {
  /// Creates an entry with a [code] and, for a field error, the [attr] it belongs to.
  const new(this.code, {this.attr});

  /// The error code, for example `permission_denied` or `blank`. The set is open: the server may add codes, so a
  /// caller branches on the ones it knows and treats the rest as a generic failure.
  final String code;

  /// The field the error is about, dotted when nested (`items.0.quantity`), or `null` when it is not about a field.
  final String? attr;

  @override
  String toString() => attr == null ? 'ApiError($code)' : 'ApiError($code, attr: $attr)';
}
