import 'package:shared_preferences/shared_preferences.dart';

import 'shared_preferences_keys.dart';

class SharedPreferencesManager {
  static SharedPreferencesManager? _instance;
  static SharedPreferences? _sharedPreferences;

  static Future<SharedPreferencesManager> getInstance() async {
    if (_instance == null) {
      _instance = SharedPreferencesManager();
    }
    if (_sharedPreferences == null) {
      _sharedPreferences = await SharedPreferences.getInstance();
    }
    return _instance!;
  }

  Future<bool> putBool(SharedPreferencesKeys key, bool value) =>
      _sharedPreferences!.setBool(key.name, value);

  bool? getBool(SharedPreferencesKeys key) =>
      _sharedPreferences?.getBool(key.name);

  Future<bool> putDouble(SharedPreferencesKeys key, double value) =>
      _sharedPreferences!.setDouble(key.name, value);

  double? getDouble(SharedPreferencesKeys key) =>
      _sharedPreferences?.getDouble(key.name);

  Future<bool> putInt(SharedPreferencesKeys key, int value) =>
      _sharedPreferences!.setInt(key.name, value);

  int? getInt(SharedPreferencesKeys key) =>
      _sharedPreferences?.getInt(key.name);

  Future<bool> putString(SharedPreferencesKeys key, String value) =>
      _sharedPreferences!.setString(key.name, value);

  String? getString(SharedPreferencesKeys key) =>
      _sharedPreferences?.getString(key.name);

  Future<bool> putStringList(SharedPreferencesKeys key, List<String> value) =>
      _sharedPreferences!.setStringList(key.name, value);

  List<String>? getStringList(SharedPreferencesKeys key) =>
      _sharedPreferences?.getStringList(key.name);

  bool isKeyExists(SharedPreferencesKeys key) =>
      _sharedPreferences!.containsKey(key.name);

  Future<bool> clearKey(SharedPreferencesKeys key) =>
      _sharedPreferences!.remove(key.name);

  Future<bool> clearAll() => _sharedPreferences!.clear();
}
