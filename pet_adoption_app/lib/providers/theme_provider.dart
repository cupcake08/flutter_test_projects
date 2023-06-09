import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;

  void toggleTheme(bool isOn, {bool notify = true}) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    if (notify) notifyListeners();
  }
}
