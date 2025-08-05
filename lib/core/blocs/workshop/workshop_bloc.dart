import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelogue_mobile/core/blocs/workshop/workshop_event.dart';
import 'package:travelogue_mobile/core/blocs/workshop/workshop_state.dart';

import 'package:travelogue_mobile/core/repository/workshop_repository.dart';

class WorkshopBloc extends Bloc<WorkshopEvent, WorkshopState> {
  final WorkshopRepository repository;

  WorkshopBloc(this.repository) : super(WorkshopInitial()) {
    on<GetWorkshopsEvent>(_onGetWorkshops);
     on<GetWorkshopDetailEvent>(_onGetWorkshopDetail); 
  }

  Future<void> _onGetWorkshops(
      GetWorkshopsEvent event, Emitter<WorkshopState> emit) async {
    emit(WorkshopLoading());
    try {
      final workshops = await repository.getWorkshops(
        name: event.name,
        craftVillageId: event.craftVillageId,
      );

      emit(WorkshopLoaded(workshops));
    } catch (e) {
      emit(WorkshopError(e.toString()));
    }
  }

 Future<void> _onGetWorkshopDetail(
    GetWorkshopDetailEvent event, Emitter<WorkshopState> emit) async {
  emit(WorkshopLoading());
  try {
    final workshop = await repository.getWorkshopDetail(
      workshopId: event.workshopId,
      scheduleId: event.scheduleId,
    );

    if (workshop != null) {
      emit(WorkshopDetailLoaded(workshop));
    } else {
      emit(const WorkshopError('Không tìm thấy workshop'));
    }
  } catch (e) {
    emit(WorkshopError(e.toString()));
  }
}
}
