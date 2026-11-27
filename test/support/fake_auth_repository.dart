import 'dart:async';

import 'package:wasli_restaurant/features/auth/domain/auth_repository.dart';
import 'package:wasli_restaurant/features/auth/domain/staff_permission.dart';
import 'package:wasli_restaurant/features/auth/domain/staff_restaurant.dart';
import 'package:wasli_restaurant/features/auth/domain/staff_role.dart';
import 'package:wasli_restaurant/features/auth/domain/staff_session.dart';

/// A signed-in cashier of an invented restaurant.
const StaffSession testSession = StaffSession(
  id: 'staff-1',
  username: 'sara.cashier',
  fullName: 'Sara Tester',
  role: StaffRole.cashier,
  permissions: {StaffPermission.ordersView, StaffPermission.ordersDecide},
  mustChangePassword: false,
  restaurant: StaffRestaurant(
    slug: 'demo-grill',
    nameEn: 'Demo Grill',
    nameAr: 'مشويات تجريبية',
    latitude: 25.2,
    longitude: 55.27,
    currency: 'AED',
    serviceRadiusMeters: 500,
  ),
);

/// An [AuthRepository] for tests: it answers from what the test sets and remembers what it was asked.
class FakeAuthRepository implements AuthRepository {
  /// Creates the fake. [restored] is what a stored token gives (`null` = nobody signed in).
  new({this.restored});

  /// What [restore] gives back.
  StaffSession? restored;

  /// What [restore] throws instead, when set.
  Object? restoreError;

  /// What [signIn] gives back.
  StaffSession signedInAs = testSession;

  /// What [signIn] throws instead, when set.
  Object? signInError;

  /// When set, [signIn] waits for it before it answers, so a test can look at the form while a sign-in is on its way.
  Completer<void>? signInHold;

  /// The `(username, password)` of each [signIn] call.
  final List<(String, String)> signIns = [];

  /// How many times [signOut] was called.
  int signOuts = 0;

  @override
  Future<StaffSession?> restore() async {
    if (restoreError case final error?) Error.throwWithStackTrace(error, StackTrace.current);
    return restored;
  }

  @override
  Future<StaffSession> signIn({required String username, required String password}) async {
    signIns.add((username, password));
    await signInHold?.future;
    if (signInError case final error?) Error.throwWithStackTrace(error, StackTrace.current);
    return signedInAs;
  }

  @override
  Future<void> signOut() async => signOuts++;
}
