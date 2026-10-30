class VideoQuality {
  final String label; // e.g. "360p", "480p", "720p", "1080p"
  final String format; // "mp4"
  final int? approxSizeBytes;
  final bool isMuxed; // Has combined video + audio
  final dynamic streamRef; // Underlying stream info reference

  const VideoQuality({
    required this.label,
    this.format = 'mp4',
    this.approxSizeBytes,
    this.isMuxed = true,
    this.streamRef,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VideoQuality &&
          runtimeType == other.runtimeType &&
          label == other.label &&
          format == other.format;

  @override
  int get hashCode => label.hashCode ^ format.hashCode;
}

