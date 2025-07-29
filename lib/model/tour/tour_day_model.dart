import 'package:travelogue_mobile/model/tour/tour_activity_model.dart';

class TourDayModel {
  final int? dayNumber;
  final List<TourActivityModel>? activities;

  TourDayModel({this.dayNumber, this.activities});

  factory TourDayModel.fromJson(Map<String, dynamic> json) {
    return TourDayModel(
      dayNumber: json['dayNumber'],
      activities: (json['activities'] as List?)
          ?.map((e) => TourActivityModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'dayNumber': dayNumber,
        'activities': activities?.map((e) => e.toJson()).toList(),
      };
}

