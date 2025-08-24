// lib/model/tour/tour_review_model.dart
class TourReviewModel {
  final String? id;
  final String? userId;
  final String? userName;
  final String? bookingId;
  final String? tourId;
  final String? workshopId;
  final String? tourGuideId;
  final String? comment;
  final int? rating;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const TourReviewModel({
    this.id,
    this.userId,
    this.userName,
    this.bookingId,
    this.tourId,
    this.workshopId,
    this.tourGuideId,
    this.comment,
    this.rating,
    this.createdAt,
    this.updatedAt,
  });

  factory TourReviewModel.fromJson(Map<String, dynamic> json) => TourReviewModel(
    id: json['id'] as String?,
    userId: json['userId'] as String?,
    userName: json['userName'] as String?,
    bookingId: json['bookingId'] as String?,
    tourId: json['tourId'] as String?,
    workshopId: json['workshopId'] as String?,
    tourGuideId: json['tourGuideId'] as String?,
    comment: json['comment'] as String?,
    rating: json['rating'] as int?,
    createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
    updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'userName': userName,
    'bookingId': bookingId,
    'tourId': tourId,
    'workshopId': workshopId,
    'tourGuideId': tourGuideId,
    'comment': comment,
    'rating': rating,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };
}
