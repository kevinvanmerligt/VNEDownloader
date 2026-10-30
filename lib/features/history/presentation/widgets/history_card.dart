import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_filex/open_filex.dart';
import 'package:vnedownloader/app/l10n/app_localizations.dart';
import 'package:vnedownloader/core/constants/app_constants.dart';
import 'package:vnedownloader/core/util/formatters.dart';
import 'package:vnedownloader/features/download/application/download_controller.dart';
import 'package:vnedownloader/features/download/domain/download_item.dart';
import 'package:vnedownloader/features/history/application/history_controller.dart';

class HistoryCard extends ConsumerWidget {
  final DownloadItem item;

  const HistoryCard({super.key, required this.item});

  Future<void> _handleTap(BuildContext context, WidgetRef ref) async {
    final strings = AppStrings.of(context);

    if (item.status == DownloadStatus.completed) {
      if (item.fileUri != null) {
        final file = File(item.fileUri!);
        if (await file.exists()) {
          final result = await OpenFilex.open(item.fileUri!);
          if (result.type != ResultType.done && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Tidak dapat membuka file: ${result.message}'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        } else if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('File tidak ditemukan di penyimpanan.'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } else if (item.status == DownloadStatus.failed) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(strings.statusFailedBadge),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                item.errorCode ?? 'Unduhan gagal karena gangguan jaringan.',
                style: const TextStyle(color: AppConstants.statusFailed),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(strings.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                ref.read(downloadControllerProvider.notifier).retryDownload(item);
              },
              child: Text(strings.retry),
            ),
          ],
        ),
      );
    }
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    final strings = AppStrings.of(context);
    bool deletePhysicalFile = true;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (dialogCtx, setDialogState) => AlertDialog(
          title: Text(strings.confirmDelete),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hapus "${item.title}" dari riwayat?',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 12),
              if (item.fileUri != null)
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  value: deletePhysicalFile,
                  title: Text(
                    strings.deleteFileToo,
                    style: const TextStyle(fontSize: 13),
                  ),
                  onChanged: (val) {
                    setDialogState(() {
                      deletePhysicalFile = val ?? true;
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
                ref.read(historyProvider.notifier).deleteItem(
                      item.id,
                      deleteFile: deletePhysicalFile,
                    );
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
    final isMp3 = item.format.toLowerCase() == 'mp3';

    final infoLine =
        '${item.quality} ${item.format.toUpperCase()} · ${Formatters.formatBytes(item.sizeBytes)} · ${Formatters.formatRelativeDate(item.createdAt)}';

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppConstants.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppConstants.darkBorder : AppConstants.lightBorder,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: () => _handleTap(context, ref),
          onLongPress: () => _showDeleteDialog(context, ref),
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                // Icon file di kiri
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Icon(
                      item.status == DownloadStatus.completed
                          ? (isMp3 ? Icons.music_note_rounded : Icons.play_arrow_rounded)
                          : (item.status == DownloadStatus.failed
                              ? Icons.error_outline_rounded
                              : Icons.downloading_rounded),
                      color: item.status == DownloadStatus.completed
                          ? (isMp3 ? const Color(0xFF10B981) : AppConstants.primaryColor)
                          : (item.status == DownloadStatus.failed
                              ? AppConstants.statusFailed
                              : AppConstants.statusDownloading),
                      size: 26,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Video/Audio info (Title 1 baris, info baris kecil)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppConstants.textLight
                              : AppConstants.textDark,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        infoLine,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.5,
                          color: isDark
                              ? AppConstants.textLightMuted
                              : AppConstants.textMuted,
                        ),
                      ),
                      if (item.status == DownloadStatus.downloading) ...[
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: item.progress > 0 ? item.progress : null,
                            backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                AppConstants.primaryColor),
                            minHeight: 4,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // Lencana status di kanan: Selesai, Mengunduh, Gagal
                _buildStatusBadge(context, ref, strings),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(
      BuildContext context, WidgetRef ref, AppStrings strings) {
    switch (item.status) {
      case DownloadStatus.completed:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: AppConstants.statusCompletedLight,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppConstants.statusCompleted.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Text(
            strings.statusCompletedBadge,
            style: const TextStyle(
              color: AppConstants.statusCompleted,
              fontWeight: FontWeight.w700,
              fontSize: 11,
            ),
          ),
        );

      case DownloadStatus.downloading:
        final percent = (item.progress * 100).toInt();
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppConstants.primaryLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$percent%',
                style: const TextStyle(
                  color: AppConstants.primaryColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close_rounded, size: 16),
              color: Colors.grey,
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () {
                ref
                    .read(downloadControllerProvider.notifier)
                    .cancelDownload(item.id);
              },
            ),
          ],
        );

      case DownloadStatus.failed:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppConstants.statusFailedLight,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppConstants.statusFailed.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: AppConstants.statusFailed,
                    size: 13,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    strings.statusFailedBadge,
                    style: const TextStyle(
                      color: AppConstants.statusFailed,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.refresh_rounded, size: 18),
              color: AppConstants.primaryColor,
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.only(left: 4),
              constraints: const BoxConstraints(),
              onPressed: () {
                ref
                    .read(downloadControllerProvider.notifier)
                    .retryDownload(item);
              },
            ),
          ],
        );

      default:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            strings.statusQueuedBadge,
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        );
    }
  }
}
