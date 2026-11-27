import 'package:flutter_test/flutter_test.dart';
import 'package:wasli_restaurant/features/auth/domain/staff_permission.dart';
import 'package:wasli_restaurant/features/auth/domain/staff_role.dart';

import '../../../support/fake_auth_repository.dart';

void main() {
  group('StaffRole.fromCode', () {
    for (final (code, expected) in [
      ('admin', StaffRole.admin),
      ('cashier', StaffRole.cashier),
      ('kitchen', StaffRole.unknown),
      ('', StaffRole.unknown),
    ]) {
      test('"$code" is ${expected.name}', () => expect(StaffRole.fromCode(code), expected));
    }
  });

  group('StaffPermission.fromCode', () {
    for (final permission in StaffPermission.values.where((p) => p != StaffPermission.unknown)) {
      test('"${permission.code}" is ${permission.name}', () {
        expect(StaffPermission.fromCode(permission.code), permission);
      });
    }

    test('a code the app does not know, or an empty one, is unknown', () {
      expect(StaffPermission.fromCode('orders.print'), StaffPermission.unknown);
      expect(StaffPermission.fromCode(''), StaffPermission.unknown);
    });
  });

  group('StaffRestaurant.nameIn', () {
    test('gives the Arabic name for ar and the English name for anything else', () {
      expect(testSession.restaurant.nameIn('ar'), 'مشويات تجريبية');
      expect(testSession.restaurant.nameIn('en'), 'Demo Grill');
      expect(testSession.restaurant.nameIn('fr'), 'Demo Grill');
    });
  });

  group('StaffSession.can', () {
    test('is true only for what the server gave', () {
      expect(testSession.can(StaffPermission.ordersDecide), isTrue);
      expect(testSession.can(StaffPermission.menuEdit), isFalse);
    });
  });
}
