import 'package:dio/dio.dart';
import 'package:travelogue_mobile/core/constants/endpoints.dart';
import 'package:travelogue_mobile/core/constants/status_code.dart';
import 'package:travelogue_mobile/core/repository/base_repository.dart';
import 'package:travelogue_mobile/model/news_model.dart';

class NewsRepository {
  Future<List<NewsModel>> getAllNews() async {
    final Response response = await BaseRepository().getRoute(
      Endpoints.news,
    );

    if (response.statusCode == StatusCode.ok) {
      final List listData = response.data['data'] as List;
      return listData.map((value) => NewsModel.fromMap(value)).toList();
    }
    return [];
  }
}
