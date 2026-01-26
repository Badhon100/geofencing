// domain/entities/HistoricalPlacesEntity.dart
import 'package:equatable/equatable.dart';

class HistoricalPlacesEntity extends Equatable {
  final int id;
  final String title;
  final String body;
  final String imageUrl;

  const HistoricalPlacesEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.imageUrl,
  });

  @override
  List<Object> get props => [id, title, body, imageUrl];
}
