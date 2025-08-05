import 'package:equatable/equatable.dart';

abstract class WorkshopEvent extends Equatable {
  const WorkshopEvent();

  @override
  List<Object?> get props => [];
}

class GetWorkshopsEvent extends WorkshopEvent {
  final String? name;
  final String? craftVillageId;

  const GetWorkshopsEvent({this.name, this.craftVillageId});

  @override
  List<Object?> get props => [name, craftVillageId];
}

class GetWorkshopDetailEvent extends WorkshopEvent {
  final String workshopId;
  final String? scheduleId;

  const GetWorkshopDetailEvent({
    required this.workshopId,
    this.scheduleId,
  });

  @override
  List<Object?> get props => [workshopId, scheduleId];
}
