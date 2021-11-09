import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const String _themeModeKey = 'themeMode';

  late final SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  ThemeMode getThemeMode() {
    final int index = _load(_themeModeKey, defValue: ThemeMode.system.index)!;
    return ThemeMode.values[index];
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    await _set(_themeModeKey, themeMode.index);
  }

  T? _load<T>(String key, {T? defValue}) {
    T? value;
    switch (T) {
      case int:
        value = _prefs.getInt(key) as T?;
        break;
      case double:
        value = _prefs.getDouble(key) as T?;
        break;
      case bool:
        value = _prefs.getBool(key) as T?;
        break;
      case String:
        value = _prefs.getString(key) as T?;
        break;
      default:
        throw Exception('Invalid type: $T');
    }
    if (value == null && defValue != null) {
      value = defValue;
    }
    return value;
  }

  Future<void> _set<T>(String key, T value) async {
    switch (T) {
      case int:
        await _prefs.setInt(key, value as int);
        break;
      case double:
        await _prefs.setDouble(key, value as double);
        break;
      case bool:
        await _prefs.setBool(key, value as bool);
        break;
      case String:
        await _prefs.setString(key, value as String);
        break;
      default:
        await _prefs.setString(key, value.toString());
    }
  }
}
