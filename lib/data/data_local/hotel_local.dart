import 'package:hive/hive.dart';
import 'package:travelogue_mobile/data/data_local/storage_key.dart';
import 'package:travelogue_mobile/model/hotel_model.dart';
import 'package:travelogue_mobile/model/restaurant_model.dart';

class HotelRestaurantLocal {
  final Box boxHotel = Hive.box(StorageKey.boxHotel);
  final Box boxRestaurant = Hive.box(StorageKey.boxRestaurant);

  // Getter
  List<HotelModel>? getListHotelLocal(String locationId) {
    final List? hotelByLocation = boxHotel.get(
      '${StorageKey.hotels}/$locationId',
      defaultValue: null,
    );

    if (hotelByLocation == null) {
      return null;
    }

    return hotelByLocation
        .map(
          (message) => HotelModel.fromJson(message),
        )
        .toList();
  }

  List<RestaurantModel>? getListRestaurantLocal(String locationId) {
    final List? restaurantByLocation = boxHotel.get(
      '${StorageKey.restaurants}/$locationId',
      defaultValue: null,
    );

    if (restaurantByLocation == null) {
      return null;
    }

    return restaurantByLocation
        .map(
          (message) => RestaurantModel.fromJson(message),
        )
        .toList();
  }

  // Setter

  void saveHotelsByLocation({
    required String locationId,
    required List<HotelModel> hotels,
  }) {
    if (hotels.isEmpty) {
      return;
    }

    boxHotel.put(
      '${StorageKey.hotels}/$locationId',
      hotels
          .map(
            (hotel) => hotel.toJson(),
          )
          .toList(),
    );
  }

  void saveRestaurantsByLocation({
    required String locationId,
    required List<RestaurantModel> restaurants,
  }) {
    if (restaurants.isEmpty) {
      return;
    }

    boxHotel.put(
      '${StorageKey.restaurants}/$locationId',
      restaurants
          .map(
            (restaurant) => restaurant.toJson(),
          )
          .toList(),
    );
  }

  // Clean
  void clear() {
    boxHotel.clear();
    boxRestaurant.clear();
  }
}
