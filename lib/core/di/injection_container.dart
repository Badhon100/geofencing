import 'package:geofencing/core/di/historical_places/historical_places_di.dart';
import 'package:geofencing/core/services/api_service.dart';
import 'package:get_it/get_it.dart';


class Dependency {
  static final sl = GetIt.instance;
  Dependency._init();

  static Future<void> init() async {
    
    sl.registerLazySingleton<ApiService>(() => ApiService());

    
    HistoricalPlacesDi.init(sl);
  }
}
