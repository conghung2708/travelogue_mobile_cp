import 'package:equatable/equatable.dart';
import 'package:travelogue_mobile/model/workshop/workshop_detail_model.dart';
import 'package:travelogue_mobile/model/workshop/workshop_list_model.dart';

abstract class WorkshopState extends Equatable {
  const WorkshopState();

  @override
  List<Object?> get props => [];
}

class WorkshopInitial extends WorkshopState {}

class WorkshopLoading extends WorkshopState {}

class WorkshopLoaded extends WorkshopState {
  final List<WorkshopListModel> workshops;

  const WorkshopLoaded(this.workshops);

  @override
  List<Object?> get props => [workshops];
}

class WorkshopError extends WorkshopState {
  final String message;

  const WorkshopError(this.message);

  @override
  List<Object?> get props => [message];
}


class WorkshopDetailLoaded extends WorkshopState {
  final WorkshopDetailModel workshop;

  const WorkshopDetailLoaded(this.workshop);

  @override
  List<Object?> get props => [workshop];
}
