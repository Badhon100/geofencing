import '../entities/historical_places_entity.dart';
import '../repositories/historical_places_repository.dart';
import '../../../settings/cubit/settings_cubit.dart';

class GetHistoricalPlaces {
  final HistoricalPlacesRepository repository;

  GetHistoricalPlaces(this.repository);

  Future<List<HistoricalPlacesEntity>> call() async {
    final allowCache = await SettingsCubit.getCachePreference();
    return repository.getHistoricalPlaces(allowCache: allowCache);
  }
}
