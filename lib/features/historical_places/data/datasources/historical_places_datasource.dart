import 'dart:io';

import 'package:dio/dio.dart';
import 'package:geofencing/core/services/api_service.dart';
import 'package:geofencing/features/historical_places/data/models/historical_places_model.dart';

abstract class HistoricalPlacesRemoteDataSource {
  Future<List<HistoricalPlacesModel>> getHistoricalPlaces();
}

class HistoricalPlacesRemoteDataSourceImpl
    implements HistoricalPlacesRemoteDataSource {
  final ApiService apiService;

  HistoricalPlacesRemoteDataSourceImpl(this.apiService);

  @override
  Future<List<HistoricalPlacesModel>> getHistoricalPlaces() async {
    try {
      final response = await apiService.get("https://dummyjson.com/posts");

      // ❗ If API didn't return success → THROW
      if (response.statusCode != 200 || response.data == null) {
        throw Exception("Server error");
      }

      final List posts = response.data['posts'];

      return posts.map((e) => HistoricalPlacesModel.fromJson(e)).toList();
    } on DioException catch (e) {
      // 🔥 THIS PART MAKES OFFLINE CACHE WORK
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.error is SocketException) {
        throw Exception("No Internet Connection");
      }

      throw Exception("Network error: ${e.message}");
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }
}
  