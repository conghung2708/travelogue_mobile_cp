import 'dart:convert';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';

class WorkshopListModel {
  final String? id;
  final String? name;
  final String? description;
  final String? content;
  final int? status;
  final String? craftVillageId;
  final String? craftVillageName;
  final String? statusText;
  final double? averageRating;
  final int? totalReviews;
  final List<String>? imageList; // 🔹 thêm field ảnh

  WorkshopListModel({
    this.id,
    this.name,
    this.description,
    this.content,
    this.status,
    this.craftVillageId,
    this.craftVillageName,
    this.statusText,
    this.averageRating,
    this.totalReviews,
    this.imageList,
  });

  factory WorkshopListModel.fromMap(Map<String, dynamic> map) {
   
    List<String> images = [];
    if (map['imageList'] != null && map['imageList'] is List) {
      images = List<String>.from(
        map['imageList'].map((e) => e?.toString() ?? '').where((url) => url.isNotEmpty),
      );
    }

  
    if (images.isEmpty) {
      images = [AssetHelper.img_default];
    }

    return WorkshopListModel(
      id: map['id']?.toString(),
      name: map['name']?.toString(),
      description: map['description']?.toString(),
      content: map['content']?.toString(),
      status: map['status'] is int
          ? map['status']
          : int.tryParse(map['status']?.toString() ?? ''),
      craftVillageId: map['craftVillageId']?.toString(),
      craftVillageName: map['craftVillageName']?.toString(),
      statusText: map['statusText']?.toString(),
      averageRating: (map['averageRating'] as num?)?.toDouble(),
      totalReviews: map['totalReviews'] is int
          ? map['totalReviews']
          : int.tryParse(map['totalReviews']?.toString() ?? ''),
      imageList: images,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'content': content,
      'status': status,
      'craftVillageId': craftVillageId,
      'craftVillageName': craftVillageName,
      'statusText': statusText,
      'averageRating': averageRating,
      'totalReviews': totalReviews,
      'imageList': imageList,
    };
  }

  String toJson() => json.encode(toMap());

  factory WorkshopListModel.fromJson(String source) =>
      WorkshopListModel.fromMap(json.decode(source));
}
