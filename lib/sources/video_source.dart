import '../features/download/domain/download_target.dart';
import '../features/download/domain/video_info.dart';
import '../features/download/domain/video_quality.dart';

abstract class VideoSource {
  String get id;
  bool canHandle(Uri url);
  Future<VideoInfo> fetchInfo(Uri url);
  Future<DownloadTarget> resolve(VideoInfo info, VideoQuality quality);
}

