import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:travelogue_mobile/core/repository/tour_repository.dart';
import 'package:travelogue_mobile/model/composite/tour_detail_composite_model.dart';
import 'package:travelogue_mobile/model/tour/tour_model.dart';
import 'package:travelogue_mobile/model/tour_guide/tour_guide_model.dart';

part 'tour_event.dart';
part 'tour_state.dart';

class TourBloc extends Bloc<TourEvent, TourState> {
  final List<TourModel> tourList = [];

  TourBloc() : super(const TourInitial()) {
    on<GetAllToursEvent>(_handleGetAllTours);
    on<GetAllToursWithGuideEvent>(_handleGetAllToursWithGuide);
    on<GetTourDetailWithGuideByIdEvent>(_handleGetTourDetailWithGuideById);
  }

  int _byNewestTour(TourModel a, TourModel b) {
    final da = a.lastUpdatedTime ??
        a.createdTime ??
        DateTime.fromMillisecondsSinceEpoch(0);
    final db = b.lastUpdatedTime ??
        b.createdTime ??
        DateTime.fromMillisecondsSinceEpoch(0);
    return db.compareTo(da);
  }

  int _byNewestComposite(
      TourDetailCompositeModel a, TourDetailCompositeModel b) {
    final ta = a.tour;
    final tb = b.tour;
    final da = ta.lastUpdatedTime ??
        ta.createdTime ??
        DateTime.fromMillisecondsSinceEpoch(0);
    final db = tb.lastUpdatedTime ??
        tb.createdTime ??
        DateTime.fromMillisecondsSinceEpoch(0);
    return db.compareTo(da);
  }

  Future<void> _handleGetAllTours(
    GetAllToursEvent event,
    Emitter<TourState> emit,
  ) async {
    emit(const TourLoading());
    try {
      final result = await TourRepository().getAllTours();

      if (result.isEmpty) {
        emit(const TourError("Không có tour nào được tìm thấy."));
        return;
      }

      tourList
        ..clear()
        ..addAll(result)
        ..sort(_byNewestTour);

      emit(GetToursSuccess(tours: List.unmodifiable(tourList)));
    } catch (e) {
      emit(TourError("Lỗi khi tải tour: $e"));
    }
  }

  Future<void> _handleGetAllToursWithGuide(
    GetAllToursWithGuideEvent event,
    Emitter<TourState> emit,
  ) async {
    emit(const TourLoading());
    try {
      final result = await TourRepository().getAllToursWithGuide();

      if (result.isEmpty) {
        emit(const TourError("Không có tour nào kèm hướng dẫn viên."));
        return;
      }

      final sorted = [...result]..sort(_byNewestComposite);
      emit(GetToursWithGuideSuccess(toursWithGuide: List.unmodifiable(sorted)));
    } catch (e) {
      emit(TourError("Lỗi khi tải tour có hướng dẫn viên: $e"));
    }
  }

  Future<void> _handleGetTourDetailWithGuideById(
    GetTourDetailWithGuideByIdEvent event,
    Emitter<TourState> emit,
  ) async {
    emit(const TourLoading());
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
      } catch (_) {
        guide = null;
      }

      emit(GetTourDetailByIdSuccess(
        tourDetail: TourDetailCompositeModel(tour: tour, guide: guide),
      ));
    } catch (e) {
      emit(TourError("Lỗi khi tải tour chi tiết: $e"));
    }
  }
}
