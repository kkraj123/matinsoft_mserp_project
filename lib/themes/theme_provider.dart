import 'package:flutter/material.dart';
import 'package:mserp/supports/share_preference_manager.dart';

class ThemeProvider extends ChangeNotifier {
  Color _primaryColor = const Color(0xFF71291D);
  bool _isDarkMode = false;

  Color get primaryColor => _primaryColor;
  bool get isDarkMode => _isDarkMode;

  ThemeData get lightTheme => ThemeData(
    brightness: Brightness.light,
    primaryColor: _primaryColor,
    appBarTheme: AppBarTheme(backgroundColor: _primaryColor),
    floatingActionButtonTheme:
    FloatingActionButtonThemeData(backgroundColor: _primaryColor),
    colorScheme: ColorScheme.light(primary: _primaryColor),
    useMaterial3: true,
  );

  ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryColor, brightness: Brightness.dark),
    scaffoldBackgroundColor: const Color(0xFF121212),
    useMaterial3: true,
  );

  ThemeMode get currentMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  ThemeProvider() {
    _loadPreferences();
  }

  void setPrimaryColor(Color color) async {
    _primaryColor = color;
    notifyListeners();
    await SharedPreferenceManager.setThemeColor(color.value);
  }

  void toggleDarkMode(bool value) async {
    _isDarkMode = value;
    notifyListeners();
    await SharedPreferenceManager.setDarkMode(value);
  }

  void _loadPreferences() async {
    int? colorValue = await SharedPreferenceManager.getThemeColor();
    bool darkMode = await SharedPreferenceManager.getDarkMode();

    if (colorValue != null) _primaryColor = Color(colorValue);
    _isDarkMode = darkMode;

    notifyListeners();
  }
}
