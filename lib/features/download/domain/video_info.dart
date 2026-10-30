import 'video_quality.dart';

class VideoInfo {
  final String id;
  final String title;
  final String author;
  final Duration? duration;
  final String? thumbnailUrl;
  final Uri originalUrl;
  final List<VideoQuality> availableQualities;
  final String? description;

  const VideoInfo({
    required this.id,
    required this.title,
    required this.author,
    this.duration,
    this.thumbnailUrl,
    required this.originalUrl,
    this.availableQualities = const [],
    this.description,
  });
}

