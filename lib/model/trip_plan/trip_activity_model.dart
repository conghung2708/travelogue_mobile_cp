import 'package:intl/intl.dart';

class TripActivityModel {
  final String? tripPlanLocationId; 
  final String locationId;

  final String? type;
  final String? name;
  final String? description;
  final String? address;

  final DateTime startTime;
  final DateTime endTime;
  final String? startTimeFormatted;
  final String? endTimeFormatted;
  final String? duration;

  final String notes;
  final int order;
  final String? imageUrl;

  TripActivityModel({
    required this.locationId,
    required this.startTime,
    required this.endTime,
    this.tripPlanLocationId,
    this.type,
    this.name,
    this.description,
    this.address,
    this.startTimeFormatted,
    this.endTimeFormatted,
    this.duration,
    this.notes = '',
    this.order = 0,
    this.imageUrl,
  });

  TripActivityModel copyWith({
    String? tripPlanLocationId,
    String? locationId,
    String? type,
    String? name,
    String? description,
    String? address,
    DateTime? startTime,
    DateTime? endTime,
    String? startTimeFormatted,
    String? endTimeFormatted,
    String? duration,
    String? notes,
    int? order,
    String? imageUrl,
  }) {
    return TripActivityModel(
      tripPlanLocationId: tripPlanLocationId ?? this.tripPlanLocationId,
      locationId: locationId ?? this.locationId,
      type: type ?? this.type,
      name: name ?? this.name,
      description: description ?? this.description,
      address: address ?? this.address,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      startTimeFormatted: startTimeFormatted ?? this.startTimeFormatted,
      endTimeFormatted: endTimeFormatted ?? this.endTimeFormatted,
      duration: duration ?? this.duration,
      notes: notes ?? this.notes,
      order: order ?? this.order,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  static DateTime _asDate(dynamic v) {
    if (v is DateTime) return v;
    if (v is String) return DateTime.tryParse(v) ?? DateTime.now();
    return DateTime.now();
  }

  static String? _asOptStr(dynamic v) => v == null ? null : v.toString();
  static String _asStr(dynamic v, {String fallback = ''}) => v == null ? fallback : v.toString();
  static int _asInt(dynamic v, {int fallback = 0}) {
    if (v is int) return v;
    if (v is String) return int.tryParse(v) ?? fallback;
    return fallback;
  }

  factory TripActivityModel.fromJson(Map<String, dynamic> json) {
    final s = _asDate(json['startTime']);
    final e = _asDate(json['endTime']);
    return TripActivityModel(
      tripPlanLocationId: _asOptStr(json['tripPlanLocationId']),
      locationId: _asStr(json['locationId']),
      type: _asOptStr(json['type']),
      name: _asOptStr(json['name']),
      description: _asOptStr(json['description']),
      address: _asOptStr(json['address']),
      startTime: s,
      endTime: e,
      startTimeFormatted: _asOptStr(json['startTimeFormatted']) ?? DateFormat('HH:mm').format(s),
      endTimeFormatted: _asOptStr(json['endTimeFormatted']) ?? DateFormat('HH:mm').format(e),
      duration: _asOptStr(json['duration']),
      notes: _asStr(json['notes'], fallback: ''),
      order: _asInt(json['order']),
      imageUrl: _asOptStr(json['imageUrl']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tripPlanLocationId': tripPlanLocationId,
      'locationId': locationId,
      'type': type,
      'name': name,
      'description': description,
      'address': address,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'startTimeFormatted': startTimeFormatted,
      'endTimeFormatted': endTimeFormatted,
      'duration': duration,
      'notes': notes,
      'order': order,
      'imageUrl': imageUrl,
    };
  }
}
