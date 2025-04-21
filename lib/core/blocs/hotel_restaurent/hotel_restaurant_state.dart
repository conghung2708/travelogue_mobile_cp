// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'hotel_restaurant_bloc.dart';

abstract class HotelRestaurantState {
  List<Object> get props => [<HotelModel>[], <RestaurantModel>[]];
}

class HotelRestaurentInitial extends HotelRestaurantState {}

class HotelRestaurantSuccess extends HotelRestaurantState {
  final List<HotelModel> listHotel;
  final List<RestaurantModel> listRestaurant;
  HotelRestaurantSuccess({
    required this.listHotel,
    required this.listRestaurant,
  });

  @override
  List<Object> get props => [listHotel, listRestaurant];
}
