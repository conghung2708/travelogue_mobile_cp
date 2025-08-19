import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:travelogue_mobile/model/media_model.dart';

class LocationModel {
  final String? id;
  final String? name;
  final String? description;
  final String? content;
  final double? latitude;
  final double? longitude;
  final int? rating;
  final String? openTime;
  final String? closeTime;
  final String? category;
  final String? districtId;
  final String? districtName;
  final List<MediaModel>? medias;
  final bool isLiked;
  final String? address;

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
    this.category,
    this.districtId,
    this.districtName,
    this.medias,
    this.isLiked = false,
    this.address,
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
    String? category,
    String? districtId,
    String? districtName,
    List<MediaModel>? medias,
    bool? isLiked,
    String? address,
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
      category: category ?? this.category,
      districtId: districtId ?? this.districtId,
      districtName: districtName ?? this.districtName,
      medias: medias ?? this.medias,
      isLiked: isLiked ?? this.isLiked,
      address: address ?? this.address,
    );
  }

 factory LocationModel.fromMap(Map<String, dynamic> map) {
  double? _toDouble(dynamic v) => v == null ? null : double.tryParse(v.toString());

  return LocationModel(
    id: map['id']?.toString(),
    name: map['name']?.toString(),
    description: map['description']?.toString(),
    content: map['content']?.toString(),
    latitude: _toDouble(map['latitude']),
    longitude: _toDouble(map['longitude']),
    rating: int.tryParse(map['rating']?.toString() ?? ''),
    openTime: map['openTime']?.toString(),
    closeTime: map['closeTime']?.toString(),
    category: map['category']?.toString(),
    districtId: map['districtId']?.toString(),
    districtName: map['districtName']?.toString(),
    medias: (map['medias'] is List)
        ? (map['medias'] as List).map((e) => MediaModel.fromMap(e)).toList()
        : [],
    address: map['address']?.toString(),
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
      'category': category, // ✅
      'districtId': districtId,
      'districtName': districtName,
      'medias': medias?.map((e) => e.toMap()).toList(),
      'address': address,
    };
  }

  String toJson() => json.encode(toMap());

  factory LocationModel.fromJson(String source) =>
      LocationModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'LocationModel(id: $id, name: $name, category: $category, district: $districtName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is LocationModel &&
            other.id == id &&
            other.name == name &&
            other.description == description &&
            other.content == content &&
            other.latitude == latitude &&
            other.longitude == longitude &&
            other.rating == rating &&
            other.openTime == openTime &&
            other.closeTime == closeTime &&
            other.category == category &&
            other.districtId == districtId &&
            other.districtName == districtName &&
            listEquals(other.medias, medias) &&
            other.isLiked == isLiked);
            
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
        category.hashCode ^
        districtId.hashCode ^
        districtName.hashCode ^
        medias.hashCode ^
        isLiked.hashCode;
  }

  String get imgUrlFirst => (medias?.isNotEmpty ?? false)
      ? (medias!.firstWhere((e) => e.mediaUrl?.isNotEmpty ?? false,
              orElse: () => MediaModel(mediaUrl: ''))).mediaUrl ??
          ''
      : '';

  List<String> get listImages =>
      medias?.map((e) => e.mediaUrl ?? '').toList() ?? [];
}
