import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../IModel.dart';

part 'device_info.g.dart';

@JsonSerializable()
class DeviceInfo extends IModel {
  @JsonKey(name: 'os_info')
  String osInfo;
  @JsonKey(name: 'device_info')
  String deviceInfo;
  @JsonKey(name: 'app_version')
  String appVersion;

  DeviceInfo(this.osInfo, this.deviceInfo, this.appVersion);

  factory DeviceInfo.fromJson(Map<String, dynamic> json) =>
      _$DeviceInfoFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceInfoToJson(this);

  @override
  String toString() => jsonEncode(this);
}
