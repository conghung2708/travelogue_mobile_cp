import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:travelogue_mobile/core/blocs/tour_guide/tour_guide_event.dart';
import 'package:travelogue_mobile/core/repository/tour_guide_repository.dart';
import 'package:travelogue_mobile/model/tour_guide/tour_guide_filter_model.dart';
import 'package:travelogue_mobile/model/tour_guide/tour_guide_model.dart';
part 'tour_guide_state.dart';

class TourGuideBloc extends Bloc<TourGuideEvent, TourGuideState> {
  final TourGuideRepository repository;

  TourGuideBloc(this.repository) : super(TourGuideInitial()) {
    on<GetAllTourGuidesEvent>(_handleGetAllTourGuides);
    on<GetTourGuideByIdEvent>(_handleGetTourGuideById);
    on<FilterTourGuideEvent>(_handleFilterTourGuide);

  }

  Future<void> _handleGetAllTourGuides(
    GetAllTourGuidesEvent event,
    Emitter<TourGuideState> emit,
  ) async {
    emit(TourGuideLoading());

    try {
      final guides = await repository.getAllTourGuides();

      if (guides.isEmpty) {
        emit(const TourGuideError("Không có hướng dẫn viên nào."));
        return;
      }

      emit(TourGuideLoaded(guides));
    } catch (e) {
      emit(TourGuideError("Lỗi khi tải danh sách hướng dẫn viên: ${e.toString()}"));
    }
  }

  Future<void> _handleGetTourGuideById(
    GetTourGuideByIdEvent event,
    Emitter<TourGuideState> emit,
  ) async {
    emit(TourGuideLoading());

    try {
      final guide = await repository.getTourGuideById(event.id);
      if (guide == null) {
        emit(const TourGuideError("Không tìm thấy hướng dẫn viên."));
        return;
      }

      emit(TourGuideDetailLoaded(guide));
    } catch (e) {
      emit(TourGuideError("Lỗi khi tải hướng dẫn viên: ${e.toString()}"));
    }
  }

Future<void> _handleFilterTourGuide(
  FilterTourGuideEvent event,
  Emitter<TourGuideState> emit,
) async {
  emit(TourGuideLoading());

  print("📤 Gửi filter tới API: ${event.filter.toJson()}");

  try {
    final guides = await repository.filterTourGuides(event.filter);

    print("📥 Kết quả nhận về: ${guides.length} hướng dẫn viên");

    if (guides.isEmpty) {
      emit(const TourGuideError("Không tìm thấy hướng dẫn viên nào theo tiêu chí lọc."));
      return;
    }

    emit(TourGuideLoaded(guides, isFiltered: true));
  } catch (e) {
    emit(TourGuideError("Lỗi khi lọc hướng dẫn viên: ${e.toString()}"));
  }
}


}
