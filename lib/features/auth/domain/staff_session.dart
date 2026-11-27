import 'package:wasli_restaurant/features/auth/domain/staff_permission.dart';
import 'package:wasli_restaurant/features/auth/domain/staff_restaurant.dart';
import 'package:wasli_restaurant/features/auth/domain/staff_role.dart';

/// Who is signed in: the member, the restaurant and what the server lets them do.
class StaffSession {
  /// Creates the session.
  const new({
    required this.id,
    required this.username,
    required this.fullName,
    required this.role,
    required this.permissions,
    required this.mustChangePassword,
    required this.restaurant,
  });

  /// The member's id.
  final String id;

  /// The username the member signs in with.
  final String username;

  /// The member's name.
  final String fullName;

  /// The member's role.
  final StaffRole role;

  /// What the member may do.
  final Set<StaffPermission> permissions;

  /// Whether the member must choose a new password (a temporary one was set).
  final bool mustChangePassword;

  /// The restaurant the member works for.
  final StaffRestaurant restaurant;

  /// Whether the server gave the member [permission]. Only for showing or hiding actions: the server still checks.
  bool can(StaffPermission permission) => permissions.contains(permission);
}
