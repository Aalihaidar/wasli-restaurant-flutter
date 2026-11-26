// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_accept_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StaffAcceptRequest _$StaffAcceptRequestFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['eta_minutes'], disallowNullValues: const ['eta_minutes']);
  return StaffAcceptRequest(
    etaMinutes: StaffAcceptRequest._read_etaMinutes(json['eta_minutes']),
    additionalProperties: StaffAcceptRequest._extras(json, 'additionalProperties') == null
        ? const {}
        : StaffAcceptRequest._readExtras(StaffAcceptRequest._extras(json, 'additionalProperties')),
  );
}

Map<String, dynamic> _$StaffAcceptRequestToJson(StaffAcceptRequest instance) => <String, dynamic>{
  'eta_minutes': ?StaffAcceptRequest._write_etaMinutes(instance.etaMinutes),
};
