// lib/model/tour/tour_schedule_model.dart
import 'dart:convert';

import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/model/tour_guide/tour_guide_model.dart';

class TourScheduleModel {
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

  const TourScheduleModel({
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

  static DateTime? _parseDateTime(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      final iso = raw.endsWith('Z') || raw.contains('+') || raw.contains('-')
          ? raw
          : '${raw}Z';
      return DateTime.parse(iso).toLocal();
    } catch (_) {
      return null;
    }
  }

  factory TourScheduleModel.fromMap(Map<String, dynamic> map) {
    return TourScheduleModel(
      scheduleId: map['scheduleId'] as String?,
      startTime: _parseDateTime(map['startTime'] as String?),
      endTime: _parseDateTime(map['endTime'] as String?),
      maxParticipant: map['maxParticipant'] as int?,
      currentBooked: map['currentBooked'] as int?,
      adultPrice: (map['adultPrice'] as num?)?.toDouble(),
      childrenPrice: (map['childrenPrice'] as num?)?.toDouble(),
      notes: map['notes'] as String?,
      imageUrl: (map['imageUrl'] != null && map['imageUrl'].toString().isNotEmpty)
          ? map['imageUrl'] as String
          : AssetHelper.img_default,
      tourGuide: map['tourGuide'] != null
          ? TourGuideModel.fromMap(map['tourGuide'] as Map<String, dynamic>)
          : null,
    );
  }

  factory TourScheduleModel.fromJson(Map<String, dynamic> json) {
    return TourScheduleModel.fromMap(json);
  }

  Map<String, dynamic> toMap() {
    return {
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
  }


  Map<String, dynamic> toJson() => toMap();


  String toJsonString() => json.encode(toMap());
}
