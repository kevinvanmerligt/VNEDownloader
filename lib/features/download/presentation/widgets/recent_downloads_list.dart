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
          // Section header with title & count matching photo
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                strings.recentDownloads,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                  color: isDark ? AppConstants.textLight : AppConstants.textDark,
                ),
              ),
              Text(
                strings.filesCount(allHistory.length),
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppConstants.textLightMuted : AppConstants.textMuted,
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
