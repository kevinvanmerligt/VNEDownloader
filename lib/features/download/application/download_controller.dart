import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:vnedownloader/core/error/failures.dart';
import 'package:vnedownloader/core/util/url_validator.dart';
import 'package:vnedownloader/sources/video_source.dart';
import 'package:vnedownloader/sources/youtube/youtube_source.dart';
import 'package:vnedownloader/features/download/data/download_service.dart';
import 'package:vnedownloader/features/download/domain/download_item.dart';
import 'package:vnedownloader/features/download/domain/video_info.dart';
import 'package:vnedownloader/features/download/domain/video_quality.dart';
import 'package:vnedownloader/features/history/application/history_controller.dart';
import 'package:vnedownloader/features/settings/application/settings_controller.dart';

final videoSourceProvider = Provider<VideoSource>((ref) {
  return YoutubeSource();
});

final downloadServiceProvider = Provider<DownloadService>((ref) {
  return DownloadService();
});

class DownloadState {
  final bool isChecking;
  final String? inputUrl;
  final VideoInfo? checkedVideo;
  final String? errorMessage;
  final Map<String, DownloadItem> activeDownloads;

  const DownloadState({
    this.isChecking = false,
    this.inputUrl,
    this.checkedVideo,
    this.errorMessage,
    this.activeDownloads = const {},
  });

  DownloadState copyWith({
    bool? isChecking,
    String? inputUrl,
    VideoInfo? checkedVideo,
    String? errorMessage,
    bool clearCheckedVideo = false,
    bool clearError = false,
    Map<String, DownloadItem>? activeDownloads,
  }) {
    return DownloadState(
      isChecking: isChecking ?? this.isChecking,
      inputUrl: inputUrl ?? this.inputUrl,
      checkedVideo: clearCheckedVideo ? null : (checkedVideo ?? this.checkedVideo),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      activeDownloads: activeDownloads ?? this.activeDownloads,
    );
  }
}

class DownloadController extends StateNotifier<DownloadState> {
  final VideoSource _videoSource;
  final DownloadService _downloadService;
  final Ref _ref;
  final Set<String> _pendingRetries = {};

  DownloadController({
    required VideoSource videoSource,
    required DownloadService downloadService,
    required Ref ref,
  })  : _videoSource = videoSource,
        _downloadService = downloadService,
        _ref = ref,
        super(const DownloadState());

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  void clearCheckedVideo() {
    state = state.copyWith(clearCheckedVideo: true);
  }

  Future<VideoInfo?> checkUrl(String url) async {
    final trimmed = url.trim();
    if (trimmed.isEmpty) {
      state = state.copyWith(
        errorMessage: 'Masukkan tautan video YouTube terlebih dahulu.',
        clearCheckedVideo: true,
      );
      return null;
    }

    if (!UrlValidator.isYouTubeUrl(trimmed)) {
      state = state.copyWith(
        errorMessage: 'Tautan tidak dikenali. Pastikan itu tautan video YouTube.',
        clearCheckedVideo: true,
      );
      return null;
    }

    state = state.copyWith(isChecking: true, clearError: true, clearCheckedVideo: true);

    try {
      final uri = Uri.parse(trimmed);
      final videoInfo = await _videoSource.fetchInfo(uri);
      state = state.copyWith(
        isChecking: false,
        checkedVideo: videoInfo,
        inputUrl: trimmed,
        clearError: true,
      );
      return videoInfo;
    } on AppFailure catch (e) {
      state = state.copyWith(
        isChecking: false,
        errorMessage: e.message,
        clearCheckedVideo: true,
      );
      return null;
    } catch (e) {
      state = state.copyWith(
        isChecking: false,
        errorMessage: 'Terjadi kesalahan: ${e.toString()}',
        clearCheckedVideo: true,
      );
      return null;
    }
  }

  Future<void> startDownload(
    VideoInfo info,
    VideoQuality quality, {
    String? existingItemId,
  }) async {
    final settings = _ref.read(settingsProvider);
    final historyNotifier = _ref.read(historyProvider.notifier);
    final itemId = existingItemId ?? const Uuid().v4();

    // Prevent duplicate download of the exact same item ID
    if (state.activeDownloads.containsKey(itemId) ||
        _downloadService.isDownloading(itemId)) {
      return;
    }

    var item = DownloadItem(
      id: itemId,
      sourceId: _videoSource.id,
      url: info.originalUrl.toString(),
      title: info.title,
      thumbnailUrl: info.thumbnailUrl,
      quality: quality.label,
      format: quality.format,
      sizeBytes: quality.approxSizeBytes,
      status: DownloadStatus.downloading,
      progress: 0.0,
      createdAt: DateTime.now(),
    );

    // Add to active downloads state & history
    final updatedMap = Map<String, DownloadItem>.from(state.activeDownloads);
    updatedMap[itemId] = item;
    state = state.copyWith(activeDownloads: updatedMap);
    await historyNotifier.saveOrUpdate(item);

    try {
      final target = await _videoSource.resolve(info, quality);

      await _downloadService.startDownload(
        item: item,
        target: target,
        onlyWifi: settings.onlyWifi,
        customFolder: settings.saveFolder,
        onProgress: (progress, received, total) {
          if (!state.activeDownloads.containsKey(itemId)) return;

          item = item.copyWith(
            progress: progress,
            sizeBytes: total > 0 ? total : item.sizeBytes,
            status: DownloadStatus.downloading,
          );
          final currentMap = Map<String, DownloadItem>.from(state.activeDownloads);
          currentMap[itemId] = item;
          state = state.copyWith(activeDownloads: currentMap);
        },
        onComplete: (filePath) async {
          item = item.copyWith(
            status: DownloadStatus.completed,
            progress: 1.0,
            fileUri: filePath,
            completedAt: DateTime.now(),
          );
          final currentMap = Map<String, DownloadItem>.from(state.activeDownloads);
          currentMap.remove(itemId);
          state = state.copyWith(activeDownloads: currentMap);

          await historyNotifier.updateItem(item);
        },
        onError: (error) async {
          item = item.copyWith(
            status: DownloadStatus.failed,
            errorCode: error,
            completedAt: DateTime.now(),
          );
          final currentMap = Map<String, DownloadItem>.from(state.activeDownloads);
          currentMap.remove(itemId);
          state = state.copyWith(activeDownloads: currentMap);

          await historyNotifier.updateItem(item);
        },
      );
    } catch (e) {
      item = item.copyWith(
        status: DownloadStatus.failed,
        errorCode: e.toString(),
        completedAt: DateTime.now(),
      );
      final currentMap = Map<String, DownloadItem>.from(state.activeDownloads);
      currentMap.remove(itemId);
      state = state.copyWith(activeDownloads: currentMap);
      await historyNotifier.updateItem(item);
    }
  }

  Future<void> retryDownload(DownloadItem item) async {
    // 1. Debounce and prevent duplicate retry requests
    if (_pendingRetries.contains(item.id) ||
        state.activeDownloads.containsKey(item.id) ||
        _downloadService.isDownloading(item.id)) {
      return;
    }

    _pendingRetries.add(item.id);

    try {
      final info = await checkUrl(item.url);
      if (info != null) {
        VideoQuality? targetQuality;
        for (final q in info.availableQualities) {
          if (q.label == item.quality) {
            targetQuality = q;
            break;
          }
        }
        targetQuality ??= info.availableQualities.isNotEmpty
            ? info.availableQualities.first
            : null;

        if (targetQuality != null) {
          // Pass the existing item.id so we NEVER create multiple duplicate items!
          await startDownload(info, targetQuality, existingItemId: item.id);
        }
      }
    } finally {
      _pendingRetries.remove(item.id);
    }
  }

  void cancelDownload(String id) {
    _downloadService.cancelDownload(id);

    final currentMap = Map<String, DownloadItem>.from(state.activeDownloads);
    final cancelledItem = currentMap.remove(id);
    state = state.copyWith(activeDownloads: currentMap);

    if (cancelledItem != null) {
      final updated = cancelledItem.copyWith(
        status: DownloadStatus.failed,
        errorCode: 'Unduhan dibatalkan',
        completedAt: DateTime.now(),
      );
      _ref.read(historyProvider.notifier).updateItem(updated);
    }
  }
}

final downloadControllerProvider =
    StateNotifierProvider<DownloadController, DownloadState>((ref) {
  final videoSource = ref.watch(videoSourceProvider);
  final downloadService = ref.watch(downloadServiceProvider);
  return DownloadController(
    videoSource: videoSource,
    downloadService: downloadService,
    ref: ref,
  );
});
