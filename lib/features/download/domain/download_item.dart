enum DownloadStatus {
  queued,
  downloading,
  paused,
  completed,
  failed,
}

class DownloadItem {
  final String id;
  final String sourceId;
  final String url;
  final String title;
  final String? thumbnailUrl;
  final String quality;
  final String format;
  final int? sizeBytes;
  final DownloadStatus status;
  final double progress;
  final String? fileUri;
  final String? errorCode;
  final DateTime createdAt;
  final DateTime? completedAt;

  const DownloadItem({
    required this.id,
    required this.sourceId,
    required this.url,
    required this.title,
    this.thumbnailUrl,
    required this.quality,
    this.format = 'mp4',
    this.sizeBytes,
    required this.status,
    this.progress = 0.0,
    this.fileUri,
    this.errorCode,
    required this.createdAt,
    this.completedAt,
  });

  DownloadItem copyWith({
    String? id,
    String? sourceId,
    String? url,
    String? title,
    String? thumbnailUrl,
    String? quality,
    String? format,
    int? sizeBytes,
    DownloadStatus? status,
    double? progress,
    String? fileUri,
    String? errorCode,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return DownloadItem(
      id: id ?? this.id,
      sourceId: sourceId ?? this.sourceId,
      url: url ?? this.url,
      title: title ?? this.title,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      quality: quality ?? this.quality,
      format: format ?? this.format,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      fileUri: fileUri ?? this.fileUri,
      errorCode: errorCode ?? this.errorCode,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sourceId': sourceId,
      'url': url,
      'title': title,
      'thumbnailUrl': thumbnailUrl,
      'quality': quality,
      'format': format,
      'sizeBytes': sizeBytes,
      'status': status.name,
      'progress': progress,
      'fileUri': fileUri,
      'errorCode': errorCode,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  factory DownloadItem.fromMap(Map<String, dynamic> map) {
    return DownloadItem(
      id: map['id'] as String,
      sourceId: map['sourceId'] as String? ?? 'youtube',
      url: map['url'] as String,
      title: map['title'] as String,
      thumbnailUrl: map['thumbnailUrl'] as String?,
      quality: map['quality'] as String? ?? '720p',
      format: map['format'] as String? ?? 'mp4',
      sizeBytes: map['sizeBytes'] as int?,
      status: DownloadStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => DownloadStatus.failed,
      ),
      progress: (map['progress'] as num?)?.toDouble() ?? 0.0,
      fileUri: map['fileUri'] as String?,
      errorCode: map['errorCode'] as String?,
      createdAt: DateTime.tryParse(map['createdAt'] as String? ?? '') ?? DateTime.now(),
      completedAt: map['completedAt'] != null ? DateTime.tryParse(map['completedAt'] as String) : null,
    );
  }
}

