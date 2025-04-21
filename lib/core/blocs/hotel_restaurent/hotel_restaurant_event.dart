part of 'hotel_restaurant_bloc.dart';

abstract class HotelRestaurentEvent {}

class GetHotelRestaurantEvent extends HotelRestaurentEvent {
  final String locationId;
  GetHotelRestaurantEvent({required this.locationId});
}

class CleanHotelRestaurentEvent extends HotelRestaurentEvent {}
