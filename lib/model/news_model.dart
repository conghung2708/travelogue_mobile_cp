// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:travelogue_mobile/model/media_model.dart';

class NewsModel {
  String? id;
  String? title;
  String? description;
  String? content;
  String? locationId;
  String? locationName;
  DateTime? createdTime;
  DateTime? lastUpdatedTime;
  List<MediaModel>? medias;

  NewsModel({
    this.id,
    this.title,
    this.description,
    this.content,
    this.locationId,
    this.locationName,
    this.createdTime,
    this.lastUpdatedTime,
    this.medias,
  });

  NewsModel copyWith({
    String? id,
    String? title,
    String? description,
    String? content,
    String? locationId,
    String? locationName,
    DateTime? createdTime,
    DateTime? lastUpdatedTime,
    List<MediaModel>? medias,
  }) {
    return NewsModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      content: content ?? this.content,
      locationId: locationId ?? this.locationId,
      locationName: locationName ?? this.locationName,
      createdTime: createdTime ?? this.createdTime,
      lastUpdatedTime: lastUpdatedTime ?? this.lastUpdatedTime,
      medias: medias ?? this.medias,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'content': content,
      'locationId': locationId,
      'locationName': locationName,
      'createdTime': createdTime,
      'lastUpdatedTime': lastUpdatedTime,
      'medias': medias?.map((x) => x.toMap()).toList(),
    };
  }

  factory NewsModel.fromMap(Map<String, dynamic> map) {
    return NewsModel(
      id: map['id'] != null ? map['id'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      content: map['content'] != null ? map['content'] as String : null,
      locationId:
          map['locationId'] != null ? map['locationId'] as String : null,
      locationName:
          map['locationName'] != null ? map['locationName'] as String : null,
      createdTime: DateTime.tryParse(map['createdTime'] ?? '')?.toLocal(),
      lastUpdatedTime:
          DateTime.tryParse(map['lastUpdatedTime'] ?? '')?.toLocal(),
      medias: map['medias'] != null && map['medias'] is List
          ? (map['medias'] as List).map((e) => MediaModel.fromMap(e)).toList()
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory NewsModel.fromJson(String source) =>
      NewsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'NewsModel(id: $id, title: $title, description: $description, content: $content, locationId: $locationId, locationName: $locationName, createdTime: $createdTime, lastUpdatedTime: $lastUpdatedTime, medias: $medias)';
  }

  @override
  bool operator ==(covariant NewsModel other) {
    if (identical(this, other)) {
      return true;
    }

    return other.id == id &&
        other.title == title &&
        other.description == description &&
        other.content == content &&
        other.locationId == locationId &&
        other.locationName == locationName &&
        other.createdTime == createdTime &&
        other.lastUpdatedTime == lastUpdatedTime &&
        listEquals(other.medias, medias);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        content.hashCode ^
        locationId.hashCode ^
        locationName.hashCode ^
        createdTime.hashCode ^
        lastUpdatedTime.hashCode ^
        medias.hashCode;
  }

  String get imgUrlFirst => (medias?.isNotEmpty ?? false)
      ? medias!.firstWhere((e) => e.mediaUrl?.isNotEmpty ?? false).mediaUrl ??
          ''
      : '';

  List<String> get listImages =>
      medias?.map((e) => e.mediaUrl ?? '').toList() ?? [];
}
