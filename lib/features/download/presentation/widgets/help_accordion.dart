import 'package:flutter/material.dart';
import 'package:vnedownloader/app/l10n/app_localizations.dart';
import 'package:vnedownloader/core/constants/app_constants.dart';

class HelpAccordion extends StatelessWidget {
  const HelpAccordion({super.key});

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
            strings.helpTitle,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isDark ? AppConstants.textLight : AppConstants.textDark,
            ),
          ),
          const SizedBox(height: 10),

          // Card enclosing the FAQ accordions
          Material(
            color: isDark ? AppConstants.darkCard : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: isDark ? AppConstants.darkBorder : AppConstants.lightBorder,
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Column(
                children: [
                  Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      leading: const Icon(
                        Icons.help_outline_rounded,
                        color: AppConstants.primaryColor,
                        size: 20,
                      ),
                      title: Text(
                        strings.faq1Question,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppConstants.textLight : AppConstants.textDark,
                        ),
                      ),
                      childrenPadding:
                          const EdgeInsets.only(left: 20, right: 20, bottom: 14),
                      children: [
                        Text(
                          strings.faq1Answer,
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.45,
                            color: isDark
                                ? AppConstants.textLightMuted
                                : AppConstants.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: isDark ? AppConstants.darkBorder : AppConstants.lightBorder,
                  ),
                  Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      leading: const Icon(
                        Icons.video_file_outlined,
                        color: AppConstants.primaryColor,
                        size: 20,
                      ),
                      title: Text(
                        strings.faq2Question,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppConstants.textLight : AppConstants.textDark,
                        ),
                      ),
                      childrenPadding:
                          const EdgeInsets.only(left: 20, right: 20, bottom: 14),
                      children: [
                        Text(
                          strings.faq2Answer,
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.45,
                            color: isDark
                                ? AppConstants.textLightMuted
                                : AppConstants.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: isDark ? AppConstants.darkBorder : AppConstants.lightBorder,
                  ),
                  Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      leading: const Icon(
                        Icons.folder_outlined,
                        color: AppConstants.primaryColor,
                        size: 20,
                      ),
                      title: Text(
                        strings.faq3Question,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppConstants.textLight : AppConstants.textDark,
                        ),
                      ),
                      childrenPadding:
                          const EdgeInsets.only(left: 20, right: 20, bottom: 14),
                      children: [
                        Text(
                          strings.faq3Answer,
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.45,
                            color: isDark
                                ? AppConstants.textLightMuted
                                : AppConstants.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Footer disclaimer
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                strings.footerDisclaimer,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: isDark ? AppConstants.textLightMuted : AppConstants.textMuted,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
