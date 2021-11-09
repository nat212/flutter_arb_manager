import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n_manager/src/settings/settings_service.dart';

class SettingsController with ChangeNotifier {
  final SettingsService _service;

  SettingsController(this._service);

  late ThemeMode _themeMode;

  ThemeMode get themeMode => _themeMode;

  Future<void> loadSettings() async {
    await _service.init();
    _themeMode = _service.getThemeMode();
    notifyListeners();
  }

  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null || newThemeMode == _themeMode) return;

    _themeMode = newThemeMode;

    notifyListeners();
    await _service.setThemeMode(themeMode);
  }
}
