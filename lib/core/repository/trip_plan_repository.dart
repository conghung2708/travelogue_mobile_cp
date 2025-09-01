import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:travelogue_mobile/core/constants/endpoints.dart';
import 'package:travelogue_mobile/core/constants/status_code.dart';
import 'package:travelogue_mobile/core/repository/base_repository.dart';
import 'package:travelogue_mobile/model/trip_plan/trip_plan_location_model.dart';
import 'package:travelogue_mobile/model/trip_plan/trip_plan_model.dart';
import 'package:travelogue_mobile/model/trip_plan/trip_plan_detail_model.dart';

class TripPlanRepository {
Future<List<TripPlanModel>> getTripPlans({
  String? title,
  int pageNumber = 1,
  int pageSize = 100,
}) async {
 
  pageSize = pageSize < 100 ? 100 : pageSize;

  final qp = {
    'title': title,
    'pageNumber': pageNumber,
    'pageSize': pageSize,
  }..removeWhere((k, v) => v == null || (v is String && v.isEmpty));

  final res = await BaseRepository().getRoute(Endpoints.tripPlans, queryParameters: qp);
  print('🔗 URL: ${res.requestOptions.uri}');
  if (res.statusCode == StatusCode.ok) {
    final items = (res.data['data']['items'] as List? ?? const []);
    return items.map((e) => TripPlanModel.fromJson(e)).toList();
  }
  return [];
}


Future<TripPlanDetailModel> getTripPlanDetail(String id) async {
  final Response response =
      await BaseRepository().getRoute("${Endpoints.tripPlans}/$id");


  print("📡 [API] GET TripPlanDetail($id)");
  print("  ↳ Status: ${response.statusCode}");
  print("  ↳ Headers: ${response.headers.map}");
  print("  ↳ Raw data: ${response.data}");

  if (response.statusCode == StatusCode.ok) {
    try {
      final detail = TripPlanDetailModel.fromJson(response.data['data']);
      print("✅ Parsed TripPlanDetail = ${detail.toJson()}");
      return detail;
    } catch (e, s) {
      print("❌ Parse error: $e");
      print(s);
      rethrow;
    }
  } else {
    print("❌ Error response: ${response.data}");
    throw Exception(
        response.data['message'] ?? "Lỗi khi tải chi tiết Trip Plan");
  }
}


Future<TripPlanDetailModel> createTripPlan({
  required String name,
  required String description,
  required DateTime startDate,
  required DateTime endDate,
  String? imageUrl,
}) async {
  final body = {
    "name": name,
    "description": description,
    "startDate": startDate.toIso8601String(),
    "endDate": endDate.toIso8601String(),
    if (imageUrl != null && imageUrl.isNotEmpty) "imageUrl": imageUrl,
  };

  print("📤 Sending createTripPlan body: $body");

  final Response response = await BaseRepository().postRoute(
    gateway: Endpoints.tripPlans,
    data: body,
  );

  print("📥 createTripPlan status: ${response.statusCode}");
  print("📥 createTripPlan data type: ${response.data.runtimeType}");
  print("📥 createTripPlan data: ${response.data}");

  if (response.statusCode == StatusCode.ok ||
      response.statusCode == StatusCode.created) {
    return TripPlanDetailModel.fromJson(response.data['data']);
  }

  throw Exception(response.data['message'] ?? "Không thể tạo Trip Plan");
}
Future<TripPlanDetailModel> updateTripPlan({
  required String tripPlanId,
  required String name,
  required String description,
  required DateTime startDate,
  required DateTime endDate,
  String? pickupAddress,
  String? imageUrl,
}) async {
  final fmt = DateFormat('yyyy-MM-dd');
  final body = {
    "name": name,
    "description": description,
    "startDate": fmt.format(startDate),
    "endDate": fmt.format(endDate),
    if (pickupAddress != null && pickupAddress.isNotEmpty) "pickupAddress": pickupAddress,
    if (imageUrl != null && imageUrl.isNotEmpty) "imageUrl": imageUrl,
  };

  final Response res = await BaseRepository().putRoute(
    gateway: "${Endpoints.tripPlan}/$tripPlanId", // /api/trip-plans/trip-plan/{id}
    data: body,
  );

  if (res.statusCode == StatusCode.ok || res.statusCode == StatusCode.created) {
    return TripPlanDetailModel.fromJson(res.data['data']);
  }
  throw Exception(res.data is Map && (res.data as Map)['message'] != null
      ? (res.data as Map)['message']
      : "Không thể cập nhật Trip Plan");
}
Future<void> updateTripPlanLocations({
  required String tripPlanId,
  required List<TripPlanLocationModel> locations,
}) async {
  final Response response = await BaseRepository().putRoute(
    gateway: "${Endpoints.tripPlanLocation}/$tripPlanId",
    data: locations.map((e) => e.toJson()).toList(),
  );

  if (response.statusCode != StatusCode.ok &&
      response.statusCode != StatusCode.created) {
    throw Exception(response.data['message'] ?? "Không thể cập nhật Trip Plan Location");
  }
}


}
