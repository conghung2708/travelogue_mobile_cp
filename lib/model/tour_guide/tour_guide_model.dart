import 'dart:convert';

class TourGuideModel {
  final String? id;
  final String? email;
  final String? userName;
  final int? maxParticipants;   
  final int? sex;
  final String? sexText;
  final String? address;
  final double? price;
  final String? introduction;
  final String? avatarUrl;
  final double? averageRating;
  final int? totalReviews;

  TourGuideModel({
    this.id,
    this.email,
    this.userName,
    this.maxParticipants,       
    this.sex,
    this.sexText,
    this.address,
    this.price,
    this.introduction,
    this.avatarUrl,
    this.averageRating,
    this.totalReviews,
  });

  factory TourGuideModel.fromMap(Map<String, dynamic> map) {
    return TourGuideModel(
      id: map['id']?.toString(),
      email: map['email']?.toString(),
      userName: map['userName']?.toString(),
      maxParticipants: map['maxParticipants'] as int?, 
      sex: map['sex'] as int?,
      sexText: map['sexText']?.toString(),
      address: map['address']?.toString(),
      price: (map['price'] as num?)?.toDouble(),
      introduction: map['introduction']?.toString(),
      avatarUrl: map['avatarUrl']?.toString(),
      averageRating: (map['averageRating'] as num?)?.toDouble(),
      totalReviews: map['totalReviews'] as int?,
    );
  }

  factory TourGuideModel.fromJson(Map<String, dynamic> json) {
    return TourGuideModel.fromMap(json);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'userName': userName,
      'maxParticipants': maxParticipants, 
      'sex': sex,
      'sexText': sexText,
      'address': address,
      'price': price,
      'introduction': introduction,
      'avatarUrl': avatarUrl,
      'averageRating': averageRating,
      'totalReviews': totalReviews,
    };
  }

  Map<String, dynamic> toJson() => toMap();

  String toJsonString() => json.encode(toMap());
}
