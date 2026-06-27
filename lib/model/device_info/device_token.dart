import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:matcha_flutter_cubit/core/my_platform.dart';

import '../IModel.dart';

part 'device_token.g.dart';

@JsonSerializable()
class DeviceToken extends IModel {
  @JsonKey(name: 'device_token')
  String? deviceToken;
  @JsonKey(name: 'device_token_android')
  String? deviceTokenAndroid;

  DeviceToken({this.deviceToken, this.deviceTokenAndroid});

  factory DeviceToken.fromJson(Map<String, dynamic> json) =>
      _$DeviceTokenFromJson(json);

  factory DeviceToken.forMyPlatform(String token) {
    if (MyPlatform.isIOS) {
      return DeviceToken(deviceToken: token);
    } else {
      return DeviceToken(deviceTokenAndroid: token);
    }
  }

  Map<String, dynamic> toJson() => _$DeviceTokenToJson(this);

  @override
  String toString() => jsonEncode(this);
}
