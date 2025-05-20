  // ignore_for_file: public_member_api_docs, sort_constructors_first
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
    String? typeLocationId;
    String? typeLocationName;

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
      this.typeLocationId,
      this.typeLocationName,
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
      String? typeLocationId,
      String? typeLocationName,
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
        typeLocationId: typeLocationId ?? this.typeLocationId,
        typeLocationName: typeLocationName ?? this.typeLocationName,
        medias: medias ?? this.medias,
        isLiked: isLiked ?? this.isLiked,
      );
    }

    Map<String, dynamic> toMap() {
      return <String, dynamic>{
        'id': id,
        'name': name,
        'description': description,
        'content': content,
        'latitude': latitude,
        'longitude': longitude,
        'rating': rating,
        'typeLocationId': typeLocationId,
        'typeLocationName': typeLocationName,
        'medias': medias?.map((x) => x.toMap()).toList(),
      };
    }

    factory LocationModel.fromMap(Map<String, dynamic> map) {
      return LocationModel(
        id: map['id']?.toString(),
        name: map['name']?.toString(),
        description: map['description']?.toString(),
        content: map['content']?.toString(),
        latitude: map['latitude'] != null ? map['latitude'] as double : null,
        longitude: map['longitude'] != null ? map['longitude'] as double : null,
        rating: map['rating'] != null ? map['rating'] as int : null,
        typeLocationId: map['typeLocationId']?.toString(),
        typeLocationName: map['typeLocationName']?.toString(),
        medias: map['medias'] != null && map['medias'] is List
            ? (map['medias'] as List).map((e) => MediaModel.fromMap(e)).toList()
            : null,
      );
    }

    String toJson() => json.encode(toMap());

    factory LocationModel.fromJson(String source) =>
        LocationModel.fromMap(json.decode(source) as Map<String, dynamic>);

    @override
    String toString() {
      return 'LocationModel(id: $id, name: $name, description: $description, content: $content, latitude: $latitude, longitude: $longitude, rating: $rating, typeLocationId: $typeLocationId, typeLocationName: $typeLocationName, medias: $medias)';
    }

    @override
    bool operator ==(covariant LocationModel other) {
      if (identical(this, other)) {
        return true;
      }

      return other.id == id &&
          other.name == name &&
          other.description == description &&
          other.content == content &&
          other.latitude == latitude &&
          other.longitude == longitude &&
          other.rating == rating &&
          other.typeLocationId == typeLocationId &&
          other.typeLocationName == typeLocationName &&
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
          typeLocationId.hashCode ^
          typeLocationName.hashCode ^
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
