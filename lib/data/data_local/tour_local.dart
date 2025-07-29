import 'package:hive/hive.dart';
import 'package:travelogue_mobile/data/data_local/storage_key.dart';
import 'package:travelogue_mobile/model/tour/tour_model.dart';

class TourLocal {
  final Box boxTour = Hive.box(StorageKey.boxTour);

  // Getter
  List<TourModel>? getListTourLocal(String locationId) {
    final List? tourByLocation = boxTour.get(
      '${StorageKey.tours}/$locationId',
      defaultValue: null,
    );

    if (tourByLocation == null) return null;

    return tourByLocation
        .map((e) => TourModel.fromJson(e))
        .toList()
        .cast<TourModel>();
  }

  // Setter
  void saveToursByLocation({
    required String locationId,
    required List<TourModel> tours,
  }) {
    if (tours.isEmpty) return;

    boxTour.put(
      '${StorageKey.tours}/$locationId',
      tours.map((e) => e.toJson()).toList(),
    );
  }

  // Clear
  void clear() {
    boxTour.clear();
  }
}
