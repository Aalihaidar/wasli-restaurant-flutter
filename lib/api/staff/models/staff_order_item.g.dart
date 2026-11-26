// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_order_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StaffOrderItem _$StaffOrderItemFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'line',
      'name_en',
      'name_ar',
      'quantity',
      'unit_price_minor',
      'options',
      'note',
      'line_total_minor',
    ],
    disallowNullValues: const [
      'line',
      'name_en',
      'name_ar',
      'quantity',
      'unit_price_minor',
      'options',
      'note',
      'line_total_minor',
    ],
  );
  return StaffOrderItem(
    line: StaffOrderItem._read_line(json['line']),
    nameEn: json['name_en'] as String,
    nameAr: json['name_ar'] as String,
    quantity: StaffOrderItem._read_quantity(json['quantity']),
    unitPriceMinor: StaffOrderItem._read_unitPriceMinor(json['unit_price_minor']),
    options: (json['options'] as List<dynamic>)
        .map((e) => StaffOrderOption.fromJson(e as Map<String, dynamic>))
        .toList(),
    note: json['note'] as String,
    lineTotalMinor: StaffOrderItem._read_lineTotalMinor(json['line_total_minor']),
    additionalProperties: StaffOrderItem._extras(json, 'additionalProperties') == null
        ? const {}
        : StaffOrderItem._readExtras(StaffOrderItem._extras(json, 'additionalProperties')),
  );
}

Map<String, dynamic> _$StaffOrderItemToJson(StaffOrderItem instance) => <String, dynamic>{
  'line': ?StaffOrderItem._write_line(instance.line),
  'name_en': instance.nameEn,
  'name_ar': instance.nameAr,
  'quantity': ?StaffOrderItem._write_quantity(instance.quantity),
  'unit_price_minor': ?StaffOrderItem._write_unitPriceMinor(instance.unitPriceMinor),
  'options': instance.options.map((e) => e.toJson()).toList(),
  'note': instance.note,
  'line_total_minor': ?StaffOrderItem._write_lineTotalMinor(instance.lineTotalMinor),
};
