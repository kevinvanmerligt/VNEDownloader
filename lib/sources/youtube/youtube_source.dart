import 'dart:async';
import 'dart:io';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as yt_lib;
import 'package:vnedownloader/core/error/failures.dart';
import 'package:vnedownloader/core/util/url_validator.dart';
import 'package:vnedownloader/features/download/domain/download_target.dart';
import 'package:vnedownloader/features/download/domain/video_info.dart';
import 'package:vnedownloader/features/download/domain/video_quality.dart';
import '../video_source.dart';

class YoutubeSource implements VideoSource {
  @override
  String get id => 'youtube';

  @override
  bool canHandle(Uri url) {
    return UrlValidator.isYouTubeUrl(url.toString());
  }

  @override
  Future<VideoInfo> fetchInfo(Uri url) async {
    final videoIdStr = UrlValidator.extractVideoId(url.toString());
    if (videoIdStr == null) {
      throw const InvalidUrlFailure();
    }

    final yt = yt_lib.YoutubeExplode();
    try {
      final videoId = yt_lib.VideoId(videoIdStr);
      final video = await yt.videos.get(videoId);

      yt_lib.StreamManifest manifest;
      try {
        manifest = await yt.videos.streamsClient.getManifest(videoId);
      } catch (e) {
        if (e is yt_lib.VideoRequiresPurchaseException ||
            e is yt_lib.VideoUnplayableException) {
          throw VideoRestrictedFailure(
              'Video tidak dapat diunduh: ${e.toString()}');
        }
        rethrow;
      }

      final qualities = <VideoQuality>[];
      final seenLabels = <String>{};

      // 1. Add muxed streams (both video & audio included, usually 360p, 720p)
      final muxedStreams = manifest.muxed.sortByVideoQuality();
      for (final stream in muxedStreams) {
        final label = stream.qualityLabel;
        if (!seenLabels.contains(label)) {
          seenLabels.add(label);
          qualities.add(VideoQuality(
            label: label,
            format: 'mp4',
            approxSizeBytes: stream.size.totalBytes,
            isMuxed: true,
            streamRef: stream,
          ));
        }
      }

      // 2. Add video streams (e.g. 1080p, 480p) if not already present
      final videoStreams = manifest.video.sortByVideoQuality();
      for (final stream in videoStreams) {
        final label = stream.qualityLabel;
        if (!seenLabels.contains(label)) {
          seenLabels.add(label);
          qualities.add(VideoQuality(
            label: label,
            format: 'mp4',
            approxSizeBytes: stream.size.totalBytes,
            isMuxed: stream is yt_lib.MuxedStreamInfo,
            streamRef: stream,
          ));
        }
      }

      // Sort video qualities by resolution descending (1080p, 720p, 480p, 360p)
      qualities.sort((a, b) {
        final resA = int.tryParse(a.label.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
        final resB = int.tryParse(b.label.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
        return resB.compareTo(resA);
      });

      // 3. Add High Quality MP3 Audio option
      final audioStreams = manifest.audioOnly.sortByBitrate();
      if (audioStreams.isNotEmpty) {
        final bestAudio = audioStreams.withHighestBitrate();
        final kbps = bestAudio.bitrate.kiloBitsPerSecond.round();
        qualities.add(VideoQuality(
          label: 'Audio MP3 ($kbps kbps)',
          format: 'mp3',
          approxSizeBytes: bestAudio.size.totalBytes,
          isMuxed: false,
          streamRef: bestAudio,
        ));
      }

      if (qualities.isEmpty) {
        throw const VideoRestrictedFailure(
            'Tidak ditemukan format video atau audio yang dapat diunduh untuk video ini.');
      }

      return VideoInfo(
        id: videoIdStr,
        title: video.title,
        author: video.author,
        duration: video.duration,
        thumbnailUrl: video.thumbnails.highResUrl,
        originalUrl: url,
        availableQualities: qualities,
        description: video.description,
      );
    } on SocketException {
      throw const NetworkFailure();
    } on AppFailure {
      rethrow;
    } catch (e) {
      final msg = e.toString().toLowerCase();
      if (msg.contains('private') ||
          msg.contains('copyright') ||
          msg.contains('restricted') ||
          msg.contains('member') ||
          msg.contains('purchase')) {
        throw const VideoRestrictedFailure(
            'Video privat, berbayar, atau dilindungi hak cipta.');
      }
      throw DownloadFailure('Gagal memeriksa tautan video: ${e.toString()}');
    } finally {
      yt.close();
    }
  }

  @override
  Future<DownloadTarget> resolve(VideoInfo info, VideoQuality quality) async {
    final isMp3 = quality.format.toLowerCase() == 'mp3';
    final ext = isMp3 ? 'mp3' : 'mp4';

    final streamInfo = quality.streamRef;
    if (streamInfo is yt_lib.StreamInfo) {
      return DownloadTarget(
        downloadUrl: streamInfo.url,
        fileExtension: ext,
        expectedSizeBytes: streamInfo.size.totalBytes,
        openStream: () {
          final yt = yt_lib.YoutubeExplode();
          return yt.videos.streamsClient.get(streamInfo);
        },
      );
    }

    // If streamRef is not set directly, fetch fresh manifest
    final yt = yt_lib.YoutubeExplode();
    try {
      final videoId = yt_lib.VideoId(info.id);
      final manifest = await yt.videos.streamsClient.getManifest(videoId);
      yt_lib.StreamInfo? selectedStream;

      if (isMp3) {
        selectedStream = manifest.audioOnly.withHighestBitrate();
      } else {
        for (final s in manifest.muxed) {
          if (s.qualityLabel == quality.label) {
            selectedStream = s;
            break;
          }
        }
        selectedStream ??= manifest.muxed.withHighestBitrate();
      }

      return DownloadTarget(
        downloadUrl: selectedStream.url,
        fileExtension: ext,
        expectedSizeBytes: selectedStream.size.totalBytes,
        openStream: () {
          final client = yt_lib.YoutubeExplode();
          return client.videos.streamsClient.get(selectedStream!);
        },
      );
    } finally {
      yt.close();
    }
  }
}
