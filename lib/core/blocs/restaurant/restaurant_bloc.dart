import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelogue_mobile/model/restaurant_model.dart';
import 'package:travelogue_mobile/core/repository/restaurant_repository.dart';

part 'restaurant_event.dart';
part 'restaurant_state.dart';

class RestaurantBloc extends Bloc<RestaurantEvent, RestaurantState> {
  final RestaurantRepository repository;

  RestaurantBloc({required this.repository}) : super(RestaurantInitial()) {
    on<GetAllRestaurantEvent>(_onGetAllRestaurant);
  }

  Future<void> _onGetAllRestaurant(
    GetAllRestaurantEvent event,
    Emitter<RestaurantState> emit,
  ) async {
    emit(RestaurantLoading());
    try {
      final restaurants = await repository.getAllRestaurants();
      emit(RestaurantLoaded(restaurants: restaurants));
    } catch (e) {
      emit(RestaurantError(message: e.toString()));
    }
  }
}
