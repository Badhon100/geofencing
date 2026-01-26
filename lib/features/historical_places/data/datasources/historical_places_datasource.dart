// features/HistoricalPlaces/data/datasource/HistoricalPlaces_remote_datasource.dart


import 'package:geofencing/core/services/api_service.dart';
import 'package:geofencing/features/historical_places/data/models/historical_places_model.dart';

abstract class HistoricalPlacesRemoteDataSource {
  Future<List<HistoricalPlacesModel>> getHistoricalPlaces();
}

class HistoricalPlacesRemoteDataSourceImpl implements HistoricalPlacesRemoteDataSource {
  final ApiService apiService;

  HistoricalPlacesRemoteDataSourceImpl(this.apiService);

  @override
  Future<List<HistoricalPlacesModel>> getHistoricalPlaces() async {
    final response = await apiService.get(
      "https://dummyjson.com/posts", // full URL works fine
    );

    final List posts = response.data['posts'];
    return posts.map((e) => HistoricalPlacesModel.fromJson(e)).toList();
  }
}
