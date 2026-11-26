// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StaffToken _$StaffTokenFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['token'], disallowNullValues: const ['token']);
  return StaffToken(
    token: json['token'] as String,
    additionalProperties: StaffToken._extras(json, 'additionalProperties') == null
        ? const {}
        : StaffToken._readExtras(StaffToken._extras(json, 'additionalProperties')),
  );
}

Map<String, dynamic> _$StaffTokenToJson(StaffToken instance) => <String, dynamic>{'token': instance.token};
