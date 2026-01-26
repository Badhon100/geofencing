import 'package:geofencing/core/di/historical_places/historical_places_di.dart';
import 'package:geofencing/core/services/api_service.dart';
import 'package:geofencing/features/home/cubit/home_cubit.dart';
import 'package:geofencing/features/settings/cubit/settings_cubit.dart';
import 'package:get_it/get_it.dart';


class Dependency {
  static final sl = GetIt.instance;
  Dependency._init();

  static Future<void> init() async {
    
    sl.registerLazySingleton<ApiService>(() => ApiService());
    sl.registerFactory(() => SettingsCubit());
    sl.registerFactory(() => HomeCubit());
    
    HistoricalPlacesDi.init(sl);
  }
}
