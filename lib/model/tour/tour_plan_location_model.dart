// lib/model/tour/tour_plan_location_model.dart
class TourPlanLocationModel {
  final String? tourPlanLocationId;
  final String? locationId;
  final String? type;
  final String? name;
  final String? description;
  final String? address;
  final int? dayOrder;
  final String? startTime;
  final String? endTime;
  final String? startTimeFormatted;
  final String? endTimeFormatted;
  final String? duration;
  final String? notes;
  final String? imageUrl;
  final int? travelTimeFromPrev;
  final int? distanceFromPrev;
  final int? estimatedStartTime;
  final int? estimatedEndTime;

  const TourPlanLocationModel({
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
  });

  factory TourPlanLocationModel.fromJson(Map<String, dynamic> json) => TourPlanLocationModel(
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
    distanceFromPrev: json['distanceFromPrev'] as int?,
    estimatedStartTime: json['estimatedStartTime'] as int?,
    estimatedEndTime: json['estimatedEndTime'] as int?,
  );

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
  };
}
