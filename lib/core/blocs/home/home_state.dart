
part of 'home_bloc.dart';


abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

/// Trạng thái khởi tạo ban đầu (chưa fetch bất kỳ dữ liệu nào)
class HomeInitial extends HomeState {
  @override
  List<Object> get props => [];
}

/// Trạng thái đang loading (ví dụ khi fetch API)
class HomeLoading extends HomeState {
  const HomeLoading();
}


class GetHomeSuccess extends HomeState {
  final List<TypeLocationModel> typeLocations;
  final List<LocationModel> locations;
  final List<EventModel> events;
  final List<LocationModel> locationFavorites;

  const GetHomeSuccess({
    required this.typeLocations,
    required this.locations,
    required this.events,
    required this.locationFavorites,
  });

  @override
  List<Object?> get props => [
        typeLocations,
        locations,
        events,
        locationFavorites,
      ];
}
class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
