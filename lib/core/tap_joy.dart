import 'package:flutter/services.dart';

import './../core/configure.dart';
import 'event_tracking.dart';
import 'my_logger.dart';
import 'my_platform.dart';

class TapJoys {
  static const _methodChannel = MethodChannel('net.matchchat/tapjoy');

  // プリロード
  static Future requestContents() async {
    if (MyPlatform.isWeb) return;

    String placement;
    if (Config.environment == Flavor.PRODUCTION) {
      placement = 'TicketScreen';
    } else {
      placement = 'devTicketScreen';
    }
    try {
      return await _methodChannel
          .invokeMethod('request_content', {'placement': placement});
    } on PlatformException catch (e, s) {
      MyLogger.e(e, stacktrace: s);
      return -1;
    }
  }

  static Future setUserId(String userId) async {
    if (MyPlatform.isWeb) return;

    try {
      EventTracking.sendLog('TapJoys.setUserId() ; userId : $userId');
      return await _methodChannel
          .invokeMethod('set_user_id', {'user_id': userId});
    } on PlatformException catch (e, s) {
      MyLogger.e(e, stacktrace: s);
      return false;
    }
  }

  static Future<bool> isReady() async {
    if (MyPlatform.isWeb) return false;

    try {
      return await _methodChannel.invokeMethod('is_ready');
    } on PlatformException catch (e, s) {
      MyLogger.e(e, stacktrace: s);
      return false;
    }
  }

  // 実際にコンテンツを表示する
  static Future showContents() async {
    if (MyPlatform.isWeb) return;

    try {
      return await _methodChannel.invokeMethod('show_contents');
    } on PlatformException catch (e, s) {
      MyLogger.e(e, stacktrace: s);
      return -1;
    }
  }
}
