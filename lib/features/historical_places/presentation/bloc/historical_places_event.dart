part of 'historical_places_bloc.dart';

abstract class HistoricalPlacesEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchHistoricalPlacesEvent extends HistoricalPlacesEvent {}
