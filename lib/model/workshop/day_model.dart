// lib/model/workshop/day_model.dart
import 'activity_model.dart';

class DayModel {
  final int? dayNumber;
  final List<ActivityModel> activities;

  DayModel({this.dayNumber, required this.activities});

  factory DayModel.fromMap(Map<String, dynamic> map) {
    final acts = ((map['activities'] as List?) ?? const [])
        .whereType<Map>()
        .map((e) => ActivityModel.fromMap(e.cast<String, dynamic>()))
        .toList();

    return DayModel(
      dayNumber: map['dayNumber'] as int?,
      activities: acts,
    );
  }

  Map<String, dynamic> toMap() => {
        'dayNumber': dayNumber,
        'activities': activities.map((e) => e.toMap()).toList(),
      };
}
