import 'package:flutter/material.dart';
import 'package:vnedownloader/app/l10n/app_localizations.dart';
import 'package:vnedownloader/core/constants/app_constants.dart';

class HelpAccordion extends StatelessWidget {
  const HelpAccordion({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dividerColor = isDark ? AppConstants.darkBorder : AppConstants.lightBorder;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // "Bantuan" title matching photo
          Text(
            strings.helpTitle,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
              color: isDark ? AppConstants.textLight : AppConstants.textDark,
            ),
          ),
          const SizedBox(height: 4),

          // Flat accordion list with clean dividers matching photo
          Divider(height: 1, thickness: 1, color: dividerColor),
          _buildAccordionItem(
            context,
            question: strings.faq1Question,
            answer: strings.faq1Answer,
            isDark: isDark,
          ),
          Divider(height: 1, thickness: 1, color: dividerColor),
          _buildAccordionItem(
            context,
            question: strings.faq2Question,
            answer: strings.faq2Answer,
            isDark: isDark,
          ),
          Divider(height: 1, thickness: 1, color: dividerColor),
          _buildAccordionItem(
            context,
            question: strings.faq3Question,
            answer: strings.faq3Answer,
            isDark: isDark,
          ),
          Divider(height: 1, thickness: 1, color: dividerColor),

          const SizedBox(height: 14),

          // Footer disclaimer matching photo
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Text(
              strings.footerDisclaimer,
              style: TextStyle(
                fontSize: 12,
                height: 1.4,
                color: isDark ? AppConstants.textLightMuted : const Color(0xFF6B7280),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildAccordionItem(
    BuildContext context, {
    required String question,
    required String answer,
    required bool isDark,
  }) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        trailing: Icon(
          Icons.add_rounded,
          size: 20,
          color: isDark ? AppConstants.textLightMuted : const Color(0xFF6B7280),
        ),
        title: Text(
          question,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? AppConstants.textLight : AppConstants.textDark,
          ),
        ),
        childrenPadding: const EdgeInsets.only(left: 0, right: 8, bottom: 12),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              answer,
              style: TextStyle(
                fontSize: 13,
                height: 1.45,
                color: isDark ? AppConstants.textLightMuted : AppConstants.textMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
