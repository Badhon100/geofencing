// domain/repositories/Historical_repository.dart

import 'package:geofencing/features/historical_places/domain/entities/historical_places_entity.dart';

abstract class HistoricalPlacesRepository {
  Future<List<HistoricalPlacesEntity>> getHistoricalPlaces();
}
