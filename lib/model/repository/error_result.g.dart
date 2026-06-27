// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorResult _$ErrorResultFromJson(Map<String, dynamic> json) => ErrorResult(
      json['error_code'] as int?,
      json['message'] as String,
    );

Map<String, dynamic> _$ErrorResultToJson(ErrorResult instance) =>
    <String, dynamic>{
      'error_code': instance.errorCode,
      'message': instance.message,
    };
