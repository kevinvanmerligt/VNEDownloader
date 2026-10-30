import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:vnedownloader/core/error/failures.dart';
import 'package:vnedownloader/core/util/file_utils.dart';
import 'package:vnedownloader/core/util/notification_service.dart';
import '../domain/download_item.dart';
import '../domain/download_target.dart';

class DownloadService {
  final Map<String, StreamSubscription> _activeSubscriptions = {};
  final Map<String, IOSink> _activeSinks = {};
  final Map<String, File> _activeFiles = {};
  final Connectivity _connectivity = Connectivity();

  Future<bool> isNetworkConnected() async {
    final results = await _connectivity.checkConnectivity();
    return !results.contains(ConnectivityResult.none);
  }

  Future<bool> isWifiConnected() async {
    final results = await _connectivity.checkConnectivity();
    return results.contains(ConnectivityResult.wifi);
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

    try {
      // 1. Check network
      final connected = await isNetworkConnected();
      if (!connected) {
        throw const NetworkFailure('Tidak ada koneksi internet.');
      }

      // 2. Check Only Wi-Fi
      if (onlyWifi) {
        final onWifi = await isWifiConnected();
        if (!onWifi) {
          throw const WifiOnlyBlockedFailure();
        }
      }

      // 3. Prepare directory and target file
      final dir = await FileUtils.getDownloadDirectory(customPath: customFolder);
      final sanitizedName = FileUtils.sanitizeFileName(item.title, extension: target.fileExtension);
      final file = await FileUtils.getAvailableFile(dir, sanitizedName);

      _activeFiles[item.id] = file;
      final sink = file.openWrite();
      _activeSinks[item.id] = sink;

      final stream = target.openStream != null
          ? target.openStream!()
          : null;

      if (stream == null) {
        throw const DownloadFailure('Gagal membuka aliran video untuk diunduh.');
      }

      int receivedBytes = 0;
      final totalBytes = target.expectedSizeBytes ?? item.sizeBytes ?? 0;
      int lastReportedPercent = -1;
      DateTime lastNotificationTime = DateTime.now().subtract(const Duration(seconds: 2));

      final completer = Completer<void>();

      final subscription = stream.listen(
        (chunk) {
          sink.add(chunk);
          receivedBytes += chunk.length;

          double progress = 0.0;
          if (totalBytes > 0) {
            progress = (receivedBytes / totalBytes).clamp(0.0, 1.0);
          }

          onProgress(progress, receivedBytes, totalBytes);

          // Update notification throttling
          final percent = (progress * 100).toInt();
          final now = DateTime.now();
          if (percent != lastReportedPercent &&
              (now.difference(lastNotificationTime).inMilliseconds > 800 || percent == 100)) {
            lastReportedPercent = percent;
            lastNotificationTime = now;
            NotificationService.instance.showProgress(notifId, item.title, percent, 100);
          }
        },
        onDone: () async {
          await sink.flush();
          await sink.close();
          _activeSinks.remove(item.id);
          _activeSubscriptions.remove(item.id);
          _activeFiles.remove(item.id);

          await NotificationService.instance.showCompleted(notifId, item.title, file.path);
          onComplete(file.path);
          if (!completer.isCompleted) completer.complete();
        },
        onError: (err) async {
          await sink.close();
          _activeSinks.remove(item.id);
          _activeSubscriptions.remove(item.id);
          _activeFiles.remove(item.id);

          final errorStr = err.toString();
          await NotificationService.instance.showFailed(notifId, item.title, errorStr);
          onError(errorStr);
          if (!completer.isCompleted) completer.completeError(err);
        },
        cancelOnError: true,
      );

      _activeSubscriptions[item.id] = subscription;
      await completer.future;
    } catch (e) {
      await NotificationService.instance.showFailed(notifId, item.title, e.toString());
      onError(e.toString());
    }
  }

  void cancelDownload(String itemId) {
    if (_activeSubscriptions.containsKey(itemId)) {
      _activeSubscriptions[itemId]?.cancel();
      _activeSubscriptions.remove(itemId);
    }
    if (_activeSinks.containsKey(itemId)) {
      _activeSinks[itemId]?.close();
      _activeSinks.remove(itemId);
    }
    if (_activeFiles.containsKey(itemId)) {
      final file = _activeFiles[itemId];
      if (file != null && file.existsSync()) {
        try {
          file.deleteSync();
        } catch (_) {}
      }
      _activeFiles.remove(itemId);
    }
    final notifId = itemId.hashCode & 0x7FFFFFFF;
    NotificationService.instance.cancel(notifId);
  }
}
