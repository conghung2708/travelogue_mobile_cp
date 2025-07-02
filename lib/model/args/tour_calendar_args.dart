import 'package:travelogue_mobile/model/tour/tour_schedule_with_price.dart';
import 'package:travelogue_mobile/model/tour/tour_test_model.dart';

class TourCalendarArgs {
  final TourTestModel tour;
  final List<TourScheduleWithPrice> schedules;

  TourCalendarArgs({
    required this.tour,
    required this.schedules,
  });
}
