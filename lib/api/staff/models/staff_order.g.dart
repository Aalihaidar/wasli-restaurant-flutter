// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StaffOrder _$StaffOrderFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'id',
      'number',
      'status',
      'order_type',
      'placed_at',
      'updated_at',
      'decided_at',
      'eta_minutes',
      'rejection_reason_code',
      'rejection_note',
      'items',
      'customer_note',
      'subtotal_minor',
      'total_minor',
      'currency',
      'distance_m',
      'distance_band',
    ],
    disallowNullValues: const [
      'id',
      'number',
      'placed_at',
      'updated_at',
      'items',
      'customer_note',
      'subtotal_minor',
      'total_minor',
      'currency',
      'vehicle',
      'parking_note',
      'customer_location',
    ],
  );
  return StaffOrder(
    id: json['id'] as String,
    number: StaffOrder._read_number(json['number']),
    status: StaffOrder._read_status(json['status']),
    orderType: StaffOrder._read_orderType(json['order_type']),
    placedAt: StaffOrder._read_placedAt(json['placed_at']),
    updatedAt: StaffOrder._read_updatedAt(json['updated_at']),
    decidedAt: StaffOrder._read_decidedAt(json['decided_at']),
    etaMinutes: StaffOrder._read_etaMinutes(json['eta_minutes']),
    rejectionReasonCode: json['rejection_reason_code'] as String?,
    rejectionNote: json['rejection_note'] as String?,
    items: (json['items'] as List<dynamic>).map((e) => StaffOrderItem.fromJson(e as Map<String, dynamic>)).toList(),
    customerNote: json['customer_note'] as String,
    subtotalMinor: StaffOrder._read_subtotalMinor(json['subtotal_minor']),
    totalMinor: StaffOrder._read_totalMinor(json['total_minor']),
    currency: json['currency'] as String,
    vehicle: json['vehicle'] == null ? null : StaffVehicle.fromJson(json['vehicle'] as Map<String, dynamic>),
    parkingNote: json['parking_note'] as String?,
    customerLocation: json['customer_location'] == null
        ? null
        : StaffLocation.fromJson(json['customer_location'] as Map<String, dynamic>),
    distanceM: StaffOrder._read_distanceM(json['distance_m']),
    distanceBand: StaffOrder._read_distanceBand(json['distance_band']),
    additionalProperties: StaffOrder._extras(json, 'additionalProperties') == null
        ? const {}
        : StaffOrder._readExtras(StaffOrder._extras(json, 'additionalProperties')),
  );
}

Map<String, dynamic> _$StaffOrderToJson(StaffOrder instance) => <String, dynamic>{
  'id': instance.id,
  'number': ?StaffOrder._write_number(instance.number),
  'status': StaffOrder._write_status(instance.status),
  'order_type': StaffOrder._write_orderType(instance.orderType),
  'placed_at': ?StaffOrder._write_placedAt(instance.placedAt),
  'updated_at': ?StaffOrder._write_updatedAt(instance.updatedAt),
  'decided_at': StaffOrder._write_decidedAt(instance.decidedAt),
  'eta_minutes': StaffOrder._write_etaMinutes(instance.etaMinutes),
  'rejection_reason_code': instance.rejectionReasonCode,
  'rejection_note': instance.rejectionNote,
  'items': instance.items.map((e) => e.toJson()).toList(),
  'customer_note': instance.customerNote,
  'subtotal_minor': ?StaffOrder._write_subtotalMinor(instance.subtotalMinor),
  'total_minor': ?StaffOrder._write_totalMinor(instance.totalMinor),
  'currency': instance.currency,
  'vehicle': ?instance.vehicle?.toJson(),
  'parking_note': ?instance.parkingNote,
  'customer_location': ?instance.customerLocation?.toJson(),
  'distance_m': StaffOrder._write_distanceM(instance.distanceM),
  'distance_band': StaffOrder._write_distanceBand(instance.distanceBand),
};
