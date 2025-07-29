part of 'tour_bloc.dart';

abstract class TourState extends Equatable {
  const TourState();

  @override
  List<Object?> get props => [];
}

class TourInitial extends TourState {}

class TourLoading extends TourState {}

class GetToursSuccess extends TourState {
  final List<TourModel> tours;

  const GetToursSuccess({required this.tours});

  @override
  List<Object?> get props => [tours];
}

class GetToursWithGuideSuccess extends TourState {
  final List<TourDetailCompositeModel> toursWithGuide;

  const GetToursWithGuideSuccess({required this.toursWithGuide});

  @override
  List<Object?> get props => [toursWithGuide];
}

class GetTourDetailByIdSuccess extends TourState {
  final TourDetailCompositeModel tourDetail;

  const GetTourDetailByIdSuccess({required this.tourDetail});

  @override
  List<Object?> get props => [tourDetail];
}

class TourError extends TourState {
  final String message;

  const TourError(this.message);

  @override
  List<Object?> get props => [message];
}
