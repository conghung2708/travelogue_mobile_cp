class CreateBookingTourModel {
  final String tourId;
  final String scheduledId;
  final String? promotionCode;
  final int adultCount;
  final int childrenCount;

  CreateBookingTourModel({
    required this.tourId,
    required this.scheduledId,
    this.promotionCode,
    required this.adultCount,
    required this.childrenCount,
  });

  Map<String, dynamic> toJson() => {
        "tourId": tourId,
        "scheduledId": scheduledId,
        "promotionCode": promotionCode,
        "adultCount": adultCount,
        "childrenCount": childrenCount,
      };
}
