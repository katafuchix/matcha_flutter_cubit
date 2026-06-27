// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'point_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PointModel _$PointModelFromJson(Map<String, dynamic> json) => PointModel(
      json['process_date'] as String,
      json['process_type'] as String,
      json['point'] as int,
    );

Map<String, dynamic> _$PointModelToJson(PointModel instance) =>
    <String, dynamic>{
      'process_date': instance.processDate,
      'process_type': instance.processType,
      'point': instance.point,
    };
