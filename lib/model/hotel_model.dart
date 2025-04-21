// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:travelogue_mobile/model/media_model.dart';

class HotelModel {
  String? id;
  String? name;
  String? description;
  String? content;
  String? locationId;
  String? address;
  double? starRating;
  int? pricePerNight;
  String? phoneNumber;
  String? email;
  String? website;
  List<MediaModel>? medias;
  String? createdTime;
  String? lastUpdatedTime;
  HotelModel({
    this.id,
    this.name,
    this.description,
    this.content,
    this.locationId,
    this.address,
    this.starRating,
    this.pricePerNight,
    this.phoneNumber,
    this.email,
    this.website,
    this.medias,
    this.createdTime,
    this.lastUpdatedTime,
  });

  HotelModel copyWith({
    String? id,
    String? name,
    String? description,
    String? content,
    String? locationId,
    String? address,
    double? starRating,
    int? pricePerNight,
    String? phoneNumber,
    String? email,
    String? website,
    List<MediaModel>? medias,
    String? createdTime,
    String? lastUpdatedTime,
  }) {
    return HotelModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      content: content ?? this.content,
      locationId: locationId ?? this.locationId,
      address: address ?? this.address,
      starRating: starRating ?? this.starRating,
      pricePerNight: pricePerNight ?? this.pricePerNight,
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
      'starRating': starRating,
      'pricePerNight': pricePerNight,
      'phoneNumber': phoneNumber,
      'email': email,
      'website': website,
      'medias': medias?.map((x) => x.toMap()).toList(),
      'createdTime': createdTime,
      'lastUpdatedTime': lastUpdatedTime,
    };
  }

  factory HotelModel.fromMap(Map<String, dynamic> map) {
    return HotelModel(
      id: map['id']?.toString(),
      name: map['name']?.toString(),
      description: map['description']?.toString(),
      content: map['content']?.toString(),
      locationId: map['locationId']?.toString(),
      address: map['address']?.toString(),
      starRating:
          map['starRating'] != null ? map['starRating'] as double : null,
      pricePerNight:
          map['pricePerNight'] != null ? map['pricePerNight'] as int : null,
      phoneNumber: map['phoneNumber']?.toString(),
      email: map['email']?.toString(),
      website: map['website']?.toString(),
      medias: map['medias'] != null && map['medias'] is List
          ? (map['medias'] as List).map((e) => MediaModel.fromMap(e)).toList()
          : null,
      createdTime: map['createdTime']?.toString(),
      lastUpdatedTime: map['lastUpdatedTime']?.toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory HotelModel.fromJson(String source) =>
      HotelModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'HotelModel(id: $id, name: $name, description: $description, content: $content, locationId: $locationId, address: $address, starRating: $starRating, pricePerNight: $pricePerNight, phoneNumber: $phoneNumber, email: $email, website: $website, medias: $medias, createdTime: $createdTime, lastUpdatedTime: $lastUpdatedTime)';
  }

  @override
  bool operator ==(covariant HotelModel other) {
    if (identical(this, other)) {
      return true;
    }

    return other.id == id &&
        other.name == name &&
        other.description == description &&
        other.content == content &&
        other.locationId == locationId &&
        other.address == address &&
        other.starRating == starRating &&
        other.pricePerNight == pricePerNight &&
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
        starRating.hashCode ^
        pricePerNight.hashCode ^
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
