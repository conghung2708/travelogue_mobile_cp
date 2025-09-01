// lib/model/workshop/schedule_model.dart
import 'dart:convert';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/model/tour_guide/tour_guide_model.dart';

class ScheduleModel {
  final String? scheduleId;
  final DateTime? startTime;
  final DateTime? endTime;
  final int? maxParticipant;
  final int? currentBooked;
  final double? adultPrice;
  final double? childrenPrice;
  final String? notes;
  final String? imageUrl;
  final TourGuideModel? tourGuide;

  ScheduleModel({
    this.scheduleId,
    this.startTime,
    this.endTime,
    this.maxParticipant,
    this.currentBooked,
    this.adultPrice,
    this.childrenPrice,
    this.notes,
    this.imageUrl,
    this.tourGuide,
  });

  static DateTime? _parse(String? raw) {
    if (raw == null || raw.isEmpty) return null;

    final iso = (raw.endsWith('Z') || raw.contains('+')) ? raw : '${raw}Z';
    try {
      return DateTime.parse(iso).toLocal();
    } catch (_) {
      return null;
    }
  }

  factory ScheduleModel.fromMap(Map<String, dynamic> map) {
    return ScheduleModel(
     
      scheduleId: (map['scheduleId'] ?? map['id']) as String?,
      startTime: _parse(map['startTime'] as String? ?? map['departureDate'] as String?),
      endTime: _parse(map['endTime'] as String?),
     
      maxParticipant: (map['maxParticipant'] ?? map['capacity']) as int?,
      currentBooked: map['currentBooked'] as int?,
      adultPrice: (map['adultPrice'] as num?)?.toDouble(),
      childrenPrice: (map['childrenPrice'] as num?)?.toDouble(),
      notes: map['notes'] as String?,
      imageUrl: (map['imageUrl'] != null && map['imageUrl'].toString().isNotEmpty)
          ? map['imageUrl'] as String
          : AssetHelper.img_default,
      tourGuide: (map['tourGuide'] is Map)
          ? TourGuideModel.fromMap((map['tourGuide'] as Map).cast<String, dynamic>())
          : null,
    );
  }

  Map<String, dynamic> toMap() => {
        'scheduleId': scheduleId,
        'startTime': startTime?.toIso8601String(),
        'endTime': endTime?.toIso8601String(),
        'maxParticipant': maxParticipant,
        'currentBooked': currentBooked,
        'adultPrice': adultPrice,
        'childrenPrice': childrenPrice,
        'notes': notes,
        'imageUrl': imageUrl,
        'tourGuide': tourGuide?.toMap(),
      };

  String toJson() => json.encode(toMap());
}
