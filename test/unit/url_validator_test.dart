import 'package:flutter_test/flutter_test.dart';
import 'package:vnedownloader/core/util/url_validator.dart';

void main() {
  group('UrlValidator tests', () {
    test('Validates youtube.com/watch URLs', () {
      expect(
        UrlValidator.isYouTubeUrl('https://www.youtube.com/watch?v=dQw4w9WgXcQ'),
        isTrue,
      );
      expect(
        UrlValidator.isYouTubeUrl('https://youtube.com/watch?v=dQw4w9WgXcQ&t=10s'),
        isTrue,
      );
      expect(
        UrlValidator.isYouTubeUrl('http://m.youtube.com/watch?v=dQw4w9WgXcQ'),
        isTrue,
      );
      expect(
        UrlValidator.extractVideoId('https://www.youtube.com/watch?v=dQw4w9WgXcQ'),
        equals('dQw4w9WgXcQ'),
      );
    });

    test('Validates youtu.be short URLs', () {
      expect(
        UrlValidator.isYouTubeUrl('https://youtu.be/dQw4w9WgXcQ'),
        isTrue,
      );
      expect(
        UrlValidator.isYouTubeUrl('https://youtu.be/dQw4w9WgXcQ?si=abcdef'),
        isTrue,
      );
      expect(
        UrlValidator.extractVideoId('https://youtu.be/dQw4w9WgXcQ?si=abcdef'),
        equals('dQw4w9WgXcQ'),
      );
    });

    test('Validates youtube.com/shorts URLs', () {
      expect(
        UrlValidator.isYouTubeUrl('https://www.youtube.com/shorts/dQw4w9WgXcQ'),
        isTrue,
      );
      expect(
        UrlValidator.isYouTubeUrl('https://youtube.com/shorts/dQw4w9WgXcQ'),
        isTrue,
      );
      expect(
        UrlValidator.extractVideoId('https://youtube.com/shorts/dQw4w9WgXcQ'),
        equals('dQw4w9WgXcQ'),
      );
    });

    test('Rejects invalid non-YouTube URLs', () {
      expect(UrlValidator.isYouTubeUrl('https://google.com'), isFalse);
      expect(UrlValidator.isYouTubeUrl('https://facebook.com/video/123'), isFalse);
      expect(UrlValidator.isYouTubeUrl('random string'), isFalse);
      expect(UrlValidator.isYouTubeUrl(''), isFalse);
      expect(UrlValidator.extractVideoId('https://google.com'), isNull);
    });
  });
}

