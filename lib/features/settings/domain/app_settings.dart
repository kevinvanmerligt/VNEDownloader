enum ThemePreference { system, light, dark }

enum QualityPreference {
  ask('Tanya setiap kali', 'Ask every time'),
  p480('480p', '480p'),
  p720('720p', '720p'),
  p1080('1080p', '1080p');

  final String labelId;
  final String labelEn;
  const QualityPreference(this.labelId, this.labelEn);
}

class AppSettings {
  final String saveFolder;
  final bool onlyWifi;
  final QualityPreference defaultQuality;
  final ThemePreference themePreference;
  final String languageCode; // 'id' or 'en'

  const AppSettings({
    this.saveFolder = 'Movies/VNEDownloader',
    this.onlyWifi = true,
    this.defaultQuality = QualityPreference.ask,
    this.themePreference = ThemePreference.system,
    this.languageCode = 'id',
  });

  AppSettings copyWith({
    String? saveFolder,
    bool? onlyWifi,
    QualityPreference? defaultQuality,
    ThemePreference? themePreference,
    String? languageCode,
  }) {
    return AppSettings(
      saveFolder: saveFolder ?? this.saveFolder,
      onlyWifi: onlyWifi ?? this.onlyWifi,
      defaultQuality: defaultQuality ?? this.defaultQuality,
      themePreference: themePreference ?? this.themePreference,
      languageCode: languageCode ?? this.languageCode,
    );
  }
}

