import 'package:dio/dio.dart';
import 'package:travelogue_mobile/core/constants/endpoints.dart';
import 'package:travelogue_mobile/core/constants/status_code.dart';
import 'package:travelogue_mobile/core/repository/base_repository.dart';
import 'package:travelogue_mobile/model/hotel_model.dart';
import 'package:travelogue_mobile/model/restaurant_model.dart';

class HotelRestaurantRepository {
  Future<List<HotelModel>> getHotelByLocation({
    required String locationId,
  }) async {
    final Response response = await BaseRepository().getRoute(
      '${Endpoints.location}/$locationId/${Endpoints.hotelByLocation}',
    );

    if (response.statusCode == StatusCode.ok) {
      final List listData = response.data['data']['recommendedHotels'] as List;
      return listData.map((value) => HotelModel.fromMap(value)).toList();
    }
    return [];
  }

  Future<List<RestaurantModel>> getRestaurantsByLocation({
    required String locationId,
  }) async {
    final Response response = await BaseRepository().getRoute(
      '${Endpoints.location}/$locationId/${Endpoints.restaurantLocation}',
    );

    if (response.statusCode == StatusCode.ok) {
      final List listData =
          response.data['data']['recommendedRestaurants'] as List;
      return listData.map((value) => RestaurantModel.fromMap(value)).toList();
    }
    return [];
  }
}
