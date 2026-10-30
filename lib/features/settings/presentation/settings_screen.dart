import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vnedownloader/app/l10n/app_localizations.dart';
import 'package:vnedownloader/core/constants/app_constants.dart';
import 'package:vnedownloader/features/history/application/history_controller.dart';
import '../application/settings_controller.dart';
import '../domain/app_settings.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  void _showQualityDialog(BuildContext context, WidgetRef ref) {
    final strings = AppStrings.of(context);
    final settings = ref.read(settingsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? AppConstants.darkPrimaryAccent : AppConstants.primaryColor;

    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(strings.settingDefaultQuality),
        children: QualityPreference.values.map((q) {
          final isSelected = settings.defaultQuality == q;
          final label = strings.isIndonesian ? q.labelId : q.labelEn;
          return SimpleDialogOption(
            onPressed: () {
              ref.read(settingsProvider.notifier).setDefaultQuality(q);
              Navigator.of(ctx).pop();
            },
            child: Row(
              children: [
                Icon(
                  isSelected
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_off_rounded,
                  color: isSelected ? accentColor : Colors.grey,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showThemeDialog(BuildContext context, WidgetRef ref) {
    final strings = AppStrings.of(context);
    final settings = ref.read(settingsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? AppConstants.darkPrimaryAccent : AppConstants.primaryColor;

    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(strings.settingTheme),
        children: [
          _themeOption(
            ctx,
            ref,
            ThemePreference.system,
            strings.settingThemeSystem,
            settings.themePreference,
            accentColor,
          ),
          _themeOption(
            ctx,
            ref,
            ThemePreference.light,
            strings.settingThemeLight,
            settings.themePreference,
            accentColor,
          ),
          _themeOption(
            ctx,
            ref,
            ThemePreference.dark,
            '${strings.settingThemeDark} (Halloween Dark)',
            settings.themePreference,
            accentColor,
          ),
        ],
      ),
    );
  }

  Widget _themeOption(
    BuildContext context,
    WidgetRef ref,
    ThemePreference theme,
    String label,
    ThemePreference current,
    Color accentColor,
  ) {
    final isSelected = theme == current;
    return SimpleDialogOption(
      onPressed: () {
        ref.read(settingsProvider.notifier).setThemePreference(theme);
        Navigator.of(context).pop();
      },
      child: Row(
        children: [
          Icon(
            isSelected
                ? Icons.radio_button_checked_rounded
                : Icons.radio_button_off_rounded,
            color: isSelected ? accentColor : Colors.grey,
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, WidgetRef ref) {
    final strings = AppStrings.of(context);
    final settings = ref.read(settingsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? AppConstants.darkPrimaryAccent : AppConstants.primaryColor;

    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(strings.settingLanguage),
        children: [
          SimpleDialogOption(
            onPressed: () {
              ref.read(settingsProvider.notifier).setLanguageCode('id');
              Navigator.of(ctx).pop();
            },
            child: Row(
              children: [
                Icon(
                  settings.languageCode == 'id'
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_off_rounded,
                  color: settings.languageCode == 'id'
                      ? accentColor
                      : Colors.grey,
                  size: 20,
                ),
                const SizedBox(width: 12),
                const Text('Bahasa Indonesia',
                    style: TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () {
              ref.read(settingsProvider.notifier).setLanguageCode('en');
              Navigator.of(ctx).pop();
            },
            child: Row(
              children: [
                Icon(
                  settings.languageCode == 'en'
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_off_rounded,
                  color: settings.languageCode == 'en'
                      ? accentColor
                      : Colors.grey,
                  size: 20,
                ),
                const SizedBox(width: 12),
                const Text('English',
                    style: TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showClearDataDialog(BuildContext context, WidgetRef ref) {
    final strings = AppStrings.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(strings.settingClearData),
        content: Text(strings.clearAllConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(strings.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.statusFailed,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              ref.read(historyProvider.notifier).clearAll();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Semua riwayat unduhan telah dibersihkan.'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: Text(strings.delete),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicyDialog(BuildContext context) {
    final strings = AppStrings.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(strings.settingPrivacy),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Privasi 100% Lokal',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              SizedBox(height: 6),
              Text(
                'VNEDownloader tidak mengumpulkan data pribadi Anda, tidak menggunakan server perantara, analitik pihak ketiga, atau pelacakan. Seluruh data riwayat dan berkas video disimpan langsung di perangkat ponsel Anda.',
                style: TextStyle(fontSize: 13, height: 1.4),
              ),
              SizedBox(height: 12),
              Text(
                'Ketentuan Penggunaan',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              SizedBox(height: 6),
              Text(
                'Aplikasi ini ditujukan untuk mengarsipkan konten milik Anda sendiri atau konten berlisensi publik untuk ditonton secara offline. Pengguna bertanggung jawab penuh atas konten yang diunduh dan diputar.',
                style: TextStyle(fontSize: 13, height: 1.4),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(strings.ok),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppStrings.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? AppConstants.darkPrimaryAccent : AppConstants.primaryColor;
    final dividerColor = isDark ? AppConstants.darkBorder : AppConstants.lightBorder;
    final settings = ref.watch(settingsProvider);

    String themeLabel = strings.settingThemeSystem;
    switch (settings.themePreference) {
      case ThemePreference.light:
        themeLabel = strings.settingThemeLight;
        break;
      case ThemePreference.dark:
        themeLabel = '${strings.settingThemeDark} (Halloween Dark)';
        break;
      case ThemePreference.system:
        themeLabel = strings.settingThemeSystem;
        break;
    }

    final qualityLabel = strings.isIndonesian
        ? settings.defaultQuality.labelId
        : settings.defaultQuality.labelEn;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          strings.settingsTitle,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: isDark ? AppConstants.textLight : AppConstants.textDark,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        children: [
          // Section: Unduhan
          _buildSectionHeader('Preferensi Unduhan', isDark),
          _buildCard(
            isDark: isDark,
            children: [
              // Folder simpan
              ListTile(
                leading: Icon(Icons.folder_open_rounded, color: accentColor),
                title: Text(strings.settingFolder),
                subtitle: Text(
                  settings.saveFolder,
                  style: const TextStyle(fontSize: 12),
                ),
                trailing: const Icon(Icons.info_outline_rounded, size: 20),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('File disimpan di folder: ${settings.saveFolder}'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              Divider(height: 1, color: dividerColor),
              // Hanya Wi-Fi
              SwitchListTile(
                secondary: Icon(Icons.wifi_rounded, color: accentColor),
                title: Text(strings.settingWifiOnly),
                subtitle: Text(
                  strings.settingWifiOnlySub,
                  style: const TextStyle(fontSize: 12),
                ),
                value: settings.onlyWifi,
                activeThumbColor: accentColor,
                onChanged: (val) {
                  ref.read(settingsProvider.notifier).setOnlyWifi(val);
                },
              ),
              Divider(height: 1, color: dividerColor),
              // Kualitas bawaan
              ListTile(
                leading: Icon(Icons.high_quality_rounded, color: accentColor),
                title: Text(strings.settingDefaultQuality),
                subtitle: Text(
                  qualityLabel,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: accentColor,
                  ),
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => _showQualityDialog(context, ref),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Section: Tampilan & Bahasa
          _buildSectionHeader('Tampilan & Bahasa', isDark),
          _buildCard(
            isDark: isDark,
            children: [
              // Tema
              ListTile(
                leading: Icon(Icons.palette_outlined, color: accentColor),
                title: Text(strings.settingTheme),
                subtitle: Text(
                  themeLabel,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: accentColor,
                  ),
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => _showThemeDialog(context, ref),
              ),
              Divider(height: 1, color: dividerColor),
              // Bahasa
              ListTile(
                leading: Icon(Icons.language_rounded, color: accentColor),
                title: Text(strings.settingLanguage),
                subtitle: Text(
                  settings.languageCode == 'id' ? 'Bahasa Indonesia' : 'English',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: accentColor,
                  ),
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => _showLanguageDialog(context, ref),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Section: Data & Penyimpanan
          _buildSectionHeader('Data & Penyimpanan', isDark),
          _buildCard(
            isDark: isDark,
            children: [
              ListTile(
                leading: const Icon(Icons.delete_outline_rounded,
                    color: AppConstants.statusFailed),
                title: Text(
                  strings.settingClearData,
                  style: const TextStyle(color: AppConstants.statusFailed),
                ),
                subtitle: Text(
                  strings.settingClearDataSub,
                  style: const TextStyle(fontSize: 12),
                ),
                onTap: () => _showClearDataDialog(context, ref),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Section: Tentang
          _buildSectionHeader(strings.settingAbout, isDark),
          _buildCard(
            isDark: isDark,
            children: [
              ListTile(
                leading: Icon(Icons.info_outline_rounded, color: accentColor),
                title: Text(strings.settingAboutVersion),
                subtitle: const Text('VNEDownloader v1.0.0 (MVP)'),
              ),
              Divider(height: 1, color: dividerColor),
              ListTile(
                leading: Icon(Icons.code_rounded, color: accentColor),
                title: Text(strings.settingAboutGithub),
                subtitle: const Text(AppConstants.githubUrl),
                trailing: const Icon(Icons.open_in_new_rounded, size: 18),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Rilis APK bertanda tangan di GitHub.'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              Divider(height: 1, color: dividerColor),
              ListTile(
                leading: Icon(Icons.privacy_tip_outlined, color: accentColor),
                title: Text(strings.settingPrivacy),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => _showPrivacyPolicyDialog(context),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: isDark ? AppConstants.textLightMuted : AppConstants.textMuted,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _buildCard({required bool isDark, required List<Widget> children}) {
    return Material(
      color: isDark ? AppConstants.darkCard : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: isDark ? AppConstants.darkBorder : AppConstants.lightBorder,
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Column(children: children),
      ),
    );
  }
}
