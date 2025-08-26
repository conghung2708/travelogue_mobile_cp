// lib/model/tour/tour_model.dart
import 'package:travelogue_mobile/model/media_model.dart';
import 'package:travelogue_mobile/model/tour/tour_day_model.dart';
import 'package:travelogue_mobile/model/tour/tour_plan_location_model.dart';
import 'package:travelogue_mobile/model/tour/tour_review_model.dart';
import 'package:travelogue_mobile/model/tour_guide/tour_guide_model.dart';
import 'package:travelogue_mobile/model/tour/tour_media_test_model.dart';
import 'package:travelogue_mobile/model/tour/tour_schedule_model.dart';

class TourModel {
  final String? tourId;
  final String? name;
  final String? description;
  final String? content;
  final String? transportType;
  final int? totalDays;
  final int? tourType;
  final String? tourTypeText;
  final String? totalDaysText;
  final double? adultPrice;
  final double? childrenPrice;
  final double? finalPrice;
  final bool? isDiscount;
  final int? status;
  final String? statusText;

  final List<TourScheduleModel> schedules;
  final List<TourDayModel> days;
  final TourGuideModel? tourGuide;
  final List<MediaModel> medias;

  final List<dynamic> promotions;
  final double? averageRating;
  final int? totalReviews;
  final TourPlanLocationModel? startLocation;
  final TourPlanLocationModel? endLocation;
  final List<TourReviewModel> reviews;

  const TourModel({
    this.tourId,
    this.name,
    this.description,
    this.content,
    this.transportType,
    this.totalDays,
    this.tourType,
    this.tourTypeText,
    this.totalDaysText,
    this.adultPrice,
    this.childrenPrice,
    this.finalPrice,
    this.isDiscount,
    this.status,
    this.statusText,
    this.tourGuide,
    this.averageRating,
    this.totalReviews,
    this.startLocation,
    this.endLocation,
    this.schedules = const [],
    this.days = const [],
    this.medias = const [],
    this.promotions = const [],
    this.reviews = const [],
  });

  factory TourModel.fromLiteJson(Map<String, dynamic> json) {
    final rawMedias = (json['medias'] is List)
        ? json['medias']
        : (json['mediaList'] is List ? json['mediaList'] : const []);

    print(
        '[fromLiteJson] ${json['name']} - rawMedias type=${rawMedias.runtimeType} len=${(rawMedias as List).length}');
    if (rawMedias is List && rawMedias.isNotEmpty) {
      print('[fromLiteJson] first media: ${rawMedias.first}');
    }

    final mediaList = (rawMedias as List)
        .whereType<Map<String, dynamic>>()
        .map((e) => MediaModel.fromJson(e))
        .toList();
    print(
        '[fromLiteJson] ${json['name']} -> medias.length=${mediaList.length}');

    return TourModel(
      tourId: json['tourId'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      content: json['content'] as String?,
      transportType: json['transportType'] as String?,
      totalDays: json['totalDays'] as int?,
      tourType: json['tourType'] as int?,
      tourTypeText: json['tourTypeText'] as String?,
      totalDaysText: json['totalDaysText'] as String?,
      adultPrice: (json['adultPrice'] as num?)?.toDouble(),
      childrenPrice: (json['childrenPrice'] as num?)?.toDouble(),
      finalPrice: (json['finalPrice'] as num?)?.toDouble(),
      isDiscount: json['isDiscount'] as bool?,
      status: json['status'] as int?,
      statusText: json['statusText'] as String?,
      averageRating: (json['averageRating'] as num?)?.toDouble(),
      totalReviews: json['totalReviews'] as int?,
      medias: mediaList,
    );
  }

  factory TourModel.fromDetailJson(Map<String, dynamic> json,
      {bool logSchedules = false}) {
    final rawSchedules = json['schedules'];
    final guideRaw = json['tourGuide'];
    final rawDays = json['days'];

    final rawMedias = (json['medias'] is List)
        ? json['medias']
        : (json['mediaList'] is List ? json['mediaList'] : const []);

    final rawPromotions = json['promotions'];
    final rawReviews = json['reviews'];
    final rawStartLocation = json['startLocation'];
    final rawEndLocation = json['endLocation'];

    return TourModel(
      tourId: json['tourId'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      content: json['content'] as String?,
      transportType: json['transportType'] as String?,
      totalDays: json['totalDays'] as int?,
      tourType: json['tourType'] as int?,
      tourTypeText: json['tourTypeText'] as String?,
      totalDaysText: json['totalDaysText'] as String?,
      adultPrice: (json['adultPrice'] as num?)?.toDouble(),
      childrenPrice: (json['childrenPrice'] as num?)?.toDouble(),
      finalPrice: (json['finalPrice'] as num?)?.toDouble(),
      isDiscount: json['isDiscount'] as bool?,
      status: json['status'] as int?,
      statusText: json['statusText'] as String?,
      averageRating: (json['averageRating'] as num?)?.toDouble(),
      totalReviews: json['totalReviews'] as int?,
      schedules: (rawSchedules is List)
          ? rawSchedules
              .map((e) => TourScheduleModel.fromMap(e as Map<String, dynamic>))
              .toList()
          : const [],
      days: (rawDays is List)
          ? rawDays.map((e) => TourDayModel.fromJson(e)).toList()
          : const [],
      tourGuide: (() {
        if (guideRaw is List && guideRaw.isNotEmpty) {
          return TourGuideModel.fromJson(guideRaw.first);
        } else if (guideRaw is Map<String, dynamic>) {
          return TourGuideModel.fromJson(guideRaw);
        }
        return null;
      })(),
      medias: (rawMedias as List)
          .map((e) => MediaModel.fromJson(e))
          .toList()
          .cast<MediaModel>(),
      promotions: (rawPromotions is List) ? rawPromotions : const [],
      startLocation: (rawStartLocation is Map<String, dynamic>)
          ? TourPlanLocationModel.fromJson(rawStartLocation)
          : null,
      endLocation: (rawEndLocation is Map<String, dynamic>)
          ? TourPlanLocationModel.fromJson(rawEndLocation)
          : null,
      reviews: (rawReviews is List)
          ? rawReviews
              .map((e) => TourReviewModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : const [],
    );
  }

  factory TourModel.fromJson(Map<String, dynamic> json) =>
      TourModel.fromDetailJson(json);

  Map<String, dynamic> toJson() {
    return {
      'tourId': tourId,
      'name': name,
      'description': description,
      'content': content,
      'transportType': transportType,
      'totalDays': totalDays,
      'tourType': tourType,
      'tourTypeText': tourTypeText,
      'totalDaysText': totalDaysText,
      'adultPrice': adultPrice,
      'childrenPrice': childrenPrice,
      'finalPrice': finalPrice,
      'isDiscount': isDiscount,
      'status': status,
      'statusText': statusText,
      'averageRating': averageRating,
      'totalReviews': totalReviews,
      'schedules': schedules.map((e) => e.toJson()).toList(),
      'days': days.map((e) => e.toJson()).toList(),
      'tourGuide': tourGuide?.toJson(),
      'medias': medias.map((e) => e.toJson()).toList(),
      'promotions': promotions,
      'startLocation': startLocation?.toJson(),
      'endLocation': endLocation?.toJson(),
      'reviews': reviews.map((e) => e.toJson()).toList(),
    };
  }
}
