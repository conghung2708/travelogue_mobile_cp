part of 'tour_bloc.dart';

abstract class TourEvent extends Equatable {
  const TourEvent();

  @override
  List<Object?> get props => [];
}

class GetAllToursEvent extends TourEvent {
  const GetAllToursEvent();
}

class GetAllToursWithGuideEvent extends TourEvent {
  const GetAllToursWithGuideEvent();
}

class GetTourDetailWithGuideByIdEvent extends TourEvent {
  final String tourId;

  const GetTourDetailWithGuideByIdEvent(this.tourId);

  @override
  List<Object?> get props => [tourId];
}
