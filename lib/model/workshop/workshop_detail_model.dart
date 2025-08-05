import 'dart:convert';
import 'day_model.dart';
import 'schedule_model.dart';

class WorkshopDetailModel {
  final String? workshopId;
  final String? name;
  final String? description;
  final String? content;
  final String? craftVillageId;
  final String? craftVillageName;
  final int? status;
  final String? statusText;
  final List<String>? imageList;
  final List<ScheduleModel> schedules;
  final List<DayModel> days;

  WorkshopDetailModel({
    this.workshopId,
    this.name,
    this.description,
    this.content,
    this.craftVillageId,
    this.craftVillageName,
    this.status,
    this.statusText,
    this.imageList,
    required this.schedules,
    required this.days,
  });

  factory WorkshopDetailModel.fromMap(Map<String, dynamic> map) {
    return WorkshopDetailModel(
      workshopId: map['workshopId'],
      name: map['name'],
      description: map['description'],
      content: map['content'],
      craftVillageId: map['craftVillageId'],
      craftVillageName: map['craftVillageName'],
      status: map['status'],
      statusText: map['statusText'],
      imageList: map['imageList'] != null
          ? List<String>.from(map['imageList'])
          : [],
      schedules: (map['schedules'] as List)
          .map((e) => ScheduleModel.fromMap(e))
          .toList(),
      days: (map['days'] as List)
          .map((e) => DayModel.fromMap(e))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'workshopId': workshopId,
      'name': name,
      'description': description,
      'content': content,
      'craftVillageId': craftVillageId,
      'craftVillageName': craftVillageName,
      'status': status,
      'statusText': statusText,
      'imageList': imageList ?? [],
      'schedules': schedules.map((e) => e.toMap()).toList(),
      'days': days.map((e) => e.toMap()).toList(),
    };
  }

  String toJson() => json.encode(toMap());
}
