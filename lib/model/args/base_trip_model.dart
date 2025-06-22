import 'package:travelogue_mobile/model/tour_guide_test_model.dart';

abstract class BaseTrip {
  String get id;
  String get name;
  String get description;
  DateTime get startDate;
  DateTime get endDate;
  String get coverImage;
  int get status;
  double? get rating;
  double? get price;
  TourGuideTestModel? get tourGuide;

  /// ⚠️ Thêm dòng này
  String? get versionId;
}
