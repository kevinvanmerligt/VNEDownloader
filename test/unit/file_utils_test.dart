import 'package:flutter_test/flutter_test.dart';
import 'package:vnedownloader/core/util/file_utils.dart';
import 'package:vnedownloader/core/util/formatters.dart';

void main() {
  group('FileUtils tests', () {
    test('Sanitizes illegal characters in file names', () {
      const dirty = 'Video/Title: With? Illegal* Characters|"<>! ';
      final clean = FileUtils.sanitizeFileName(dirty);
      expect(clean.contains('/'), isFalse);
      expect(clean.contains(':'), isFalse);
      expect(clean.contains('?'), isFalse);
      expect(clean.contains('*'), isFalse);
      expect(clean.contains('|'), isFalse);
      expect(clean.contains('"'), isFalse);
      expect(clean.contains('<'), isFalse);
      expect(clean.contains('>'), isFalse);
      expect(clean.endsWith('.mp4'), isTrue);
    });

    test('Appends .mp4 extension if missing', () {
      final clean = FileUtils.sanitizeFileName('My Awesome Video');
      expect(clean, equals('My Awesome Video.mp4'));
    });
  });

  group('Formatters tests', () {
    test('Formats file bytes correctly', () {
      expect(Formatters.formatBytes(500), equals('500 B'));
      expect(Formatters.formatBytes(1024), equals('1.0 KB'));
      expect(Formatters.formatBytes(1024 * 1024 * 54), equals('54 MB'));
      expect(Formatters.formatBytes(1024 * 1024 * 1024 * 2), equals('2.0 GB'));
    });

    test('Formats video duration correctly', () {
      expect(Formatters.formatDuration(const Duration(seconds: 45)), equals('00:45'));
      expect(Formatters.formatDuration(const Duration(minutes: 3, seconds: 12)), equals('03:12'));
      expect(Formatters.formatDuration(const Duration(hours: 1, minutes: 2, seconds: 3)), equals('1:02:03'));
    });
  });
}

