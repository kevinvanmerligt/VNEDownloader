abstract class AppFailure {
  final String message;
  final String? code;

  const AppFailure(this.message, {this.code});

  @override
  String toString() => message;
}

class NetworkFailure extends AppFailure {
  const NetworkFailure([super.message = 'Tidak ada koneksi internet. Periksa koneksi Anda dan coba lagi.'])
      : super(code: 'NETWORK_ERROR');
}

class InvalidUrlFailure extends AppFailure {
  const InvalidUrlFailure([super.message = 'Tautan tidak dikenali. Pastikan itu tautan video YouTube.'])
      : super(code: 'INVALID_URL');
}

class VideoRestrictedFailure extends AppFailure {
  const VideoRestrictedFailure([super.message = 'Video privat, berbayar, atau dibatasi akses oleh YouTube.'])
      : super(code: 'VIDEO_RESTRICTED');
}

class StorageFailure extends AppFailure {
  const StorageFailure([super.message = 'Penyimpanan tidak cukup atau akses ditolak.'])
      : super(code: 'STORAGE_ERROR');
}

class DownloadFailure extends AppFailure {
  const DownloadFailure(super.message, {super.code = 'DOWNLOAD_ERROR'});
}

class WifiOnlyBlockedFailure extends AppFailure {
  const WifiOnlyBlockedFailure([super.message = 'Pengaturan "Hanya Wi-Fi" aktif. Sambungkan ke Wi-Fi untuk mengunduh.'])
      : super(code: 'WIFI_ONLY');
}
