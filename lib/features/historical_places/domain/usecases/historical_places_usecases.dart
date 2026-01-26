// domain/usecases/get_news.dart

import 'package:geofencing/features/historical_places/domain/entities/historical_places_entity.dart';
import 'package:geofencing/features/historical_places/domain/repositories/historical_places_repository.dart';

class GetHistoricalPlaces {
  final HistoricalPlacesRepository repository;

  GetHistoricalPlaces(this.repository);

  Future<List<HistoricalPlacesEntity>> call() {
    return repository.getHistoricalPlaces();
  }
}
