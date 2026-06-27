import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'my_logger.dart';
import 'my_platform.dart';

class MyNotificationManager {
  static FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future init() async {
    _initLocalNotifications();
    _initFirebaseMessaging();
  }

  static Future requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
  }

  static Future _initLocalNotifications() async {
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_launcher');
    // IOSInitializationSettings → DarwinInitializationSettings (v9+)
    const initializationSettingsIOS = DarwinInitializationSettings();
    const initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future _initFirebaseMessaging() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      MyLogger.d('Got a message whilst in the foreground!');
      MyLogger.d('Message data: ${message.data}');

      if (message.notification != null) {
        MyLogger.d(
            'Message also contained a notification: ${message.notification}');
        _showNotification(message.notification!);
      }
    });
  }

  static Future _showNotification(RemoteNotification notification) async {
    String pushTitle;
    String pushText;
    String action = '';

    if (MyPlatform.isAndroid) {
      pushTitle = notification.title ?? '';
      pushText = notification.body ?? '';
      action = notification.android?.clickAction ?? '';
    } else {
      pushTitle = notification.title ?? '';
      pushText = notification.body ?? '';
    }
    MyLogger.d("AppPushs params pushTitle : $pushTitle");
    MyLogger.d("AppPushs params pushText : $pushText");
    MyLogger.d("AppPushs params pushAction : $action");

    // channelDescription が v9+ で位置引数→名前付き引数に変更
    const platformChannelSpecificsAndroid = AndroidNotificationDetails(
        'your channel id', 'your channel name',
        channelDescription: 'your channel description',
        playSound: false,
        enableVibration: false,
        importance: Importance.max,
        priority: Priority.high);
    // IOSNotificationDetails → DarwinNotificationDetails (v9+)
    const platformChannelSpecificsIos =
        DarwinNotificationDetails(presentSound: false);
    const platformChannelSpecifics = NotificationDetails(
        android: platformChannelSpecificsAndroid,
        iOS: platformChannelSpecificsIos);

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
        0,
        pushTitle,
        pushText,
        platformChannelSpecifics,
        payload: 'No_Sound',
      );
    });
  }
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  MyLogger.d("Handling a background message: ${message.messageId}");
}
