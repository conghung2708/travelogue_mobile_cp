import 'package:travelogue_mobile/model/args/base_trip_model.dart';
import 'package:travelogue_mobile/model/tour_guide_test_model.dart';
import 'package:travelogue_mobile/model/trip_plan_cuisine.dart';
import 'package:travelogue_mobile/model/trip_plan_location.dart';
import 'package:travelogue_mobile/model/trip_plan_version.dart';
import 'package:travelogue_mobile/model/enums/trip_status.dart';

class TripPlan implements BaseTrip {
  @override
  final String id;

  @override
  String name;

  @override
  final String description;

  @override
  final DateTime startDate;

  @override
  final DateTime endDate;

  @override
  String coverImage;

  @override
  int status;

  @override
  final double rating;

  @override
  final double price;

  @override
  TourGuideTestModel? tourGuide;

  String? versionId;

  TripPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.coverImage,
    required this.status,
    required this.rating,
    required this.price,
    this.tourGuide,
    this.versionId,
  });

  TripStatus get statusEnum => TripStatus.values[status];

  set statusEnum(TripStatus newStatus) {
    status = newStatus.index;
  }

  TripPlan copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    String? coverImage,
    int? status,
    double? rating,
    double? price,
    TourGuideTestModel? tourGuide,
    String? versionId,
  }) {
    return TripPlan(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      coverImage: coverImage ?? this.coverImage,
      status: status ?? this.status,
      rating: rating ?? this.rating,
      price: price ?? this.price,
      tourGuide: tourGuide ?? this.tourGuide,
      versionId: versionId ?? this.versionId,
    );
  }
}

final List<TripPlan> tripPlans = [
  TripPlan(
    id: 'trip001',
    name: 'Khám phá Tây Ninh',
    description:
        'Hành trình khám phá làng nghề, địa điểm du lịch và ẩm thực đặc sắc tại Tây Ninh',
    startDate: DateTime(2025, 7, 10),
    endDate: DateTime(2025, 7, 11),
    coverImage: getTripPlanCoverImage('ver001'),
    status: TripStatus.planning.index,
    price: 9999999,
    rating: 4.7,
    tourGuide: mockTourGuides[0],
    versionId: tripVersion.id,
  ),
];
String getTripPlanCoverImage(String tripPlanVersionId) {
  final allImages = <String>[];

  allImages.addAll(tripLocations
      .where((e) => e.tripPlanVersionId == tripPlanVersionId)
      .expand((e) => e.location.medias?.map((m) => m.mediaUrl ?? '') ?? []));

  allImages.addAll(tripCuisines
      .where((e) => e.tripPlanVersionId == tripPlanVersionId)
      .expand((e) => e.restaurant.medias?.map((m) => m.mediaUrl ?? '') ?? []));

  allImages.removeWhere((url) => url.isEmpty);

  allImages.shuffle();
  return allImages.isNotEmpty
      ? allImages.first
      : 'https://via.placeholder.com/400x200?text=No+Image';
}
