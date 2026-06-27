import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'core/app_info.dart';
import 'core/configure.dart';
import 'core/event_tracking.dart';
import 'core/my_logger.dart';
import 'core/my_notification_manager.dart';
import 'core/my_platform.dart';
import 'ui/app.dart';

init(Flavor flavor) async {
  Config.environment = flavor;

  Intl.defaultLocale = 'ja_JP';
  initializeDateFormatting('ja_JP');

  if (MyPlatform.isMobileApp) {
    MobileAds.instance.initialize();
  }

  await MyLogger.init();
  await AppInfo.init();
  await EventTracking.initialize();
  await MyNotificationManager.init();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // enablePendingPurchases は in_app_purchase v3.x で不要になったため削除
}

Future initAndRunApp(Flavor flavor) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  if (MyPlatform.isMobileApp) {
    runZonedGuarded<Future<void>>(() async {
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

      await init(flavor);
      AppEvent.sendPushEvent('/launch');
      runApp(AppEntryPoint());
    }, FirebaseCrashlytics.instance.recordError);
  } else {
    await init(flavor);
    AppEvent.sendPushEvent('/launch');
    runApp(AppEntryPoint());
  }
}
