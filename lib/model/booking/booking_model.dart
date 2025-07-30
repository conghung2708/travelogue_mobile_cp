class BookingModel {
  final String id;
  final String userId;
  final String? tourId;
  final String? tourScheduleId;
  final String? tourGuideId;
  final String? tripPlanId;
  final String? workshopId;
  final String? workshopScheduleId;
  final String? paymentLinkId;
  final String status;
  final String? statusText;
  final String bookingType;
  final String? bookingTypeText;
  final DateTime bookingDate;
  final DateTime? cancelledAt;
  final String? promotionId;
  final double originalPrice;
  final double discountAmount;
  final double finalPrice;

  BookingModel({
    required this.id,
    required this.userId,
    this.tourId,
    this.tourScheduleId,
    this.tourGuideId,
    this.tripPlanId,
    this.workshopId,
    this.workshopScheduleId,
    this.paymentLinkId,
    required this.status,
    this.statusText,
    required this.bookingType,
    this.bookingTypeText,
    required this.bookingDate,
    this.cancelledAt,
    this.promotionId,
    required this.originalPrice,
    required this.discountAmount,
    required this.finalPrice,
  });

factory BookingModel.fromJson(Map<String, dynamic> json) {
  return BookingModel(
    id: json['id']?.toString() ?? '',
    userId: json['userId']?.toString() ?? '',
    tourId: json['tourId']?.toString(),
    tourScheduleId: json['tourScheduleId']?.toString(),
    tourGuideId: json['tourGuideId']?.toString(),
    tripPlanId: json['tripPlanId']?.toString(),
    workshopId: json['workshopId']?.toString(),
    workshopScheduleId: json['workshopScheduleId']?.toString(),
    paymentLinkId: json['paymentLinkId']?.toString(),
    status: json['status']?.toString() ?? 'UNKNOWN',
    statusText: json['statusText']?.toString(),
    bookingType: json['bookingType']?.toString() ?? 'UNKNOWN',
    bookingTypeText: json['bookingTypeText']?.toString(),
   bookingDate: json['bookingDate'] != null
    ? DateTime.parse(json['bookingDate'])
    : throw const FormatException('bookingDate is missing'), 
    cancelledAt: json['cancelledAt'] != null
        ? DateTime.parse(json['cancelledAt'])
        : null,
    promotionId: json['promotionId']?.toString(),
    originalPrice: (json['originalPrice'] ?? 0).toDouble(),
    discountAmount: (json['discountAmount'] ?? 0).toDouble(),
    finalPrice: (json['finalPrice'] ?? 0).toDouble(),
  );
}

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'tourId': tourId,
      'tourScheduleId': tourScheduleId,
      'tourGuideId': tourGuideId,
      'tripPlanId': tripPlanId,
      'workshopId': workshopId,
      'workshopScheduleId': workshopScheduleId,
      'paymentLinkId': paymentLinkId,
      'status': status,
      'statusText': statusText,
      'bookingType': bookingType,
      'bookingTypeText': bookingTypeText,
      'bookingDate': bookingDate.toIso8601String(),
      'cancelledAt': cancelledAt?.toIso8601String(),
      'promotionId': promotionId,
      'originalPrice': originalPrice,
      'discountAmount': discountAmount,
      'finalPrice': finalPrice,
    };
  }
}
