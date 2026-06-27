import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:stack_trace/stack_trace.dart' show Trace;

import 'configure.dart';
import 'event_tracking.dart';
import 'my_platform.dart';

class MyLogger {
  // static final _logger = SimpleLogger();
  static final tag = "my-app-log";

  static init() {
    // _logger.setLevel(Level.ALL, includeCallerInfo: true);
  }

  static void d(Object object) {
    _logImpl(object, "DEBUG");
  }

  static void i(Object object) {
    _logImpl(object, "INFO");
  }

  static void w(Object object, {StackTrace? stacktrace}) {
    _logImpl(object, "WARN", error: Exception("warning"));
    EventTracking.onWarning(object, "WARN", stacktrace: stacktrace);
  }

  static void e(Object object, {StackTrace? stacktrace}) {
    _logImpl(object, "ERROR", error: Exception("error"));
    EventTracking.onError(object, "ERROR", stacktrace: stacktrace);
  }

  static void _logImpl(Object object, String logLevel, {Object? error}) async {
    const level = 2;
    final frames = Trace.current(level).frames;
    final frame = frames.isEmpty ? null : frames.first;

    var now = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    if (MyPlatform.isMobileApp) {
      log("┌─────────────────────────────────────────────────────────────────────────────────────");
      log("| ------------------------------------------------------------------------------------");
      log("| $frame");
      log("| ------------------------------------------------------------------------------------");
      log("| $tag $now $logLevel $object", error: error);
      log("└─────────────────────────────────────────────────────────────────────────────────────");
    } else if (Config.environment == Flavor.DEVELOP) {
      print("┌────────────────────────────────────");
      print("| -----------------------------------");
      print("| $frame");
      print("| -----------------------------------");
      print("| $tag $now $logLevel $object");
      print("└────────────────────────────────────");
    }
  }
}
