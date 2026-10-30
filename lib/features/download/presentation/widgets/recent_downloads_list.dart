import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vnedownloader/app/l10n/app_localizations.dart';
import 'package:vnedownloader/core/constants/app_constants.dart';
import 'package:vnedownloader/features/history/application/history_controller.dart';
import 'package:vnedownloader/features/history/presentation/widgets/history_card.dart';

class RecentDownloadsList extends ConsumerWidget {
  const RecentDownloadsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppStrings.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final allHistory = ref.watch(historyProvider);

    if (allHistory.isEmpty) {
      return const SizedBox.shrink();
    }

    final recentItems = allHistory.take(3).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header with title & counter
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                strings.recentDownloads,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppConstants.textLight : AppConstants.textDark,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  strings.filesCount(allHistory.length),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppConstants.textLightMuted : AppConstants.textMuted,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // List of cards
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recentItems.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              return HistoryCard(item: recentItems[index]);
            },
          ),
        ],
      ),
    );
  }
}
