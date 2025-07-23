import 'package:travelogue_mobile/model/location_model.dart';
import 'package:travelogue_mobile/model/media_model.dart';

class TripPlanLocation {
  final String tripPlanVersionId;
  // final String locationId;
  // final String locationName;
  final DateTime startTime;
  final DateTime endTime;
  final String note;
  final int order;
  final LocationModel location;

  TripPlanLocation({
    required this.tripPlanVersionId,
    // required this.locationId,
    // required this.locationName,
    required this.startTime,
    required this.endTime,
    required this.note,
    required this.order, 
    required this.location,
  });
}

final List<TripPlanLocation> tripLocations = [
  TripPlanLocation(
    tripPlanVersionId: 'ver001',
    location: LocationModel(
      id: '08dd751b-1bca-4643-8dec-1ec35b418a2d',
      name: 'Địa đạo An Thới',
      description: 'An Thới là 01 trong 8 ấp thuộc xã An Tịnh, huyện Trảng Bàng, tỉnh Tây Ninh.',
      content: 'Địa hình hiểm trở, hệ thống địa đạo liên hoàn, có giá trị lịch sử cao.',
      latitude: 11.0464125,
      longitude: 106.387984375,
      rating: 0,
      // typeLocationId: '08dd74f1-e8cc-431e-85c8-c563159bce3f',
      // typeLocationName: 'Di tích lịch sử',
      medias: [
        MediaModel(mediaUrl: 'https://i.imgur.com/dI9a3Fj.jpeg'),
        MediaModel(mediaUrl: 'https://i.imgur.com/1voTlly.jpeg'),
      ],
    ),
    startTime: DateTime(2025, 7, 10, 10, 30),
    endTime: DateTime(2025, 7, 10, 12, 0),
    note: 'Khám phá địa đạo và chiến tranh du kích',
    order: 1, 
    // locationId: '', locationName: '',
  ),
  TripPlanLocation(
    tripPlanVersionId: 'ver001',
    location: LocationModel(
      id: '08dd751b-5cb5-4905-80c8-5c6686bef73c',
      name: 'Địa Đạo Lợi Thuận',
      description: 'Địa bàn chiến lược thời kháng chiến, di tích cấp quốc gia.',
      content: 'Địa đạo mang giá trị quân sự và nghệ thuật chiến tranh du kích.',
      latitude: 11.118853,
      longitude: 106.19102,
      rating: 0,
      // typeLocationId: '08dd74f1-e8cc-431e-85c8-c563159bce3f',
      // typeLocationName: 'Di tích lịch sử',
      medias: [
        MediaModel(mediaUrl: 'https://i.imgur.com/BgKd6ZM.jpeg'),
      ],
    ),
    startTime: DateTime(2025, 7, 11, 10, 0),
    endTime: DateTime(2025, 7, 11, 11, 30),
    note: 'Tham quan căn cứ du kích',
    order: 2, 
    // locationId: '', locationName: '',
  ),
];
