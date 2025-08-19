import 'package:travelogue_mobile/model/location_model.dart';

class ItineraryStop {
  final LocationModel place;
  final DateTime arrival;   // giờ đến
  final DateTime depart;    // giờ rời
  final int stayMinutes;    // thời gian ở lại (phút)
  final int travelMeters;   // quãng đường từ điểm trước tới đây
  final int travelSeconds;  // thời gian di chuyển từ điểm trước tới đây

  ItineraryStop({
    required this.place,
    required this.arrival,
    required this.depart,
    required this.stayMinutes,
    required this.travelMeters,
    required this.travelSeconds,
  });
}
