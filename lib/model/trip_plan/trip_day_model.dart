import 'package:travelogue_mobile/model/trip_plan/trip_activity_model.dart';

class TripDayModel {
  final int dayNumber;
  final DateTime date;
  final String dateFormatted;
  final List<TripActivityModel> activities;

  TripDayModel({
    required this.dayNumber,
    required this.date,
    required this.dateFormatted,
    required this.activities,
  });


  static int _asInt(dynamic v, {int fallback = 1}) {
    if (v is int) return v;
    if (v is String) return int.tryParse(v) ?? fallback;
    return fallback; 
  }

  static DateTime _asDate(dynamic v) {
    if (v is DateTime) return v;
    if (v is String) return DateTime.tryParse(v) ?? DateTime.now();
    return DateTime.now();
  }

  factory TripDayModel.fromJson(Map<String, dynamic> json) {
    final activitiesJson = (json['activities'] as List?) ?? const [];

    return TripDayModel(
      dayNumber: _asInt(json['dayNumber'], fallback: 1),
      date: _asDate(json['date']),
      dateFormatted: (json['dateFormatted'] ?? '').toString(),
      activities: activitiesJson
          .map((e) => TripActivityModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
