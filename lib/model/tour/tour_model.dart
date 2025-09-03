// lib/model/tour/tour_model.dart
import 'package:travelogue_mobile/model/media_model.dart';
import 'package:travelogue_mobile/model/tour/tour_day_model.dart';
import 'package:travelogue_mobile/model/tour/tour_plan_location_model.dart';
import 'package:travelogue_mobile/model/tour/tour_review_model.dart';
import 'package:travelogue_mobile/model/tour_guide/tour_guide_model.dart';
import 'package:travelogue_mobile/model/tour/tour_schedule_model.dart';
import 'package:travelogue_mobile/model/tour/tour_activity_model.dart';

class TourModel {
  final String? tourId;
  final String? name;
  final String? description;
  final String? content;
  final String? transportType;

  final String? pickupAddress;
  final String? stayInfo;

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

  final bool? isTourWorkshop;

  
  final DateTime? createdTime;
  final DateTime? lastUpdatedTime;
  final String? createdBy;
  final String? createdByName;
  final String? lastUpdatedBy;
  final String? lastUpdatedByName;

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
    this.pickupAddress,
    this.stayInfo,
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
    this.isTourWorkshop,      
    this.createdTime,          
    this.lastUpdatedTime,      
    this.createdBy,             
    this.createdByName,         
    this.lastUpdatedBy,        
    this.lastUpdatedByName,    
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

  bool get hasWorkshop {
    if (isTourWorkshop == true) return true;
    for (final d in days) {
      final acts = d.activities ?? const [];
      for (final a in acts) {
        if ((a.activityType ?? 0) == 3) return true; 
        if ((a.activityTypeText ?? '').toLowerCase().contains('workshop')) return true;
        if (a.workshop != null) return true;
      }
    }
    return false;
  }

  static DateTime? _parseDate(dynamic v) {
    if (v == null) return null;
    if (v is DateTime) return v;
    if (v is String && v.trim().isNotEmpty) {
      try { return DateTime.parse(v); } catch (_) {}
    }
    return null;
  }

  factory TourModel.fromLiteJson(Map<String, dynamic> json) {
    final rawMedias = (json['medias'] is List)
        ? json['medias']
        : (json['mediaList'] is List ? json['mediaList'] : const []);

    final mediaList = (rawMedias as List)
        .whereType<Map<String, dynamic>>()
        .map((e) => MediaModel.fromJson(e))
        .toList();

    return TourModel(
      tourId: json['tourId'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      content: json['content'] as String?,
      transportType: json['transportType'] as String?,
      pickupAddress: json['pickupAddress'] as String?,
      stayInfo: json['stayInfo'] as String?,
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
      isTourWorkshop: json['isTourWorkshop'] as bool?,                
      createdTime: _parseDate(json['createdTime']),                   
      lastUpdatedTime: _parseDate(json['lastUpdatedTime']),            
      createdBy: json['createdBy'] as String?,                        
      createdByName: json['createdByName'] as String?,                
      lastUpdatedBy: json['lastUpdatedBy'] as String?,                
      lastUpdatedByName: json['lastUpdatedByName'] as String?,        
      medias: mediaList,
    );
  }

  factory TourModel.fromDetailJson(Map<String, dynamic> json, {bool logSchedules = false}) {
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
      pickupAddress: json['pickupAddress'] as String?,
      stayInfo: json['stayInfo'] as String?,
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

      /// NEW fields
      isTourWorkshop: json['isTourWorkshop'] as bool?,
      createdTime: _parseDate(json['createdTime']),
      lastUpdatedTime: _parseDate(json['lastUpdatedTime']),
      createdBy: json['createdBy'] as String?,
      createdByName: json['createdByName'] as String?,
      lastUpdatedBy: json['lastUpdatedBy'] as String?,
      lastUpdatedByName: json['lastUpdatedByName'] as String?,

      schedules: (rawSchedules is List)
          ? rawSchedules
              .whereType<Map<String, dynamic>>()
              .map((e) => TourScheduleModel.fromMap(e))
              .toList()
          : const [],

      days: (rawDays is List)
          ? rawDays
              .whereType<Map<String, dynamic>>()
              .map((e) => TourDayModel.fromJson(e))
              .toList()
          : const [],

      tourGuide: (() {
        if (guideRaw is List && guideRaw.isNotEmpty) {
          final first = guideRaw.first;
          if (first is Map<String, dynamic>) {
            return TourGuideModel.fromJson(first);
          }
        } else if (guideRaw is Map<String, dynamic>) {
          return TourGuideModel.fromJson(guideRaw);
        }
        return null;
      })(),

      medias: (rawMedias as List)
          .whereType<Map<String, dynamic>>()
          .map((e) => MediaModel.fromJson(e))
          .toList(),

      promotions: (rawPromotions is List) ? rawPromotions : const [],

      startLocation: (rawStartLocation is Map<String, dynamic>)
          ? TourPlanLocationModel.fromJson(rawStartLocation)
          : null,
      endLocation: (rawEndLocation is Map<String, dynamic>)
          ? TourPlanLocationModel.fromJson(rawEndLocation)
          : null,

      reviews: (rawReviews is List)
          ? rawReviews
              .whereType<Map<String, dynamic>>()
              .map((e) => TourReviewModel.fromJson(e))
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
      'pickupAddress': pickupAddress,
      'stayInfo': stayInfo,
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
      'isTourWorkshop': isTourWorkshop,                 
      'createdTime': createdTime?.toIso8601String(),    
      'lastUpdatedTime': lastUpdatedTime?.toIso8601String(), 
      'createdBy': createdBy,                          
      'createdByName': createdByName,                   
      'lastUpdatedBy': lastUpdatedBy,                   
      'lastUpdatedByName': lastUpdatedByName,          
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
