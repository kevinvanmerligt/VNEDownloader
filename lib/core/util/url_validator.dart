class UrlValidator {
  static final RegExp _youtubeRegex = RegExp(
    r'^(?:https?:\/\/)?(?:www\.|m\.)?(?:youtube\.com\/(?:watch\?.*v=|shorts\/)|youtu\.be\/)([a-zA-Z0-9_-]{11})',
    caseSensitive: false,
  );

  static bool isYouTubeUrl(String url) {
    final trimmed = url.trim();
    if (trimmed.isEmpty) return false;
    return _youtubeRegex.hasMatch(trimmed);
  }

  static String? extractVideoId(String url) {
    final trimmed = url.trim();
    final match = _youtubeRegex.firstMatch(trimmed);
    if (match != null && match.groupCount >= 1) {
      return match.group(1);
    }
    return null;
  }
}

