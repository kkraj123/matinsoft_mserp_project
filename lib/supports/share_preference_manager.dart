import 'dart:convert';

import 'package:mserp/screens/authentication_view/login_screen/model/LoginAuthModel.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SharedPreferenceManager {

  static const String oauth = "oauth";
  static const String walkthrough = "walkthrough";
  static const String themeColorKey = "themeColor";
  static const String darkModeKey = "darkMode";
  static const String checkInCheckOutValue = "checkInCheckOutValue";

  static Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  static Future<void> clear() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }

  static setOAuth(LoginAuthModel oAuth) async {
    (await prefs).setString(oauth, jsonEncode(oAuth));
  }

  static Future<LoginAuthModel?> getOAuth() async {
    String oAuthData = (await prefs).getString(oauth) ?? '';
    if (oAuthData.isNotEmpty) {
      Map<String, dynamic> json = jsonDecode(oAuthData);
      var oAuth = LoginAuthModel.fromJson(json);
      return oAuth;
    } else {
      return null;
    }
  }


  static setFirstCallOnboarding(bool oneTime) async{
    (await prefs).setBool(walkthrough, oneTime);
  }
  static getFirstCallOnboarding() async {
    return (await prefs).getBool(walkthrough) ?? false;
  }

  // Save theme color
  static Future<void> setThemeColor(int colorValue) async {
    (await prefs).setInt(themeColorKey, colorValue);
  }

  static Future<int?> getThemeColor() async {
    return (await prefs).getInt(themeColorKey);
  }

  // Save dark mode
  static Future<void> setDarkMode(bool isDark) async {
    (await prefs).setBool(darkModeKey, isDark);
  }

  static Future<bool> getDarkMode() async {
    return (await prefs).getBool(darkModeKey) ?? false;
  }
  // 🔹 Save check-in/out type
  static Future<void> setCheckInCheckOut(String type) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(checkInCheckOutValue, type);
    print("Saved check-in/out type: $type");
  }

  // 🔹 Get check-in/out type
  static Future<String?> getCheckInCheckOut() async {
    final prefs = await SharedPreferences.getInstance();
    final type = prefs.getString(checkInCheckOutValue);
    print("Retrieved check-in/out type from prefs: $type");
    return type;
  }

}
