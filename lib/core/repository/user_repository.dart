// core/repository/user_repository.dart
import 'dart:io';
import 'package:dio/dio.dart' as diox;
import 'package:travelogue_mobile/core/constants/endpoints.dart';
import 'package:travelogue_mobile/core/constants/status_code.dart';
import 'package:travelogue_mobile/core/repository/base_repository.dart';
import 'package:travelogue_mobile/model/user/tour_guide_request_model.dart';
import 'package:travelogue_mobile/model/user/user_profile_model.dart';

class UserRepository {
  Future<bool> sendTourGuideRequest(TourGuideRequestModel model) async {
    final response = await BaseRepository().postRoute(
      gateway: Endpoints.tourGuideRequest,
      data: model.toJson(),
    );
    return response.statusCode == StatusCode.ok;
  }

  Future<UserProfileModel?> getUserById(String id) async {
    final url = '${Endpoints.getUserByIdBase}/$id';
    final res = await BaseRepository().getRoute(url);
    if (res.statusCode == StatusCode.ok && res.data != null) {
      final data = res.data['data'] ?? res.data['Data'];
      if (data is Map<String, dynamic>) return UserProfileModel.fromMap(data);
    }
    return null;
  }

Future<UserProfileModel?> updateUserProfile({
  required String id,
  String? phoneNumber,
  String? fullName,
  int? sex,            
  String? address,
}) async {
  final url = '${Endpoints.updateUserBase}/$id';


  final body = <String, dynamic>{
    if (phoneNumber != null) 'phoneNumber': phoneNumber,
    if (fullName != null) 'fullName': fullName,
    if (sex != null) 'sex': (sex == 1 || sex == 2) ? sex : 1,
    if (address != null) 'address': address,
  };

  print('[➡️ PUT] $url');
  print('[📦 Body] $body');

  final res = await BaseRepository().putRoute(gateway: url, data: body);

  print('[⬅️ Status] ${res.statusCode}');
  print('[⬅️ Data] ${res.data}');

  if (res.statusCode == StatusCode.ok && res.data != null) {
    final data = res.data['data'] ?? res.data['Data'] ?? res.data;
    if (data is Map<String, dynamic>) {
      return UserProfileModel.fromMap(data);
    }
  }
  return null;
}

Future<String?> updateAvatar(File file) async {
  final form = diox.FormData.fromMap({
    'file': await diox.MultipartFile.fromFile(
      file.path,
      filename: file.uri.pathSegments.last,
    ),
  });

  print('[➡️ PUT] ${Endpoints.updateUserAvatar}');
  print('[📦 FormData] file=${file.path}');

  final res = await BaseRepository().putFormData(
    Endpoints.updateUserAvatar,
    form,
  );

  print('[⬅️ Status] ${res.statusCode}');
  print('[⬅️ Data] ${res.data}');

  if (res.statusCode == StatusCode.ok && res.data != null) {
    final d = res.data['data'] ?? res.data['Data'] ?? res.data;
    if (d is String) return d;
    if (d is Map && d['avatarUrl'] != null) return d['avatarUrl'].toString();
  }
  return null;
}
}
