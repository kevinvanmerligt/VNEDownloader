import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class FileUtils {
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
      clean = 'video_${DateTime.now().millisecondsSinceEpoch}';
    }
    final ext = extension.startsWith('.') ? extension : '.$extension';
    if (!clean.toLowerCase().endsWith(ext.toLowerCase())) {
      clean += ext;
    }
    return clean;
  }

  static Future<Directory> getDownloadDirectory({String? customPath}) async {
    if (customPath != null && customPath.isNotEmpty) {
      final customDir = Directory(customPath);
      if (await customDir.exists()) {
        return customDir;
      }
    }

    if (Platform.isAndroid) {
      // In Android, try public Movies directory or external storage
      try {
        final moviesDir = Directory('/storage/emulated/0/Movies/VNEDownloader');
        if (!await moviesDir.exists()) {
          await moviesDir.create(recursive: true);
        }
        return moviesDir;
      } catch (_) {
        // Fallback to app external or documents directory
        final extDir = await getExternalStorageDirectory();
        if (extDir != null) {
          final target = Directory(p.join(extDir.path, 'Movies', 'VNEDownloader'));
          if (!await target.exists()) {
            await target.create(recursive: true);
          }
          return target;
        }
      }
    }

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

