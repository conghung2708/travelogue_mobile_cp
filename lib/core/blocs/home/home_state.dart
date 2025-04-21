// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'home_bloc.dart';

abstract class HomeState {
  List<Object> get props => [
        <TypeLocationModel>[],
        <LocationModel>[],
        <EventModel>[],
        <LocationModel>[],
      ];
}

class HomeInitial extends HomeState {}

class GetHomeSuccess extends HomeState {
  final List<TypeLocationModel> typeLocations;
  final List<LocationModel> locations;
  final List<EventModel> events;
  final List<LocationModel> locationFavorites;
  GetHomeSuccess({
    required this.typeLocations,
    required this.locations,
    required this.events,
    required this.locationFavorites,
  });
  @override
  List<Object> get props => [
        typeLocations,
        locations,
        events,
        locationFavorites,
      ];
}
