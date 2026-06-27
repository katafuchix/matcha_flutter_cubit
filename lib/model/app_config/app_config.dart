import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../../core/app_info.dart';
import '../../core/my_platform.dart';
import '../IModel.dart';

part 'app_config.g.dart';

@JsonSerializable()
class AppConfig extends IModel {
  @JsonKey(name: 'app_name')
  String appName;
  @JsonKey(name: 'ng_words')
  String ngWords;
  @JsonKey(name: 'android_is_maintenance')
  int androidIsMaintenance;
  @JsonKey(name: 'android_maintenance_message')
  String androidMaintenanceMessage;
  @JsonKey(name: 'android_min_supported_app_version')
  String androidMinSupportedAppVersion;
  @JsonKey(name: 'android_is_force_update')
  int androidIsForceUpdate;
  @JsonKey(name: 'ios_is_maintenance')
  int iosIsMaintenance;
  @JsonKey(name: 'ios_maintenance_message')
  String iosMaintenanceMessage;
  @JsonKey(name: 'ios_is_force_update')
  int iosIsForceUpdate;
  @JsonKey(name: 'ios_force_update_version')
  String iosForceUpdateVersion;

  AppConfig(
    this.appName,
    this.ngWords,
    this.androidIsMaintenance,
    this.androidMaintenanceMessage,
    this.androidMinSupportedAppVersion,
    this.androidIsForceUpdate,
    this.iosIsMaintenance,
    this.iosMaintenanceMessage,
    this.iosIsForceUpdate,
    this.iosForceUpdateVersion,
  );

  factory AppConfig.fromJson(Map<String, dynamic> json) =>
      _$AppConfigFromJson(json);

  bool isMaintenance() {
    if (MyPlatform.isIOS) {
      return iosIsMaintenance != 0;
    }

    if (MyPlatform.isAndroid) {
      return androidIsMaintenance != 0;
    }

    return false;
  }

  String getMaintenanceMessage() {
    if (MyPlatform.isIOS) {
      return iosMaintenanceMessage;
    }

    if (MyPlatform.isAndroid) {
      return androidMaintenanceMessage;
    }

    return '';
  }

  String getRequiredVersion() {
    if (MyPlatform.isIOS) {
      return iosForceUpdateVersion;
    }

    if (MyPlatform.isAndroid) {
      return androidMinSupportedAppVersion;
    }

    return '';
  }

  bool needForceUpdate() {
    try {
      if (MyPlatform.isIOS) {
        return _isUpperVersion(iosForceUpdateVersion, AppInfo.appVersion) &&
            iosIsForceUpdate != 0;
      }

      if (MyPlatform.isAndroid) {
        return _isUpperVersion(
                androidMinSupportedAppVersion, AppInfo.appVersion) &&
            androidIsForceUpdate != 0;
      }
    } catch (e) {
      return false;
    }

    return false;
  }

  bool _isUpperVersion(String baseVersion, String comparedVersion) {
    try {
      final baseVersions = baseVersion.split(".");
      final comparedVersions = comparedVersion.split(".");

      if (int.parse(baseVersions[0]) > int.parse(comparedVersions[0]))
        return true;
      if (int.parse(baseVersions[1]) > int.parse(comparedVersions[1]))
        return true;
      if (int.parse(baseVersions[2]) > int.parse(comparedVersions[2]))
        return true;
    } catch (e) {}
    return false;
  }

  Map<String, dynamic> toJson() => _$AppConfigToJson(this);

  @override
  String toString() => jsonEncode(this);
}
