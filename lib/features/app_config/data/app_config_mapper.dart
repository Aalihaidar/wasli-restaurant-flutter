import 'package:wasli_restaurant/api/api.dart';
import 'package:wasli_restaurant/features/app_config/domain/app_config.dart';

/// The smallest poll interval the app accepts: a `0` or a negative value from the server would make the orders screen
/// ask without pausing.
const int minPollIntervalSeconds = 1;

/// Turns the `GET /config` answer into the settings this app uses.
AppConfig appConfigFromDto(Config dto) {
  final seconds = dto.pollIntervalSeconds < minPollIntervalSeconds ? minPollIntervalSeconds : dto.pollIntervalSeconds;
  return AppConfig(pollInterval: Duration(seconds: seconds));
}
