// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_restaurant_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StaffRestaurant$Response _$StaffRestaurant$ResponseFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['slug', 'name_en', 'name_ar', 'logo_url', 'latitude', 'longitude', 'currency'],
    disallowNullValues: const ['slug', 'name_en', 'name_ar', 'latitude', 'longitude', 'service_radius_m', 'currency'],
  );
  return StaffRestaurant$Response(
    slug: json['slug'] as String,
    nameEn: json['name_en'] as String,
    nameAr: json['name_ar'] as String,
    logoUrl: json['logo_url'] as String?,
    latitude: json['latitude'] as num,
    longitude: json['longitude'] as num,
    serviceRadiusM: StaffRestaurant$Response._read_serviceRadiusM(json['service_radius_m']),
    currency: json['currency'] as String,
    additionalProperties: StaffRestaurant$Response._extras(json, 'additionalProperties') == null
        ? const {}
        : StaffRestaurant$Response._readExtras(StaffRestaurant$Response._extras(json, 'additionalProperties')),
  );
}

Map<String, dynamic> _$StaffRestaurant$ResponseToJson(StaffRestaurant$Response instance) => <String, dynamic>{
  'slug': instance.slug,
  'name_en': instance.nameEn,
  'name_ar': instance.nameAr,
  'logo_url': instance.logoUrl,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'service_radius_m': ?StaffRestaurant$Response._write_serviceRadiusM(instance.serviceRadiusM),
  'currency': instance.currency,
};
