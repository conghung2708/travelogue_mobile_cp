import 'package:travelogue_mobile/model/enums/trip_status.dart';

class TripPlanModel {
  final String id;
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String? imageUrl;
  final String userId;
  final String ownerName;
  final int status;
  final String statusText;

  TripPlanModel({
    required this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    this.imageUrl,
    required this.userId,
    required this.ownerName,
    required this.status,
    required this.statusText,
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

  factory TripPlanModel.fromJson(Map<String, dynamic> json) {
    final start = _asDate(json['startDate']);
    final end = _asDate(json['endDate']);

    final stt = _asInt(json['status'], fallback: 0);
    final sttText = (json['statusText'] as String?)?.trim();
    final safeStatusText = (sttText == null || sttText.isEmpty)
        ? _statusToText(stt)
        : sttText;

    return TripPlanModel(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      startDate: start,
      endDate: end,
      imageUrl: (json['imageUrl'] as String?),
      userId: (json['userId'] ?? '').toString(),
      ownerName: (json['ownerName'] ?? '').toString(),
      status: stt,
      statusText: safeStatusText,
    );
  }

  static String _statusToText(int status) {
    switch (status) {
      case 0: return 'Draft';
      case 1: return 'Sketch';
      case 2: return 'Booked';
      default: return 'Draft';
    }
  }

  TripStatus get statusEnum {
    switch (status) {
      case 0: return TripStatus.draft;
      case 1: return TripStatus.sketch;
      case 2: return TripStatus.booked;
      default: return TripStatus.draft;
    }
  }
}
