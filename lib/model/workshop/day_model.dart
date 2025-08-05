import 'activity_model.dart';

class DayModel {
  final int? dayNumber;
  final List<ActivityModel> activities;

  DayModel({this.dayNumber, required this.activities});

  factory DayModel.fromMap(Map<String, dynamic> map) {
    return DayModel(
      dayNumber: map['dayNumber'],
      activities: (map['activities'] as List)
          .map((e) => ActivityModel.fromMap(e))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dayNumber': dayNumber,
      'activities': activities.map((e) => e.toMap()).toList(),
    };
  }
}
