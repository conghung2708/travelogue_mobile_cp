// lib/model/craft_village/craft_village_model.dart
import 'package:travelogue_mobile/model/media_model.dart';

class CraftVillageModel {
  final String? ownerId;
  final String? phoneNumber;
  final String? email;
  final String? website;
  final String? signatureProduct;
  final int? yearsOfHistory;
  final bool? workshopsAvailable;
  final bool? isRecognizedByUnesco;

  final WorkshopModel? workshop; 
  final List<MediaModel> medias;

  CraftVillageModel({
    this.ownerId,
    this.phoneNumber,
    this.email,
    this.website,
    this.signatureProduct,
    this.yearsOfHistory,
    this.workshopsAvailable,
    this.isRecognizedByUnesco,
    this.workshop,
    this.medias = const [],
  });

  factory CraftVillageModel.fromMap(Map<String, dynamic> map) {
    final rawMedias = (map['medias'] is List) ? map['medias'] as List : const [];
    return CraftVillageModel(
      ownerId: map['ownerId']?.toString(),
      phoneNumber: map['phoneNumber']?.toString(),
      email: map['email']?.toString(),
      website: map['website']?.toString(),
      signatureProduct: map['signatureProduct']?.toString(),
      yearsOfHistory: (map['yearsOfHistory'] is num) ? (map['yearsOfHistory'] as num).toInt() : null,
      workshopsAvailable: map['workshopsAvailable'] as bool?,
      isRecognizedByUnesco: map['isRecognizedByUnesco'] as bool?,
      workshop: (map['workshop'] is Map) ? WorkshopModel.fromMap(map['workshop']) : null,
      medias: rawMedias.whereType<Map<String, dynamic>>().map(MediaModel.fromMap).toList(),
    );
  }

  Map<String, dynamic> toMap() => {
        'ownerId': ownerId,
        'phoneNumber': phoneNumber,
        'email': email,
        'website': website,
        'signatureProduct': signatureProduct,
        'yearsOfHistory': yearsOfHistory,
        'workshopsAvailable': workshopsAvailable,
        'isRecognizedByUnesco': isRecognizedByUnesco,
        'workshop': workshop?.toMap(),
        'medias': medias.map((e) => e.toMap()).toList(),
      };
}

class WorkshopModel {
  final String? id;
  final String? name;
  final String? description;
  final String? content;
  final int? status;
  final String? craftVillageId;
  final String? locationId;
  final String? craftVillageName;

  final List<TicketTypeModel> ticketTypes;
  final List<WorkshopScheduleModel> schedules;
  final List<RecurringRuleModel> recurringRules;
  final List<WorkshopExceptionModel> exceptions;
  final List<MediaModel> medias;

  WorkshopModel({
    this.id,
    this.name,
    this.description,
    this.content,
    this.status,
    this.craftVillageId,
    this.locationId,
    this.craftVillageName,
    this.ticketTypes = const [],
    this.schedules = const [],
    this.recurringRules = const [],
    this.exceptions = const [],
    this.medias = const [],
  });

  factory WorkshopModel.fromMap(Map<String, dynamic> map) {
    return WorkshopModel(
      id: map['id']?.toString(),
      name: map['name']?.toString(),
      description: map['description']?.toString(),
      content: map['content']?.toString(),
      status: (map['status'] is num) ? (map['status'] as num).toInt() : null,
      craftVillageId: map['craftVillageId']?.toString(),
      locationId: map['locationId']?.toString(),
      craftVillageName: map['craftVillageName']?.toString(),
      ticketTypes: (map['ticketTypes'] is List)
          ? (map['ticketTypes'] as List)
              .whereType<Map<String, dynamic>>()
              .map(TicketTypeModel.fromMap)
              .toList()
          : const [],
      schedules: (map['schedules'] is List)
          ? (map['schedules'] as List)
              .whereType<Map<String, dynamic>>()
              .map(WorkshopScheduleModel.fromMap)
              .toList()
          : const [],
      recurringRules: (map['recurringRules'] is List)
          ? (map['recurringRules'] as List)
              .whereType<Map<String, dynamic>>()
              .map(RecurringRuleModel.fromMap)
              .toList()
          : const [],
      exceptions: (map['exceptions'] is List)
          ? (map['exceptions'] as List)
              .whereType<Map<String, dynamic>>()
              .map(WorkshopExceptionModel.fromMap)
              .toList()
          : const [],
      medias: (map['medias'] is List)
          ? (map['medias'] as List)
              .whereType<Map<String, dynamic>>()
              .map(MediaModel.fromMap)
              .toList()
          : const [],
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'description': description,
        'content': content,
        'status': status,
        'craftVillageId': craftVillageId,
        'locationId': locationId,
        'craftVillageName': craftVillageName,
        'ticketTypes': ticketTypes.map((e) => e.toMap()).toList(),
        'schedules': schedules.map((e) => e.toMap()).toList(),
        'recurringRules': recurringRules.map((e) => e.toMap()).toList(),
        'exceptions': exceptions.map((e) => e.toMap()).toList(),
        'medias': medias.map((e) => e.toMap()).toList(),
      };
}

class TicketTypeModel {
  final String? id;
  final String? workshopId;
  final int? type;
  final String? name;
  final double? price;
  final bool? isCombo;
  final int? durationMinutes;
  final String? content;
  final List<TicketActivityModel> activities;

  TicketTypeModel({
    this.id,
    this.workshopId,
    this.type,
    this.name,
    this.price,
    this.isCombo,
    this.durationMinutes,
    this.content,
    this.activities = const [],
  });

  factory TicketTypeModel.fromMap(Map<String, dynamic> map) {
    double? _toDouble(dynamic v) => v == null ? null : double.tryParse(v.toString());

    return TicketTypeModel(
      id: map['id']?.toString(),
      workshopId: map['workshopId']?.toString(),
      type: (map['type'] is num) ? (map['type'] as num).toInt() : null,
      name: map['name']?.toString(),
      price: _toDouble(map['price']),
      isCombo: map['isCombo'] as bool?,
      durationMinutes: (map['durationMinutes'] is num)
          ? (map['durationMinutes'] as num).toInt()
          : null,
      content: map['content']?.toString(),
      activities: (map['activities'] is List)
          ? (map['activities'] as List)
              .whereType<Map<String, dynamic>>()
              .map(TicketActivityModel.fromMap)
              .toList()
          : const [],
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'workshopId': workshopId,
        'type': type,
        'name': name,
        'price': price,
        'isCombo': isCombo,
        'durationMinutes': durationMinutes,
        'content': content,
        'activities': activities.map((e) => e.toMap()).toList(),
      };
}

class TicketActivityModel {
  final String? id;
  final String? workshopTicketTypeId;
  final String? activity;
  final String? description;
  final int? durationMinutes;
  final int? activityOrder;

  TicketActivityModel({
    this.id,
    this.workshopTicketTypeId,
    this.activity,
    this.description,
    this.durationMinutes,
    this.activityOrder,
  });

  factory TicketActivityModel.fromMap(Map<String, dynamic> map) => TicketActivityModel(
        id: map['id']?.toString(),
        workshopTicketTypeId: map['workshopTicketTypeId']?.toString(),
        activity: map['activity']?.toString(),
        description: map['description']?.toString(),
        durationMinutes: (map['durationMinutes'] is num)
            ? (map['durationMinutes'] as num).toInt()
            : null,
        activityOrder: (map['activityOrder'] is num)
            ? (map['activityOrder'] as num).toInt()
            : null,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'workshopTicketTypeId': workshopTicketTypeId,
        'activity': activity,
        'description': description,
        'durationMinutes': durationMinutes,
        'activityOrder': activityOrder,
      };
}

class WorkshopScheduleModel {
  final String? id;
  final String? workshopId;
  final DateTime? startTime;
  final DateTime? endTime;
  final int? capacity;
  final int? currentBooked;
  final String? notes;
  final int? status;

  WorkshopScheduleModel({
    this.id,
    this.workshopId,
    this.startTime,
    this.endTime,
    this.capacity,
    this.currentBooked,
    this.notes,
    this.status,
  });

  factory WorkshopScheduleModel.fromMap(Map<String, dynamic> map) {
    DateTime? _d(dynamic v) {
      if (v is String && v.isNotEmpty) { try { return DateTime.parse(v); } catch (_) {} }
      return null;
    }

    return WorkshopScheduleModel(
      id: map['id']?.toString(),
      workshopId: map['workshopId']?.toString(),
      startTime: _d(map['startTime']),
      endTime: _d(map['endTime']),
      capacity: (map['capacity'] is num) ? (map['capacity'] as num).toInt() : null,
      currentBooked: (map['currentBooked'] is num) ? (map['currentBooked'] as num).toInt() : null,
      notes: map['notes']?.toString(),
      status: (map['status'] is num) ? (map['status'] as num).toInt() : null,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'workshopId': workshopId,
        'startTime': startTime?.toIso8601String(),
        'endTime': endTime?.toIso8601String(),
        'capacity': capacity,
        'currentBooked': currentBooked,
        'notes': notes,
        'status': status,
      };
}

class RecurringRuleModel {
  final String? id;
  final String? workshopId;
  final List<int> daysOfWeek;
  final List<String> daysOfWeekText;
  final String? daysOfWeekDisplay;
  final List<RecurringSessionModel> sessions;

  RecurringRuleModel({
    this.id,
    this.workshopId,
    this.daysOfWeek = const [],
    this.daysOfWeekText = const [],
    this.daysOfWeekDisplay,
    this.sessions = const [],
  });

  factory RecurringRuleModel.fromMap(Map<String, dynamic> map) => RecurringRuleModel(
        id: map['id']?.toString(),
        workshopId: map['workshopId']?.toString(),
        daysOfWeek: (map['daysOfWeek'] is List)
            ? (map['daysOfWeek'] as List)
                .whereType<num>()
                .map((e) => e.toInt())
                .toList()
            : const [],
        daysOfWeekText: (map['daysOfWeekText'] is List)
            ? (map['daysOfWeekText'] as List)
                .whereType<String>()
                .toList()
            : const [],
        daysOfWeekDisplay: map['daysOfWeekDisplay']?.toString(),
        sessions: (map['sessions'] is List)
            ? (map['sessions'] as List)
                .whereType<Map<String, dynamic>>()
                .map(RecurringSessionModel.fromMap)
                .toList()
            : const [],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'workshopId': workshopId,
        'daysOfWeek': daysOfWeek,
        'daysOfWeekText': daysOfWeekText,
        'daysOfWeekDisplay': daysOfWeekDisplay,
        'sessions': sessions.map((e) => e.toMap()).toList(),
      };
}

class RecurringSessionModel {
  final String? id;
  final String? recurringRuleId;
  final String? startTime; // HH:mm:ss
  final String? endTime;   // HH:mm:ss
  final int? capacity;

  RecurringSessionModel({
    this.id,
    this.recurringRuleId,
    this.startTime,
    this.endTime,
    this.capacity,
  });

  factory RecurringSessionModel.fromMap(Map<String, dynamic> map) => RecurringSessionModel(
        id: map['id']?.toString(),
        recurringRuleId: map['recurringRuleId']?.toString(),
        startTime: map['startTime']?.toString(),
        endTime: map['endTime']?.toString(),
        capacity: (map['capacity'] is num) ? (map['capacity'] as num).toInt() : null,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'recurringRuleId': recurringRuleId,
        'startTime': startTime,
        'endTime': endTime,
        'capacity': capacity,
      };
}

class WorkshopExceptionModel {
  final String? id;
  final String? workshopId;
  final DateTime? date;
  final String? reason;

  WorkshopExceptionModel({
    this.id,
    this.workshopId,
    this.date,
    this.reason,
  });

  factory WorkshopExceptionModel.fromMap(Map<String, dynamic> map) {
    DateTime? _d(dynamic v) {
      if (v is String && v.isNotEmpty) { try { return DateTime.parse(v); } catch (_) {} }
      return null;
    }

    return WorkshopExceptionModel(
      id: map['id']?.toString(),
      workshopId: map['workshopId']?.toString(),
      date: _d(map['date']),
      reason: map['reason']?.toString(),
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'workshopId': workshopId,
        'date': date?.toIso8601String(),
        'reason': reason,
      };
}
