import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/model/review_base_model.dart';

class ReviewTestModel  implements ReviewBase {
  final String id;                
  final String userName;         
  final String userAvatarUrl;    
  final int rating;           
  final String comment;          
  final DateTime createdAt;      
  int likes;                     
  int dislikes;                 

  ReviewTestModel({
    required this.id,
    required this.userName,
    required this.userAvatarUrl,
    required this.rating,
    required this.comment,
    required this.createdAt,
    this.likes = 0,
    this.dislikes = 0,
  });
}

final List<ReviewTestModel> mockReviews = [
  ReviewTestModel(
    id: 'r1',
    userName: 'Đặng Công Hưng',
    userAvatarUrl: AssetHelper.img_ava_1,
    rating: 5,
    comment: 'Tây Ninh thật sự khiến mình bất ngờ vì vẻ đẹp tự nhiên và sự thân thiện của người dân. Rất đáng để trải nghiệm!',
    createdAt: DateTime.now().subtract(const Duration(hours: 3)),
    likes: 15,
    dislikes: 0,
  ),
  ReviewTestModel(
    id: 'r2',
    userName: 'Nguyễn Tấn Hưng',
    userAvatarUrl:  AssetHelper.img_ava_2,
    rating: 4,
    comment: 'Mình thích khu di tích lịch sử và cách tổ chức tham quan rất bài bản. Tuy nhiên thời tiết khá nắng, nhớ mang theo mũ nhé!',
    createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 1)),
    likes: 10,
    dislikes: 1,
  ),
  ReviewTestModel(
    id: 'r3',
    userName: 'Đoàn Mỹ Hảo',
    userAvatarUrl:  AssetHelper.img_ava_4,
    rating: 5,
    comment: 'Đồ ăn ở Tây Ninh ngon xuất sắc! Bánh tráng phơi sương, muối tôm... ăn một lần là nhớ mãi luôn.',
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
    likes: 20,
    dislikes: 0,
  ),
  ReviewTestModel(
    id: 'r4',
    userName:  'Nguyễn Hương Giang',
    userAvatarUrl: AssetHelper.img_ava_3,
    rating: 3,
    comment: 'Cảnh đẹp nhưng dịch vụ nhà vệ sinh công cộng chưa được tốt lắm. Mong địa phương cải thiện thêm.',
    createdAt: DateTime.now().subtract(const Duration(days: 3, hours: 4)),
    likes: 8,
    dislikes: 3,
  ),
];
