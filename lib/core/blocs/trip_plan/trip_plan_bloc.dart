import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:travelogue_mobile/core/repository/trip_plan_repository.dart';
import 'package:travelogue_mobile/model/trip_plan/trip_plan_detail_model.dart';
import 'package:travelogue_mobile/model/trip_plan/trip_plan_location_model.dart';
import 'package:travelogue_mobile/model/trip_plan/trip_plan_model.dart';

part 'trip_plan_event.dart';
part 'trip_plan_state.dart';

class TripPlanBloc extends Bloc<TripPlanEvent, TripPlanState> {
  final TripPlanRepository _repo = TripPlanRepository();

  TripPlanBloc() : super(const TripPlanInitial()) {
    on<GetTripPlansEvent>(_handleGetTripPlans);
    on<GetTripPlanDetailEvent>(_handleGetTripPlanDetail);
    on<CreateTripPlanEvent>(_handleCreateTripPlan);
    on<UpdateTripPlanEvent>(_handleUpdateTripPlan);
    on<UpdateTripPlanLocationsEvent>(_handleUpdateTripPlanLocations);
  }

  Future<void> _handleGetTripPlans(
    GetTripPlansEvent event,
    Emitter<TripPlanState> emit,
  ) async {
    // print('[Bloc] GetTripPlansEvent');
    emit(GetTripPlansLoading());
    try {
      final result = await _repo.getTripPlans(
        title: event.title,
        pageNumber: event.pageNumber,
        pageSize: event.pageSize,
      );
      emit(GetTripPlansSuccess(result));
    } catch (e) {
      emit(GetTripPlansError('Lỗi khi tải Trip Plan: $e'));
    }
  }

  Future<void> _handleGetTripPlanDetail(
    GetTripPlanDetailEvent event,
    Emitter<TripPlanState> emit,
  ) async {
    // print('[Bloc] GetTripPlanDetailEvent id=${event.id}');
    emit(GetTripPlanDetailLoading());
    try {
      final detail = await _repo.getTripPlanDetail(event.id);
      emit(GetTripPlanDetailSuccess(detail));
    } catch (e) {
      emit(GetTripPlanDetailError('Lỗi khi tải chi tiết Trip Plan: $e'));
    }
  }

  Future<void> _handleCreateTripPlan(
    CreateTripPlanEvent event,
    Emitter<TripPlanState> emit,
  ) async {
    // print('[Bloc] CreateTripPlanEvent name=${event.name}');
    emit(CreateTripPlanLoading());
    try {
      final detail = await _repo.createTripPlan(
        name: event.name,
        description: event.description,
        startDate: event.startDate,
        endDate: event.endDate,
        imageUrl: event.imageUrl,
      );
      emit(CreateTripPlanSuccess(detail));
    } catch (e) {
      emit(CreateTripPlanError('Lỗi khi tạo Trip Plan: $e'));
    }
  }

  Future<void> _handleUpdateTripPlan(
    UpdateTripPlanEvent event,
    Emitter<TripPlanState> emit,
  ) async {
    // print('[Bloc] UpdateTripPlanEvent id=${event.id}');
    emit(UpdateTripPlanLoading());
    try {
      final detail = await _repo.updateTripPlan(
        tripPlanId: event.id,
        name: event.name,
        description: event.description,
        startDate: event.startDate,
        endDate: event.endDate,
        imageUrl: event.imageUrl,
      );
      emit(UpdateTripPlanSuccess(detail));
    } catch (e) {
      emit(UpdateTripPlanError('Lỗi khi cập nhật Trip Plan: $e'));
    }
  }

  Future<void> _handleUpdateTripPlanLocations(
    UpdateTripPlanLocationsEvent event,
    Emitter<TripPlanState> emit,
  ) async {
    // print('[Bloc] UpdateTripPlanLocationsEvent tripPlanId=${event.tripPlanId}');
    emit(UpdateTripPlanLocationsLoading());
    try {
      await _repo.updateTripPlanLocations(
        tripPlanId: event.tripPlanId,
        locations: event.locations,
      );
      emit(const UpdateTripPlanLocationsSuccess());
    } catch (e) {
      emit(UpdateTripPlanLocationsError('Lỗi khi cập nhật Trip Plan Locations: $e'));
    }
  }
}
