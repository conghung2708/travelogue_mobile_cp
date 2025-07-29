
import 'package:travelogue_mobile/model/tour/tour_plan_version_test_model.dart';
import 'package:travelogue_mobile/model/tour/tour_schedule_test_model.dart';
import 'package:travelogue_mobile/model/tour/tour_schedule_model.dart';

class TourScheduleWithPrice {
  final String scheduleId;
  final String tourId;
  final DateTime departureDate;
  final int maxParticipant;
  final int currentBooked;
  final int availableSlot;
  final int totalDays;
  final double adultPrice;
  final double childrenPrice;
  final double price; 
  final bool isDiscount; 

  TourScheduleWithPrice({
    required this.scheduleId,
    required this.tourId,
    required this.departureDate,
    required this.maxParticipant,
    required this.currentBooked,
    required this.availableSlot,
    required this.totalDays,
    required this.adultPrice,
    required this.childrenPrice,
    required this.price,
    required this.isDiscount,
  });
}

