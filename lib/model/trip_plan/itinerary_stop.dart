import 'package:travelogue_mobile/model/location_model.dart';

class ItineraryStop {
  final LocationModel place;
  final DateTime arrival;   
  final DateTime depart;    
  final int stayMinutes;    
  final int travelMeters;   
  final int travelSeconds; 

  ItineraryStop({
    required this.place,
    required this.arrival,
    required this.depart,
    required this.stayMinutes,
    required this.travelMeters,
    required this.travelSeconds,
  });
}
