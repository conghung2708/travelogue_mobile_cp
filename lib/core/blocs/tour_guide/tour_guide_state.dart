part of 'tour_guide_bloc.dart';

abstract class TourGuideState extends Equatable {
  const TourGuideState();

  @override
  List<Object?> get props => [];
}

class TourGuideInitial extends TourGuideState {}

class TourGuideLoading extends TourGuideState {}

class TourGuideLoaded extends TourGuideState {
  final List<TourGuideModel> guides;
  final bool isFiltered;

  const TourGuideLoaded(this.guides, {this.isFiltered = false});

  @override
  List<Object?> get props => [guides, isFiltered];
}

class TourGuideDetailLoaded extends TourGuideState {
  final TourGuideModel guide;

  const TourGuideDetailLoaded(this.guide);

  @override
  List<Object?> get props => [guide];
}

class TourGuideError extends TourGuideState {
  final String message;

  const TourGuideError(this.message);

  @override
  List<Object?> get props => [message];
}
