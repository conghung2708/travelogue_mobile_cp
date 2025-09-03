// lib/model/workshop/workshop_detail_model.dart
import 'dart:convert';
import 'day_model.dart';
import 'schedule_model.dart';
import 'activity_model.dart';
import 'ticket_type_model.dart';

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

  final List<TicketTypeModel> ticketTypes;

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
    this.ticketTypes = const [],
  });


  num? get visitPrice {
    final visit = ticketTypes
        .where((t) => t.type == 1) 
        .map((t) => t.price)
        .whereType<num>()
        .toList();
    if (visit.isEmpty) return null;
    visit.sort();
    return visit.first;
  }

  num? get experiencePrice {
    final exp = ticketTypes
        .where((t) => t.type == 2 || (t.isCombo == true)) 
        .map((t) => t.price)
        .whereType<num>()
        .toList();
    if (exp.isEmpty) return null;
    exp.sort();
    return exp.first;
  }

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

    final List<TicketTypeModel> ttList =
        ((map['ticketTypes'] as List?) ?? const [])
            .whereType<Map>()
            .map((m) => TicketTypeModel.fromMap(m.cast<String, dynamic>()))
            .toList();

    List<DayModel> dayList = ((map['days'] as List?) ?? const [])
        .whereType<Map>()
        .map((e) => DayModel.fromMap(e.cast<String, dynamic>()))
        .toList();

    if (dayList.isEmpty && ttList.isNotEmpty) {
      List<ActivityModel> acts = [];
      final preferred = ttList.firstWhere(
        (t) => (t.type == 2) || (t.isCombo == true),
        orElse: () => const TicketTypeModel(),
      );
      if (preferred.activities.isNotEmpty) {
        acts = [...preferred.activities];
      } else {
        acts = ttList.expand((t) => t.activities).toList();
      }
      acts.sort((a, b) => (a.activityOrder ?? 0).compareTo(b.activityOrder ?? 0));
      if (acts.isNotEmpty) {
        dayList = [DayModel(dayNumber: 1, activities: acts)];
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
      ticketTypes: ttList, 
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
        'ticketTypes': ticketTypes.map((e) => e.toMap()).toList(),
      };

  String toJson() => json.encode(toMap());

  
}
