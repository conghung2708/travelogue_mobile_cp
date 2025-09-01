// lib/core/blocs/location/location_event.dart
import 'package:equatable/equatable.dart';

abstract class LocationEvent extends Equatable {
  const LocationEvent();
  @override
  List<Object?> get props => [];
}

class LocationSearchRequested extends LocationEvent {
  final String query;
  const LocationSearchRequested(this.query);
  @override
  List<Object?> get props => [query];
}

class LocationDetailRequested extends LocationEvent {
  final String id;
  const LocationDetailRequested(this.id);
  @override
  List<Object?> get props => [id];
}
