// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_me_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StaffMe$Response _$StaffMe$ResponseFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['id', 'username', 'full_name', 'role', 'permissions', 'must_change_password', 'restaurant'],
    disallowNullValues: const ['id', 'username', 'full_name', 'permissions', 'must_change_password', 'restaurant'],
  );
  return StaffMe$Response(
    id: json['id'] as String,
    username: json['username'] as String,
    fullName: json['full_name'] as String,
    role: StaffMe$Response._read_role(json['role']),
    permissions: StaffMe$Response._read_permissions(json['permissions']),
    mustChangePassword: json['must_change_password'] as bool,
    restaurant: StaffRestaurant$Response.fromJson(json['restaurant'] as Map<String, dynamic>),
    additionalProperties: StaffMe$Response._extras(json, 'additionalProperties') == null
        ? const {}
        : StaffMe$Response._readExtras(StaffMe$Response._extras(json, 'additionalProperties')),
  );
}

Map<String, dynamic> _$StaffMe$ResponseToJson(StaffMe$Response instance) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'full_name': instance.fullName,
  'role': StaffMe$Response._write_role(instance.role),
  'permissions': ?StaffMe$Response._write_permissions(instance.permissions),
  'must_change_password': instance.mustChangePassword,
  'restaurant': instance.restaurant.toJson(),
};
