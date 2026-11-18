/// Keeps the `X-Request-ID` of the latest response.
///
/// A generic error screen shows it, so a problem a restaurant reports can be found in the server logs. It holds no
/// personal data: the ID is a random value the server makes up per request.
class RequestIdRecorder {
  /// Creates an empty recorder.
  new();

  /// The ID of the latest response that carried one, or `null` before the first.
  String? last;
}
