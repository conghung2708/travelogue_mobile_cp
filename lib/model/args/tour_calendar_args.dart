// lib/model/args/tour_calendar_args.dart
import 'package:travelogue_mobile/model/tour/tour_model.dart';
import 'package:travelogue_mobile/model/tour/tour_schedule_model.dart';

class TourCalendarArgs {
  final TourModel tour;
  final List<TourScheduleModel> schedules;
  final bool isGroupTour;

 
  final String? pickupAddress;

  const TourCalendarArgs({
    required this.tour,
    required this.schedules,
    required this.isGroupTour,
    this.pickupAddress,
  });
}
