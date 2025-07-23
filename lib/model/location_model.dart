import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:travelogue_mobile/model/media_model.dart';

class LocationModel {
  String? id;
  String? name;
  String? description;
  String? content;
  double? latitude;
  double? longitude;
  int? rating;
  String? openTime;
  String? closeTime;
  List<String>? categories;
  String? districtId;
  String? districtName;
  List<MediaModel>? medias;
  bool isLiked;

  LocationModel({
    this.id,
    this.name,
    this.description,
    this.content,
    this.latitude,
    this.longitude,
    this.rating,
    this.openTime,
    this.closeTime,
    this.categories,
    this.districtId,
    this.districtName,
    this.medias,
    this.isLiked = false,
  });

  LocationModel copyWith({
    String? id,
    String? name,
    String? description,
    String? content,
    double? latitude,
    double? longitude,
    int? rating,
    String? openTime,
    String? closeTime,
    List<String>? categories,
    String? districtId,
    String? districtName,
    List<MediaModel>? medias,
    bool? isLiked,
  }) {
    return LocationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      content: content ?? this.content,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      rating: rating ?? this.rating,
      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,
      categories: categories ?? this.categories,
      districtId: districtId ?? this.districtId,
      districtName: districtName ?? this.districtName,
      medias: medias ?? this.medias,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      id: map['id']?.toString(),
      name: map['name']?.toString(),
      description: map['description']?.toString(),
      content: map['content']?.toString(),
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
      rating: map['rating'] is int
          ? map['rating']
          : int.tryParse(map['rating']?.toString() ?? ''),
      openTime: map['openTime']?.toString(),
      closeTime: map['closeTime']?.toString(),
      categories:
          (map['categories'] as List?)?.map((e) => e.toString()).toList(),
      districtId: map['districtId']?.toString(),
      districtName: map['districtName']?.toString(),
    medias: map['medias'] is List
    ? (map['medias'] as List).map((e) => MediaModel.fromMap(e)).toList()
    : [],

    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'content': content,
      'latitude': latitude,
      'longitude': longitude,
      'rating': rating,
      'openTime': openTime,
      'closeTime': closeTime,
      'categories': categories,
      'districtId': districtId,
      'districtName': districtName,
      'medias': medias,
    };
  }

  String toJson() => json.encode(toMap());

  factory LocationModel.fromJson(String source) =>
      LocationModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'LocationModel(id: $id, name: $name, latitude: $latitude, longitude: $longitude, districtName: $districtName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LocationModel &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.content == content &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.rating == rating &&
        other.openTime == openTime &&
        other.closeTime == closeTime &&
        listEquals(other.categories, categories) &&
        other.districtId == districtId &&
        other.districtName == districtName &&
        listEquals(other.medias, medias) &&
        other.isLiked == isLiked & listEquals(other.medias, medias);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        content.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        rating.hashCode ^
        openTime.hashCode ^
        closeTime.hashCode ^
        categories.hashCode ^
        districtId.hashCode ^
        districtName.hashCode ^
        medias.hashCode ^
        isLiked.hashCode;
  }

   String get imgUrlFirst => (medias?.isNotEmpty ?? false)
      ? medias!.firstWhere((e) => e.mediaUrl?.isNotEmpty ?? false).mediaUrl ??
          ''
      : '';

  List<String> get listImages =>
      medias?.map((e) => e.mediaUrl ?? '').toList() ?? [];
}
