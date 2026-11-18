import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

/// What the fake server does for one request: answer it, or throw a [DioException].
typedef FakeResponder = Future<ResponseBody> Function(RequestOptions options);

/// A JSON answer with [status] and optional [headers].
FakeResponder jsonResponder(Object body, {int status = 200, Map<String, String> headers = const {}}) {
  return (options) async => ResponseBody.fromString(
    jsonEncode(body),
    status,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
      for (final entry in headers.entries) entry.key: [entry.value],
    },
  );
}

/// A plain-text answer, for example a proxy's error page.
FakeResponder textResponder(String body, {required int status}) {
  return (options) async => ResponseBody.fromString(
    body,
    status,
    headers: {
      Headers.contentTypeHeader: ['text/html'],
    },
  );
}

/// A call that never got a response.
FakeResponder failingResponder(DioExceptionType type) {
  return (options) async => throw DioException(requestOptions: options, type: type);
}

/// A [HttpClientAdapter] for tests: it answers the requests one after the other from a script and remembers them.
///
/// Tests never reach a real server. The last responder is used again when the script runs out.
class FakeHttpAdapter implements HttpClientAdapter {
  /// Creates the adapter with its [script].
  new(List<FakeResponder> script) : _script = List.of(script);

  final List<FakeResponder> _script;
  int _next = 0;

  /// The requests received so far, oldest first.
  final List<RequestOptions> requests = [];

  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<Uint8List>? requestStream, Future<void>? cancelFuture) {
    requests.add(options);
    final index = _next < _script.length ? _next : _script.length - 1;
    _next++;
    return _script[index](options);
  }

  @override
  void close({bool force = false}) {}
}
