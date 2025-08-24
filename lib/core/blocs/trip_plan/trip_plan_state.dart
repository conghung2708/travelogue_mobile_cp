part of 'trip_plan_bloc.dart';



abstract class TripPlanState extends Equatable {
  const TripPlanState();
  @override
  List<Object?> get props => [];
}

class TripPlanInitial extends TripPlanState {}
class TripPlanLoading extends TripPlanState {}
class GetTripPlansSuccess extends TripPlanState {
  final List<TripPlanModel> tripPlans;
  const GetTripPlansSuccess(this.tripPlans);
  @override
  List<Object?> get props => [tripPlans];
}
class TripPlanError extends TripPlanState {
  final String message;
  const TripPlanError(this.message);
  @override
  List<Object?> get props => [message];
}


class GetTripPlanDetailSuccess extends TripPlanState {
  final TripPlanDetailModel tripPlanDetail;
  const GetTripPlanDetailSuccess(this.tripPlanDetail);
  @override
  List<Object?> get props => [tripPlanDetail];
}


class CreateTripPlanSuccess extends TripPlanState {
  final TripPlanDetailModel tripPlanDetail;
  const CreateTripPlanSuccess(this.tripPlanDetail);
  @override
  List<Object?> get props => [tripPlanDetail];
}

class UpdateTripPlanSuccess extends TripPlanState {
  final TripPlanDetailModel tripPlanDetail;
  const UpdateTripPlanSuccess(this.tripPlanDetail);

  @override
  List<Object?> get props => [tripPlanDetail];
}

class UpdateTripPlanLocationsSuccess extends TripPlanState {
  const UpdateTripPlanLocationsSuccess();
}

class UpdateTripPlanLocationsError extends TripPlanState {
  final String message;
  const UpdateTripPlanLocationsError(this.message);

  @override
  List<Object?> get props => [message];
}
