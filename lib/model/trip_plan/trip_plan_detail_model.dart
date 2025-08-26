import 'package:travelogue_mobile/model/enums/trip_status.dart';
import 'package:travelogue_mobile/model/trip_plan/trip_day_model.dart';

class TripPlanDetailModel {
  final String id;
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final int totalDays;
  final int status;
  final String statusText;
  final List<TripDayModel> days;
  final String? imageUrl; 

  TripPlanDetailModel({
    required this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.totalDays,
    required this.status,
    required this.statusText,
    required this.days,
    this.imageUrl, 
  });

  static int _asInt(dynamic v, {int fallback = 0}) {
    if (v is int) return v;
    if (v is String) return int.tryParse(v) ?? fallback;
    return fallback;
  }

  static DateTime _asDate(dynamic v) {
    if (v is DateTime) return v;
    if (v is String) return DateTime.tryParse(v) ?? DateTime.now();
    return DateTime.now();
  }

  static int _calcDays(DateTime s, DateTime e) =>
      e.difference(DateTime(s.year, s.month, s.day)).inDays + 1;

  static String _statusToText(int status) {
    switch (status) {
      case 0: return 'Draft';
      case 1: return 'Sketch';
      case 2: return 'Booked';
      default: return 'Draft';
    }
  }

  factory TripPlanDetailModel.fromJson(Map<String, dynamic> json) {
    final start = _asDate(json['startDate']);
    final end = _asDate(json['endDate']);

    final stt = _asInt(json['status'], fallback: 0);
    final total = _asInt(json['totalDays'], fallback: _calcDays(start, end));

    final daysJson = (json['days'] as List?) ?? const [];
    final statusTextRaw = (json['statusText'] as String?)?.trim();
    final safeStatusText =
        (statusTextRaw == null || statusTextRaw.isEmpty) ? _statusToText(stt) : statusTextRaw;

    final rawImage = (json['imageUrl'] as String?)?.trim();
    final safeImage = (rawImage == null || rawImage.isEmpty) ? null : rawImage;

    return TripPlanDetailModel(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      startDate: start,
      endDate: end,
      totalDays: total,
      status: stt,
      statusText: safeStatusText,
      days: daysJson
          .map((e) => TripDayModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      imageUrl: safeImage, 
    );
  }

  TripStatus get statusEnum {
    switch (status) {
      case 0: return TripStatus.draft;
      case 1: return TripStatus.sketch;
      case 2: return TripStatus.booked;
      default: return TripStatus.draft;
    }
  }

  List<DateTime> getDays() {
    return List.generate(
      totalDays,
      (i) => DateTime(startDate.year, startDate.month, startDate.day).add(Duration(days: i)),
    );
  }


  String get displayImageUrl =>
      imageUrl ?? 'https://your.cdn.com/placeholder.png'; 
      Map<String, dynamic> toJson() {
  return {
    'id': id,
    'name': name,
    'description': description,
    'startDate': startDate.toIso8601String(),
    'endDate': endDate.toIso8601String(),
    'totalDays': totalDays,
    'status': status,
    'statusText': statusText,
    'imageUrl': imageUrl,
  };
}

}


