import 'package:travelogue_mobile/model/tour_guide/tour_guide_model.dart';
import 'package:travelogue_mobile/model/tour/tour_model.dart';

class TourDetailCompositeModel {
  final TourModel tour;
  final TourGuideModel? guide;

  TourDetailCompositeModel({
    required this.tour,
    required this.guide,
  });

  factory TourDetailCompositeModel.fromJson(Map<String, dynamic> json) {
    final guideRaw = json['tourGuide'];
    TourGuideModel? guide;

    if (guideRaw is List && guideRaw.isNotEmpty) {
      guide = TourGuideModel.fromJson(guideRaw.first);
    } else if (guideRaw is Map<String, dynamic>) {
      guide = TourGuideModel.fromJson(guideRaw);
    }

    return TourDetailCompositeModel(
      tour: TourModel.fromJson(json['tour']),
      guide: guide,
    );
  }

  Map<String, dynamic> toJson() => {
        'tour': tour.toJson(),
        'tourGuide': guide?.toJson(),
      };
}
