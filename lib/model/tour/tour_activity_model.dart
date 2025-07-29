class TourActivityModel {
  final String? tourPlanLocationId;
  final String? locationId;
  final String? type;
  final String? name;
  final String? description;
  final String? address;
  final int? dayOrder;
  final DateTime? startTime;
  final DateTime? endTime;
  final DateTime? startTimeFormatted;
  final DateTime? endTimeFormatted;
  final String? duration;
  final String? notes;
  final String? imageUrl;
  final int? travelTimeFromPrev;
  final int? distanceFromPrev;
  final int? estimatedStartTime;
  final int? estimatedEndTime;

  TourActivityModel({
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

  factory TourActivityModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseTime(dynamic value) {
      if (value is String && value.isNotEmpty) {
        try {
          return DateTime.parse("1970-01-01T$value");
        } catch (_) {}
      }
      return null;
    }

    return TourActivityModel(
      tourPlanLocationId: json['tourPlanLocationId'],
      locationId: json['locationId'],
      type: json['type'],
      name: json['name'],
      description: json['description'],
      address: json['address'],
      dayOrder: json['dayOrder'],
      startTime: parseTime(json['startTime']),
      endTime: parseTime(json['endTime']),
      startTimeFormatted: parseTime(json['startTimeFormatted']),
      endTimeFormatted: parseTime(json['endTimeFormatted']),
      duration: json['duration'],
      notes: json['notes'],
      imageUrl: json['imageUrl'],
      travelTimeFromPrev: json['travelTimeFromPrev'],
      distanceFromPrev: json['distanceFromPrev'],
      estimatedStartTime: json['estimatedStartTime'],
      estimatedEndTime: json['estimatedEndTime'],
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
        'startTime': startTime?.toIso8601String(),
        'endTime': endTime?.toIso8601String(),
        'startTimeFormatted': startTimeFormatted?.toIso8601String(),
        'endTimeFormatted': endTimeFormatted?.toIso8601String(),
        'duration': duration,
        'notes': notes,
        'imageUrl': imageUrl,
        'travelTimeFromPrev': travelTimeFromPrev,
        'distanceFromPrev': distanceFromPrev,
        'estimatedStartTime': estimatedStartTime,
        'estimatedEndTime': estimatedEndTime,
      };
}
