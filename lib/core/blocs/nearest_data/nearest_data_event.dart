import 'package:equatable/equatable.dart';

abstract class NearestDataEvent extends Equatable {
  const NearestDataEvent();
}

class GetNearestCuisineEvent extends NearestDataEvent {
  final String locationId;

  const GetNearestCuisineEvent(this.locationId);

  @override
  List<Object> get props => [locationId];
}

class GetNearestHistoricalEvent extends NearestDataEvent {
  final String locationId;

  const GetNearestHistoricalEvent(this.locationId);

  @override
  List<Object> get props => [locationId];
}
