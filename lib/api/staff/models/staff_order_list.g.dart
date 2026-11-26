// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_order_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StaffOrderList _$StaffOrderListFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['server_time', 'orders'], disallowNullValues: const ['server_time', 'orders']);
  return StaffOrderList(
    serverTime: StaffOrderList._read_serverTime(json['server_time']),
    orders: (json['orders'] as List<dynamic>).map((e) => StaffOrder.fromJson(e as Map<String, dynamic>)).toList(),
    additionalProperties: StaffOrderList._extras(json, 'additionalProperties') == null
        ? const {}
        : StaffOrderList._readExtras(StaffOrderList._extras(json, 'additionalProperties')),
  );
}

Map<String, dynamic> _$StaffOrderListToJson(StaffOrderList instance) => <String, dynamic>{
  'server_time': ?StaffOrderList._write_serverTime(instance.serverTime),
  'orders': instance.orders.map((e) => e.toJson()).toList(),
};
