import 'package:geolocator/geolocator.dart';
import '../locations/target_locations.dart';

class DistanceUtils {
  static bool isInsideRadius({
    required double userLat,
    required double userLng,
    required TargetLocation target,
  }) {
    final distance = Geolocator.distanceBetween(
      userLat,
      userLng,
      target.latitude,
      target.longitude,
    );

    return distance <= target.radius;
  }
}
