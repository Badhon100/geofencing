import 'package:hive_flutter/hive_flutter.dart';
import '../models/historical_places_model.dart';

abstract class HistoricalPlacesLocalDatasource {
  Future<void> cacheHistoricalPlaces(List<HistoricalPlacesModel> places);
  Future<List<HistoricalPlacesModel>> getCachedHistoricalPlaces();
}

class HistoricalPlacesLocalDatasourceImpl
    implements HistoricalPlacesLocalDatasource {
  static const boxName = 'historical_places_box';

  @override
  Future<void> cacheHistoricalPlaces(List<HistoricalPlacesModel> places) async {
    final box = await Hive.openBox(boxName);

    final jsonList = places
        .map(
          (e) => {
            'id': e.id,
            'title': e.title,
            'body': e.body,
            'imageUrl': e.imageUrl,
          },
        )
        .toList();

    await box.put('places', jsonList);

    print("✅ Cached ${places.length} historical places");
  }

  @override
  Future<List<HistoricalPlacesModel>> getCachedHistoricalPlaces() async {
    final box = await Hive.openBox(boxName);

    final data = box.get('places');

    if (data == null) return [];

    final List list = data as List;

    print("📦 Loaded ${list.length} places from cache");

    return list
        .map(
          (e) => HistoricalPlacesModel(
            id: e['id'],
            title: e['title'],
            body: e['body'],
            imageUrl: e['imageUrl'],
          ),
        )
        .toList();
  }
}
