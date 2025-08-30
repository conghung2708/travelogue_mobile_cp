part of 'trip_plan_bloc.dart';

abstract class TripPlanState extends Equatable {
  const TripPlanState();
  @override
  List<Object?> get props => [];

  
}

class TripPlanInitial extends TripPlanState {
  const TripPlanInitial();
}


class GetTripPlansLoading extends TripPlanState {}

class GetTripPlansSuccess extends TripPlanState {
  final List<TripPlanModel> tripPlans;
  const GetTripPlansSuccess(this.tripPlans);
  @override
  List<Object?> get props => [tripPlans];
}

class GetTripPlansError extends TripPlanState {
  final String message;
  const GetTripPlansError(this.message);
  @override
  List<Object?> get props => [message];
}


class GetTripPlanDetailLoading extends TripPlanState {}

class GetTripPlanDetailSuccess extends TripPlanState {
  final TripPlanDetailModel tripPlanDetail;
  const GetTripPlanDetailSuccess(this.tripPlanDetail);
  @override
  List<Object?> get props => [tripPlanDetail];
}

class GetTripPlanDetailError extends TripPlanState {
  final String message;
  const GetTripPlanDetailError(this.message);
  @override
  List<Object?> get props => [message];
}

class CreateTripPlanLoading extends TripPlanState {}

class CreateTripPlanSuccess extends TripPlanState {
  final TripPlanDetailModel tripPlanDetail;
  const CreateTripPlanSuccess(this.tripPlanDetail);
  @override
  List<Object?> get props => [tripPlanDetail];
}

class CreateTripPlanError extends TripPlanState {
  final String message;
  const CreateTripPlanError(this.message);
  @override
  List<Object?> get props => [message];
}


class UpdateTripPlanLoading extends TripPlanState {}

class UpdateTripPlanSuccess extends TripPlanState {
  final TripPlanDetailModel tripPlanDetail;
  const UpdateTripPlanSuccess(this.tripPlanDetail);
  @override
  List<Object?> get props => [tripPlanDetail];
}

class UpdateTripPlanError extends TripPlanState {
  final String message;
  const UpdateTripPlanError(this.message);
  @override
  List<Object?> get props => [message];
}


class UpdateTripPlanLocationsLoading extends TripPlanState {}

class UpdateTripPlanLocationsSuccess extends TripPlanState {
  const UpdateTripPlanLocationsSuccess();
}

class UpdateTripPlanLocationsError extends TripPlanState {
  final String message;
  const UpdateTripPlanLocationsError(this.message);
  @override
  List<Object?> get props => [message];
}
