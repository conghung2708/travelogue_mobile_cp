import 'package:travelogue_mobile/model/args/tour_day_plan_test_model.dart';
import 'package:travelogue_mobile/model/args/tour_day_schedule.dart';
import 'package:travelogue_mobile/model/destination_test_model.dart';
import 'package:travelogue_mobile/model/tour_guide_test_model.dart';

enum TourType {
  guideOnly,
  fullPackage,
}
class TourSuggestionTestModel {
  final int id;
  final String name;
  final String imageUrl;
  final List<DestinationTestModel> destinations;
  final TourGuideTestModel guide;
  final TourType type;
  final double price;
  final bool isAvailable;
  final List<int> hobbyIds;
  final List<TourDaySchedule> schedule;

  TourSuggestionTestModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.destinations,
    required this.guide,
    required this.type,
    required this.price,
    required this.isAvailable,
    required this.hobbyIds,
    required this.schedule,
  });
}

final List<TourSuggestionTestModel> mockTours = [
  TourSuggestionTestModel(
    id: 1,
    name: 'Khám phá Núi Bà Đen trong ngày',
    imageUrl: mockDestinations[0].imageUrls.first,
    destinations: [
      mockDestinations[0], 
      mockDestinations[6], 
      mockDestinations[11] 
    ],
    guide: mockTourGuides[0],
    type: TourType.fullPackage,
    price: 350000,
    isAvailable: true,
    hobbyIds: [1, 5],
    schedule: [
      TourDaySchedule(
        day: 1,
        plan: TourDayPlan(
          morning: 'Leo núi, cáp treo lên đỉnh Núi Bà Đen',
          lunch: 'Ăn trưa tại Nhà hàng sinh thái Lạc Viên',
          afternoon: 'Tắm mát tại Suối Đá',
        ),
      ),
    ],
  ),
  TourSuggestionTestModel(
    id: 2,
    name: 'Tour Văn hoá - Tâm linh 2 ngày',
    imageUrl: mockDestinations[11].imageUrls.first,
    destinations: [
      mockDestinations[1], 
      mockDestinations[5], 
      mockDestinations[6], 
      mockDestinations[4], 
      mockDestinations[7], 
      mockDestinations[11] 
    ],
    guide: mockTourGuides[1],
    type: TourType.guideOnly,
    price: 490000,
    isAvailable: true,
    hobbyIds: [2, 3],
    schedule: [
      TourDaySchedule(
        day: 1,
        plan: TourDayPlan(
          morning: 'Tham quan Tòa Thánh Tây Ninh',
          lunch: 'Ăn trưa tại Nhà hàng sinh thái Lạc Viên',
          afternoon: 'Tham quan Chùa Gò Kén',
        ),
      ),
      TourDaySchedule(
        day: 2,
        plan: TourDayPlan(
          morning: 'Tháp cổ Bình Thạnh - tìm hiểu văn hóa Óc Eo',
          lunch: 'Nhà hàng Bò tơ Út Khương',
          afternoon: 'Vui chơi tại Long Điền Sơn',
        ),
      ),
    ],
  ),
  TourSuggestionTestModel(
    id: 3,
    name: 'Trọn vẹn Tây Ninh 3 ngày 2 đêm',
    imageUrl: mockDestinations[6].imageUrls.first,
    destinations: [
      mockDestinations[0], 
      mockDestinations[6], 
      mockDestinations[11], 
      mockDestinations[1], 
      mockDestinations[8], 
      mockDestinations[4], 
      mockDestinations[2], 
      mockDestinations[9], 
      mockDestinations[3], 
    ],
    guide: mockTourGuides[2],
    type: TourType.fullPackage,
    price: 890000,
    isAvailable: true,
    hobbyIds: [1, 2, 4, 6],
    schedule: [
      TourDaySchedule(
        day: 1,
        plan: TourDayPlan(
          morning: 'Tham quan Núi Bà Đen - Cáp treo',
          lunch: 'Nhà hàng sinh thái Lạc Viên',
          afternoon: 'Tắm suối tại Suối Đá',
        ),
      ),
      TourDaySchedule(
        day: 2,
        plan: TourDayPlan(
          morning: 'Tòa Thánh Tây Ninh',
          lunch: 'Ẩm thực Sông Quê',
          afternoon: 'Tháp cổ Bình Thạnh',
        ),
      ),
      TourDaySchedule(
        day: 3,
        plan: TourDayPlan(
          morning: 'Thăm Hồ Dầu Tiếng',
          lunch: 'Nhà hàng Hải sản Bờ Kè',
          afternoon: 'Thám hiểm Ma Thiên Lãnh',
        ),
      ),
    ],
  ),
];
