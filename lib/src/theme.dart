import 'package:flutter/material.dart';

final ThemeData themeData = ThemeData.from(
        colorScheme: const ColorScheme.light(
            primary: Colors.teal, secondary: Colors.purple))
    .copyWith(visualDensity: VisualDensity.adaptivePlatformDensity);

final ThemeData darkThemeData = ThemeData.from(
        colorScheme: const ColorScheme.dark(
            primary: Colors.teal, secondary: Colors.purple))
    .copyWith(visualDensity: VisualDensity.adaptivePlatformDensity);
