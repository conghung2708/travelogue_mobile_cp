import 'package:travelogue_mobile/model/booking/booking_participant_model.dart';

class CreateBookingTourModel {
  final String tourId;
  final String scheduledId;
  final String? promotionCode;

  // Contact info (required theo sample BE)
  final String contactName;
  final String contactEmail;
  final String contactPhone;
  final String contactAddress;

  // Danh sách người tham gia
  final List<BookingParticipantModel> participants;

  CreateBookingTourModel({
    required this.tourId,
    required this.scheduledId,
    this.promotionCode,
    required this.contactName,
    required this.contactEmail,
    required this.contactPhone,
    required this.contactAddress,
    required this.participants,
  });

  Map<String, dynamic> toJson() => {
        "tourId": tourId,
        "scheduledId": scheduledId,
        "promotionCode": promotionCode,
        "contactName": contactName,
        "contactEmail": contactEmail,
        "contactPhone": contactPhone,
        "contactAddress": contactAddress,
        "participants": participants.map((e) => e.toJson()).toList(),
      };
}
