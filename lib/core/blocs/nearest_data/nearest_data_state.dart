import 'package:equatable/equatable.dart';
import 'package:travelogue_mobile/model/location_model.dart';

abstract class NearestDataState extends Equatable {
  const NearestDataState();

  @override
  List<Object> get props => [];
}

class NearestDataInitial extends NearestDataState {}

class NearestDataLoading extends NearestDataState {}

class NearestCuisineLoaded extends NearestDataState {
  final List<LocationModel> cuisines;

  const NearestCuisineLoaded(this.cuisines);

  @override
  List<Object> get props => [cuisines];
}

class NearestHistoricalLoaded extends NearestDataState {
  final List<LocationModel> historicals;

  const NearestHistoricalLoaded(this.historicals);

  @override
  List<Object> get props => [historicals];
}
