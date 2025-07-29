// import 'package:travelogue_mobile/model/tour/tour_schedule_test_model.dart';
// import 'package:travelogue_mobile/model/tour/tour_plan_version_test_model.dart';
// import 'package:travelogue_mobile/model/tour/tour_schedule_with_price.dart';

// List<TourScheduleWithPrice> combineScheduleWithPrice({
//   required List<TourScheduleTestModel> schedules,
//   required List<TourPlanVersionTestModel> versions,
// }) {
//   final latestVersionMap = <String, TourPlanVersionTestModel>{};

//   for (var version in versions) {
//     if (version.isActive && !version.isDeleted) {
//       final current = latestVersionMap[version.tourId];
//       if (current == null || version.versionDate.isAfter(current.versionDate)) {
//         latestVersionMap[version.tourId] = version;
//       }
//     }
//   }

//   return schedules.where((s) => s.isActive && !s.isDeleted).map((s) {
//     final version = latestVersionMap[s.tourId];
//     return TourScheduleWithPrice(
//       scheduleId: s.id,
//       tourId: s.tourId,
//       departureDate: s.departureDate,
//       maxParticipant: s.maxParticipant,
//       currentBooked: s.currentBooked,
//       availableSlot: s.maxParticipant - s.currentBooked,
//       adultPrice: version?.adultPrice ?? 0,
//       childrenPrice: version?.childrenPrice ?? 0,
//       price: version?.price ?? 0, 
//       versionId: version?.id ?? '',
//       isDiscount: version?.isDiscount ?? false, 
//     );
//   }).toList();
// }
