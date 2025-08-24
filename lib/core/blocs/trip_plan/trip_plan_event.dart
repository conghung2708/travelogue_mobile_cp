part of 'trip_plan_bloc.dart';


abstract class TripPlanEvent extends Equatable {
  const TripPlanEvent();
  @override
  List<Object?> get props => [];
}

class GetTripPlansEvent extends TripPlanEvent {
  final String? title;
  final int pageNumber;
  final int pageSize;
  const GetTripPlansEvent({this.title, this.pageNumber = 1, this.pageSize = 10});
  @override
  List<Object?> get props => [title, pageNumber, pageSize];
}

class GetTripPlanDetailEvent extends TripPlanEvent {
  final String id;
  const GetTripPlanDetailEvent(this.id);
  @override
  List<Object?> get props => [id];
}

class CreateTripPlanEvent extends TripPlanEvent {
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String? imageUrl;
  const CreateTripPlanEvent({
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    this.imageUrl,
  });
  @override
  List<Object?> get props => [name, description, startDate, endDate, imageUrl];
}


class UpdateTripPlanEvent extends TripPlanEvent {
  final String id;
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String? imageUrl;

  const UpdateTripPlanEvent({
    required this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [id, name, description, startDate, endDate, imageUrl];
}

class UpdateTripPlanLocationsEvent extends TripPlanEvent {
  final String tripPlanId;
  final List<TripPlanLocationModel> locations;

  const UpdateTripPlanLocationsEvent({
    required this.tripPlanId,
    required this.locations,
  });

  @override
  List<Object?> get props => [tripPlanId, locations];
}
