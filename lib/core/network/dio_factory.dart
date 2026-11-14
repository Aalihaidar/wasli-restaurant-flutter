import 'package:dio/dio.dart';

/// How long the app waits to open a connection.
const Duration connectTimeout = Duration(seconds: 10);

/// How long the app waits while sending a request. Request bodies here are small.
const Duration sendTimeout = Duration(seconds: 15);

/// How long the app waits for the response once the request is sent. Every request has a timeout, so a hung connection
/// ends as a network failure instead of a screen that waits for ever.
const Duration receiveTimeout = Duration(seconds: 20);

/// Builds the one [Dio] client the generated API client runs on.
///
/// [baseUrl] is joined with the path of each generated call, which already starts with `/api/v1`, so it is the server
/// address without a path. [interceptors] are added in the given order: each concern (auth, locale, request ID, retry,
/// logging) is its own interceptor, and the caller composes them. [adapter] replaces the HTTP adapter and exists for
/// tests, which never reach a real server.
Dio createDio({required Uri baseUrl, Iterable<Interceptor> interceptors = const [], HttpClientAdapter? adapter}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl.toString(),
      connectTimeout: connectTimeout,
      sendTimeout: sendTimeout,
      receiveTimeout: receiveTimeout,
      headers: {Headers.acceptHeader: Headers.jsonContentType},
    ),
  )..interceptors.addAll(interceptors);
  if (adapter != null) {
    dio.httpClientAdapter = adapter;
  }
  return dio;
}
