import 'package:wasli_restaurant/api/api.dart';
import 'package:wasli_restaurant/features/auth/domain/staff_permission.dart';
import 'package:wasli_restaurant/features/auth/domain/staff_restaurant.dart';
import 'package:wasli_restaurant/features/auth/domain/staff_role.dart';
import 'package:wasli_restaurant/features/auth/domain/staff_session.dart';

/// The session described by the answer of `GET /staff/me`. A role or permission the app does not know becomes
/// `unknown` instead of failing.
StaffSession staffSessionFromDto(StaffMe$Response dto) {
  final restaurant = dto.restaurant;
  return StaffSession(
    id: dto.id,
    username: dto.username,
    fullName: dto.fullName,
    role: StaffRole.fromCode(dto.role.value),
    permissions: {for (final permission in dto.permissions) StaffPermission.fromCode(permission.value)},
    mustChangePassword: dto.mustChangePassword,
    restaurant: StaffRestaurant(
      slug: restaurant.slug,
      nameEn: restaurant.nameEn,
      nameAr: restaurant.nameAr,
      logoUrl: restaurant.logoUrl,
      latitude: restaurant.latitude.toDouble(),
      longitude: restaurant.longitude.toDouble(),
      serviceRadiusMeters: restaurant.serviceRadiusM,
      currency: restaurant.currency,
    ),
  );
}
