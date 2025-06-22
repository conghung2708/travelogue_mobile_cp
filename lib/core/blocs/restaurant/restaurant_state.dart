part of 'restaurant_bloc.dart';

abstract class RestaurantState {}

class RestaurantInitial extends RestaurantState {}

class RestaurantLoading extends RestaurantState {}

class RestaurantLoaded extends RestaurantState {
  final List<RestaurantModel> restaurants;

  RestaurantLoaded({required this.restaurants});
}

class RestaurantError extends RestaurantState {
  final String message;

  RestaurantError({required this.message});
}
