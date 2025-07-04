
import 'package:travelogue_mobile/model/tour/tour_plan_version_test_model.dart';
import 'package:travelogue_mobile/model/tour/tour_schedule_test_model.dart';
class TourScheduleWithPrice {
  final String scheduleId;
  final String tourId;
  final DateTime departureDate;
  final int maxParticipant;
   int currentBooked;
  final int availableSlot;
  final double adultPrice;
  final double childrenPrice;
  final double price;
  final String versionId;
  final bool isDiscount; 

  TourScheduleWithPrice({
    required this.scheduleId,
    required this.tourId,
    required this.departureDate,
    required this.maxParticipant,
    required this.currentBooked,
    required this.availableSlot,
    required this.adultPrice,
    required this.childrenPrice,
    required this.price,
    required this.versionId,
    required this.isDiscount, 
  });
}

final List<TourScheduleWithPrice> mockTourSchedulesWithPrice = mockTourSchedules.map((schedule) {
  final matchedVersions = mockTourPlanVersions
      .where((v) => v.tourId == schedule.tourId && !v.isDeleted && v.isActive)
      .toList();

  matchedVersions.sort((a, b) => b.versionNumber.compareTo(a.versionNumber));
  final latestVersion = matchedVersions.first;

  return TourScheduleWithPrice(
    scheduleId: schedule.id,
    tourId: schedule.tourId,
    departureDate: schedule.departureDate,
    maxParticipant: schedule.maxParticipant,
    currentBooked: schedule.currentBooked,
    availableSlot: schedule.maxParticipant - schedule.currentBooked,
    adultPrice: latestVersion.adultPrice,
    childrenPrice: latestVersion.childrenPrice,
    price: latestVersion.price,
    versionId: latestVersion.id,
    isDiscount: latestVersion.isDiscount, 
  );
}).toList();
