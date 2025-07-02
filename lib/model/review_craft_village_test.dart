import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/model/review_base_model.dart';

class ReviewCraftVillageTestModel implements ReviewBase {
  @override
  final String id;
  @override
  final String userName;
  @override
  final String userAvatarUrl;
  @override
  final int rating;
  @override
  final String comment;
  @override
  final DateTime createdAt;
  @override
  int likes;
  @override
  int dislikes;

  ReviewCraftVillageTestModel({
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
  ReviewCraftVillageTestModel copyWith({
    int? likes,
    int? dislikes,
  }) {
    return ReviewCraftVillageTestModel(
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

final List<ReviewCraftVillageTestModel> mockCraftVillageReviews = [
  ReviewCraftVillageTestModel(
    id: 'cv1',
    userName: 'Phạm Văn Thắng',
    userAvatarUrl: AssetHelper.img_ava_1,
    rating: 5,
    comment: 'Rất thú vị khi được tận mắt chứng kiến quá trình làm thủ công. Cảm giác như quay về tuổi thơ.',
    createdAt: DateTime.now().subtract(const Duration(hours: 6)),
    likes: 14,
    dislikes: 0,
  ),
  ReviewCraftVillageTestModel(
    id: 'cv2',
    userName: 'Trịnh Hồng Anh',
    userAvatarUrl: AssetHelper.img_ava_3,
    rating: 4,
    comment: 'Hướng dẫn viên chia sẻ rất chi tiết, các sản phẩm truyền thống đẹp và tinh xảo.',
    createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
    likes: 11,
    dislikes: 1,
  ),
  ReviewCraftVillageTestModel(
    id: 'cv3',
    userName: 'Lương Thành Đạt',
    userAvatarUrl: AssetHelper.img_ava_2,
    rating: 5,
    comment: 'Một nơi tuyệt vời để hiểu hơn về văn hóa địa phương. Có thể mua quà lưu niệm độc đáo nữa.',
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
    likes: 20,
    dislikes: 0,
  ),
  ReviewCraftVillageTestModel(
    id: 'cv4',
    userName: 'Ngô Diệu Linh',
    userAvatarUrl: AssetHelper.img_ava_4,
    rating: 3,
    comment: 'Không gian hơi nhỏ và đông khách, nhưng vẫn rất đáng đến trải nghiệm nếu chưa từng.',
    createdAt: DateTime.now().subtract(const Duration(days: 3)),
    likes: 7,
    dislikes: 2,
  ),
];
