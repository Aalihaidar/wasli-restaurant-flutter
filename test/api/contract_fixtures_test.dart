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

    test('POST /auth/login (200)', () {
      final json = readApiFixture('auth_login_200');
      final token = StaffToken.fromJson(json);

      expect(token.token, isNotEmpty);
      expect(token.toJson(), json);
    });

    test('GET /staff/me (200)', () {
      final json = readApiFixture('staff_me_200');
      final me = StaffMe$Response.fromJson(json);

      expect(me.username, 'sara.cashier');
      expect(me.role.value, 'cashier');
      expect(me.permissions.map((permission) => permission.value), ['orders.view', 'orders.decide']);
      expect(me.mustChangePassword, isFalse);
      expect(me.restaurant.nameAr, 'مشويات تجريبية');
      expect(me.restaurant.logoUrl, isNull);
      expect(me.restaurant.serviceRadiusM, 500);
      expect(me.toJson(), json);
    });
  });
}
