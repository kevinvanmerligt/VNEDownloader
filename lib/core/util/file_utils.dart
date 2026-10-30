import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FileUtils {
  static Future<bool> requestStoragePermission() async {
    if (!Platform.isAndroid) return true;

    try {
      // 1. Notification permission for progress alerts
      await Permission.notification.request();

      // 2. Storage permission depending on Android version
      if (await Permission.videos.status.isGranted ||
          await Permission.storage.status.isGranted) {
        return true;
      }

      final statuses = await [
        Permission.storage,
        Permission.videos,
        Permission.audio,
      ].request();

      final storageGranted = statuses[Permission.storage]?.isGranted ?? false;
      final mediaGranted = (statuses[Permission.videos]?.isGranted ?? false) ||
          (statuses[Permission.audio]?.isGranted ?? false);

      return storageGranted || mediaGranted;
    } catch (_) {
      return true; // Proceed and allow standard app directory fallback
    }
  }

  static String sanitizeFileName(String input, {String extension = 'mp4'}) {
    // Replace illegal filename characters
    String clean = input.replaceAll(RegExp(r'[\\/:*?"<>|\r\n\t]'), '_');
    // Remove repeated spaces or underscores
    clean = clean.replaceAll(RegExp(r'\s+'), ' ').trim();
    // Trim length to avoid filesystem limits (max ~100 chars)
    if (clean.length > 100) {
      clean = clean.substring(0, 100).trim();
    }
    if (clean.isEmpty) {
      clean = 'media_${DateTime.now().millisecondsSinceEpoch}';
    }
    final ext = extension.startsWith('.') ? extension : '.$extension';
    if (!clean.toLowerCase().endsWith(ext.toLowerCase())) {
      clean += ext;
    }
    return clean;
  }

  static Future<Directory> getDownloadDirectory({String? customPath}) async {
    // 1. If user specified custom path
    if (customPath != null && customPath.trim().isNotEmpty) {
      final trimmed = customPath.trim();
      String resolvedPath = trimmed;

      if (Platform.isAndroid && !trimmed.startsWith('/')) {
        // Preset paths like 'Movies/VNEDownloader' or 'Download/VNEDownloader'
        resolvedPath = p.join('/storage/emulated/0', trimmed);
      }

      try {
        final dir = Directory(resolvedPath);
        if (!await dir.exists()) {
          await dir.create(recursive: true);
        }
        // Test writability
        final testFile = File(p.join(dir.path, '.test_write'));
        await testFile.writeAsString('ok');
        await testFile.delete();
        return dir;
      } catch (_) {
        // Fallback below
      }
    }

    // 2. Try default Android public storage (Movies or Download)
    if (Platform.isAndroid) {
      try {
        final publicDirs = [
          Directory('/storage/emulated/0/Download/VNEDownloader'),
          Directory('/storage/emulated/0/Movies/VNEDownloader'),
        ];

        for (final dir in publicDirs) {
          try {
            if (!await dir.exists()) {
              await dir.create(recursive: true);
            }
            final testFile = File(p.join(dir.path, '.test_write'));
            await testFile.writeAsString('ok');
            await testFile.delete();
            return dir;
          } catch (_) {
            continue;
          }
        }
      } catch (_) {
        // Fallback to app-specific external storage
      }

      try {
        final extDir = await getExternalStorageDirectory();
        if (extDir != null) {
          final target = Directory(p.join(extDir.path, 'VNEDownloader'));
          if (!await target.exists()) {
            await target.create(recursive: true);
          }
          return target;
        }
      } catch (_) {}
    }

    // 3. Fallback to standard app documents directory
    final docDir = await getApplicationDocumentsDirectory();
    final fallback = Directory(p.join(docDir.path, 'VNEDownloader'));
    if (!await fallback.exists()) {
      await fallback.create(recursive: true);
    }
    return fallback;
  }

  static Future<File> getAvailableFile(Directory dir, String baseFileName) async {
    String name = p.basenameWithoutExtension(baseFileName);
    String ext = p.extension(baseFileName);
    if (ext.isEmpty) ext = '.mp4';

    File file = File(p.join(dir.path, '$name$ext'));
    int counter = 1;
    while (await file.exists()) {
      file = File(p.join(dir.path, '$name ($counter)$ext'));
      counter++;
    }
    return file;
  }
}
