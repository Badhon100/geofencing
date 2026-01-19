import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geofencing/core/services/notifiations_service.dart';
import '../locations/target_locations.dart';
import 'location_service.dart';
import '../utils/distance_util.dart';

Future<void> initializeBackgroundService() async {
  final service = FlutterBackgroundService();

  await NotificationService.init();
  await LocationService.requestPermission();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onServiceStart,
      isForegroundMode: true,
      autoStart: true,
      foregroundServiceTypes:  [AndroidForegroundType.location],
    ),
    iosConfiguration: IosConfiguration(
      onForeground: onServiceStart,
      onBackground: onIosBackground,
    ),
  );

  await service.startService();
}

@pragma('vm:entry-point')
void onServiceStart(ServiceInstance service) async {
  if (service is AndroidServiceInstance) {
    service.setAsForegroundService();

    service.setForegroundNotificationInfo(
      title: 'Geofencing Service',
      content: 'Location monitoring is active',
    );
  }

  // Keep track of which locations already triggered
  final triggeredLocations = <String>{};

  // 🔹 Immediately check current location when service starts
  final currentPosition = await LocationService.getCurrentPosition();
  for (final target in targetLocations) {
    final isInside = DistanceUtils.isInsideRadius(
      userLat: currentPosition.latitude,
      userLng: currentPosition.longitude,
      target: target,
    );
    if (isInside) {
      NotificationService.show('Hello, welcome to ${target.name}');
      triggeredLocations.add(target.id);
    }
  }

  // 🔄 Listen to location updates for entering/exiting other locations
  LocationService.positionStream().listen((position) {
    for (final target in targetLocations) {
      final isInside = DistanceUtils.isInsideRadius(
        userLat: position.latitude,
        userLng: position.longitude,
        target: target,
      );

      if (isInside && !triggeredLocations.contains(target.id)) {
        NotificationService.show('Hello, welcome to ${target.name}');
        triggeredLocations.add(target.id);
      }

      // Remove from triggered set if user leaves radius
      if (!isInside && triggeredLocations.contains(target.id)) {
        triggeredLocations.remove(target.id);
      }
    }
  });

  // ❌ Stop service manually
  service.on('stopService').listen((event) {
    service.stopSelf();
  });
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  return true;
}
