import 'package:dio/dio.dart';
import 'package:travelogue_mobile/core/constants/endpoints.dart';
import 'package:travelogue_mobile/core/constants/status_code.dart';
import 'package:travelogue_mobile/core/repository/base_repository.dart';
import 'package:travelogue_mobile/model/location_model.dart';

class LocationRepository {
  Future<List<LocationModel>> searchLocation({required String search}) async {
    final Response response = await BaseRepository().getRoute(
      '${Endpoints.searchLocation}?title=$search&&pageNumber=1&&pageSize=10',
    );

    if (response.statusCode == StatusCode.ok) {
      final List listData = response.data['data'] as List;
      return listData.map((value) => LocationModel.fromMap(value)).toList();
    }

    return [];
  }
}
