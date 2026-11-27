import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wasli_restaurant/core/network/api_providers.dart';
import 'package:wasli_restaurant/features/app_config/data/app_config_repository_impl.dart';
import 'package:wasli_restaurant/features/app_config/domain/app_config.dart';
import 'package:wasli_restaurant/features/app_config/domain/app_config_repository.dart';

/// The repository that reads the server settings.
final appConfigRepositoryProvider = Provider<AppConfigRepository>(
  (ref) => AppConfigRepositoryImpl.fromDio(ref.watch(dioProvider)),
  name: 'appConfigRepository',
);

/// The server settings, read once when the app starts and kept for the whole run.
///
/// A failure is not retried by the provider: reads already retry once or twice in the network layer, and the start
/// screen offers a button to try again (`ref.invalidate`).
final appConfigProvider = FutureProvider<AppConfig>(
  (ref) => ref.watch(appConfigRepositoryProvider).load(),
  retry: (retryCount, error) => null,
  name: 'appConfig',
);
