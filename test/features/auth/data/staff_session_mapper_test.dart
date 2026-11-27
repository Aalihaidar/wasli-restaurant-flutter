import 'package:flutter_test/flutter_test.dart';
import 'package:wasli_restaurant/api/api.dart';
import 'package:wasli_restaurant/features/auth/data/staff_session_mapper.dart';
import 'package:wasli_restaurant/features/auth/domain/staff_permission.dart';
import 'package:wasli_restaurant/features/auth/domain/staff_role.dart';

import '../../../support/api_fixtures.dart';

void main() {
  group('staffSessionFromDto', () {
    test('maps the member, the role, the permissions and the restaurant', () {
      final session = staffSessionFromDto(StaffMe$Response.fromJson(readApiFixture('staff_me_200')));

      expect(session.id, '6f1d2c1e-3b4a-4c55-9d0e-1a2b3c4d5e6f');
      expect(session.username, 'sara.cashier');
      expect(session.fullName, 'Sara Tester');
      expect(session.role, StaffRole.cashier);
      expect(session.permissions, {StaffPermission.ordersView, StaffPermission.ordersDecide});
      expect(session.mustChangePassword, isFalse);
      expect(session.restaurant.slug, 'demo-grill');
      expect(session.restaurant.nameEn, 'Demo Grill');
      expect(session.restaurant.nameAr, 'مشويات تجريبية');
      expect(session.restaurant.logoUrl, isNull);
      expect(session.restaurant.latitude, 25.2048);
      expect(session.restaurant.longitude, 55.2708);
      expect(session.restaurant.serviceRadiusMeters, 500);
      expect(session.restaurant.currency, 'AED');
    });

    test('a restaurant with no service limit has none, and a whole-number position is read as a double', () {
      final json = readApiFixture('staff_me_200');
      final restaurant = Map<String, Object?>.of(json['restaurant']! as Map<String, Object?>)
        ..remove('service_radius_m')
        ..['latitude'] = 25;

      final session = staffSessionFromDto(StaffMe$Response.fromJson({...json, 'restaurant': restaurant}));

      expect(session.restaurant.serviceRadiusMeters, isNull);
      expect(session.restaurant.latitude, 25.0);
    });

    test('a role and a permission the app does not know become unknown', () {
      final json = {
        ...readApiFixture('staff_me_200'),
        'role': 'chef',
        'permissions': ['orders.view', 'orders.print'],
      };

      final session = staffSessionFromDto(StaffMe$Response.fromJson(json));

      expect(session.role, StaffRole.unknown);
      expect(session.permissions, {StaffPermission.ordersView, StaffPermission.unknown});
    });
  });
}
