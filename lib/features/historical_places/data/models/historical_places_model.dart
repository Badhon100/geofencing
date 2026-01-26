// data/models/HistoricalPlacesModel_model.dart

import 'package:geofencing/features/historical_places/domain/entities/historical_places_entity.dart';

class HistoricalPlacesModel extends HistoricalPlacesEntity {
  const HistoricalPlacesModel({
    required super.id,
    required super.title,
    required super.body,
    required super.imageUrl,
  });

  factory HistoricalPlacesModel.fromJson(Map<String, dynamic> json) {
    return HistoricalPlacesModel(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      imageUrl: "https://picsum.photos/seed/${json['id']}/600/400",
    );
  }
}
