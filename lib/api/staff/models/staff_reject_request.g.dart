// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_reject_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StaffRejectRequest _$StaffRejectRequestFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['reason_code'], disallowNullValues: const ['reason_code', 'note']);
  return StaffRejectRequest(
    reasonCode: json['reason_code'] as String,
    note: json['note'] as String?,
    additionalProperties: StaffRejectRequest._extras(json, 'additionalProperties') == null
        ? const {}
        : StaffRejectRequest._readExtras(StaffRejectRequest._extras(json, 'additionalProperties')),
  );
}

Map<String, dynamic> _$StaffRejectRequestToJson(StaffRejectRequest instance) => <String, dynamic>{
  'reason_code': instance.reasonCode,
  'note': ?instance.note,
};
