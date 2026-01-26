part of 'historical_places_bloc.dart';

abstract class HistoricalPlacesState extends Equatable {
  @override
  List<Object> get props => [];
}

class HistoricalPlacesInitial extends HistoricalPlacesState {}

class HistoricalPlacesLoading extends HistoricalPlacesState {}

class HistoricalPlacesLoaded extends HistoricalPlacesState {
  final List<HistoricalPlacesEntity> historicalPlaces;
  HistoricalPlacesLoaded(this.historicalPlaces);
  @override
  List<Object> get props => [historicalPlaces];
}

class HistoricalPlacesError extends HistoricalPlacesState {
  final String message;
  HistoricalPlacesError(this.message);
  @override
  List<Object> get props => [message];
}
