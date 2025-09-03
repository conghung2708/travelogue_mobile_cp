// lib/model/workshop/schedule_model.dart
import 'dart:convert';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/model/tour_guide/tour_guide_model.dart';

class ScheduleModel {
  final String? scheduleId;
  final String? workshopId;
  final DateTime? startTime;
  final DateTime? endTime;

  final int? capacity;

  final int? currentBooked;

  final double? adultPrice;
  final double? childrenPrice;
  final String? notes;
  final String? imageUrl;
  final int? status;
  final TourGuideModel? tourGuide;

  const ScheduleModel({
    this.scheduleId,
    this.workshopId,
    this.startTime,
    this.endTime,
    this.capacity,
    this.currentBooked,
    this.adultPrice,
    this.childrenPrice,
    this.notes,
    this.imageUrl,
    this.status,
    this.tourGuide,
  });


  static DateTime? _parseToLocal(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    try {
      final dt = DateTime.parse(raw.trim());
      return dt.isUtc ? dt.toLocal() : dt;
    } catch (_) {
      return null;
    }
  }

  static double? _numToDouble(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    final s = v.toString().trim();
    if (s.isEmpty) return null;
    return double.tryParse(s);
  }

  static int? _toInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is num) return v.toInt();
    final s = v.toString().trim();
    if (s.isEmpty) return null;
    return int.tryParse(s);
  }

  factory ScheduleModel.fromMap(Map<String, dynamic> map) {
    final tourGuideMap = map['tourGuide'];
    return ScheduleModel(
      scheduleId: (map['scheduleId'] ?? map['id']) as String?,
      workshopId: map['workshopId'] as String?,
      startTime: _parseToLocal(
        (map['startTime'] as String?) ?? (map['departureDate'] as String?),
      ),
      endTime: _parseToLocal(map['endTime'] as String?),
      capacity: _toInt(map['capacity']),          
      currentBooked: _toInt(map['currentBooked']),
      adultPrice: _numToDouble(map['adultPrice']),
      childrenPrice: _numToDouble(map['childrenPrice']),
      notes: map['notes'] as String?,
      imageUrl: (() {
        final v = map['imageUrl'];
        if (v == null) return AssetHelper.img_default;
        final s = v.toString();
        return s.isNotEmpty ? s : AssetHelper.img_default;
      })(),
      status: _toInt(map['status']),
      tourGuide: (tourGuideMap is Map)
          ? TourGuideModel.fromMap(
              tourGuideMap.map((k, v) => MapEntry(k.toString(), v)))
          : null,
    );
  }

  Map<String, dynamic> toMap() => {
        'scheduleId': scheduleId,
        'workshopId': workshopId,
        'startTime': startTime?.toIso8601String(),
        'endTime': endTime?.toIso8601String(),
        'capacity': capacity,               
        'currentBooked': currentBooked,
        'adultPrice': adultPrice,
        'childrenPrice': childrenPrice,
        'notes': notes,
        'imageUrl': imageUrl,
        'status': status,
        'tourGuide': tourGuide?.toMap(),
      };

  String toJson() => json.encode(toMap());


  bool get hasCapacity {
    if (capacity == null) return true;
    final booked = currentBooked ?? 0;
    return booked < capacity!;
  }

  int? get remainingSlots {
    if (capacity == null) return null;
    final booked = currentBooked ?? 0;
    final remain = capacity! - booked;
    return remain < 0 ? 0 : remain;
  }
}
