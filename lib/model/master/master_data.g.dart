// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'master_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MasterData _$MasterDataFromJson(Map<String, dynamic> json) => MasterData(
      json['id'] as int,
      json['name'] as String,
      json['enabled'] as bool?,
      json['sort_order'] as int?,
    );

Map<String, dynamic> _$MasterDataToJson(MasterData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'enabled': instance.enabled,
      'sort_order': instance.sortOrder,
    };
