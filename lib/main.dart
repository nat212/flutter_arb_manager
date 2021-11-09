import 'package:flutter/material.dart';
import 'package:flutter_i18n_manager/src/app.dart';
import 'package:flutter_i18n_manager/src/settings/settings_controller.dart';
import 'package:flutter_i18n_manager/src/settings/settings_service.dart';

void main() async {
  final SettingsController settingsController =
      SettingsController(SettingsService());
  await settingsController.loadSettings();
  runApp(App(
    settingsController: settingsController,
  ));
}
