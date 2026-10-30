import 'package:flutter/material.dart';
import 'package:vnedownloader/app/l10n/app_localizations.dart';
import 'package:vnedownloader/core/constants/app_constants.dart';

class DownloadHero extends StatelessWidget {
  const DownloadHero({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            strings.heroTitle,
            style: TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.w800,
              height: 1.18,
              letterSpacing: -0.6,
              color: isDark ? AppConstants.textLight : AppConstants.textDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            strings.heroSubtitle,
            style: TextStyle(
              fontSize: 13.5,
              height: 1.4,
              fontWeight: FontWeight.w400,
              color: isDark ? AppConstants.textLightMuted : const Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }
}
