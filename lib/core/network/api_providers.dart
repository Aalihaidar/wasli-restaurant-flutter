import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wasli_restaurant/core/config/app_environment_provider.dart';
import 'package:wasli_restaurant/core/l10n/locale_controller.dart';
import 'package:wasli_restaurant/core/logging/logging_providers.dart';
import 'package:wasli_restaurant/core/network/auth_interceptor.dart';
import 'package:wasli_restaurant/core/network/dio_factory.dart';
import 'package:wasli_restaurant/core/network/locale_interceptor.dart';
import 'package:wasli_restaurant/core/network/redacted_log_interceptor.dart';
import 'package:wasli_restaurant/core/network/request_id_interceptor.dart';
import 'package:wasli_restaurant/core/network/request_id_recorder.dart';
import 'package:wasli_restaurant/core/network/retry_interceptor.dart';
import 'package:wasli_restaurant/core/storage/token_store_provider.dart';

/// The `X-Request-ID` of the latest response, for a generic error screen.
final requestIdRecorderProvider = Provider<RequestIdRecorder>((ref) => RequestIdRecorder(), name: 'requestIdRecorder');

/// The one [Dio] client of this run, which the data layer of each feature builds the generated API client on, with its interceptors in this order: language, token, request ID, redacted log,
/// retry of reads.
///
/// The language and the token are read when a call is made, so this provider is not rebuilt when either changes. A `401`
/// on an authenticated call clears the stored token; the login feature will also reset its own session state and send
/// the user to the login screen.
final dioProvider = Provider<Dio>((ref) {
  final tokenStore = ref.watch(tokenStoreProvider);
  final logger = ref.watch(loggerProvider);
  final dio = createDio(
    baseUrl: ref.watch(appEnvironmentProvider).apiBaseUrl,
    interceptors: [
      LocaleInterceptor(() => ref.read(localeProvider).languageCode),
      AuthInterceptor(readToken: tokenStore.read, onUnauthenticated: () => unawaited(tokenStore.clear())),
      RequestIdInterceptor(ref.watch(requestIdRecorderProvider)),
      RedactedLogInterceptor(logger.debug),
    ],
  );
  dio.interceptors.add(RetryInterceptor(dio: dio));
  ref.onDispose(dio.close);
  return dio;
}, name: 'dio');
