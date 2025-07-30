import 'package:hive/hive.dart';
import 'package:travelogue_mobile/data/data_local/storage_key.dart';
import 'package:travelogue_mobile/model/tour_guide/tour_guide_model.dart';

class TourGuideLocal {
  final Box boxTour = Hive.box(StorageKey.boxTour);

  // Getter
  List<TourGuideModel>? getListTourGuideLocal(String locationId) {
    final List? guideByLocation = boxTour.get(
      '${StorageKey.tourGuides}/$locationId',
      defaultValue: null,
    );

    if (guideByLocation == null) return null;

    return guideByLocation
        .map((e) => TourGuideModel.fromJson(e))
        .toList()
        .cast<TourGuideModel>();
  }

  // Setter
  void saveTourGuidesByLocation({
    required String locationId,
    required List<TourGuideModel> guides,
  }) {
    if (guides.isEmpty) return;

    boxTour.put(
      '${StorageKey.tourGuides}/$locationId',
      guides.map((e) => e.toJson()).toList(),
    );
  }

  // Clear all guides
  void clear() {
    boxTour.clear();
  }
}
