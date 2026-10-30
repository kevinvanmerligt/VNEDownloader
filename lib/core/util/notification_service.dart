import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService instance = NotificationService._internal();
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  NotificationService._internal();

  Future<void> init() async {
    if (_initialized) return;

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(
      android: androidSettings,
    );

    try {
      await _notificationsPlugin.initialize(
        settings: initSettings,
        onDidReceiveNotificationResponse: (response) {
          // Handle tap on notification
        },
      );
      _initialized = true;
    } catch (_) {
      // Notification plugin may fail gracefully on unsupported platforms
    }
  }

  Future<void> showProgress(
      int notificationId, String title, int progress, int max) async {
    if (!_initialized || !Platform.isAndroid) return;

    final androidDetails = AndroidNotificationDetails(
      'vne_download_channel',
      'Unduhan VNEDownloader',
      channelDescription: 'Menampilkan progres unduhan video',
      importance: Importance.low,
      priority: Priority.low,
      showProgress: true,
      maxProgress: max,
      progress: progress,
      onlyAlertOnce: true,
      ongoing: true,
    );

    final details = NotificationDetails(android: androidDetails);
    try {
      await _notificationsPlugin.show(
        id: notificationId,
        title: 'Mengunduh: $title',
        body: '$progress%',
        notificationDetails: details,
      );
    } catch (_) {}
  }

  Future<void> showCompleted(
      int notificationId, String title, String filePath) async {
    if (!_initialized || !Platform.isAndroid) return;

    const androidDetails = AndroidNotificationDetails(
      'vne_download_channel',
      'Unduhan VNEDownloader',
      channelDescription: 'Menampilkan notifikasi unduhan selesai',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      ongoing: false,
      autoCancel: true,
    );

    final details = const NotificationDetails(android: androidDetails);
    try {
      await _notificationsPlugin.show(
        id: notificationId,
        title: 'Unduhan Selesai',
        body: title,
        notificationDetails: details,
        payload: filePath,
      );
    } catch (_) {}
  }

  Future<void> showFailed(
      int notificationId, String title, String error) async {
    if (!_initialized || !Platform.isAndroid) return;

    const androidDetails = AndroidNotificationDetails(
      'vne_download_channel',
      'Unduhan VNEDownloader',
      channelDescription: 'Menampilkan notifikasi kesalahan unduhan',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      ongoing: false,
      autoCancel: true,
    );

    final details = const NotificationDetails(android: androidDetails);
    try {
      await _notificationsPlugin.show(
        id: notificationId,
        title: 'Unduhan Gagal',
        body: '$title ($error)',
        notificationDetails: details,
      );
    } catch (_) {}
  }

  Future<void> cancel(int notificationId) async {
    if (!_initialized || !Platform.isAndroid) return;
    try {
      await _notificationsPlugin.cancel(id: notificationId);
    } catch (_) {}
  }
}
