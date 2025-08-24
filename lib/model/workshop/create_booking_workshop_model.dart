import 'package:intl/intl.dart';
import 'package:travelogue_mobile/model/booking/booking_participant_model.dart';

class CreateBookingWorkshopModel {
  final String workshopId;          // required
  final String workshopScheduleId;  // required
  final String? promotionCode;      // optional
  final String contactName;         // required
  final String contactEmail;        // required
  final String contactPhone;        // required
  final String contactAddress;      // required
  final List<BookingParticipantModel> participants; // required

  CreateBookingWorkshopModel({
    required this.workshopId,
    required this.workshopScheduleId,
    this.promotionCode,
    required this.contactName,
    required this.contactEmail,
    required this.contactPhone,
    required this.contactAddress,
    required this.participants,
  });

  Map<String, dynamic> toJson() {
    return {
      "workshopId": workshopId,
      "workshopScheduleId": workshopScheduleId,
      if (promotionCode != null && promotionCode!.isNotEmpty)
        "promotionCode": promotionCode,
      "contactName": contactName,
      "contactEmail": contactEmail,
      "contactPhone": contactPhone,
      "contactAddress": contactAddress,
      "participants": participants.map((e) => e.toJson()).toList(),
    };
  }
}

