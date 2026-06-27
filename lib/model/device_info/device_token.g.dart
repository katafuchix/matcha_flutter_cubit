// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceToken _$DeviceTokenFromJson(Map<String, dynamic> json) => DeviceToken(
      deviceToken: json['device_token'] as String?,
      deviceTokenAndroid: json['device_token_android'] as String?,
    );

Map<String, dynamic> _$DeviceTokenToJson(DeviceToken instance) =>
    <String, dynamic>{
      'device_token': instance.deviceToken,
      'device_token_android': instance.deviceTokenAndroid,
    };
