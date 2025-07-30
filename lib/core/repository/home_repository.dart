import 'package:dio/dio.dart';
import 'package:travelogue_mobile/core/constants/endpoints.dart';
import 'package:travelogue_mobile/core/constants/status_code.dart';
import 'package:travelogue_mobile/core/repository/base_repository.dart';
import 'package:travelogue_mobile/model/event_model.dart';
import 'package:travelogue_mobile/model/location_model.dart';
import 'package:travelogue_mobile/model/type_location_model.dart';

class HomeRepository {
  Future<List<TypeLocationModel>> getTypeLocation() async {
    final Response response = await BaseRepository().getRoute(
      Endpoints.locationType,
    );

    if (response.statusCode == StatusCode.ok) {
      final List listData = response.data['data'] as List;
      return listData.map((value) => TypeLocationModel.fromMap(value)).toList();
    }
    return [];
  }

Future<List<LocationModel>> getAllLocation() async {
  final Response response = await BaseRepository().getRoute(
    Endpoints.location,
  );

  print('📡 Response status: ${response.statusCode}');
  print('📦 Raw data: ${response.data}');

  if (response.statusCode == StatusCode.ok) {
    try {
      final List listData = response.data['data'] as List;
      print('📊 Danh sách địa điểm từ API: ${listData.length}');
      return listData.map((value) => LocationModel.fromMap(value)).toList();
    } catch (e) {
      print('❌ Lỗi parse danh sách địa điểm: $e');
    }
  } else {
    print('❌ API trả về mã lỗi: ${response.statusCode}');
  }

  return [];
}


  Future<List<EventModel>> getEvents() async {
    final Response response = await BaseRepository().getRoute(
      Endpoints.events,
    );

    if (response.statusCode == StatusCode.ok) {
      final List listData = response.data['data'] as List;
      return listData.map((value) => EventModel.fromMap(value)).toList();
    }
    return [];
  }

  Future<List<LocationModel>> getLocationFavorite() async {
    final Response response = await BaseRepository().getRoute(
      '${Endpoints.locationFavorite}?pageNumber=1&pageSize=10',
    );

    if (response.statusCode == StatusCode.ok) {
      final List listData = response.data['data']['items'] as List;
      return listData.map((value) => LocationModel.fromMap(value)).toList();
    }
    return [];
  }

Future<bool> updateLikedLocation({required String locationId}) async {
  final Response response = await BaseRepository().postRoute(
    gateway: '${Endpoints.location}/$locationId/favorite',
    data: {}, 
  );

  return response.statusCode == StatusCode.ok;
}


  Future<bool> deletedLikedLocation({required String locationId}) async {
    final Response response = await BaseRepository().deleteRoute(
      '${Endpoints.location}/$locationId/favorite',
    );

    return response.statusCode == StatusCode.ok;
  }
}
