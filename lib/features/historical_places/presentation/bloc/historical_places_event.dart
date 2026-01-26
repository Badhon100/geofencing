part of 'historical_places_bloc.dart';

abstract class HistoricalPlacesEvent extends Equatable {
  const HistoricalPlacesEvent();

  @override
  List<Object> get props => [];
}

class FetchHistoricalPlacesEvent extends HistoricalPlacesEvent {
  final bool allowCache;

  const FetchHistoricalPlacesEvent(this.allowCache);

  @override
  List<Object> get props => [allowCache];
}
