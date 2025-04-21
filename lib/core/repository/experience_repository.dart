import 'package:dio/dio.dart';
import 'package:travelogue_mobile/core/constants/endpoints.dart';
import 'package:travelogue_mobile/core/constants/status_code.dart';
import 'package:travelogue_mobile/core/repository/base_repository.dart';
import 'package:travelogue_mobile/model/experience_model.dart';

class ExperienceRepository {
  Future<List<ExperienceModel>> getAllExperience() async {
    final Response response = await BaseRepository().getRoute(
      Endpoints.experiences,
    );

    if (response.statusCode == StatusCode.ok) {
      final List listData = response.data['data'] as List;
      return listData.map((value) => ExperienceModel.fromMap(value)).toList();
    }
    return [];
  }
}
