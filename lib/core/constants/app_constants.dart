import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'VNEDownloader';
  static const String appVersion = '1.0.0';
  static const String appSubtitle = 'MP4 & MP3 dari YouTube';
  static const String githubUrl = 'https://github.com/kevinvanmerligt/VNEDownloader';
  static const String defaultDownloadFolder = 'Movies/VNEDownloader';

  // Accent and Brand Colors (Sky Blue #3BA3F0)
  static const Color primaryColor = Color(0xFF3BA3F0);
  static const Color primaryDark = Color(0xFF1D82D2);
  static const Color primaryLight = Color(0xFFE0F2FE);

  // Status Colors
  static const Color statusActive = Color(0xFF10B981); // Emerald / Green
  static const Color statusActiveLight = Color(0xFFD1FAE5);
  static const Color statusCompleted = Color(0xFF0284C7); // Blue
  static const Color statusCompletedLight = Color(0xFFE0F2FE);
  static const Color statusFailed = Color(0xFFEF4444); // Red
  static const Color statusFailedLight = Color(0xFFFEE2E2);
  static const Color statusDownloading = Color(0xFF3BA3F0);
  static const Color statusPaused = Color(0xFFF59E0B);
  static const Color statusPausedLight = Color(0xFFFEF3C7);

  // Surface Colors
  static const Color lightBg = Color(0xFFF8FAFC);
  static const Color lightCard = Colors.white;
  static const Color lightBorder = Color(0xFFE2E8F0);

  static const Color darkBg = Color(0xFF0F172A);
  static const Color darkCard = Color(0xFF1E293B);
  static const Color darkBorder = Color(0xFF334155);

  // Text Colors
  static const Color textDark = Color(0xFF0F172A);
  static const Color textMuted = Color(0xFF64748B);
  static const Color textLight = Color(0xFFF8FAFC);
  static const Color textLightMuted = Color(0xFF94A3B8);
}
