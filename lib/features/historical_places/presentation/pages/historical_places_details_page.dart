import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geofencing/features/historical_places/domain/entities/historical_places_entity.dart';

class HistoricalPlacesDetailPage extends StatelessWidget {
  final HistoricalPlacesEntity historicalPlaces;
  const HistoricalPlacesDetailPage({super.key, required this.historicalPlaces});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(historicalPlaces.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
              SizedBox(height: 10),
              CachedNetworkImage(imageUrl: historicalPlaces.imageUrl),
              SizedBox(height: 10),
              Text(historicalPlaces.body, style: const TextStyle(fontSize: 16, color: Colors.black54)),
            ],
          ),
        ),
      ),
    );
  }
}
