import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:travelogue_mobile/core/repository/tour_repository.dart';
import 'package:travelogue_mobile/model/composite/tour_detail_composite_model.dart';
import 'package:travelogue_mobile/model/tour/tour_guide_model.dart';
import 'package:travelogue_mobile/model/tour/tour_model.dart';

part 'tour_event.dart';
part 'tour_state.dart';

class TourBloc extends Bloc<TourEvent, TourState> {
  final List<TourModel> tourList = [];

  TourBloc() : super(TourInitial()) {
    on<GetAllToursEvent>(_handleGetAllTours);
    on<GetAllToursWithGuideEvent>(_handleGetAllToursWithGuide);
    on<GetTourDetailWithGuideByIdEvent>(_handleGetTourDetailWithGuideById);
  }

  Future<void> _handleGetAllTours(
    GetAllToursEvent event,
    Emitter<TourState> emit,
  ) async {
    emit(TourLoading());

    try {
      final result = await TourRepository().getAllTours();

      if (result.isEmpty) {
        emit(const TourError("Không có tour nào được tìm thấy."));
        return;
      }

      tourList
        ..clear()
        ..addAll(result);

      emit(GetToursSuccess(tours: tourList));
    } catch (e) {
      emit(TourError("Lỗi khi tải tour: ${e.toString()}"));
    }
  }

  Future<void> _handleGetAllToursWithGuide(
    GetAllToursWithGuideEvent event,
    Emitter<TourState> emit,
  ) async {
    emit(TourLoading());

    try {
      final result = await TourRepository().getAllToursWithGuide();

      if (result.isEmpty) {
        emit(const TourError("Không có tour nào kèm hướng dẫn viên."));
        return;
      }

      emit(GetToursWithGuideSuccess(toursWithGuide: result));
    } catch (e) {
      emit(TourError("Lỗi khi tải tour có hướng dẫn viên: ${e.toString()}"));
    }
  }

  Future<void> _handleGetTourDetailWithGuideById(
    GetTourDetailWithGuideByIdEvent event,
    Emitter<TourState> emit,
  ) async {
    emit(TourLoading());

    try {
      final tour = await TourRepository().getTourById(event.tourId);
      if (tour == null) {
        emit(const TourError("Không tìm thấy tour."));
        return;
      }

      final guideRaw = tour.toJson()['tourGuide'];
      TourGuideModel? guide;

      try {
        if (guideRaw is List && guideRaw.isNotEmpty) {
          guide = TourGuideModel.fromJson(guideRaw.first);
        } else if (guideRaw is Map<String, dynamic>) {
          guide = TourGuideModel.fromJson(guideRaw);
        }
      } catch (e) {
        print('⚠️ Error parsing guide in detail: $e');
        guide = null;
      }

      emit(GetTourDetailByIdSuccess(
        tourDetail: TourDetailCompositeModel(tour: tour, guide: guide),
      ));
    } catch (e) {
      emit(TourError("Lỗi khi tải tour chi tiết: ${e.toString()}"));
    }
  }
}
