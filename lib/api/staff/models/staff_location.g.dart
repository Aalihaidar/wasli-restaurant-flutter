// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StaffLocation _$StaffLocationFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['lat', 'lng', 'accuracy_m', 'source', 'captured_at'],
    disallowNullValues: const ['lat', 'lng', 'source'],
  );
  return StaffLocation(
    lat: json['lat'] as num,
    lng: json['lng'] as num,
    accuracyM: json['accuracy_m'] as num?,
    source: json['source'] as String,
    capturedAt: StaffLocation._read_capturedAt(json['captured_at']),
    additionalProperties: StaffLocation._extras(json, 'additionalProperties') == null
        ? const {}
        : StaffLocation._readExtras(StaffLocation._extras(json, 'additionalProperties')),
  );
}

Map<String, dynamic> _$StaffLocationToJson(StaffLocation instance) => <String, dynamic>{
  'lat': instance.lat,
  'lng': instance.lng,
  'accuracy_m': instance.accuracyM,
  'source': instance.source,
  'captured_at': StaffLocation._write_capturedAt(instance.capturedAt),
};
