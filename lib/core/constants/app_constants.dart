import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'VNEDownloader';
  static const String appVersion = '1.0.0';
  static const String appSubtitle = 'MP4 & MP3 dari YouTube';
  static const String githubUrl = 'https://github.com/kevinvanmerligt/VNEDownloader';
  static const String defaultDownloadFolder = 'Movies/VNEDownloader';

  // Light Theme Colors (Clean Sky Blue from Design Mockup)
  static const Color primaryColor = Color(0xFF38A2F2);
  static const Color primaryDark = Color(0xFF1E88E5);
  static const Color primaryLight = Color(0xFFE0F2FE);

  // Dark Theme Colors (Halloween Blood Red & Pure Matte Black - No Neon / No AI Slop)
  static const Color darkPrimaryColor = Color(0xFF991B1B); // Rich Blood Red
  static const Color darkPrimaryDark = Color(0xFF7F1D1D);  // Deep Dried Blood Red
  static const Color darkPrimaryLight = Color(0xFF220C10); // Deep Blood Tint
  static const Color darkPrimaryAccent = Color(0xFFDC2626); // Crisp Blood Red Accent

  // Status Colors (Light Theme)
  static const Color statusCompleted = Color(0xFF0284C7);
  static const Color statusCompletedLight = Color(0xFFE0F2FE);
  static const Color statusFailed = Color(0xFFDC2626);
  static const Color statusFailedLight = Color(0xFFFEE2E2);
  static const Color statusDownloading = Color(0xFF38A2F2);
  static const Color statusPaused = Color(0xFFF59E0B);
  static const Color statusPausedLight = Color(0xFFFEF3C7);

  // Status Colors (Dark Theme Halloween Blood Red)
  static const Color darkStatusCompleted = Color(0xFFEF4444);
  static const Color darkStatusCompletedLight = Color(0xFF220C10);
  static const Color darkStatusFailed = Color(0xFFF87171);
  static const Color darkStatusFailedLight = Color(0xFF2A0A0A);

  // Surface Colors (Light Mode: Flat White & Neutral Gray)
  static const Color lightBg = Colors.white;
  static const Color lightCard = Colors.white;
  static const Color lightCardSubtle = Color(0xFFF9FAFB);
  static const Color lightBorder = Color(0xFFE5E7EB);

  // Surface Colors (Dark Mode: Matte Pure Black & Deep Charcoal)
  static const Color darkBg = Color(0xFF0A0A0A);
  static const Color darkCard = Color(0xFF141414);
  static const Color darkCardSubtle = Color(0xFF1A1A1A);
  static const Color darkBorder = Color(0xFF262626);

  // Text Colors
  static const Color textDark = Color(0xFF111827);
  static const Color textMuted = Color(0xFF6B7280);
  static const Color textLight = Color(0xFFF5F5F5);
  static const Color textLightMuted = Color(0xFFA3A3A3);
}
