// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_vehicle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StaffVehicle _$StaffVehicleFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['plate', 'model', 'colour'],
    disallowNullValues: const ['plate', 'model', 'colour'],
  );
  return StaffVehicle(
    plate: json['plate'] as String,
    model: json['model'] as String,
    colour: json['colour'] as String,
    additionalProperties: StaffVehicle._extras(json, 'additionalProperties') == null
        ? const {}
        : StaffVehicle._readExtras(StaffVehicle._extras(json, 'additionalProperties')),
  );
}

Map<String, dynamic> _$StaffVehicleToJson(StaffVehicle instance) => <String, dynamic>{
  'plate': instance.plate,
  'model': instance.model,
  'colour': instance.colour,
};
