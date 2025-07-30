import 'package:travelogue_mobile/model/tour/tour_day_model.dart';
import 'package:travelogue_mobile/model/tour_guide/tour_guide_model.dart';
import 'package:travelogue_mobile/model/tour/tour_media_test_model.dart';
import 'package:travelogue_mobile/model/tour/tour_schedule_model.dart';

class TourModel {
  final String? tourId;
  final String? name;
  final String? description;
  final String? content;
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
  final List<TourScheduleModel>? schedules;
  final List<TourDayModel>? days;
  final TourGuideModel? tourGuide;
  final List<TourMediaTestModel> mediaList;

  TourModel({
    this.tourId,
    this.name,
    this.description,
    this.content,
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
    this.schedules,
    this.days,
    this.tourGuide,
    this.mediaList = const [],
  });

  factory TourModel.fromLiteJson(Map<String, dynamic> json) {
    return TourModel(
      tourId: json['tourId'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      content: json['content'] as String?,
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
    );
  }

  factory TourModel.fromDetailJson(Map<String, dynamic> json, {bool logSchedules = false}) {
    final tourId = json['tourId'];
    final name = json['name'];

    print('🟩 Parsing TourModel: tourId=$tourId, name=$name');

    final rawSchedules = json['schedules'];
    if (rawSchedules != null && rawSchedules is List) {
      print('📆 Found ${rawSchedules.length} schedules for tourId $tourId');
    } else {
      print('📆 No schedules found for tourId $tourId');
    }

    final guideRaw = json['tourGuide'];
    print('🧑‍✈️ tourGuide type = ${guideRaw.runtimeType}');
    print('🧑‍✈️ tourGuide raw = $guideRaw');

    final rawDays = json['days'];
    if (rawDays != null && rawDays is List) {
      print('📜 Found ${rawDays.length} days');
    }

    final rawMedia = json['mediaList'];

    return TourModel(
      tourId: tourId as String?,
      name: name as String?,
      description: json['description'] as String?,
      content: json['content'] as String?,
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
      schedules: (rawSchedules != null && rawSchedules is List)
          ? rawSchedules.map((e) {
              if (logSchedules) {
                print('➡️ schedule: $e');
              }
              return TourScheduleModel.fromJson(e);
            }).toList()
          : [],
      days: (rawDays != null && rawDays is List)
          ? rawDays.map((e) => TourDayModel.fromJson(e)).toList()
          : [],
      tourGuide: (() {
        if (guideRaw is List && guideRaw.isNotEmpty) {
          return TourGuideModel.fromJson(guideRaw.first);
        } else if (guideRaw is Map<String, dynamic>) {
          return TourGuideModel.fromJson(guideRaw);
        }
        return null;
      })(),
      mediaList: (rawMedia != null && rawMedia is List)
          ? rawMedia.map((e) => TourMediaTestModel.fromJson(e)).toList()
          : [],
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
      'schedules': schedules?.map((e) => e.toJson()).toList(),
      'days': days?.map((e) => e.toJson()).toList(),
      'tourGuide': tourGuide?.toJson(),
      'mediaList': mediaList.map((e) => e.toJson()).toList(),
    };
  }
}
