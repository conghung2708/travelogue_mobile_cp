// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:travelogue_mobile/model/media_model.dart';

class ExperienceModel {
  String? id;
  String? title;
  String? description;
  String? content;
  String? locationId;
  List<MediaModel>? medias;
  DateTime? createdAt;
  String? typeExperienceId;
  ExperienceModel({
    this.id,
    this.title,
    this.description,
    this.content,
    this.locationId,
    this.medias,
    this.createdAt,
    this.typeExperienceId,
  });

  ExperienceModel copyWith({
    String? id,
    String? title,
    String? description,
    String? content,
    String? locationId,
    List<MediaModel>? medias,
    DateTime? createdAt,
    String? typeExperienceId,
  }) {
    return ExperienceModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      content: content ?? this.content,
      locationId: locationId ?? this.locationId,
      medias: medias ?? this.medias,
      createdAt: createdAt ?? this.createdAt,
      typeExperienceId: typeExperienceId ?? this.typeExperienceId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'content': content,
      'locationId': locationId,
      'medias': medias?.map((x) => x.toMap()).toList(),
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'typeExperienceId': typeExperienceId,
    };
  }

  factory ExperienceModel.fromMap(Map<String, dynamic> map) {
    return ExperienceModel(
      id: map['id']?.toString(),
      title: map['title']?.toString(),
      description: map['description']?.toString(),
      content: map['content']?.toString(),
      locationId: map['locationId']?.toString(),
      medias: map['medias'] != null && map['medias'] is List
          ? (map['medias'] as List).map((e) => MediaModel.fromMap(e)).toList()
          : null,
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int)
          : null,
      typeExperienceId: map['typeExperienceId']?.toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory ExperienceModel.fromJson(String source) =>
      ExperienceModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ExperienceModel(id: $id, title: $title, description: $description, content: $content, locationId: $locationId, medias: $medias, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant ExperienceModel other) {
    if (identical(this, other)) {
      return true;
    }

    return other.id == id &&
        other.title == title &&
        other.description == description &&
        other.content == content &&
        other.locationId == locationId &&
        listEquals(other.medias, medias) &&
        other.typeExperienceId == typeExperienceId &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        content.hashCode ^
        locationId.hashCode ^
        medias.hashCode ^
        typeExperienceId.hashCode ^
        createdAt.hashCode;
  }

  String get imgUrlFirst => (medias?.isNotEmpty ?? false)
      ? medias!.firstWhere((e) => e.mediaUrl?.isNotEmpty ?? false).mediaUrl ??
          ''
      : '';

  List<String> get listImages =>
      medias?.map((e) => e.mediaUrl ?? '').toList() ?? [];
}
