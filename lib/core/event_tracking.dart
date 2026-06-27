import 'dart:convert';
import 'dart:math';

import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:stack_trace/stack_trace.dart' show Trace;

import '../model/basic/sex.dart';
import 'my_logger.dart';
import 'my_platform.dart';

part 'app_event.dart';

class EventTracking {
  static AppsflyerSdk? _appsflyerSdkInstance;

  static Future initialize() async {
    //await Firebase.initializeApp();
    await _initAppsFlyer();
  }

  static Future _initAppsFlyer() async {
    AppsflyerSdk? appsflyerSdk = getAppsflyerSdk();
    await appsflyerSdk?.initSdk(
        registerConversionDataCallback: true,
        registerOnAppOpenAttributionCallback: true,
        registerOnDeepLinkingCallback: true);
  }

  static onRefreshUser(int userId) {
    if (MyPlatform.isMobileApp) {
      FirebaseCrashlytics.instance.setUserIdentifier(userId.toString());
    }
    FirebaseAnalytics.instance.setUserId(id: userId.toString());
    getAppsflyerSdk()?.setCustomerUserId(userId.toString());
  }

  static Future sendLog(final String message) async {
    final end = min(message.length, 100);
    final m = message.substring(0, end);
    final l = m.length;
    await _sendEvent('app_log', {'message': m});
  }

  static Future onWarning(final dynamic error, final String reason,
      {StackTrace? stacktrace}) async {
    await _onError(error, reason, stacktrace: stacktrace, fatal: false);
  }

  static Future onError(final dynamic error, final String reason,
      {StackTrace? stacktrace}) async {
    await _onError(error, reason, fatal: true);
  }

  static Future _onError(final dynamic error, final String reason,
      {StackTrace? stacktrace, bool fatal = false}) async {
    await FirebaseCrashlytics.instance.recordError(
        error, stacktrace ?? Trace.current(2),
        reason: reason, fatal: fatal);
  }

  static Future _sendEvent(
      String eventName, Map<String, dynamic>? parameters) async {
    try {
      final log = {};
      log['event_name'] = eventName;
      log['event_param'] = parameters == null ? {} : parameters;
      MyLogger.d(jsonEncode(log));
    } catch (_) {}

    try {
      await FirebaseAnalytics.instance
          .logEvent(name: eventName, parameters: parameters?.cast<String, Object>());
    } catch (_) {}

    try {
      Map eventValues = parameters == null ? {} : parameters;
      await getAppsflyerSdk()?.logEvent(eventName, eventValues);
    } catch (_) {}
  }

  static clear() {}

  static AppsflyerSdk? getAppsflyerSdk() {
    if (!MyPlatform.isMobileApp) return null;

    if (_appsflyerSdkInstance == null) {
      String afAppId = '';
      if (MyPlatform.isIOS) {
        //afAppId = "xxxxxxxxxxxx";
      }
      Map appsFlyerOptions = {
        "afDevKey": "5FwscjhFZLfhsTN2LNFVwS",
        "afAppId": afAppId,
        "isDebug": kDebugMode
      };

      _appsflyerSdkInstance = AppsflyerSdk(appsFlyerOptions);
    }
    return _appsflyerSdkInstance;
  }
}
