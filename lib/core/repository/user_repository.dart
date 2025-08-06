import 'package:travelogue_mobile/core/constants/endpoints.dart';
import 'package:travelogue_mobile/core/constants/status_code.dart';
import 'package:travelogue_mobile/core/repository/base_repository.dart';
import 'package:travelogue_mobile/model/user/tour_guide_request_model.dart';

class UserRepository {
  Future<bool> sendTourGuideRequest(TourGuideRequestModel model) async {
    final response = await BaseRepository().postRoute(
      gateway: Endpoints.tourGuideRequest, 
      data: model.toJson(),
    );

    if (response.statusCode == StatusCode.ok) {
      print("✅ Tour guide request sent successfully!");
      return true;
    } else {
      print("❌ Failed to send request: ${response.data}");
      return false;
    }
  }
}
