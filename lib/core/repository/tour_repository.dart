import 'package:dio/dio.dart';
import 'package:travelogue_mobile/core/constants/endpoints.dart';
import 'package:travelogue_mobile/core/constants/status_code.dart';
import 'package:travelogue_mobile/core/repository/base_repository.dart';
import 'package:travelogue_mobile/model/composite/tour_detail_composite_model.dart';
import 'package:travelogue_mobile/model/tour_guide/tour_guide_model.dart';
import 'package:travelogue_mobile/model/tour/tour_model.dart';

class TourRepository {

  Future<List<TourModel>> getAllTours() async {
    final Response response = await BaseRepository().getRoute(Endpoints.tour);

    if (response.statusCode == StatusCode.ok) {
      final List listData = response.data['data'] as List;
      return listData.map((e) => TourModel.fromLiteJson(e)).toList();
    }

    return [];
  }


  Future<TourModel?> getTourById(String tourId) async {
    final Response response = await BaseRepository().getRoute('${Endpoints.tour}/$tourId');

    if (response.statusCode == StatusCode.ok) {
      return TourModel.fromDetailJson(response.data['data'], logSchedules: true);
    }

    return null;
  }




Future<bool> createTour(Map<String, dynamic> body) async {
  final Response response = await BaseRepository().postRoute(
    gateway: Endpoints.tour,
    data: body,
  );

  return response.statusCode == StatusCode.created;
}

Future<bool> updateTour(String tourId, Map<String, dynamic> body) async {
  final Response response = await BaseRepository().putRoute(
    gateway: '${Endpoints.tour}/$tourId',
    data: body,
  );

  return response.statusCode == StatusCode.ok;
}



  Future<bool> deleteTour(String tourId) async {
    final Response response = await BaseRepository().deleteRoute(
      '${Endpoints.tour}/$tourId',
    );

    return response.statusCode == StatusCode.ok;
  }

  Future<List<TourDetailCompositeModel>> getAllToursWithGuide() async {
    final Response response = await BaseRepository().getRoute(Endpoints.tour);

    if (response.statusCode == StatusCode.ok) {
      final List listData = response.data['data'] as List;
      final List<TourDetailCompositeModel> results = [];

      for (final rawTour in listData) {
        final String? tourId = rawTour['tourId'];
        if (tourId == null) continue;

        final detailResponse = await BaseRepository().getRoute('${Endpoints.tour}/$tourId');

        if (detailResponse.statusCode == StatusCode.ok) {
          final detailData = detailResponse.data['data'];

          final tour = TourModel.fromDetailJson(detailData);
          final guideRaw = detailData['tourGuide'];
          TourGuideModel? guide;

          try {
            if (guideRaw is List && guideRaw.isNotEmpty) {
              guide = TourGuideModel.fromJson(guideRaw.first);
            } else if (guideRaw is Map<String, dynamic>) {
              guide = TourGuideModel.fromJson(guideRaw);
            }
          } catch (e) {
            print('🔥 Error parsing tourGuide: $e');
            guide = null;
          }

          results.add(TourDetailCompositeModel(tour: tour, guide: guide));
        }
      }

      return results;
    }

    return [];
  }
}
