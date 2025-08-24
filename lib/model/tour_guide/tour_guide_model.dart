import 'dart:convert';

class TourGuideModel {
  final String? id;
  final String? email;
  final String? userName;
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
      id: map['id'],
      email: map['email'],
      userName: map['userName'],
      sex: map['sex'],
      sexText: map['sexText'],
      address: map['address'],
      price: (map['price'] as num?)?.toDouble(),
      introduction: map['introduction'],
      avatarUrl: map['avatarUrl'],
      averageRating: (map['averageRating'] as num?)?.toDouble(),
      totalReviews: map['totalReviews'],
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

  Map<String, dynamic> toJson() {
    return toMap();
  }

  String toJsonString() => json.encode(toMap());
}
