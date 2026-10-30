import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/settings_repository.dart';
import '../domain/app_settings.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Must override sharedPreferencesProvider');
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SettingsRepository(prefs);
});

class SettingsNotifier extends StateNotifier<AppSettings> {
  final SettingsRepository _repo;

  SettingsNotifier(this._repo) : super(_repo.loadSettings());

  Future<void> setSaveFolder(String folder) async {
    final updated = state.copyWith(saveFolder: folder);
    state = updated;
    await _repo.saveSettings(updated);
  }

  Future<void> setOnlyWifi(bool onlyWifi) async {
    final updated = state.copyWith(onlyWifi: onlyWifi);
    state = updated;
    await _repo.saveSettings(updated);
  }

  Future<void> setDefaultQuality(QualityPreference quality) async {
    final updated = state.copyWith(defaultQuality: quality);
    state = updated;
    await _repo.saveSettings(updated);
  }

  Future<void> setThemePreference(ThemePreference theme) async {
    final updated = state.copyWith(themePreference: theme);
    state = updated;
    await _repo.saveSettings(updated);
  }

  Future<void> setLanguageCode(String languageCode) async {
    final updated = state.copyWith(languageCode: languageCode);
    state = updated;
    await _repo.saveSettings(updated);
  }

  ThemeMode get themeMode {
    switch (state.themePreference) {
      case ThemePreference.light:
        return ThemeMode.light;
      case ThemePreference.dark:
        return ThemeMode.dark;
      case ThemePreference.system:
        return ThemeMode.system;
    }
  }

  Locale get locale => Locale(state.languageCode);
}

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  final repo = ref.watch(settingsRepositoryProvider);
  return SettingsNotifier(repo);
});

