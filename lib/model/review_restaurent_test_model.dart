import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/model/review_base_model.dart';

class ReviewRestaurantTestModel implements ReviewBase {
  final String id;
  final String userName;
  final String userAvatarUrl;
  final int rating;
  final String comment;
  final DateTime createdAt;
  int likes;
  int dislikes;

  ReviewRestaurantTestModel({
    required this.id,
    required this.userName,
    required this.userAvatarUrl,
    required this.rating,
    required this.comment,
    required this.createdAt,
    this.likes = 0,
    this.dislikes = 0,
  });

  @override
  ReviewRestaurantTestModel copyWith({
    int? likes,
    int? dislikes,
  }) {
    return ReviewRestaurantTestModel(
      id: id,
      userName: userName,
      userAvatarUrl: userAvatarUrl,
      rating: rating,
      comment: comment,
      createdAt: createdAt,
      likes: likes ?? this.likes,
      dislikes: dislikes ?? this.dislikes,
    );
  }
}

final List<ReviewRestaurantTestModel> mockRestaurantReviews = [
  ReviewRestaurantTestModel(
    id: 'rr1',
    userName: 'Trần Văn Minh',
    userAvatarUrl: AssetHelper.img_ava_1,
    rating: 5,
    comment: 'Hương vị đậm đà, trình bày món ăn rất tinh tế và sạch sẽ. Một trải nghiệm ẩm thực đáng nhớ.',
    createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    likes: 12,
    dislikes: 0,
  ),
  ReviewRestaurantTestModel(
    id: 'rr2',
    userName: 'Lê Ngọc Mai',
    userAvatarUrl: AssetHelper.img_ava_3,
    rating: 4,
    comment: 'Không gian ấm cúng, phục vụ thân thiện. Món ăn được chuẩn bị nhanh và nóng hổi.',
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
    likes: 9,
    dislikes: 1,
  ),
  ReviewRestaurantTestModel(
    id: 'rr3',
    userName: 'Nguyễn Quốc Dũng',
    userAvatarUrl: AssetHelper.img_ava_2,
    rating: 5,
    comment: 'Mùi vị rất đặc trưng, phù hợp cả người ăn chay lẫn ăn mặn. Giá cả hợp lý so với chất lượng.',
    createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 3)),
    likes: 18,
    dislikes: 0,
  ),
  ReviewRestaurantTestModel(
    id: 'rr4',
    userName: 'Phạm Thị Hồng Nhung',
    userAvatarUrl: AssetHelper.img_ava_4,
    rating: 3,
    comment: 'Một vài món chưa thực sự đặc sắc, nhưng tổng thể thì ổn cho một bữa ăn gia đình.',
    createdAt: DateTime.now().subtract(const Duration(days: 3)),
    likes: 6,
    dislikes: 2,
  ),
];
