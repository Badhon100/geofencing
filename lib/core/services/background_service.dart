import 'package:flutter/widgets.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';

import '../locations/target_locations.dart';
import '../utils/distance_util.dart';
import 'location_service.dart';
import 'package:geofencing/core/services/notifications_service.dart';

Future<void> initializeBackgroundService() async {
  final service = FlutterBackgroundService();

  // 🔹 MUST be done in UI isolate
  await NotificationService.init();

  // 🔹 Permissions + GPS check BEFORE starting service
  await LocationService.requestPermission();

  final serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    await Geolocator.openLocationSettings();
    return;
  }

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onServiceStart,
      isForegroundMode: true,
      autoStart: true,
      foregroundServiceTypes: const [AndroidForegroundType.location],
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
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();

  if (service is AndroidServiceInstance) {
    service.setAsForegroundService();
    service.setForegroundNotificationInfo(
      title: 'Geofencing Service',
      content: 'Location monitoring is active',
    );
  }

  final triggeredLocations = <String>{};

  // 🔹 Initial location (SAFE)
  final currentPosition = await LocationService.getCurrentPosition();
  if (currentPosition != null) {
    _processLocation(currentPosition, triggeredLocations);
  }

  // 🔹 Continuous updates
  LocationService.positionStream().listen(
    (position) {
      _processLocation(position, triggeredLocations);
    },
    onError: (_) {
      // GPS turned off while running — ignore, service keeps alive
    },
  );

  service.on('stopService').listen((_) {
    service.stopSelf();
  });

  service.on('resetState').listen((_) async {
    triggeredLocations.clear();
    final currentPosition = await LocationService.getCurrentPosition();
    if (currentPosition != null) {
      _processLocation(currentPosition, triggeredLocations);
    }
  });
}

void _processLocation(Position position, Set<String> triggeredLocations) {
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

    if (!isInside && triggeredLocations.contains(target.id)) {
      triggeredLocations.remove(target.id);
    }
  }
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  return true;
}
