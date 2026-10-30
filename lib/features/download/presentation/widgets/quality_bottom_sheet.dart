import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vnedownloader/app/l10n/app_localizations.dart';
import 'package:vnedownloader/core/constants/app_constants.dart';
import 'package:vnedownloader/core/util/formatters.dart';
import 'package:vnedownloader/features/download/application/download_controller.dart';
import 'package:vnedownloader/features/download/domain/video_info.dart';
import 'package:vnedownloader/features/download/domain/video_quality.dart';

class QualityBottomSheet extends ConsumerStatefulWidget {
  final VideoInfo videoInfo;

  const QualityBottomSheet({super.key, required this.videoInfo});

  @override
  ConsumerState<QualityBottomSheet> createState() => _QualityBottomSheetState();
}

class _QualityBottomSheetState extends ConsumerState<QualityBottomSheet> {
  VideoQuality? _selectedQuality;

  @override
  void initState() {
    super.initState();
    if (widget.videoInfo.availableQualities.isNotEmpty) {
      _selectedQuality = widget.videoInfo.availableQualities.first;
    }
  }

  void _handleDownload() {
    if (_selectedQuality == null) return;
    Navigator.of(context).pop();

    ref.read(downloadControllerProvider.notifier).startDownload(
          widget.videoInfo,
          _selectedQuality!,
        );

    final isAudio = _selectedQuality!.format.toLowerCase() == 'mp3';
    final primaryColor = Theme.of(context).colorScheme.primary;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isAudio
              ? 'Mulai mengunduh audio MP3: ${widget.videoInfo.title}'
              : 'Mulai mengunduh video: ${widget.videoInfo.title}',
        ),
        backgroundColor: primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final info = widget.videoInfo;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppConstants.darkCard : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
        border: Border(
          top: BorderSide(
            color: isDark ? AppConstants.darkBorder : AppConstants.lightBorder,
            width: 1,
          ),
        ),
      ),
      padding: EdgeInsets.only(
        top: 12,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).padding.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF333333) : const Color(0xFFD1D5DB),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Title
          Text(
            strings.selectQualityTitle,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: isDark ? AppConstants.textLight : AppConstants.textDark,
            ),
          ),
          const SizedBox(height: 14),

          // Video Preview Header
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark ? AppConstants.darkCardSubtle : const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? AppConstants.darkBorder : AppConstants.lightBorder,
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Thumbnail
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: info.thumbnailUrl != null
                      ? Image.network(
                          info.thumbnailUrl!,
                          width: 90,
                          height: 56,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 90,
                            height: 56,
                            color: isDark ? const Color(0xFF222222) : Colors.grey[300],
                            child: const Icon(Icons.movie_creation_outlined,
                                color: Colors.white70),
                          ),
                        )
                      : Container(
                          width: 90,
                          height: 56,
                          color: isDark ? const Color(0xFF222222) : Colors.grey[300],
                          child: const Icon(Icons.movie_creation_outlined,
                              color: Colors.white70),
                        ),
                ),
                const SizedBox(width: 10),
                // Video Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        info.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          height: 1.25,
                          color: isDark ? AppConstants.textLight : AppConstants.textDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              info.author,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11.5,
                                color: isDark
                                    ? AppConstants.textLightMuted
                                    : AppConstants.textMuted,
                              ),
                            ),
                          ),
                          if (info.duration != null) ...[
                            const SizedBox(width: 6),
                            Text(
                              '• ${Formatters.formatDuration(info.duration)}',
                              style: TextStyle(
                                fontSize: 11.5,
                                color: isDark
                                    ? AppConstants.textLightMuted
                                    : AppConstants.textMuted,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Quality Options List Header
          Text(
            strings.approxSize,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: isDark ? AppConstants.textLightMuted : AppConstants.textMuted,
            ),
          ),
          const SizedBox(height: 8),

          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 250),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: info.availableQualities.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final quality = info.availableQualities[index];
                final isSelected = _selectedQuality == quality;
                final isMp3 = quality.format.toLowerCase() == 'mp3';
                final sizeStr = quality.approxSizeBytes != null
                    ? Formatters.formatBytes(quality.approxSizeBytes)
                    : '~ ? MB';

                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedQuality = quality;
                    });
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (isDark
                              ? AppConstants.darkPrimaryLight
                              : AppConstants.primaryLight)
                          : (isDark ? AppConstants.darkCardSubtle : Colors.white),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? primaryColor
                            : (isDark ? AppConstants.darkBorder : AppConstants.lightBorder),
                        width: isSelected ? 1.6 : 1.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isSelected
                              ? Icons.radio_button_checked_rounded
                              : Icons.radio_button_off_rounded,
                          color: isSelected
                              ? primaryColor
                              : (isDark ? Colors.grey[600] : Colors.grey[400]),
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Icon(
                          isMp3
                              ? Icons.music_note_rounded
                              : Icons.videocam_rounded,
                          color: isMp3
                              ? const Color(0xFF10B981)
                              : primaryColor,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        // Quality Label
                        Expanded(
                          child: Row(
                            children: [
                              Text(
                                quality.label,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? AppConstants.textLight : AppConstants.textDark,
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Format Badge
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: isMp3
                                      ? (isDark ? const Color(0xFF0F291E) : const Color(0xFFD1FAE5))
                                      : (isDark ? const Color(0xFF262626) : const Color(0xFFE5E7EB)),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  quality.format.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: isMp3
                                        ? const Color(0xFF10B981)
                                        : (isDark ? Colors.grey[300] : Colors.grey[700]),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Estimated Size
                        Text(
                          sizeStr,
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? primaryColor
                                : (isDark
                                    ? AppConstants.textLightMuted
                                    : AppConstants.textMuted),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 18),

          // Download Action Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: _selectedQuality != null ? _handleDownload : null,
              icon: Icon(
                _selectedQuality?.format.toLowerCase() == 'mp3'
                    ? Icons.audio_file_rounded
                    : Icons.download_rounded,
                size: 20,
              ),
              label: Text(strings.downloadAction),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
