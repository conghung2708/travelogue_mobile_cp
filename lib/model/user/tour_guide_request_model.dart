class TourGuideRequestModel {
  final String introduction;
  final double price;
  final List<Certification> certifications;

  TourGuideRequestModel({
    required this.introduction,
    required this.price,
    required this.certifications,
  });

  Map<String, dynamic> toJson() {
    return {
      'introduction': introduction,
      'price': price,
      'certifications': certifications.map((e) => e.toJson()).toList(),
    };
  }
}

class Certification {
  final String name;
  final String certificateUrl;

  Certification({
    required this.name,
    required this.certificateUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'certificateUrl': certificateUrl,
    };
  }
}
