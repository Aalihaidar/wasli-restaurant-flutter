import 'package:flutter_test/flutter_test.dart';
import 'package:wasli_restaurant/api/api.dart';

import '../support/api_fixtures.dart';

/// Every success fixture must parse with the generated client and serialise back to the same JSON, so a contract
/// change that the fixtures do not follow fails here.
void main() {
  group('generated models read the contract fixtures', () {
    test('GET /config', () {
      final json = readApiFixture('config_200');
      final config = Config.fromJson(json);

      expect(config.locationCheck, LocationCheckEnum.warn);
      expect(config.requireScreenOnline, isTrue);
      expect(config.aiEnabled, isTrue);
      expect(config.languages, [LanguagesEnum.en, LanguagesEnum.ar]);
      expect(config.pollIntervalSeconds, 3);
      expect(config.toJson(), json);
    });
  });
}
