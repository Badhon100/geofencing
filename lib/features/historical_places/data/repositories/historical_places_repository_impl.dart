// features/HistoricalPlaces/data/repository/HistoricalPlaces_repository_impl.dart

import 'package:geofencing/features/historical_places/data/datasources/historical_places_datasource.dart';
import 'package:geofencing/features/historical_places/domain/entities/historical_places_entity.dart';
import 'package:geofencing/features/historical_places/domain/repositories/historical_places_repository.dart';

class HistoricalPlacesRepositoryImpl implements HistoricalPlacesRepository {
  final HistoricalPlacesRemoteDataSource remoteDataSource;

  HistoricalPlacesRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<HistoricalPlacesEntity>> getHistoricalPlaces() async {
    return await remoteDataSource.getHistoricalPlaces();
  }
}
