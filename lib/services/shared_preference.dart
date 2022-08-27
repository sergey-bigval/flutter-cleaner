import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static const String _buttonKey = 'bool_pref';

  static Future<void> saveStartButtonVisibility({required bool value}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(_buttonKey, value);
  }

  static Future<bool> getStartButtonVisibility() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(_buttonKey) ?? false;
  }
}