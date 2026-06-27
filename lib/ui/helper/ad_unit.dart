import '../../core/configure.dart';
import '../../core/my_platform.dart';

class AdUnits {
  static String? get _testBannerAdUnitId {
    if (MyPlatform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    }
    if (MyPlatform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    }
    if (MyPlatform.isWeb) return null;
    throw new UnsupportedError("Unsupported platform");
  }

  static String? get _testNativeAdUnitId {
    if (MyPlatform.isAndroid) {
      return 'ca-app-pub-3940256099942544/2247696110';
    }
    if (MyPlatform.isIOS) {
      return 'ca-app-pub-3940256099942544/3986624511';
    }
    if (MyPlatform.isWeb) return null;
    throw new UnsupportedError("Unsupported platform");
  }

  static String? get searchScreenBannerAdUnitId {
    if (MyPlatform.isAndroid) {
      if (Config.environment == Flavor.PRODUCTION) {
        return 'ca-app-pub-2922123409443630/1077251443';
      } else {
        return _testBannerAdUnitId;
      }
    }
    if (MyPlatform.isIOS) {
      throw UnsupportedError("Unsupported platform");
    }
    if (MyPlatform.isWeb) return null;
    throw UnsupportedError("Unsupported platform");
  }

  static String? get messageScreenBannerAdUnitId {
    if (MyPlatform.isAndroid) {
      if (Config.environment == Flavor.PRODUCTION) {
        return 'ca-app-pub-2922123409443630/9647728805';
      } else {
        return _testBannerAdUnitId;
      }
    }
    if (MyPlatform.isIOS) {
      throw UnsupportedError("Unsupported platform");
    }
    if (MyPlatform.isWeb) return null;
    throw UnsupportedError("Unsupported platform");
  }

  static String? get historyScreenBannerAdUnitId {
    if (MyPlatform.isAndroid) {
      if (Config.environment == Flavor.PRODUCTION) {
        return 'ca-app-pub-2922123409443630/5325340415';
      } else {
        return _testBannerAdUnitId;
      }
    }
    if (MyPlatform.isIOS) {
      throw UnsupportedError("Unsupported platform");
    }
    if (MyPlatform.isWeb) return null;
    throw UnsupportedError("Unsupported platform");
  }

  static String? get ticketScreenBannerAdUnitId {
    if (MyPlatform.isAndroid) {
      if (Config.environment == Flavor.PRODUCTION) {
        return 'ca-app-pub-2922123409443630/6255278700';
      } else {
        return _testBannerAdUnitId;
      }
    }
    if (MyPlatform.isIOS) {
      throw UnsupportedError("Unsupported platform");
    }
    if (MyPlatform.isWeb) return null;
    throw UnsupportedError("Unsupported platform");
  }

  static String? get bbsScreenBannerAdUnitId {
    if (MyPlatform.isAndroid) {
      if (Config.environment == Flavor.PRODUCTION) {
        return 'ca-app-pub-2922123409443630/8689870359';
      } else {
        return _testBannerAdUnitId;
      }
    }
    if (MyPlatform.isIOS) {
      throw UnsupportedError("Unsupported platform");
    }
    if (MyPlatform.isWeb) return null;
    throw UnsupportedError("Unsupported platform");
  }

  static String? get menuScreenBannerAdUnitId {
    if (MyPlatform.isAndroid) {
      if (Config.environment == Flavor.PRODUCTION) {
        return 'ca-app-pub-2922123409443630/7022378506';
      } else {
        return 'ca-app-pub-2922123409443630/7022378506';
      }
    }
    if (MyPlatform.isIOS) {
      throw UnsupportedError("Unsupported platform");
    }
    if (MyPlatform.isWeb) return null;
    throw UnsupportedError("Unsupported platform");
  }
}
