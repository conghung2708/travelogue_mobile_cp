// lib/core/repository/tour_guide_repository.dart
import 'package:dio/dio.dart';
import 'package:travelogue_mobile/core/constants/endpoints.dart';
import 'package:travelogue_mobile/core/constants/status_code.dart';
import 'package:travelogue_mobile/core/repository/base_repository.dart';
import 'package:travelogue_mobile/model/tour_guide/tour_guide_filter_model.dart';
import 'package:travelogue_mobile/model/tour_guide/tour_guide_model.dart';
import 'package:flutter/material.dart';

class TourGuideRepository {
  Future<List<TourGuideModel>> getAllTourGuides() async {
    final Response response = await BaseRepository().getRoute(Endpoints.tourGuide);
    if (response.statusCode == StatusCode.ok) {
      final List listData = response.data['data'] as List;
      return listData.map((e) => TourGuideModel.fromJson(e)).toList();
    }
    return [];
  }

  Future<TourGuideModel?> getTourGuideById(String guideId) async {
    final Response response =
        await BaseRepository().getRoute('${Endpoints.tourGuide}/$guideId');
    if (response.statusCode == StatusCode.ok) {
      return TourGuideModel.fromJson(response.data['data']);
    }
    return null;
  }

  Future<List<TourGuideModel>> filterTourGuides(TourGuideFilterModel filter) async {
    final params = filter.toQueryParams();
    final response = await BaseRepository()
        .getRoute(Endpoints.tourGuideFilter, queryParameters: params);

    if (response.statusCode == StatusCode.ok) {
      final List data = response.data['data'];
      return data.map((e) => TourGuideModel.fromJson(e)).toList();
    }
    return [];
  }

  Future<bool> isAvailableUsingFilter({
    required String guideId,
    required DateTime start,
    required DateTime end,
  }) async {
    final results = await filterTourGuides(
      TourGuideFilterModel(startDate: start, endDate: end),
    );

    return results.any((g) => g.id == guideId || g.id == guideId);
  }

  /// Gợi ý các khoảng ngày gần nhất mà HDV rảnh, dùng filter lặp để tìm.
  /// - Giữ nguyên độ dài khoảng ngày gốc (end-start).
  /// - Tìm xuôi trước, rồi lùi lại sau (hoặc ngược lại), thu tối đa [limit] gợi ý.
  Future<List<DateTimeRange>> suggestNearestAvailabilityUsingFilter({
    required String guideId,
    required DateTime from,
    required DateTime to,
    int limit = 4,
    int maxSearchDays = 30, // không nên quá lớn để tránh gọi API nhiều
  }) async {
    final suggestions = <DateTimeRange>[];
    final days = to.difference(from).inDays.clamp(1, 30); // độ dài range
    int offset = 1;

    // Tìm lần lượt +offset, -offset cho tới khi đủ limit hoặc hết maxSearchDays
    while (suggestions.length < limit && offset <= maxSearchDays) {
      // thử tiến về phía trước
      final f1 = from.add(Duration(days: offset));
      final t1 = f1.add(Duration(days: days));
      final ok1 = await isAvailableUsingFilter(guideId: guideId, start: f1, end: t1);
      if (ok1) {
        suggestions.add(DateTimeRange(start: f1, end: t1));
        if (suggestions.length >= limit) break;
      }

      // thử lùi về phía sau
      final f2 = from.subtract(Duration(days: offset));
      final t2 = f2.add(Duration(days: days));
      if (f2.isAfter(DateTime.now().subtract(const Duration(days: 1)))) {
        final ok2 = await isAvailableUsingFilter(guideId: guideId, start: f2, end: t2);
        if (ok2) {
          suggestions.add(DateTimeRange(start: f2, end: t2));
          if (suggestions.length >= limit) break;
        }
      }

      offset++;
    }

    return suggestions;
  }
}
