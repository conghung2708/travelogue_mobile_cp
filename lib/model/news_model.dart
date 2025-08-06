import 'dart:convert';
import 'package:travelogue_mobile/model/media_model.dart';

class NewsModel {
  String? id;
  String? title;
  String? description;
  String? content;
  String? locationId;
  String? locationName;
  int? newsCategory;
  String? categoryName;
  bool? isHighlighted;
  List<MediaModel>? medias;
  DateTime? createdTime;
  DateTime? lastUpdatedTime;
  String? createdBy;
  String? createdByName;
  String? lastUpdatedBy;
  String? lastUpdatedByName;

  NewsModel({
    this.id,
    this.title,
    this.description,
    this.content,
    this.locationId,
    this.locationName,
    this.newsCategory,
    this.categoryName,
    this.isHighlighted,
    this.medias,
    this.createdTime,
    this.lastUpdatedTime,
    this.createdBy,
    this.createdByName,
    this.lastUpdatedBy,
    this.lastUpdatedByName,
  });

  factory NewsModel.fromMap(Map<String, dynamic> map) {
    return NewsModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      content: map['content'],
      locationId: map['locationId'],
      locationName: map['locationName'],
      newsCategory: map['newsCategory'],
      categoryName: map['categoryName'],
      isHighlighted: map['isHighlighted'],
      medias: map['medias'] != null
          ? List<MediaModel>.from(
              map['medias'].map((x) => MediaModel.fromMap(x)))
          : [],
      createdTime: map['createdTime'] != null
          ? DateTime.parse(map['createdTime']).toLocal()
          : null,
      lastUpdatedTime: map['lastUpdatedTime'] != null
          ? DateTime.parse(map['lastUpdatedTime']).toLocal()
          : null,
      createdBy: map['createdBy'],
      createdByName: map['createdByName'],
      lastUpdatedBy: map['lastUpdatedBy'],
      lastUpdatedByName: map['lastUpdatedByName'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'content': content,
      'locationId': locationId,
      'locationName': locationName,
      'newsCategory': newsCategory,
      'categoryName': categoryName,
      'isHighlighted': isHighlighted,
      'medias': medias?.map((x) => x.toMap()).toList(),
      'createdTime': createdTime?.toUtc().toIso8601String(),
      'lastUpdatedTime': lastUpdatedTime?.toUtc().toIso8601String(),
      'createdBy': createdBy,
      'createdByName': createdByName,
      'lastUpdatedBy': lastUpdatedBy,
      'lastUpdatedByName': lastUpdatedByName,
    };
  }

  factory NewsModel.fromJson(String source) =>
      NewsModel.fromMap(json.decode(source));

  String toJson() => json.encode(toMap());

  String get imgUrlFirst => (medias?.isNotEmpty ?? false)
      ? (medias!.firstWhere((e) => e.mediaUrl?.isNotEmpty ?? false).mediaUrl ??
          '')
      : '';

  List<String> get listImages =>
      medias?.map((e) => e.mediaUrl ?? '').toList() ?? [];
}

/// Parse toàn bộ response API
class NewsResponse {
  List<NewsModel> data;
  String? message;
  bool? succeeded;
  int? statusCode;

  NewsResponse({
    required this.data,
    this.message,
    this.succeeded,
    this.statusCode,
  });

  factory NewsResponse.fromMap(Map<String, dynamic> map) {
    return NewsResponse(
      data: map['data'] != null
          ? List<NewsModel>.from(
              map['data'].map((x) => NewsModel.fromMap(x)))
          : [],
      message: map['message'],
      succeeded: map['succeeded'],
      statusCode: map['statusCode'],
    );
  }

  factory NewsResponse.fromJson(String source) =>
      NewsResponse.fromMap(json.decode(source));
}
