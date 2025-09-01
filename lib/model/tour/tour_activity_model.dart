// lib/model/tour/tour_activity_model.dart

enum ActivityType { unknown, sightseeing, dining, workshop }

class ActivityTypeHelper {
  static ActivityType fromInt(int? v) {
    switch (v) {
      case 1:
        return ActivityType.sightseeing;
      case 2:
        return ActivityType.dining;
      case 3:
        return ActivityType.workshop;
      default:
        return ActivityType.unknown;
    }
  }

  static int? toInt(ActivityType? t) {
    switch (t) {
      case ActivityType.sightseeing:
        return 1;
      case ActivityType.dining:
        return 2;
      case ActivityType.workshop:
        return 3;
      case ActivityType.unknown:
      default:
        return null;
    }
  }
}

class WorkshopInfoModel {
  final String? workshopId;
  final String? workshopName;

  final String? workshopTicketTypeId;
  final String? workshopTicketTypeName;
  final int? workshopTicketDurationMinutes;
  final double? workshopTicketPrice;

  final String? workshopSessionRuleId;
  final String? workshopSessionStart;           // "HH:mm:ss"
  final String? workshopSessionEnd;             // "HH:mm:ss"
  final String? workshopSessionTimeFormatted;   // "HH:mm - HH:mm"
  final int? workshopSessionCapacity;

  const WorkshopInfoModel({
    this.workshopId,
    this.workshopName,
    this.workshopTicketTypeId,
    this.workshopTicketTypeName,
    this.workshopTicketDurationMinutes,
    this.workshopTicketPrice,
    this.workshopSessionRuleId,
    this.workshopSessionStart,
    this.workshopSessionEnd,
    this.workshopSessionTimeFormatted,
    this.workshopSessionCapacity,
  });

  factory WorkshopInfoModel.fromJson(Map<String, dynamic> json) {
    double? _toDouble(dynamic v) {
      if (v == null) return null;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString());
    }

    return WorkshopInfoModel(
      workshopId: json['workshopId'] as String?,
      workshopName: json['workshopName'] as String?,
      workshopTicketTypeId: json['workshopTicketTypeId'] as String?,
      workshopTicketTypeName: json['workshopTicketTypeName'] as String?,
      workshopTicketDurationMinutes: json['workshopTicketDurationMinutes'] as int?,
      workshopTicketPrice: _toDouble(json['workshopTicketPrice']),
      workshopSessionRuleId: json['workshopSessionRuleId'] as String?,
      workshopSessionStart: json['workshopSessionStart'] as String?,
      workshopSessionEnd: json['workshopSessionEnd'] as String?,
      workshopSessionTimeFormatted: json['workshopSessionTimeFormatted'] as String?,
      workshopSessionCapacity: json['workshopSessionCapacity'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'workshopId': workshopId,
        'workshopName': workshopName,
        'workshopTicketTypeId': workshopTicketTypeId,
        'workshopTicketTypeName': workshopTicketTypeName,
        'workshopTicketDurationMinutes': workshopTicketDurationMinutes,
        'workshopTicketPrice': workshopTicketPrice,
        'workshopSessionRuleId': workshopSessionRuleId,
        'workshopSessionStart': workshopSessionStart,
        'workshopSessionEnd': workshopSessionEnd,
        'workshopSessionTimeFormatted': workshopSessionTimeFormatted,
        'workshopSessionCapacity': workshopSessionCapacity,
      };
}

class TourActivityModel {
  final String? tourPlanLocationId;
  final String? locationId;
  final String? type;
  final String? name;
  final String? description;
  final String? address;

  final int? dayOrder;

  /// Giờ từ API: "HH:mm" hoặc "HH:mm:ss"
  final String? startTime;
  final String? endTime;
  final String? startTimeFormatted;
  final String? endTimeFormatted;

  final String? duration;
  final String? notes;
  final String? imageUrl;

  final int? travelTimeFromPrev;     // phút
  final double? distanceFromPrev;    // km
  final int? estimatedStartTime;
  final int? estimatedEndTime;

  final int? activityType;           
  final String? activityTypeText;
  final WorkshopInfoModel? workshop; 
  const TourActivityModel({
    this.tourPlanLocationId,
    this.locationId,
    this.type,
    this.name,
    this.description,
    this.address,
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
    this.activityType,
    this.activityTypeText,
    this.workshop,
  });

  ActivityType get activityTypeEnum => ActivityTypeHelper.fromInt(activityType);

  factory TourActivityModel.fromJson(Map<String, dynamic> json) {
    double? _toDouble(dynamic v) {
      if (v == null) return null;
      if (v is num) return v.toDouble();
      final s = v.toString();
      return double.tryParse(s);
    }

    return TourActivityModel(
      tourPlanLocationId: json['tourPlanLocationId'] as String?,
      locationId: json['locationId'] as String?,
      type: json['type'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      address: json['address'] as String?,
      dayOrder: json['dayOrder'] as int?,

      startTime: json['startTime'] as String?,
      endTime: json['endTime'] as String?,
      startTimeFormatted: json['startTimeFormatted'] as String?,
      endTimeFormatted: json['endTimeFormatted'] as String?,

      duration: json['duration'] as String?,
      notes: json['notes'] as String?,
      imageUrl: json['imageUrl'] as String?,

      travelTimeFromPrev: json['travelTimeFromPrev'] as int?,
      distanceFromPrev: _toDouble(json['distanceFromPrev']),
      estimatedStartTime: json['estimatedStartTime'] as int?,
      estimatedEndTime: json['estimatedEndTime'] as int?,

      activityType: json['activityType'] as int?,
      activityTypeText: json['activityTypeText'] as String?,
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

        'activityType': activityType,
        'activityTypeText': activityTypeText,
        'workshop': workshop?.toJson(),
      };
}
