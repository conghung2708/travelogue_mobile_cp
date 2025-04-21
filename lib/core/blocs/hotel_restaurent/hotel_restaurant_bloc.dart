import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelogue_mobile/core/repository/hotel_restaurant_repository.dart';
import 'package:travelogue_mobile/data/data_local/hotel_local.dart';
import 'package:travelogue_mobile/model/hotel_model.dart';
import 'package:travelogue_mobile/model/restaurant_model.dart';

part 'hotel_restaurant_event.dart';
part 'hotel_restaurant_state.dart';

class HotelRestaurantBloc
    extends Bloc<HotelRestaurentEvent, HotelRestaurantState> {
  final List<HotelModel> listHotel = [];
  final List<RestaurantModel> listRestaurant = [];

  HotelRestaurantBloc() : super(HotelRestaurentInitial()) {
    on<HotelRestaurentEvent>((event, emit) async {
      if (event is GetHotelRestaurantEvent) {
        listHotel.clear();
        listRestaurant.clear();

        listHotel.addAll(
          HotelRestaurantLocal().getListHotelLocal(event.locationId) ?? [],
        );

        listRestaurant.addAll(
          HotelRestaurantLocal().getListRestaurantLocal(event.locationId) ?? [],
        );

        if (listHotel.isNotEmpty || listRestaurant.isNotEmpty) {
          emit(_getSuccess);
        }

        await _getHotelRestaurent(event);
        emit(_getSuccess);
      }
    });
  }

  // Private funtion
  HotelRestaurantSuccess get _getSuccess => HotelRestaurantSuccess(
        listHotel: listHotel,
        listRestaurant: listRestaurant,
      );

  Future<void> _getHotelRestaurent(GetHotelRestaurantEvent event) async {
    final List<HotelModel> hotels = await HotelRestaurantRepository()
        .getHotelByLocation(locationId: event.locationId);

    final List<RestaurantModel> restaurants = await HotelRestaurantRepository()
        .getRestaurantsByLocation(locationId: event.locationId);

    if (listHotel.isEmpty) {
      listHotel.addAll(hotels);
      HotelRestaurantLocal().saveHotelsByLocation(
        hotels: hotels,
        locationId: event.locationId,
      );
    }

    if (listRestaurant.isEmpty) {
      listRestaurant.addAll(restaurants);
      HotelRestaurantLocal().saveRestaurantsByLocation(
        locationId: event.locationId,
        restaurants: restaurants,
      );
    }
  }
}
