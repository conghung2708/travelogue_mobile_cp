import 'package:travelogue_mobile/core/constants/endpoints.dart';
import 'package:travelogue_mobile/core/constants/status_code.dart';
import 'package:travelogue_mobile/core/repository/base_repository.dart';
import 'package:travelogue_mobile/model/workshop/workshop_detail_model.dart';
import 'package:travelogue_mobile/model/workshop/workshop_list_model.dart';

class WorkshopRepository {

  Future<List<WorkshopListModel>> getWorkshops({
    String? name,
    String? craftVillageId,
  }) async {
    print('[📤 GET WORKSHOPS] name=$name, craftVillageId=$craftVillageId');

    
    final Map<String, dynamic> queryParams = {};
    if (name != null && name.isNotEmpty) queryParams['name'] = name;
    if (craftVillageId != null && craftVillageId.isNotEmpty) {
      queryParams['craftVillageId'] = craftVillageId;
    }

    final response = await BaseRepository().getRoute(
      Endpoints.getWorkshops,
      queryParameters: queryParams.isEmpty ? null : queryParams,
    );

    print('[📥 GET WORKSHOPS] Status: ${response.statusCode}');
    print('[📥 GET WORKSHOPS] Data: ${response.data}');

    if (response.statusCode == StatusCode.ok &&
        response.data != null &&
        response.data['data'] != null &&
        response.data['data'] is List) {
      try {
        final List<dynamic> list = response.data['data'];
        final workshops = list
            .map((item) =>
                WorkshopListModel.fromMap(item as Map<String, dynamic>))
            .toList();
        print('[✅ PARSE SUCCESS] Total workshops: ${workshops.length}');
        return workshops;
      } catch (e) {
        print('[❌ PARSE WORKSHOPS ERROR] $e');
        return [];
      }
    } else {
      print('[❌ GET WORKSHOPS FAILED]');
      return [];
    }
  }

Future<WorkshopDetailModel?> getWorkshopDetail({
  required String workshopId,
  String? scheduleId,
}) async {
  print('[📤 GET WORKSHOP DETAIL] workshopId=$workshopId, scheduleId=$scheduleId');

  final response = await BaseRepository().getRoute(
    '${Endpoints.getWorkshopDetail}/$workshopId', 
    queryParameters: scheduleId != null ? {'scheduleId': scheduleId} : null,
  );

  print('[📥 GET WORKSHOP DETAIL] Status: ${response.statusCode}');
  print('[📥 GET WORKSHOP DETAIL] Data: ${response.data}');

  if (response.statusCode == StatusCode.ok &&
      response.data != null &&
      response.data['data'] != null) {
    try {
      return WorkshopDetailModel.fromMap(response.data['data']);
    } catch (e) {
      print('[❌ PARSE WORKSHOP DETAIL ERROR] $e');
      return null;
    }
  } else {
    print('[❌ GET WORKSHOP DETAIL FAILED]');
    return null;
  }
}


  
}
