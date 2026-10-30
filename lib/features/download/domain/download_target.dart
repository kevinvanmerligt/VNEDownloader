class DownloadTarget {
  final Uri? downloadUrl;
  final String fileExtension;
  final int? expectedSizeBytes;
  final Stream<List<int>> Function()? openStream;

  const DownloadTarget({
    this.downloadUrl,
    this.fileExtension = 'mp4',
    this.expectedSizeBytes,
    this.openStream,
  });
}

