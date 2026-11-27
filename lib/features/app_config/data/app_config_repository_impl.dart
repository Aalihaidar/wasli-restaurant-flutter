import 'package:dio/dio.dart' show Dio;
import 'package:wasli_restaurant/api/api.dart';
import 'package:wasli_restaurant/core/network/dio_failure_mapper.dart';
import 'package:wasli_restaurant/features/app_config/data/app_config_mapper.dart';
import 'package:wasli_restaurant/features/app_config/domain/app_config.dart';
import 'package:wasli_restaurant/features/app_config/domain/app_config_repository.dart';

/// Reads the settings from the public `GET /config`, which is called without a token.
class AppConfigRepositoryImpl implements AppConfigRepository {
  /// Creates the repository on the generated config client.
  const new(this._client);

  /// Creates the repository on the app's [dio] client.
  new fromDio(Dio dio) : this(Api(dio).config);

  final ConfigClient _client;

  @override
  Future<AppConfig> load() async => appConfigFromDto(await guardRequest(_client.configRetrieve));
}
