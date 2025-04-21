// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:travelogue_mobile/model/media_model.dart';

class EventModel {
  String? id;
  String? name;
  String? description;
  String? content;
  String? typeEventId;
  String? locationId;
  DateTime? lunarStartDate;
  DateTime? lunarEndDate;

  DateTime? startDate;
  DateTime? endDate;
  bool? isRecurring;
  String? recurrencePattern;
  bool? isHighlighted;
  List<MediaModel>? medias;

  EventModel({
    this.id,
    this.name,
    this.description,
    this.content,
    this.typeEventId,
    this.locationId,
    this.lunarStartDate,
    this.lunarEndDate,
    this.startDate,
    this.endDate,
    this.isRecurring,
    this.recurrencePattern,
    this.isHighlighted,
    this.medias,
  });

  EventModel copyWith({
    String? id,
    String? name,
    String? description,
    String? content,
    String? typeEventId,
    String? locationId,
    DateTime? lunarStartDate,
    DateTime? lunarEndDate,
    DateTime? startDate,
    DateTime? endDate,
    bool? isRecurring,
    String? recurrencePattern,
    bool? isHighlighted,
    List<MediaModel>? medias,
  }) {
    return EventModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      content: content ?? this.content,
      typeEventId: typeEventId ?? this.typeEventId,
      locationId: locationId ?? this.locationId,
      lunarStartDate: lunarStartDate ?? this.lunarStartDate,
      lunarEndDate: lunarEndDate ?? this.lunarEndDate,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isRecurring: isRecurring ?? this.isRecurring,
      recurrencePattern: recurrencePattern ?? this.recurrencePattern,
      isHighlighted: isHighlighted ?? this.isHighlighted,
      medias: medias ?? this.medias,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'content': content,
      'typeEventId': typeEventId,
      'locationId': locationId,
      'lunarStartDate': lunarStartDate,
      'lunarEndDate': lunarEndDate,
      'startDate': startDate?.toString(),
      'endDate': endDate?.toString(),
      'isRecurring': isRecurring,
      'recurrencePattern': recurrencePattern,
      'isHighlighted': isHighlighted,
      'medias': medias?.map((x) => x.toMap()).toList(),
    };
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id']?.toString(),
      name: map['name']?.toString(),
      description: map['description']?.toString(),
      content: map['content']?.toString(),
      typeEventId: map['typeEventId']?.toString(),
      locationId: map['locationId']?.toString(),
      lunarStartDate: DateTime.tryParse(map['lunarStartDate'] ?? '')?.toLocal(),
      lunarEndDate: DateTime.tryParse(map['lunarEndDate'] ?? '')?.toLocal(),
      startDate: DateTime.tryParse(map['startDate'] ?? '')?.toLocal(),
      endDate: DateTime.tryParse(map['endDate'] ?? '')?.toLocal(),
      isRecurring:
          map['isRecurring'] != null ? map['isRecurring'] as bool : null,
      recurrencePattern: map['recurrencePattern']?.toString(),
      isHighlighted:
          map['isHighlighted'] != null ? map['isHighlighted'] as bool : null,
      medias: map['medias'] != null && map['medias'] is List
          ? (map['medias'] as List).map((e) => MediaModel.fromMap(e)).toList()
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory EventModel.fromJson(String source) =>
      EventModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'EventModel(id: $id, name: $name, description: $description, typeEventId: $typeEventId, locationId: $locationId, lunarStartDate: $lunarStartDate, lunarEndDate: $lunarEndDate, startDate: $startDate, endDate: $endDate, isRecurring: $isRecurring, recurrencePattern: $recurrencePattern, isHighlighted: $isHighlighted, medias: $medias)';
  }

  @override
  bool operator ==(covariant EventModel other) {
    if (identical(this, other)) {
      return true;
    }

    return other.id == id &&
        other.name == name &&
        other.description == description &&
        other.content == content &&
        other.typeEventId == typeEventId &&
        other.locationId == locationId &&
        other.lunarStartDate == lunarStartDate &&
        other.lunarEndDate == lunarEndDate &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.isRecurring == isRecurring &&
        other.recurrencePattern == recurrencePattern &&
        other.isHighlighted == isHighlighted &&
        listEquals(other.medias, medias);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        content.hashCode ^
        typeEventId.hashCode ^
        locationId.hashCode ^
        lunarStartDate.hashCode ^
        lunarEndDate.hashCode ^
        startDate.hashCode ^
        endDate.hashCode ^
        isRecurring.hashCode ^
        recurrencePattern.hashCode ^
        isHighlighted.hashCode ^
        medias.hashCode;
  }

  String get imgUrlFirst => (medias?.isNotEmpty ?? false)
      ? medias!.firstWhere((e) => e.mediaUrl?.isNotEmpty ?? false).mediaUrl ??
          ''
      : '';

  List<String> get listImages =>
      medias?.map((e) => e.mediaUrl ?? '').toList() ?? [];
}
