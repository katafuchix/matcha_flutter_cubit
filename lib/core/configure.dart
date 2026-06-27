enum Flavor {
  DEVELOP,
  STAGING,
  PRODUCTION,
}

class Config {
  static Flavor environment = Flavor.PRODUCTION;
}

extension ApiBaseExt on Flavor {
  String get apiBaseUrl {
    switch (this) {
      case Flavor.PRODUCTION:
        {
          // return 'http://133.125.60.37';
          return 'https://matchchat.net';
        }
      default:
        return 'http://133.125.60.37';
    }
  }
}

extension WebSocketExt on Flavor {
  String get webSocketBaseUrl {
    switch (this) {
      case Flavor.PRODUCTION:
        {
          return 'http://153.127.63.230:9000';
          // return 'http://133.125.50.67:9000';
        }
      default:
        return 'http://153.127.63.230:9000';
    }
  }
}
