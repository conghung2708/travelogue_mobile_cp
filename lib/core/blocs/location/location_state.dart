// lib/core/blocs/location/location_state.dart
import 'package:equatable/equatable.dart';
import 'package:travelogue_mobile/model/location_model.dart';

abstract class LocationState extends Equatable {
  const LocationState();
  @override
  List<Object?> get props => [];
}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationEmpty extends LocationState {}

class LocationFailure extends LocationState {
  final String message;
  const LocationFailure(this.message);
  @override
  List<Object?> get props => [message];
}

class LocationSearchSuccess extends LocationState {
  final List<LocationModel> results;
  const LocationSearchSuccess(this.results);
  @override
  List<Object?> get props => [results];
}

class LocationDetailSuccess extends LocationState {
  final LocationModel location;
  const LocationDetailSuccess(this.location);
  @override
  List<Object?> get props => [location];
}
