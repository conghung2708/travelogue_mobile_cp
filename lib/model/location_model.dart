// lib/model/location_model.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:travelogue_mobile/model/media_model.dart';
import 'package:travelogue_mobile/model/craft_village/craft_village_model.dart';

class LocationModel {
  final String? id;
  final String? name;
  final String? description;
  final String? content;
  final double? latitude;
  final double? longitude;
  final String? openTime;
  final String? closeTime;
  final String? category;
  final String? districtId;
  final String? districtName;
  final List<MediaModel>? medias;
  final bool isLiked;
  final String? address;

  final double? minPrice;
  final double? maxPrice;
  final DateTime? createdTime;
  final DateTime? lastUpdatedTime;
  final String? createdBy;
  final String? createdByName;
  final String? lastUpdatedBy;
  final String? lastUpdatedByName;

  final CraftVillageModel? craftVillage;
  final double? rating;

  LocationModel({
    this.id,
    this.name,
    this.description,
    this.content,
    this.latitude,
    this.longitude,
    this.openTime,
    this.closeTime,
    this.category,
    this.districtId,
    this.districtName,
    this.medias,
    this.isLiked = false,
    this.address,
    this.minPrice,
    this.maxPrice,
    this.createdTime,
    this.lastUpdatedTime,
    this.createdBy,
    this.createdByName,
    this.lastUpdatedBy,
    this.lastUpdatedByName,
    this.craftVillage,
    this.rating,
  });

  LocationModel copyWith({
    String? id,
    String? name,
    String? description,
    String? content,
    double? latitude,
    double? longitude,
    String? openTime,
    String? closeTime,
    String? category,
    String? districtId,
    String? districtName,
    List<MediaModel>? medias,
    bool? isLiked,
    String? address,
    double? minPrice,
    double? maxPrice,
    DateTime? createdTime,
    DateTime? lastUpdatedTime,
    String? createdBy,
    String? createdByName,
    String? lastUpdatedBy,
    String? lastUpdatedByName,
    CraftVillageModel? craftVillage,
    double? rating,
  }) {
    return LocationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      content: content ?? this.content,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,
      category: category ?? this.category,
      districtId: districtId ?? this.districtId,
      districtName: districtName ?? this.districtName,
      medias: medias ?? this.medias,
      isLiked: isLiked ?? this.isLiked,
      address: address ?? this.address,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      createdTime: createdTime ?? this.createdTime,
      lastUpdatedTime: lastUpdatedTime ?? this.lastUpdatedTime,
      createdBy: createdBy ?? this.createdBy,
      createdByName: createdByName ?? this.createdByName,
      lastUpdatedBy: lastUpdatedBy ?? this.lastUpdatedBy,
      lastUpdatedByName: lastUpdatedByName ?? this.lastUpdatedByName,
      craftVillage: craftVillage ?? this.craftVillage,
      rating: rating ?? this.rating,
    );
  }

  static double? _toDouble(dynamic v) =>
      v == null ? null : double.tryParse(v.toString());
  static DateTime? _toDate(dynamic v) {
    if (v == null) return null;
    if (v is DateTime) return v;
    if (v is String && v.trim().isNotEmpty) {
      try {
        return DateTime.parse(v);
      } catch (_) {}
    }
    return null;
  }

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    final rawMedias =
        (map['medias'] is List) ? (map['medias'] as List) : const [];
    final craftVillage = (map['craftVillage'] is Map)
        ? CraftVillageModel.fromMap(map['craftVillage'])
        : null;

    return LocationModel(
      id: map['id']?.toString(),
      name: map['name']?.toString(),
      description: map['description']?.toString(),
      content: map['content']?.toString(),
      latitude: _toDouble(map['latitude']),
      longitude: _toDouble(map['longitude']),
      openTime: map['openTime']?.toString(),
      closeTime: map['closeTime']?.toString(),
      category: map['category']?.toString(),
      districtId: map['districtId']?.toString(),
      districtName: map['districtName']?.toString(),
      medias: rawMedias
          .whereType<Map<String, dynamic>>()
          .map((e) => MediaModel.fromMap(e))
          .toList(),
      address: map['address']?.toString(),
      minPrice: _toDouble(map['minPrice']),
      maxPrice: _toDouble(map['maxPrice']),
      createdTime: _toDate(map['createdTime']),
      lastUpdatedTime: _toDate(map['lastUpdatedTime']),
      createdBy: map['createdBy']?.toString(),
      createdByName: map['createdByName']?.toString(),
      lastUpdatedBy: map['lastUpdatedBy']?.toString(),
      lastUpdatedByName: map['lastUpdatedByName']?.toString(),
      craftVillage: map['craftVillage'] is Map<String, dynamic>
          ? CraftVillageModel.fromMap(map['craftVillage'])
          : null,
      rating: _toDouble(map['rating']),
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'description': description,
        'content': content,
        'latitude': latitude,
        'longitude': longitude,
        'openTime': openTime,
        'closeTime': closeTime,
        'category': category,
        'districtId': districtId,
        'districtName': districtName,
        'medias': medias?.map((e) => e.toMap()).toList(),
        'address': address,
        'minPrice': minPrice,
        'maxPrice': maxPrice,
        'createdTime': createdTime?.toIso8601String(),
        'lastUpdatedTime': lastUpdatedTime?.toIso8601String(),
        'createdBy': createdBy,
        'createdByName': createdByName,
        'lastUpdatedBy': lastUpdatedBy,
        'lastUpdatedByName': lastUpdatedByName,
        'craftVillage': craftVillage?.toMap(),
        'rating': rating,
      };

  String toJson() => json.encode(toMap());
  factory LocationModel.fromJson(String source) =>
      LocationModel.fromMap(json.decode(source));

  String get imgUrlFirst => (medias?.isNotEmpty ?? false)
      ? (medias!.firstWhere((e) => (e.mediaUrl?.isNotEmpty ?? false),
              orElse: () => MediaModel(mediaUrl: ''))).mediaUrl ??
          ''
      : '';

  List<String> get listImages =>
      medias?.map((e) => e.mediaUrl ?? '').toList() ?? [];
}
