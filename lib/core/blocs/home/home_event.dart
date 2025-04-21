// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'home_bloc.dart';

abstract class HomeEvent {}

class GetLocationTypeEvent extends HomeEvent {}

class GetAllLocationEvent extends HomeEvent {}

class GetEventHomeEvent extends HomeEvent {}

class FilterLocationTypeEvent extends HomeEvent {
  final String locationTypeId;
  FilterLocationTypeEvent({
    required this.locationTypeId,
  });
}

class GetLocationFavoriteEvent extends HomeEvent {}

class UpdateLikedLocationEvent extends HomeEvent {
  final String locationId;
  final bool isLiked;
  final BuildContext context;
  UpdateLikedLocationEvent({
    required this.locationId,
    required this.isLiked,
    required this.context,
  });
}
