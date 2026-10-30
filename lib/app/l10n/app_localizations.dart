import 'package:flutter/material.dart';

class AppStrings {
  final Locale locale;
  AppStrings(this.locale);

  static AppStrings of(BuildContext context) {
    return Localizations.of<AppStrings>(context, AppStrings) ??
        AppStrings(const Locale('id'));
  }

  bool get isIndonesian => locale.languageCode == 'id';

  // App & Header
  String get appName => 'VNEDownloader';
  String get appSubtitle => isIndonesian ? 'MP4 & MP3 dari YouTube' : 'MP4 & MP3 from YouTube';
  String get statusActive => isIndonesian ? 'Aktif' : 'Active';

  // Navigation
  String get navDownload => isIndonesian ? 'Unduh' : 'Download';
  String get navHistory => isIndonesian ? 'Riwayat' : 'History';
  String get navSettings => isIndonesian ? 'Pengaturan' : 'Settings';

  // Download Screen Hero
  String get heroTitle =>
      isIndonesian ? 'Simpan video & audio YouTube ke ponsel' : 'Save YouTube videos & audio to phone';
  String get heroSubtitle => isIndonesian
      ? 'Tempel tautan, pilih format MP4 atau MP3, lalu unduh langsung ke penyimpanan ponsel.'
      : 'Paste link, select MP4 video or MP3 audio format, then download directly to your device.';

  // Link Input
  String get linkFieldLabel => isIndonesian ? 'Tautan video' : 'Video link';
  String get linkFieldPlaceholder =>
      isIndonesian ? 'Tempel tautan YouTube' : 'Paste YouTube link';
  String get pasteButton => isIndonesian ? 'Tempel' : 'Paste';
  String get checkLinkButton => isIndonesian ? 'Cek tautan →' : 'Check link →';
  String get checkingLink => isIndonesian ? 'Memeriksa tautan...' : 'Checking link...';

  // Errors & Warnings
  String get invalidUrlError => isIndonesian
      ? 'Tautan tidak dikenali. Pastikan itu tautan video YouTube.'
      : 'Unrecognized link. Make sure it is a YouTube video link.';
  String get noInternetError => isIndonesian
      ? 'Tidak ada koneksi internet. Periksa koneksi Anda.'
      : 'No internet connection. Please check your network.';
  String get wifiOnlyError => isIndonesian
      ? 'Pengaturan "Hanya Wi-Fi" aktif. Sambungkan ke Wi-Fi untuk mengunduh.'
      : '"Only Wi-Fi" setting is on. Connect to Wi-Fi to download.';
  String get retry => isIndonesian ? 'Coba lagi' : 'Retry';
  String get cancel => isIndonesian ? 'Batal' : 'Cancel';
  String get ok => 'OK';

  // Quality Bottom Sheet
  String get selectQualityTitle =>
      isIndonesian ? 'Pilih Format & Kualitas' : 'Select Format & Quality';
  String get downloadAction => isIndonesian ? 'Unduh Sekarang' : 'Download Now';
  String get approxSize => isIndonesian ? 'Pilihan Format Tersedia' : 'Available Formats';

  // Recent & History
  String get recentDownloads => isIndonesian ? 'Riwayat unduhan' : 'Download history';
  String filesCount(int count) => isIndonesian ? '$count berkas' : '$count files';
  String get emptyHistory =>
      isIndonesian ? 'Belum ada riwayat unduhan' : 'No download history yet';
  String get emptyHistorySub => isIndonesian
      ? 'Video dan musik MP3 yang Anda unduh akan muncul di sini secara otomatis.'
      : 'Videos and MP3 audio you download will appear here automatically.';
  String get openVideo => isIndonesian ? 'Buka File' : 'Open File';
  String get deleteFromHistory => isIndonesian ? 'Hapus dari Riwayat' : 'Delete from History';
  String get deleteFileToo =>
      isIndonesian ? 'Hapus juga file dari penyimpanan?' : 'Also delete file from storage?';
  String get confirmDelete => isIndonesian ? 'Konfirmasi Hapus' : 'Confirm Delete';
  String get delete => isIndonesian ? 'Hapus' : 'Delete';
  String get clearAllHistory => isIndonesian ? 'Hapus Semua Riwayat' : 'Clear All History';
  String get clearAllConfirm => isIndonesian
      ? 'Apakah Anda yakin ingin menghapus semua catatan riwayat?'
      : 'Are you sure you want to clear all history records?';

  // Status Badges
  String get statusCompletedBadge => isIndonesian ? 'Selesai' : 'Completed';
  String get statusDownloadingBadge => isIndonesian ? 'Mengunduh' : 'Downloading';
  String get statusFailedBadge => isIndonesian ? 'Gagal' : 'Failed';
  String get statusQueuedBadge => isIndonesian ? 'Antre' : 'Queued';

  // FAQ / Help
  String get helpTitle => isIndonesian ? 'Bantuan & FAQ' : 'Help & FAQ';
  String get faq1Question =>
      isIndonesian ? 'Kenapa tautan saya ditolak?' : 'Why was my link rejected?';
  String get faq1Answer => isIndonesian
      ? 'Pastikan tautan berasal dari YouTube (youtube.com/watch, youtu.be, atau youtube.com/shorts). Video privat, berbayar, atau yang memiliki pembatasan usia mungkin tidak dapat diunduh.'
      : 'Make sure the link is from YouTube (youtube.com/watch, youtu.be, or youtube.com/shorts). Private, paid, or age-restricted videos cannot be downloaded.';

  String get faq2Question =>
      isIndonesian ? 'Format apa yang dihasilkan?' : 'What formats are supported?';
  String get faq2Answer => isIndonesian
      ? 'VNEDownloader mendukung format video MP4 (360p, 480p, 720p, 1080p) dan audio MP3 kualitas tinggi yang dapat diputar di semua pemutar media ponsel Android.'
      : 'VNEDownloader supports MP4 video (360p, 480p, 720p, 1080p) and high-quality MP3 audio playable on all Android media players.';

  String get faq3Question =>
      isIndonesian ? 'Di mana file video dan MP3 disimpan?' : 'Where are files saved?';
  String get faq3Answer => isIndonesian
      ? 'File disimpan di folder Movies/VNEDownloader di memori perangkat Anda, sehingga langsung dapat diakses lewat Galeri atau Pemutar Musik.'
      : 'Files are saved in Movies/VNEDownloader on your device storage, directly accessible via Gallery or Music Players.';

  String get footerDisclaimer => isIndonesian
      ? 'Unduh hanya video atau audio milik Anda atau yang diizinkan untuk disimpan.'
      : 'Download only videos or audio you own or have permission to save.';

  // Settings
  String get settingsTitle => isIndonesian ? 'Pengaturan' : 'Settings';
  String get settingFolder => isIndonesian ? 'Folder simpan' : 'Save folder';
  String get settingWifiOnly => isIndonesian ? 'Hanya Wi-Fi' : 'Wi-Fi Only';
  String get settingWifiOnlySub => isIndonesian
      ? 'Cegah pengunduhan menggunakan kuota seluler'
      : 'Prevent downloads using mobile cellular data';
  String get settingDefaultQuality => isIndonesian ? 'Kualitas bawaan' : 'Default Quality';
  String get settingTheme => isIndonesian ? 'Tema' : 'Theme';
  String get settingThemeSystem => isIndonesian ? 'Ikuti sistem' : 'System';
  String get settingThemeLight => isIndonesian ? 'Terang' : 'Light';
  String get settingThemeDark => isIndonesian ? 'Gelap' : 'Dark';
  String get settingLanguage => isIndonesian ? 'Bahasa' : 'Language';
  String get settingClearData => isIndonesian ? 'Hapus data aplikasi' : 'Clear app data';
  String get settingClearDataSub =>
      isIndonesian ? 'Hapus semua riwayat lokal' : 'Clear all local history';
  String get settingAbout => isIndonesian ? 'Tentang' : 'About';
  String get settingAboutVersion => isIndonesian ? 'Versi aplikasi' : 'App version';
  String get settingAboutGithub => isIndonesian ? 'Tautan GitHub' : 'GitHub Link';
  String get settingPrivacy => isIndonesian ? 'Kebijakan Privasi' : 'Privacy Policy';
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppStrings> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['id', 'en'].contains(locale.languageCode);

  @override
  Future<AppStrings> load(Locale locale) async => AppStrings(locale);

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppStrings> old) => false;
}
