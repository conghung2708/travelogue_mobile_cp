import 'package:intl/intl.dart';

class CreateBookingTourGuideModel {
  final String tourGuideId;
  final String? tripPlanId;
  final DateTime startDate;
  final DateTime endDate;
  final int adultCount;
  final int childrenCount;
  final String? promotionCode;
  final String? note;

  CreateBookingTourGuideModel({
    required this.tourGuideId,
    this.tripPlanId,
    required this.startDate,
    required this.endDate,
    required this.adultCount,
    required this.childrenCount,
    this.promotionCode,
    this.note,
  });

  Map<String, dynamic> toJson() {
    final dateFmt = DateFormat('yyyy-MM-dd'); 
    return {
      "tourGuideId": tourGuideId,
      if (tripPlanId != null && tripPlanId!.isNotEmpty) "tripPlanId": tripPlanId,
      "startDate": dateFmt.format(startDate),
      "endDate": dateFmt.format(endDate),
      "adultCount": adultCount,
      "childrenCount": childrenCount,
      if (promotionCode != null && promotionCode!.isNotEmpty) "promotionCode": promotionCode,
      if (note != null && note!.isNotEmpty) "note": note,
    };
  }
}
