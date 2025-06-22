import 'package:dio/dio.dart';
import 'package:travelogue_mobile/core/constants/endpoints.dart';
import 'package:travelogue_mobile/core/constants/status_code.dart';
import 'package:travelogue_mobile/core/repository/base_repository.dart';
import 'package:travelogue_mobile/model/restaurant_model.dart';

class RestaurantRepository {
  Future<List<RestaurantModel>> getAllRestaurants() async {
    final Response response = await BaseRepository().getRoute(
      Endpoints.restaurant,
    );

    if (response.statusCode == StatusCode.ok) {
      final List listData = response.data['data'] as List;
      return listData.map((e) => RestaurantModel.fromMap(e)).toList();
    }
    return [];
  }
}
