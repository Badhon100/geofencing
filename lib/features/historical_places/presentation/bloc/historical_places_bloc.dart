import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geofencing/features/historical_places/domain/entities/historical_places_entity.dart';
import 'package:geofencing/features/historical_places/domain/usecases/historical_places_usecases.dart';

part 'historical_places_event.dart';
part 'historical_places_state.dart';

class HistoricalPlacesBloc extends Bloc<HistoricalPlacesEvent, HistoricalPlacesState> {
  final GetHistoricalPlaces getHistoricalPlaces;

  HistoricalPlacesBloc(this.getHistoricalPlaces) : super(HistoricalPlacesInitial()) {
    on<FetchHistoricalPlacesEvent>((event, emit) async {
      emit(HistoricalPlacesLoading());
      try {
        final HistoricalPlaces = await getHistoricalPlaces();
        emit(HistoricalPlacesLoaded(HistoricalPlaces));
      } catch (e) {
        emit(HistoricalPlacesError(e.toString()));
      }
    });
  }
}
