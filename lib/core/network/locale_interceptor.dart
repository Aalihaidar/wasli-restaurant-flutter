import 'package:dio/dio.dart';

/// Sends the language of the app (`en` or `ar`) as `Accept-Language`, so the server answers in it.
class LocaleInterceptor extends Interceptor {
  /// Creates the interceptor; [readLanguageCode] returns the language the app shows right now.
  new(this.readLanguageCode);

  /// Returns the language code the app shows right now.
  final String Function() readLanguageCode;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Accept-Language'] = readLanguageCode();
    handler.next(options);
  }
}
