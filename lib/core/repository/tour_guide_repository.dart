import 'package:dio/dio.dart';
import 'package:travelogue_mobile/core/constants/endpoints.dart';
import 'package:travelogue_mobile/core/constants/status_code.dart';
import 'package:travelogue_mobile/core/repository/base_repository.dart';
import 'package:travelogue_mobile/model/tour_guide/tour_guide_filter_model.dart';
import 'package:travelogue_mobile/model/tour_guide/tour_guide_model.dart';

class TourGuideRepository {
  // Get all tour guides
  Future<List<TourGuideModel>> getAllTourGuides() async {
    final Response response = await BaseRepository().getRoute(Endpoints.tourGuide);

    if (response.statusCode == StatusCode.ok) {
      final List listData = response.data['data'] as List;
      return listData.map((e) => TourGuideModel.fromJson(e)).toList();
    }

    return [];
  }

  // Get tour guide by ID
  Future<TourGuideModel?> getTourGuideById(String guideId) async {
    final Response response = await BaseRepository().getRoute('${Endpoints.tourGuide}/$guideId');

    if (response.statusCode == StatusCode.ok) {
      return TourGuideModel.fromJson(response.data['data']);
    }

    return null;
  }

Future<List<TourGuideModel>> filterTourGuides(TourGuideFilterModel filter) async {
  final params = filter.toQueryParams();
  print('📎 Full query: $params');

  final response = await BaseRepository().getRoute(
    Endpoints.tourGuideFilter,
    queryParameters: params,
  );

  print("🚀 Đang gọi filter hướng dẫn viên với các params:");
params.forEach((key, value) => print("🔹 $key = $value"));

  print('📥 Raw response: ${response.data}');
  print('🟢 Data trả về: $response');

  if (response.statusCode == StatusCode.ok) {
    final List data = response.data['data'];
    return data.map((e) => TourGuideModel.fromJson(e)).toList();
  }

  return [];
}


}
