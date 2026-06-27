// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppConfig _$AppConfigFromJson(Map<String, dynamic> json) => AppConfig(
      json['app_name'] as String,
      json['ng_words'] as String,
      json['android_is_maintenance'] as int,
      json['android_maintenance_message'] as String,
      json['android_min_supported_app_version'] as String,
      json['android_is_force_update'] as int,
      json['ios_is_maintenance'] as int,
      json['ios_maintenance_message'] as String,
      json['ios_is_force_update'] as int,
      json['ios_force_update_version'] as String,
    );

Map<String, dynamic> _$AppConfigToJson(AppConfig instance) => <String, dynamic>{
      'app_name': instance.appName,
      'ng_words': instance.ngWords,
      'android_is_maintenance': instance.androidIsMaintenance,
      'android_maintenance_message': instance.androidMaintenanceMessage,
      'android_min_supported_app_version':
          instance.androidMinSupportedAppVersion,
      'android_is_force_update': instance.androidIsForceUpdate,
      'ios_is_maintenance': instance.iosIsMaintenance,
      'ios_maintenance_message': instance.iosMaintenanceMessage,
      'ios_is_force_update': instance.iosIsForceUpdate,
      'ios_force_update_version': instance.iosForceUpdateVersion,
    };
