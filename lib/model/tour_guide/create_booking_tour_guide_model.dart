import 'package:intl/intl.dart';
import 'package:travelogue_mobile/model/booking/booking_participant_model.dart';

class CreateBookingTourGuideModel {

  final String tourGuideId;
  final DateTime startDate;
  final DateTime endDate;


  final String? tripPlanId;
  final String? promotionCode;


  final String contactName;
  final String contactEmail;
  final String contactPhone;
  final String contactAddress;


  final List<BookingParticipantModel>? participants;

  CreateBookingTourGuideModel({
    required this.tourGuideId,
    required this.startDate,
    required this.endDate,
    required this.contactName,
    required this.contactEmail,
    required this.contactPhone,
    required this.contactAddress,
    this.tripPlanId,
    this.promotionCode,
    this.participants,
  });

  Map<String, dynamic> toJson() {
    final dateFmt = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
    return {
      "tourGuideId": tourGuideId,
      "startDate": dateFmt.format(startDate),
      "endDate": dateFmt.format(endDate),

     
      if (tripPlanId != null && tripPlanId!.isNotEmpty) "tripPlanId": tripPlanId,
      if (promotionCode != null && promotionCode!.isNotEmpty) "promotionCode": promotionCode,

    
      "contactName": contactName,
      "contactEmail": contactEmail,
      "contactPhone": contactPhone,
      "contactAddress": contactAddress,

   
      if (participants != null && participants!.isNotEmpty)
        "participants": participants!.map((p) => p.toJson()).toList(),
    };
  }
}
