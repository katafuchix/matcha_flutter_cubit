enum SharedPreferencesKeys {
  SAMPLE,

  ACCESS_TOKEN,
  IS_MALE,
}

extension SharedPreferencesKeysKeyExt on SharedPreferencesKeys {
  String get name {
    switch (this) {
      case SharedPreferencesKeys.SAMPLE:
        return 'sample';
      case SharedPreferencesKeys.ACCESS_TOKEN:
        return 'access_token';
      case SharedPreferencesKeys.IS_MALE:
        return 'is_male';
      default:
        throw StateError('unknown shared preference key');
    }
  }
}
