part of 'home_bloc.dart';


abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class GetLocationTypeEvent extends HomeEvent {
  const GetLocationTypeEvent();
}

class GetAllLocationEvent extends HomeEvent {
  const GetAllLocationEvent();
}

class GetEventHomeEvent extends HomeEvent {
  const GetEventHomeEvent();
}

class GetLocationFavoriteEvent extends HomeEvent {
  const GetLocationFavoriteEvent();
}

class FilterLocationByCategoryEvent extends HomeEvent {
  final String category;
  const FilterLocationByCategoryEvent({required this.category});

  @override
  List<Object?> get props => [category];
}

class UpdateLikedLocationEvent extends HomeEvent {
  final String locationId;
  final bool isLiked;
  final BuildContext context;

  const UpdateLikedLocationEvent({
    required this.locationId,
    required this.isLiked,
    required this.context,
  });

  @override
  List<Object?> get props => [locationId, isLiked];
}
