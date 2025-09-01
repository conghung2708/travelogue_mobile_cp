// lib/core/blocs/location/location_bloc.dart
import 'package:bloc/bloc.dart';
import 'location_event.dart';
import 'location_state.dart';
import 'package:travelogue_mobile/core/repository/location_repository.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final LocationRepository repo;
  LocationBloc(this.repo) : super(LocationInitial()) {
    on<LocationSearchRequested>(_onSearch);
    on<LocationDetailRequested>(_onDetail);
  }

  Future<void> _onSearch(
    LocationSearchRequested event,
    Emitter<LocationState> emit,
  ) async {
    final q = event.query.trim();
    if (q.isEmpty) {
      emit(LocationEmpty());
      return;
    }
    emit(LocationLoading());
    try {
      final results = await repo.searchLocation(search: q);
      if (results.isEmpty) {
        emit(LocationEmpty());
      } else {
        emit(LocationSearchSuccess(results));
      }
    } catch (e) {
      emit(LocationFailure('Không tìm được địa điểm: $e'));
    }
  }

  Future<void> _onDetail(
    LocationDetailRequested event,
    Emitter<LocationState> emit,
  ) async {
    emit(LocationLoading());
    try {
      final loc = await repo.getLocationById(event.id);
      if (loc == null) {
        emit(LocationEmpty());
      } else {
        emit(LocationDetailSuccess(loc));
      }
    } catch (e) {
      emit(LocationFailure('Lỗi tải chi tiết địa điểm: $e'));
    }
  }
}
