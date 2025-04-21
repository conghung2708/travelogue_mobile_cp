// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:travelogue_mobile/model/media_model.dart';

class RestaurantModel {
  String? id;
  String? name;
  String? description;
  String? content;
  String? locationId;
  String? address;
  String? cuisineType;
  String? phoneNumber;
  String? email;
  String? website;
  List<MediaModel>? medias;
  String? createdTime;
  String? lastUpdatedTime;
  RestaurantModel({
    this.id,
    this.name,
    this.description,
    this.content,
    this.locationId,
    this.address,
    this.cuisineType,
    this.phoneNumber,
    this.email,
    this.website,
    this.medias,
    this.createdTime,
    this.lastUpdatedTime,
  });

  RestaurantModel copyWith({
    String? id,
    String? name,
    String? description,
    String? content,
    String? locationId,
    String? address,
    String? cuisineType,
    String? phoneNumber,
    String? email,
    String? website,
    List<MediaModel>? medias,
    String? createdTime,
    String? lastUpdatedTime,
  }) {
    return RestaurantModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      content: content ?? this.content,
      locationId: locationId ?? this.locationId,
      address: address ?? this.address,
      cuisineType: cuisineType ?? this.cuisineType,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      website: website ?? this.website,
      medias: medias ?? this.medias,
      createdTime: createdTime ?? this.createdTime,
      lastUpdatedTime: lastUpdatedTime ?? this.lastUpdatedTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'content': content,
      'locationId': locationId,
      'address': address,
      'cuisineType': cuisineType,
      'phoneNumber': phoneNumber,
      'email': email,
      'website': website,
      'medias': medias?.map((x) => x.toMap()).toList(),
      'createdTime': createdTime,
      'lastUpdatedTime': lastUpdatedTime,
    };
  }

  factory RestaurantModel.fromMap(Map<String, dynamic> map) {
    return RestaurantModel(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      content: map['content'] != null ? map['content'] as String : null,
      locationId:
          map['locationId'] != null ? map['locationId'] as String : null,
      address: map['address'] != null ? map['address'] as String : null,
      cuisineType:
          map['cuisineType'] != null ? map['cuisineType'] as String : null,
      phoneNumber:
          map['phoneNumber'] != null ? map['phoneNumber'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      website: map['website'] != null ? map['website'] as String : null,
      medias: map['medias'] != null && map['medias'] is List
          ? (map['medias'] as List).map((e) => MediaModel.fromMap(e)).toList()
          : null,
      createdTime:
          map['createdTime'] != null ? map['createdTime'] as String : null,
      lastUpdatedTime: map['lastUpdatedTime'] != null
          ? map['lastUpdatedTime'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory RestaurantModel.fromJson(String source) =>
      RestaurantModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'RestaurantModel(id: $id, name: $name, description: $description, content: $content, locationId: $locationId, address: $address, cuisineType: $cuisineType, phoneNumber: $phoneNumber, email: $email, website: $website, medias: $medias, createdTime: $createdTime, lastUpdatedTime: $lastUpdatedTime)';
  }

  @override
  bool operator ==(covariant RestaurantModel other) {
    if (identical(this, other)) {
      return true;
    }

    return other.id == id &&
        other.name == name &&
        other.description == description &&
        other.content == content &&
        other.locationId == locationId &&
        other.address == address &&
        other.cuisineType == cuisineType &&
        other.phoneNumber == phoneNumber &&
        other.email == email &&
        other.website == website &&
        listEquals(other.medias, medias) &&
        other.createdTime == createdTime &&
        other.lastUpdatedTime == lastUpdatedTime;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        content.hashCode ^
        locationId.hashCode ^
        address.hashCode ^
        cuisineType.hashCode ^
        phoneNumber.hashCode ^
        email.hashCode ^
        website.hashCode ^
        medias.hashCode ^
        createdTime.hashCode ^
        lastUpdatedTime.hashCode;
  }

  String get imgUrlFirst => (medias?.isNotEmpty ?? false)
      ? medias!.firstWhere((e) => e.mediaUrl?.isNotEmpty ?? false).mediaUrl ??
          ''
      : '';

  List<String> get listImages =>
      medias?.map((e) => e.mediaUrl ?? '').toList() ?? [];
}
