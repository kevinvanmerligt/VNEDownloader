import 'package:shared_preferences/shared_preferences.dart';
import '../domain/app_settings.dart';

class SettingsRepository {
  static const _kSaveFolder = 'setting_save_folder';
  static const _kOnlyWifi = 'setting_only_wifi';
  static const _kDefaultQuality = 'setting_default_quality';
  static const _kThemePreference = 'setting_theme_preference';
  static const _kLanguageCode = 'setting_language_code';

  final SharedPreferences _prefs;

  SettingsRepository(this._prefs);

  AppSettings loadSettings() {
    final saveFolder = _prefs.getString(_kSaveFolder) ?? 'Movies/VNEDownloader';
    final onlyWifi = _prefs.getBool(_kOnlyWifi) ?? true;

    final qualityString = _prefs.getString(_kDefaultQuality) ?? QualityPreference.ask.name;
    final defaultQuality = QualityPreference.values.firstWhere(
      (e) => e.name == qualityString,
      orElse: () => QualityPreference.ask,
    );

    final themeString = _prefs.getString(_kThemePreference) ?? ThemePreference.system.name;
    final themePreference = ThemePreference.values.firstWhere(
      (e) => e.name == themeString,
      orElse: () => ThemePreference.system,
    );

    final languageCode = _prefs.getString(_kLanguageCode) ?? 'id';

    return AppSettings(
      saveFolder: saveFolder,
      onlyWifi: onlyWifi,
      defaultQuality: defaultQuality,
      themePreference: themePreference,
      languageCode: languageCode,
    );
  }

  Future<void> saveSettings(AppSettings settings) async {
    await _prefs.setString(_kSaveFolder, settings.saveFolder);
    await _prefs.setBool(_kOnlyWifi, settings.onlyWifi);
    await _prefs.setString(_kDefaultQuality, settings.defaultQuality.name);
    await _prefs.setString(_kThemePreference, settings.themePreference.name);
    await _prefs.setString(_kLanguageCode, settings.languageCode);
  }
}

