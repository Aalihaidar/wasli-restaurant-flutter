// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_order_option.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StaffOrderOption _$StaffOrderOptionFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['name_en', 'name_ar', 'price_delta_minor'],
    disallowNullValues: const ['name_en', 'name_ar', 'price_delta_minor'],
  );
  return StaffOrderOption(
    nameEn: json['name_en'] as String,
    nameAr: json['name_ar'] as String,
    priceDeltaMinor: StaffOrderOption._read_priceDeltaMinor(json['price_delta_minor']),
    additionalProperties: StaffOrderOption._extras(json, 'additionalProperties') == null
        ? const {}
        : StaffOrderOption._readExtras(StaffOrderOption._extras(json, 'additionalProperties')),
  );
}

Map<String, dynamic> _$StaffOrderOptionToJson(StaffOrderOption instance) => <String, dynamic>{
  'name_en': instance.nameEn,
  'name_ar': instance.nameAr,
  'price_delta_minor': ?StaffOrderOption._write_priceDeltaMinor(instance.priceDeltaMinor),
};
