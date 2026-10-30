import 'package:intl/intl.dart';

class Formatters {
  static String formatBytes(int? bytes) {
    if (bytes == null || bytes <= 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    int i = 0;
    double size = bytes.toDouble();
    while (size >= 1024 && i < suffixes.length - 1) {
      size /= 1024;
      i++;
    }
    return '${size.toStringAsFixed(size < 10 && i > 0 ? 1 : 0)} ${suffixes[i]}';
  }

  static String formatDuration(Duration? duration) {
    if (duration == null) return '00:00';
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    final minStr = minutes.toString().padLeft(2, '0');
    final secStr = seconds.toString().padLeft(2, '0');

    if (hours > 0) {
      return '$hours:$minStr:$secStr';
    }
    return '$minStr:$secStr';
  }

  static String formatRelativeDate(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);
    final timeStr = DateFormat('HH:mm').format(dateTime);

    final difference = today.difference(date).inDays;
    if (difference == 0) {
      return 'Hari ini, $timeStr';
    } else if (difference == 1) {
      return 'Kemarin, $timeStr';
    } else if (difference < 7) {
      final dayName = DateFormat('EEEE', 'id_ID').format(dateTime);
      return '$dayName, $timeStr';
    } else {
      return '${DateFormat('d MMM yyyy', 'id_ID').format(dateTime)}, $timeStr';
    }
  }
}

