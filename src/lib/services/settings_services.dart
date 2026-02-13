import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  final SharedPreferences _prefs;

  SettingsService(this._prefs);

  static const String themeKey = 'theme';
  static const String languageKey = 'language';
  static const String notificationsKey = 'notifications';
  static const String primaryColorKey = 'primaryColor';
  static const String darkModeKey = 'darkMode';

  Future<bool> saveSettings(String key, String value) {
    return _prefs.setString(key, value);
  }

  String? getSettings(String key) {
    return _prefs.getString(key);
  }

  Future<bool> saveBool(String key, bool value) {
    return _prefs.setBool(key, value);
  }

  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  Future<bool> saveInt(String key, int value) {
    return _prefs.setInt(key, value);
  }

  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  Future<bool> saveTheme(String theme) {
    return saveSettings(themeKey, theme);
  }

  String? getTheme() {
    return getSettings(themeKey);
  }

  Future<bool> saveLanguage(String language) {
    return saveSettings(languageKey, language);
  }

  String? getLanguage() {
    return getSettings(languageKey);
  }

  Future<bool> saveNotificationsEnabled(bool enabled) {
    return saveBool(notificationsKey, enabled);
  }

  bool? getNotificationsEnabled() {
    return getBool(notificationsKey);
  }

  Future<bool> savePrimaryColor(String colorString) {
    return saveSettings(primaryColorKey, colorString);
  }

  String? getPrimaryColor() {
    return getSettings(primaryColorKey);
  }

  Future<bool> saveDarkMode(bool enabled) {
    return saveBool(darkModeKey, enabled);
  }

  bool? getDarkMode() {
    return getBool(darkModeKey);
  }
}
