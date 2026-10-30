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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            strings.heroTitle,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              height: 1.2,
              letterSpacing: -0.5,
              color: isDark ? AppConstants.textLight : AppConstants.textDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            strings.heroSubtitle,
            style: TextStyle(
              fontSize: 14,
              height: 1.4,
              fontWeight: FontWeight.w400,
              color: isDark ? AppConstants.textLightMuted : AppConstants.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
