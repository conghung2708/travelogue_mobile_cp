import 'package:travelogue_mobile/model/tour/tour_schedule_with_price.dart';
import 'package:travelogue_mobile/model/tour/tour_test_model.dart';

class TourWithScheduleModel {
  final TourTestModel tour;
  final TourScheduleWithPrice selectedSchedule;

  TourWithScheduleModel({
    required this.tour,
    required this.selectedSchedule,
  });
}