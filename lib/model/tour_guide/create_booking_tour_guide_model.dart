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

  Map<String, dynamic> toJson() => {
        "tourGuideId": tourGuideId,
        "tripPlanId": tripPlanId,
        "startDate": startDate.toIso8601String(),
        "endDate": endDate.toIso8601String(),
        "adultCount": adultCount,
        "childrenCount": childrenCount,
        "promotionCode": promotionCode,
        "note": note,
      };
}
