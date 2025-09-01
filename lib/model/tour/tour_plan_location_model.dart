// lib/model/tour/tour_plan_location_model.dart
import 'package:travelogue_mobile/model/tour/tour_activity_model.dart';

class TourPlanLocationModel {
  final String? tourPlanLocationId;
  final String? locationId;
  final String? type;
  final String? name;
  final String? description;
  final String? address;

  final ActivityType activityTypeEnum;
  final String? activityTypeText;

  final int? dayOrder;

  final String? startTime;            // "HH:mm:ss"
  final String? endTime;              // "HH:mm:ss"
  final String? startTimeFormatted;   // "HH:mm"
  final String? endTimeFormatted;     // "HH:mm"

  final String? duration;
  final String? notes;
  final String? imageUrl;

  final int? travelTimeFromPrev;      // phút
  final double? distanceFromPrev;     // km

  final int? estimatedStartTime;
  final int? estimatedEndTime;

  final WorkshopInfoModel? workshop;

  const TourPlanLocationModel({
    this.tourPlanLocationId,
    this.locationId,
    this.type,
    this.name,
    this.description,
    this.address,
    this.activityTypeEnum = ActivityType.unknown,
    this.activityTypeText,
    this.dayOrder,
    this.startTime,
    this.endTime,
    this.startTimeFormatted,
    this.endTimeFormatted,
    this.duration,
    this.notes,
    this.imageUrl,
    this.travelTimeFromPrev,
    this.distanceFromPrev,
    this.estimatedStartTime,
    this.estimatedEndTime,
    this.workshop,
  });

  factory TourPlanLocationModel.fromJson(Map<String, dynamic> json) {
    return TourPlanLocationModel(
      tourPlanLocationId: json['tourPlanLocationId'] as String?,
      locationId: json['locationId'] as String?,
      type: json['type'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      address: json['address'] as String?,
      activityTypeEnum: ActivityTypeHelper.fromInt(json['activityType'] as int?),
      activityTypeText: json['activityTypeText'] as String?,
      dayOrder: json['dayOrder'] as int?,
      startTime: json['startTime'] as String?,
      endTime: json['endTime'] as String?,
      startTimeFormatted: json['startTimeFormatted'] as String?,
      endTimeFormatted: json['endTimeFormatted'] as String?,
      duration: json['duration'] as String?,
      notes: json['notes'] as String?,
      imageUrl: json['imageUrl'] as String?,
      travelTimeFromPrev: json['travelTimeFromPrev'] as int?,
      distanceFromPrev: (json['distanceFromPrev'] as num?)?.toDouble(),
      estimatedStartTime: json['estimatedStartTime'] as int?,
      estimatedEndTime: json['estimatedEndTime'] as int?,
      workshop: (json['workshop'] is Map<String, dynamic>)
          ? WorkshopInfoModel.fromJson(json['workshop'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'tourPlanLocationId': tourPlanLocationId,
        'locationId': locationId,
        'type': type,
        'name': name,
        'description': description,
        'address': address,
        'activityType': ActivityTypeHelper.toInt(activityTypeEnum),
        'activityTypeText': activityTypeText,
        'dayOrder': dayOrder,
        'startTime': startTime,
        'endTime': endTime,
        'startTimeFormatted': startTimeFormatted,
        'endTimeFormatted': endTimeFormatted,
        'duration': duration,
        'notes': notes,
        'imageUrl': imageUrl,
        'travelTimeFromPrev': travelTimeFromPrev,
        'distanceFromPrev': distanceFromPrev,
        'estimatedStartTime': estimatedStartTime,
        'estimatedEndTime': estimatedEndTime,
        'workshop': workshop?.toJson(),
      };
}
