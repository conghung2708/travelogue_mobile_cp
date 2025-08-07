import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelogue_mobile/core/repository/nearest_data_repository.dart';
import 'package:travelogue_mobile/core/blocs/nearest_data/nearest_data_event.dart';
import 'package:travelogue_mobile/core/blocs/nearest_data/nearest_data_state.dart';

class NearestDataBloc extends Bloc<NearestDataEvent, NearestDataState> {
  final NearestDataRepository repository;

  NearestDataBloc({required this.repository}) : super(NearestDataInitial()) {
    on<GetNearestCuisineEvent>(_onGetNearestCuisine);
    on<GetNearestHistoricalEvent>(_onGetNearestHistorical);
  }

  Future<void> _onGetNearestCuisine(
      GetNearestCuisineEvent event, Emitter<NearestDataState> emit) async {
    emit(NearestDataLoading());
    final cuisines = await repository.getNearestCuisine(event.locationId);
    emit(NearestCuisineLoaded(cuisines));
  }

  Future<void> _onGetNearestHistorical(
      GetNearestHistoricalEvent event, Emitter<NearestDataState> emit) async {
    emit(NearestDataLoading());
    final historicals =
        await repository.getNearestHistorical(event.locationId);
    emit(NearestHistoricalLoaded(historicals));
  }
}
