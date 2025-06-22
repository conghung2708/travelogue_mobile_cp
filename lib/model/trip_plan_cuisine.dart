import 'package:travelogue_mobile/model/media_model.dart';
import 'package:travelogue_mobile/model/restaurant_model.dart';

class TripPlanCuisine {
  final String tripPlanVersionId;
  final RestaurantModel restaurant;
  final DateTime startTime;
  final DateTime endTime;
  final String note;
  final int order;

  TripPlanCuisine({
    required this.tripPlanVersionId,
    required this.restaurant,
    required this.startTime,
    required this.endTime,
    required this.note,
    required this.order,
  });
}


final List<TripPlanCuisine> tripCuisines = [
  TripPlanCuisine(
    tripPlanVersionId: 'ver001',
    restaurant: RestaurantModel(
      id: '08dd734a-3eb5-4605-8023-70183cc30cd0',
      name: 'Nhà hàng Bò Tơ Năm Sánh',
      description: 'Chuyên bò tơ Tây Ninh nổi tiếng.',
      content: 'Chuyên bò tơ Tây Ninh nổi tiếng.',
      address: '92 Nguyễn Văn Rốp, TP. Tây Ninh',
      cuisineType: 'Ẩm thực châu Á',
      phoneNumber: '0276 3822 111',
      medias: [
        MediaModel(mediaUrl: 'https://i.imgur.com/BoBkXrS.jpeg'),
        MediaModel(mediaUrl: 'https://i.imgur.com/cWSCdxi.jpeg'),
      ],
    ),
    startTime: DateTime(2025, 7, 10, 18, 0),
    endTime: DateTime(2025, 7, 10, 19, 0),
    note: 'Ăn tối đặc sản bò tơ',
    order: 3,
  ),
  TripPlanCuisine(
    tripPlanVersionId: 'ver001',
    restaurant: RestaurantModel(
      id: '08dd734a-3eb5-4605-8023-70183cc30cd1',
      name: 'Gogi',
      description: 'Điểm đến lý tưởng cho tín đồ ẩm thực Hàn Quốc.',
      content: 'Không gian hiện đại, thịt nướng phong cách Hàn Quốc đậm đà.',
      address: '32 và căn PG2-33, Khu phố 1, Tây Ninh, 840000, Việt Nam',
      cuisineType: 'Ẩm thực châu Á',
      phoneNumber: '02767300220',
      medias: [
        MediaModel(mediaUrl: 'https://i.imgur.com/z5rbKT5.png'),
        MediaModel(mediaUrl: 'https://i.imgur.com/9ewO1wi.png'),
      ],
    ),
    startTime: DateTime(2025, 7, 11, 18, 0),
    endTime: DateTime(2025, 7, 11, 19, 0),
    note: 'Ăn tối kiểu Hàn Quốc',
    order: 3,
  ),
];
