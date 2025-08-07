import 'package:dio/dio.dart';
import 'package:travelogue_mobile/core/constants/endpoints.dart';
import 'package:travelogue_mobile/core/constants/status_code.dart';
import 'package:travelogue_mobile/core/repository/base_repository.dart';
import 'package:travelogue_mobile/model/location_model.dart';

class NearestDataRepository {
  Future<List<LocationModel>> getNearestCuisine(String locationId) async {
    print('🍽️ Gọi API Nearest Cuisine với locationId: $locationId');

    final Response response = await BaseRepository().getRoute(
      '${Endpoints.nearestCuisine}?locationId=$locationId',
    );

    print('📡 Status: ${response.statusCode}');
    print('📦 Body: ${response.data}');

    if (response.statusCode == StatusCode.ok) {
      try {
        final List listData = response.data['data'] as List;
        print('✅ Lấy được ${listData.length} địa điểm ẩm thực');
        return listData.map((e) => LocationModel.fromMap(e)).toList();
      } catch (e, stack) {
        print('❌ Lỗi parse nearestCuisine: $e');
        print('📍 $stack');
      }
    }

    return [];
  }

  Future<List<LocationModel>> getNearestHistorical(String locationId) async {
    print('🏛️ Gọi API Nearest Historical với locationId: $locationId');

    final Response response = await BaseRepository().getRoute(
      '${Endpoints.nearestHistorical}?locationId=$locationId',
    );

    print('📡 Status: ${response.statusCode}');
    print('📦 Body: ${response.data}');

    if (response.statusCode == StatusCode.ok) {
      try {
        final List listData = response.data['data'] as List;
        print('✅ Lấy được ${listData.length} di tích lịch sử');
        return listData.map((e) => LocationModel.fromMap(e)).toList();
      } catch (e, stack) {
        print('❌ Lỗi parse nearestHistorical: $e');
        print('📍 $stack');
      }
    }

    return [];
  }
}