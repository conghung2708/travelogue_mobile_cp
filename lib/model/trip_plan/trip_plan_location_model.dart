import 'package:travelogue_mobile/model/trip_plan/trip_activity_model.dart';

class TripPlanLocationModel {
  final String? tripPlanLocationId;
  final String locationId;
  final int order;
  final DateTime startTime;
  final DateTime endTime;
  final String notes;
  final int travelTimeFromPrev;
  final int distanceFromPrev;
  final int estimatedStartTime;
  final int estimatedEndTime;

  TripPlanLocationModel({
    this.tripPlanLocationId,
    required this.locationId,
    required this.order,
    required this.startTime,
    required this.endTime,
    this.notes = '',
    this.travelTimeFromPrev = 0,
    this.distanceFromPrev = 0,
    this.estimatedStartTime = 0,
    this.estimatedEndTime = 0,
  });


  static DateTime _asDate(dynamic v) {
    if (v is DateTime) return v;
    if (v is String) return DateTime.tryParse(v) ?? DateTime.now();
    return DateTime.now();
  }

  static int _asInt(dynamic v, {int fallback = 0}) {
    if (v is int) return v;
    if (v is String) return int.tryParse(v) ?? fallback;
    return fallback;
  }

  static String _asStr(dynamic v, {String fallback = ''}) {
    if (v == null) return fallback;
    return v.toString();
  }

  factory TripPlanLocationModel.fromJson(Map<String, dynamic> json) {
    final idRaw = json['tripPlanLocationId'];
    final idStr = (idRaw == null || idRaw.toString().trim().isEmpty)
        ? null
        : idRaw.toString();

    return TripPlanLocationModel(
      tripPlanLocationId: idStr,
      locationId: _asStr(json['locationId']),
      order: _asInt(json['order']),
      startTime: _asDate(json['startTime']),
      endTime: _asDate(json['endTime']),
      notes: _asStr(json['notes']),
      travelTimeFromPrev: _asInt(json['travelTimeFromPrev']),
      distanceFromPrev: _asInt(json['distanceFromPrev']),
      estimatedStartTime: _asInt(json['estimatedStartTime']),
      estimatedEndTime: _asInt(json['estimatedEndTime']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (tripPlanLocationId != null && tripPlanLocationId!.isNotEmpty)
        "tripPlanLocationId": tripPlanLocationId, 
      "locationId": locationId,
      "order": order,
      "startTime": startTime.toIso8601String(),
      "endTime": endTime.toIso8601String(),
      "notes": notes,
      "travelTimeFromPrev": travelTimeFromPrev,
      "distanceFromPrev": distanceFromPrev,
      "estimatedStartTime": estimatedStartTime,
      "estimatedEndTime": estimatedEndTime,
    };
  }


  factory TripPlanLocationModel.fromActivity(
    TripActivityModel a, {
    required int order,
    String? tripPlanLocationId, 
    int travelTimeFromPrev = 0,
    int distanceFromPrev = 0,
  }) {
    return TripPlanLocationModel(
      tripPlanLocationId: tripPlanLocationId,
      locationId: a.locationId,
      order: order,
      startTime: a.startTime,
      endTime: a.endTime,
      notes: a.notes,
      travelTimeFromPrev: travelTimeFromPrev,
      distanceFromPrev: distanceFromPrev,
      estimatedStartTime: 0,
      estimatedEndTime: 0,
    );
  }
}
