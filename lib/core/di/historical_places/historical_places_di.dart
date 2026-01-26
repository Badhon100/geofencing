import 'package:geofencing/features/historical_places/data/datasources/historical_places_datasource.dart';
import 'package:geofencing/features/historical_places/data/repositories/historical_places_repository_impl.dart';
import 'package:geofencing/features/historical_places/domain/repositories/historical_places_repository.dart';
import 'package:geofencing/features/historical_places/domain/usecases/historical_places_usecases.dart';
import 'package:geofencing/features/historical_places/presentation/bloc/historical_places_bloc.dart';
import 'package:get_it/get_it.dart';

class HistoricalPlacesDi {
  static void init(GetIt sl) {
     // Data Sources
    sl.registerLazySingleton<HistoricalPlacesRemoteDataSource>(
      () => HistoricalPlacesRemoteDataSourceImpl(sl()),
    );

    // Repository
    sl.registerLazySingleton<HistoricalPlacesRepository>(() => HistoricalPlacesRepositoryImpl(sl()));

    // Use Cases
    sl.registerLazySingleton(() => GetHistoricalPlaces(sl()));

    // Bloc
    sl.registerFactory(() => HistoricalPlacesBloc(sl()));
  }
}
