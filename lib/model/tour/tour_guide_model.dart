class TourGuideModel {
  final String? id;
  final String? email;
  final String? userName;
  final int? sex;
  final String? sexText;
  final String? address;
  final double? rating;
  final double? price;
  final String? introduction;
  final String? avatarUrl;

  TourGuideModel({
    this.id,
    this.email,
    this.userName,
    this.sex,
    this.sexText,
    this.address,
    this.rating,
    this.price,
    this.introduction,
    this.avatarUrl,
  });

factory TourGuideModel.fromJson(Map<String, dynamic> json) {
  return TourGuideModel(
    id: json['id'],
    email: json['email'],
    userName: json['userName'],
    sex: json['sex'],
    sexText: json['sexText'],
    address: json['address'],
    rating: (json['rating'] as num?)?.toDouble(),
    price: (json['price'] as num?)?.toDouble(),
    introduction: json['introduction'],
    avatarUrl: json['avatarUrl'],
  );
}

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'userName': userName,
        'sex': sex,
        'sexText': sexText,
        'address': address,
        'rating': rating,
        'price': price,
        'introduction': introduction,
        'avatarUrl': avatarUrl,
      };
}
