// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceInfo _$DeviceInfoFromJson(Map<String, dynamic> json) => DeviceInfo(
      json['os_info'] as String,
      json['device_info'] as String,
      json['app_version'] as String,
    );

Map<String, dynamic> _$DeviceInfoToJson(DeviceInfo instance) =>
    <String, dynamic>{
      'os_info': instance.osInfo,
      'device_info': instance.deviceInfo,
      'app_version': instance.appVersion,
    };
