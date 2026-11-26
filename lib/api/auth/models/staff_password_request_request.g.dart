// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_password_request_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StaffPasswordRequest$Request _$StaffPasswordRequest$RequestFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['current_password', 'new_password'],
    disallowNullValues: const ['current_password', 'new_password'],
  );
  return StaffPasswordRequest$Request(
    currentPassword: json['current_password'] as String,
    newPassword: json['new_password'] as String,
    additionalProperties: StaffPasswordRequest$Request._extras(json, 'additionalProperties') == null
        ? const {}
        : StaffPasswordRequest$Request._readExtras(StaffPasswordRequest$Request._extras(json, 'additionalProperties')),
  );
}

Map<String, dynamic> _$StaffPasswordRequest$RequestToJson(StaffPasswordRequest$Request instance) => <String, dynamic>{
  'current_password': instance.currentPassword,
  'new_password': instance.newPassword,
};
