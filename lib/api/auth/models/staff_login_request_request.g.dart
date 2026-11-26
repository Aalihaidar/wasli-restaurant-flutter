// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_login_request_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StaffLoginRequest$Request _$StaffLoginRequest$RequestFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['username', 'password'], disallowNullValues: const ['username', 'password']);
  return StaffLoginRequest$Request(
    username: json['username'] as String,
    password: json['password'] as String,
    additionalProperties: StaffLoginRequest$Request._extras(json, 'additionalProperties') == null
        ? const {}
        : StaffLoginRequest$Request._readExtras(StaffLoginRequest$Request._extras(json, 'additionalProperties')),
  );
}

Map<String, dynamic> _$StaffLoginRequest$RequestToJson(StaffLoginRequest$Request instance) => <String, dynamic>{
  'username': instance.username,
  'password': instance.password,
};
