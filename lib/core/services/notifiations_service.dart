import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings, // for older versions (still accepted)
      macOS: darwinSettings, // optional but safe
    );

    await _plugin.initialize(settings);

    // Request permission AFTER initialization
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }


  static Future<void> show(String message) async {
    const androidDetails = AndroidNotificationDetails(
      'geo_channel',
      'Location Monitoring',
      importance: Importance.high,
      priority: Priority.high,
    );

    await _plugin.show(
      0,
      'Geofencing Alert',
      message,
      const NotificationDetails(android: androidDetails),
    );
  }
}
