// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'point_master.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PointMaster _$PointMasterFromJson(Map<String, dynamic> json) => PointMaster(
      json['id'] as int,
      _$enumDecode(_$PointOsEnumMap, json['os']),
      json['product_id_str'] as String,
      json['name'] as String,
      json['price'] as int,
      json['price_before_discount'] as int?,
      json['discount_percent'] as int?,
      json['point'] as int,
      json['sort_order'] as int,
      json['enabled'] as bool,
      json['created_at'] as String,
      json['updated_at'] as String,
    );

Map<String, dynamic> _$PointMasterToJson(PointMaster instance) =>
    <String, dynamic>{
      'id': instance.id,
      'os': _$PointOsEnumMap[instance.os],
      'product_id_str': instance.productIdStr,
      'name': instance.name,
      'price': instance.price,
      'price_before_discount': instance.priceBeforeDiscount,
      'discount_percent': instance.discountPercent,
      'point': instance.point,
      'sort_order': instance.sortOrder,
      'enabled': instance.enabled,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$PointOsEnumMap = {
  PointOs.Android: 'android',
  PointOs.Ios: 'iOS',
};
