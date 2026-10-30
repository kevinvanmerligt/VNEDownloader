import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:vnedownloader/core/error/failures.dart';
import 'package:vnedownloader/core/util/file_utils.dart';
import 'package:vnedownloader/core/util/notification_service.dart';
import '../domain/download_item.dart';
import '../domain/download_target.dart';

class DownloadService {
  final Map<String, CancelToken> _cancelTokens = {};
  final Map<String, File> _activeFiles = {};
  final Set<String> _cancelledItemIds = {};
  final Connectivity _connectivity = Connectivity();
  late final Dio _dio;

  DownloadService() {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 25),
        receiveTimeout: const Duration(seconds: 120),
        headers: {
          'User-Agent':
              'Mozilla/5.0 (Linux; Android 13; Mobile) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36',
        },
      ),
    );
  }

  Future<bool> isNetworkConnected() async {
    final results = await _connectivity.checkConnectivity();
    return !results.contains(ConnectivityResult.none);
  }

  Future<bool> isWifiConnected() async {
    final results = await _connectivity.checkConnectivity();
    return results.contains(ConnectivityResult.wifi);
  }

  bool isDownloading(String itemId) {
    return _cancelTokens.containsKey(itemId);
  }

  Future<void> startDownload({
    required DownloadItem item,
    required DownloadTarget target,
    required bool onlyWifi,
    String? customFolder,
    required void Function(double progress, int receivedBytes, int totalBytes) onProgress,
    required void Function(String filePath) onComplete,
    required void Function(String error) onError,
  }) async {
    final notifId = item.id.hashCode & 0x7FFFFFFF;
    _cancelledItemIds.remove(item.id);

    try {
      // 1. Check network connectivity
      final connected = await isNetworkConnected();
      if (!connected) {
        throw const NetworkFailure('Tidak ada koneksi internet.');
      }

      // 2. Check Only Wi-Fi restriction
      if (onlyWifi) {
        final onWifi = await isWifiConnected();
        if (!onWifi) {
          throw const WifiOnlyBlockedFailure();
        }
      }

      // 3. Request storage permission on device
      await FileUtils.requestStoragePermission();

      // 4. Prepare directory and target file
      final dir = await FileUtils.getDownloadDirectory(customPath: customFolder);
      final sanitizedName = FileUtils.sanitizeFileName(item.title, extension: target.fileExtension);
      final file = await FileUtils.getAvailableFile(dir, sanitizedName);

      _activeFiles[item.id] = file;
      final cancelToken = CancelToken();
      _cancelTokens[item.id] = cancelToken;

      int lastReportedPercent = -1;
      DateTime lastNotificationTime = DateTime.now().subtract(const Duration(seconds: 2));

      // 5. Try downloading via Dio first for fast native streaming & direct cancellation
      bool downloadSuccess = false;
      try {
        await _dio.download(
          target.downloadUrl.toString(),
          file.path,
          cancelToken: cancelToken,
          deleteOnError: true,
          onReceiveProgress: (received, total) {
            if (_cancelledItemIds.contains(item.id)) return;

            final totalBytes = total > 0 ? total : (target.expectedSizeBytes ?? 0);
            double progress = 0.0;
            if (totalBytes > 0) {
              progress = (received / totalBytes).clamp(0.0, 1.0);
            }

            onProgress(progress, received, totalBytes);

            final percent = (progress * 100).toInt();
            final now = DateTime.now();
            if (percent != lastReportedPercent &&
                (now.difference(lastNotificationTime).inMilliseconds > 800 || percent == 100)) {
              lastReportedPercent = percent;
              lastNotificationTime = now;
              NotificationService.instance.showProgress(notifId, item.title, percent, 100);
            }
          },
        );
        downloadSuccess = true;
      } catch (dioErr) {
        if (cancelToken.isCancelled || _cancelledItemIds.contains(item.id)) {
          _cleanUpCancelled(item.id, file, notifId);
          onError('Unduhan dibatalkan');
          return;
        }

        // Fallback: If Dio failed due to headers, try target.openStream if available
        if (target.openStream != null) {
          final stream = target.openStream!();
          final sink = file.openWrite();
          int receivedBytes = 0;
          final totalBytes = target.expectedSizeBytes ?? 0;

          await for (final chunk in stream) {
            if (_cancelledItemIds.contains(item.id) || cancelToken.isCancelled) {
              await sink.close();
              _cleanUpCancelled(item.id, file, notifId);
              onError('Unduhan dibatalkan');
              return;
            }
            sink.add(chunk);
            receivedBytes += chunk.length;

            double progress = 0.0;
            if (totalBytes > 0) {
              progress = (receivedBytes / totalBytes).clamp(0.0, 1.0);
            }
            onProgress(progress, receivedBytes, totalBytes);

            final percent = (progress * 100).toInt();
            final now = DateTime.now();
            if (percent != lastReportedPercent &&
                (now.difference(lastNotificationTime).inMilliseconds > 800 || percent == 100)) {
              lastReportedPercent = percent;
              lastNotificationTime = now;
              NotificationService.instance.showProgress(notifId, item.title, percent, 100);
            }
          }
          await sink.flush();
          await sink.close();
          downloadSuccess = true;
        } else {
          rethrow;
        }
      }

      if (_cancelledItemIds.contains(item.id)) {
        _cleanUpCancelled(item.id, file, notifId);
        onError('Unduhan dibatalkan');
        return;
      }

      _cancelTokens.remove(item.id);
      _activeFiles.remove(item.id);

      if (downloadSuccess && await file.exists()) {
        await NotificationService.instance.showCompleted(notifId, item.title, file.path);
        onComplete(file.path);
      } else {
        throw const DownloadFailure('Gagal menyimpan file unduhan.');
      }
    } catch (e) {
      _cancelTokens.remove(item.id);
      _activeFiles.remove(item.id);

      if (_cancelledItemIds.contains(item.id)) {
        onError('Unduhan dibatalkan');
        return;
      }

      final errorStr = e is DioException && CancelToken.isCancel(e)
          ? 'Unduhan dibatalkan'
          : e.toString();

      await NotificationService.instance.showFailed(notifId, item.title, errorStr);
      onError(errorStr);
    }
  }

  void cancelDownload(String itemId) {
    _cancelledItemIds.add(itemId);

    if (_cancelTokens.containsKey(itemId)) {
      final token = _cancelTokens.remove(itemId);
      try {
        token?.cancel('Unduhan dibatalkan oleh pengguna');
      } catch (_) {}
    }

    if (_activeFiles.containsKey(itemId)) {
      final file = _activeFiles.remove(itemId);
      if (file != null && file.existsSync()) {
        try {
          file.deleteSync();
        } catch (_) {}
      }
    }

    final notifId = itemId.hashCode & 0x7FFFFFFF;
    NotificationService.instance.cancel(notifId);
  }

  void _cleanUpCancelled(String itemId, File file, int notifId) {
    _cancelTokens.remove(itemId);
    _activeFiles.remove(itemId);
    if (file.existsSync()) {
      try {
        file.deleteSync();
      } catch (_) {}
    }
    NotificationService.instance.cancel(notifId);
  }
}
