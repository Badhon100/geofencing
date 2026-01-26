import '../../domain/entities/historical_places_entity.dart';
import '../../domain/repositories/historical_places_repository.dart';
import '../datasources/historical_place_local_datasource.dart';
import '../datasources/historical_places_datasource.dart';

class HistoricalPlacesRepositoryImpl implements HistoricalPlacesRepository {
  final HistoricalPlacesRemoteDataSource remote;
  final HistoricalPlacesLocalDatasource local;

  HistoricalPlacesRepositoryImpl(this.remote, this.local);

  @override
  Future<List<HistoricalPlacesEntity>> getHistoricalPlaces({
    required bool allowCache,
  }) async {
    try {
      final remoteModels = await remote.getHistoricalPlaces();

      if (allowCache) {
        await local.cacheHistoricalPlaces(remoteModels);
      }

      return remoteModels;
    } catch (e) {
      if (allowCache) {
        final cachedModels = await local.getCachedHistoricalPlaces();

        if (cachedModels.isNotEmpty) {
          return cachedModels;
        }
      }

      throw Exception("No internet and no cached data available");
    }
  }
}
