import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vnedownloader/app/l10n/app_localizations.dart';
import 'package:vnedownloader/core/constants/app_constants.dart';
import 'package:vnedownloader/features/history/application/history_controller.dart';
import 'widgets/history_card.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  void _confirmClearAll(BuildContext context, WidgetRef ref) {
    final strings = AppStrings.of(context);
    bool deleteFiles = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (dialogCtx, setDialogState) => AlertDialog(
          title: Text(strings.clearAllHistory),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                strings.clearAllConfirm,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 12),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: deleteFiles,
                title: Text(
                  strings.deleteFileToo,
                  style: const TextStyle(fontSize: 13),
                ),
                onChanged: (val) {
                  setDialogState(() {
                    deleteFiles = val ?? false;
                  });
                },
              ),
            ],
          ),
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
                ref.read(historyProvider.notifier).clearAll(deleteFiles: deleteFiles);
              },
              child: Text(strings.delete),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppStrings.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final historyItems = ref.watch(historyProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          strings.navHistory,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: isDark ? AppConstants.textLight : AppConstants.textDark,
          ),
        ),
        actions: [
          if (historyItems.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined),
              tooltip: strings.clearAllHistory,
              color: isDark ? AppConstants.textLightMuted : AppConstants.textMuted,
              onPressed: () => _confirmClearAll(context, ref),
            ),
        ],
      ),
      body: historyItems.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF1E293B)
                            : const Color(0xFFF1F5F9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.history_rounded,
                        size: 44,
                        color: isDark ? Colors.grey[600] : Colors.grey[400],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      strings.emptyHistory,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? AppConstants.textLight
                            : AppConstants.textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      strings.emptyHistorySub,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.4,
                        color: isDark
                            ? AppConstants.textLightMuted
                            : AppConstants.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : RefreshIndicator(
              onRefresh: () async {
                await ref.read(historyProvider.notifier).loadHistory();
              },
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                itemCount: historyItems.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  return HistoryCard(item: historyItems[index]);
                },
              ),
            ),
    );
  }
}
