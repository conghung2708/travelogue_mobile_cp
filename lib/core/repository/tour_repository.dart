import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:travelogue_mobile/core/constants/endpoints.dart';
import 'package:travelogue_mobile/core/constants/status_code.dart';
import 'package:travelogue_mobile/core/repository/base_repository.dart';
import 'package:travelogue_mobile/model/composite/tour_detail_composite_model.dart';
import 'package:travelogue_mobile/model/media_model.dart';
import 'package:travelogue_mobile/model/tour/tour_day_model.dart';
import 'package:travelogue_mobile/model/tour/tour_plan_location_model.dart';
import 'package:travelogue_mobile/model/tour/tour_schedule_model.dart';
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
    final res = await BaseRepository().getRoute('${Endpoints.tour}/$tourId');
    if (res.statusCode != StatusCode.ok) return null;

    final data = (res.data['data'] as Map).cast<String, dynamic>();
    print(const JsonEncoder.withIndent('  ').convert(data));

    try {
      print('[parse] primitives ok: ${data['tourId']} | ${data['name']}');
    } catch (e, st) {
      print('[parse] primitives FAIL: $e\n$st');
      rethrow;
    }

    try {
      final rawSchedules = data['schedules'];
      if (rawSchedules is List) {
        for (var i = 0; i < rawSchedules.length; i++) {
          print('[parse] schedule[$i] start');
          TourScheduleModel.fromMap(
            (rawSchedules[i] as Map).cast<String, dynamic>(),
          );
          print('[parse] schedule[$i] ok');
        }
      }
    } catch (e, st) {
      print('[parse] schedules FAIL: $e\n$st');
      rethrow;
    }

    try {
      final rawDays = data['days'];
      if (rawDays is List) {
        for (var i = 0; i < rawDays.length; i++) {
          print('[parse] day[$i] start');
          TourDayModel.fromJson((rawDays[i] as Map).cast<String, dynamic>());
          print('[parse] day[$i] ok');
        }
      }
    } catch (e, st) {
      print('[parse] days FAIL: $e\n$st');
      rethrow;
    }

    try {
      final sl = data['startLocation'];
      if (sl is Map) TourPlanLocationModel.fromJson(sl.cast<String, dynamic>());
      final el = data['endLocation'];
      if (el is Map) TourPlanLocationModel.fromJson(el.cast<String, dynamic>());
      print('[parse] start/end location ok');
    } catch (e, st) {
      print('[parse] start/end location FAIL: $e\n$st');
      rethrow;
    }

    try {
      final rawMedias = (data['medias'] is List)
          ? data['medias']
          : (data['mediaList'] is List ? data['mediaList'] : const []);

      for (var i = 0; i < (rawMedias as List).length; i++) {
        final mediaMap = (rawMedias[i] as Map).cast<String, dynamic>();
        MediaModel.fromJson(mediaMap);
      }
      print('[parse] medias ok');
    } catch (e, st) {
      print('[parse] medias FAIL: $e\n$st');
      rethrow;
    }

    return TourModel.fromDetailJson(data);
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

  // Future<bool> deleteTour(String tourId) async {
  //   final Response response = await BaseRepository().deleteRoute(
  //     '${Endpoints.tour}/$tourId',
  //   );

  //   return response.statusCode == StatusCode.ok;
  // }

  Future<List<TourDetailCompositeModel>> getAllToursWithGuide() async {
    final Response response = await BaseRepository().getRoute(Endpoints.tour);

    if (response.statusCode == StatusCode.ok) {
      final List listData = response.data['data'] as List;
      final List<TourDetailCompositeModel> results = [];

      for (final rawTour in listData) {
        final String? tourId = rawTour['tourId'];
        if (tourId == null) continue;

        final detailResponse =
            await BaseRepository().getRoute('${Endpoints.tour}/$tourId');

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
