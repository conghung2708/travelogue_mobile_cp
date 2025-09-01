// lib/model/workshop/workshop_detail_model.dart
import 'dart:convert';
import 'day_model.dart';
import 'schedule_model.dart';
import 'activity_model.dart';

class WorkshopDetailModel {
  final String? workshopId;
  final String? name;
  final String? description;
  final String? content;
  final String? craftVillageId;
  final String? craftVillageName;
  final int? status;
  final String? statusText;
  final List<String> imageList;
  final List<ScheduleModel> schedules;
  final List<DayModel> days;

  const WorkshopDetailModel({
    this.workshopId,
    this.name,
    this.description,
    this.content,
    this.craftVillageId,
    this.craftVillageName,
    this.status,
    this.statusText,
    this.imageList = const [],
    this.schedules = const [],
    this.days = const [],
  });

  factory WorkshopDetailModel.fromMap(Map<String, dynamic> map0) {
    final Map<String, dynamic> map = (map0['data'] is Map)
        ? (map0['data'] as Map).cast<String, dynamic>()
        : map0.cast<String, dynamic>();

    final List<String> images = ((map['imageList'] as List?) ?? const [])
        .map((e) => e?.toString() ?? '')
        .where((s) => s.isNotEmpty)
        .toList();

   
    final List<ScheduleModel> scheduleList =
        ((map['schedules'] as List?) ?? const [])
            .whereType<Map>()
            .map((e) => ScheduleModel.fromMap(e.cast<String, dynamic>()))
            .toList();


    List<DayModel> dayList = ((map['days'] as List?) ?? const [])
        .whereType<Map>()
        .map((e) => DayModel.fromMap(e.cast<String, dynamic>()))
        .toList();

    if (dayList.isEmpty) {
      final tts = (map['ticketTypes'] as List?) ?? const [];
      if (tts.isNotEmpty && tts.first is Map) {
        final tt = (tts.first as Map).cast<String, dynamic>();
        final actsRaw = (tt['activities'] as List?) ?? const [];
        final acts = actsRaw
            .whereType<Map>()
            .map((m) => ActivityModel.fromMap(m.cast<String, dynamic>()))
            .toList()
          ..sort((a, b) => (a.activityOrder ?? 0).compareTo(b.activityOrder ?? 0));
        if (acts.isNotEmpty) {
          dayList = [DayModel(dayNumber: 1, activities: acts)];
        }
      }
    }

    return WorkshopDetailModel(
      workshopId: (map['workshopId'] ?? map['id']) as String?,
      name: map['name'] as String?,
      description: map['description'] as String?,
      content: map['content'] as String?,
      craftVillageId: map['craftVillageId'] as String?,
      craftVillageName: map['craftVillageName'] as String?,
      status: map['status'] as int?,
      statusText: map['statusText'] as String?,
      imageList: images,
      schedules: scheduleList,
      days: dayList,
    );
  }

  factory WorkshopDetailModel.fromJson(Map<String, dynamic> json) =>
      WorkshopDetailModel.fromMap(json);

  Map<String, dynamic> toMap() => {
        'workshopId': workshopId,
        'name': name,
        'description': description,
        'content': content,
        'craftVillageId': craftVillageId,
        'craftVillageName': craftVillageName,
        'status': status,
        'statusText': statusText,
        'imageList': imageList,
        'schedules': schedules.map((e) => e.toMap()).toList(),
        'days': days.map((e) => e.toMap()).toList(),
      };

  String toJson() => json.encode(toMap());
}
