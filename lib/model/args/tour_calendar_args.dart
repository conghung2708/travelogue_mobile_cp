import 'package:travelogue_mobile/model/tour/tour_model.dart';
import 'package:travelogue_mobile/model/tour/tour_schedule_model.dart';


class TourCalendarArgs {
  final TourModel tour;
  final List<TourScheduleModel> schedules;
  final bool isGroupTour;

  TourCalendarArgs({
    required this.tour,
    required this.schedules,
    this.isGroupTour = false,
  });
}
