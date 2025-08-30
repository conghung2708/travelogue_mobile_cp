import 'package:travelogue_mobile/model/location_model.dart';
import 'package:travelogue_mobile/model/chatbot/location_dto.dart';

extension LocationMapper on LocationModel {
  LocationDto toDto() {
    String? thumbnail;
    try {
      final list = (medias ?? []);
      if (list.isNotEmpty) {
        final thumb = list.firstWhere(
          (m) => m.isThumbnail == true,
          orElse: () => list.first,
        );
        thumbnail = thumb.mediaUrl;
      }
    } catch (_) {}

    return LocationDto(
      id: id ?? '',
      name: name ?? '',
      description: description ?? '',
      address: address ?? '',
      category: category ?? '',
      districtName: districtName ?? '',
      openTime: openTime ?? '08:00:00',
      closeTime: closeTime ?? '17:00:00',
      lat: latitude,
      lng: longitude,
      imageUrl: thumbnail,
    );
  }
}
