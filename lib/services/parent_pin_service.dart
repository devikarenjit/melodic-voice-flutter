import 'package:shared_preferences/shared_preferences.dart';

class ParentPinService {
  static const String _pinKey = "parent_pin";
  static const String defaultPin = "1234";

  static Future<String> getPin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_pinKey) ?? defaultPin;
  }

  static Future<void> setPin(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_pinKey, pin);
  }
}
