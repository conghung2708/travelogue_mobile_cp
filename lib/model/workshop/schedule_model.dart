import 'dart:convert';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';

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
  });

  factory ScheduleModel.fromMap(Map<String, dynamic> map) {
    return ScheduleModel(
      scheduleId: map['scheduleId'],
      startTime: map['startTime'] != null ? DateTime.parse(map['startTime']) : null,
      endTime: map['endTime'] != null ? DateTime.parse(map['endTime']) : null,
      maxParticipant: map['maxParticipant'],
      currentBooked: map['currentBooked'],
      adultPrice: (map['adultPrice'] as num?)?.toDouble(),
      childrenPrice: (map['childrenPrice'] as num?)?.toDouble(),
      notes: map['notes'],
      imageUrl: (map['imageUrl'] != null && map['imageUrl'].toString().isNotEmpty)
          ? map['imageUrl']
          : AssetHelper.img_default,
    );
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
    };
  }

  String toJson() => json.encode(toMap());
}
