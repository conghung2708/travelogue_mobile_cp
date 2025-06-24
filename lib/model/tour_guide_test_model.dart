

import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/model/enums/tour_guide_status_enum.dart';

enum Gender { male, female, other }


class TourGuideTestModel {
  final int id;
  final String name;
  final int age;
  final Gender gender;
  final String avatarUrl;
  final String bio;
  final List<String> tags;
  final double rating;
  final int reviewsCount;
   TourGuideStatus status;
  final String? declineReason;

  TourGuideTestModel({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.avatarUrl,
    required this.bio,
    required this.tags,
    required this.rating,
    required this.reviewsCount,
    required this.status,
    this.declineReason,
  });
}

final List<TourGuideTestModel> mockTourGuides = [
  TourGuideTestModel(
    id: 1,
    name: "Đặng Công Hưng",
    age: 18,
    gender: Gender.male,
    avatarUrl: AssetHelper.img_ava_1,
    bio: "Hơn 5 năm kinh nghiệm dẫn tour Tây Ninh – chuyên về văn hóa & tâm linh.",
    tags: ["Nhiệt tình", "Am hiểu lịch sử", "Lịch sự"],
    rating: 5,
    reviewsCount: 87,
    status: TourGuideStatus.available,
  ),
  TourGuideTestModel(
    id: 2,
    name: "Nguyễn Tấn Hưng",
    age: 27,
    gender: Gender.male,
    avatarUrl: AssetHelper.img_ava_2,
    bio: "Thân thiện, nói tiếng Anh tốt. Đặc biệt am hiểu các tuyến trekking.",
    tags: ["Thân thiện", "Trekking", "Nói tiếng Anh"],
    rating: 3,
    reviewsCount: 65,
    status: TourGuideStatus.pending,
  ),
  TourGuideTestModel(
    id: 3,
    name: "Đoàn Mỹ Hảo",
    age: 35,
    gender: Gender.female,
    avatarUrl: AssetHelper.img_ava_4,
    bio: "Hướng dẫn viên sinh ra ở Tây Ninh, hiểu rõ từng con đường và văn hóa bản địa.",
    tags: ["Địa phương", "Kinh nghiệm", "Lịch sử"],
    rating: 5,
    reviewsCount: 112,
    status: TourGuideStatus.declined,
    declineReason: "Lịch cá nhân bận",
  ),
  TourGuideTestModel(
    id: 4,
    name: "Nguyễn Hương Giang",
    age: 29,
    gender: Gender.female,
    avatarUrl: AssetHelper.img_ava_3,
    bio: "Nhiệt huyết và chuyên nghiệp, từng dẫn tour cho khách quốc tế.",
    tags: ["Trẻ trung", "Ngoại ngữ", "Chụp ảnh đẹp"],
    rating: 5,
    reviewsCount: 74,
    status: TourGuideStatus.unavailable,
  ),
];
