import 'dart:math';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'constants.dart';
import 'my_platform.dart';

class AppInfo {
  static String platformString = 'UnknownPlatform';
  static String deviceName = '';
  static String osVersion = '';
  static String appVersion = '';
  static String packageName = '';
  static final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
  static String? deviceId;

  static init() async {
    if (MyPlatform.isWeb) {
      platformString = 'web';
      return;
    }

    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    if (MyPlatform.isAndroid) {
      platformString = 'Android';

      final androidInfo = await _deviceInfoPlugin.androidInfo;
      deviceName = androidInfo.model;
      osVersion = androidInfo.version.release;

      appVersion = packageInfo.version;
      packageName = packageInfo.packageName;

      // device_info_plus v9+ では androidId が廃止。Build.ID で代替。
      deviceId = androidInfo.id;
      return;
    }

    if (MyPlatform.isIOS) {
      platformString = 'iOS';

      final iosInfo = await _deviceInfoPlugin.iosInfo;
      deviceName = iosInfo.model;
      osVersion = iosInfo.systemVersion;

      appVersion = packageInfo.version;
      packageName = packageInfo.packageName;

      // TODO
      // deviceId = '';
      return;
    }
  }

  static double getAppWidth(BuildContext context) {
    final double w;
    if (MyPlatform.isMobileApp) {
      w = MediaQuery.of(context).size.width;
    } else {
      w = min(MediaQuery.of(context).size.width, MAX_APP_WIDTH);
    }
    return w;
  }
}
