part of 'hotel_restaurant_bloc.dart';

abstract class HotelRestaurentEvent {}

class GetHotelRestaurantEvent extends HotelRestaurentEvent {
  final String locationId;
  GetHotelRestaurantEvent({required this.locationId});
}

class CleanHotelRestaurentEvent extends HotelRestaurentEvent {}


class GetOnlyRestaurantEvent extends HotelRestaurentEvent {
  final String locationId;
  GetOnlyRestaurantEvent({required this.locationId});
}

class GetAllRestaurantsEvent extends HotelRestaurentEvent {}
