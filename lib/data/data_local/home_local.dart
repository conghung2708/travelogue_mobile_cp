import 'package:hive/hive.dart';
import 'package:travelogue_mobile/data/data_local/storage_key.dart';
import 'package:travelogue_mobile/data/data_local/user_local.dart';
import 'package:travelogue_mobile/model/event_model.dart';
import 'package:travelogue_mobile/model/location_model.dart';
import 'package:travelogue_mobile/model/type_location_model.dart';

class HomeLocal {
  final Box boxHome = Hive.box(StorageKey.boxHome);

  // Getter
  List<TypeLocationModel>? getListTypeLocation() {
    final List? types = boxHome.get(
      StorageKey.locationType,
      defaultValue: null,
    );

    if (types == null) {
      return null;
    }

    return types
        .map(
          (type) => TypeLocationModel.fromJson(type),
        )
        .toList();
  }

  List<LocationModel>? getAllLocations() {
    final List? locations = boxHome.get(
      StorageKey.allLocation,
      defaultValue: null,
    );

    if (locations == null) {
      return null;
    }

    return locations
        .map(
          (location) => LocationModel.fromJson(location),
        )
        .toList();
  }

  List<EventModel>? getEvents() {
    final List? events = boxHome.get(
      StorageKey.eventHome,
      defaultValue: null,
    );

    if (events == null) {
      return null;
    }

    return events
        .map(
          (event) => EventModel.fromJson(event),
        )
        .toList();
  }

  List<String> get getListLocationFavorite {
    final List? locations = boxHome.get(
      '${StorageKey.locationFavorite}/${UserLocal().getUser().id}',
      defaultValue: null,
    );

    if (locations == null) {
      return [];
    }

    return locations
        .map(
          (idLocation) => idLocation.toString(),
        )
        .toList();
  }

  // Setter

  void saveTypeLocations({
    required List<TypeLocationModel> types,
  }) {
    if (types.isEmpty) {
      return;
    }

    boxHome.put(
      StorageKey.locationType,
      types
          .map(
            (type) => type.toJson(),
          )
          .toList(),
    );
  }

  void saveAllLocations({
    required List<LocationModel> locations,
  }) {
    if (locations.isEmpty) {
      return;
    }

    boxHome.put(
      StorageKey.allLocation,
      locations
          .map(
            (location) => location.toJson(),
          )
          .toList(),
    );
  }

  void saveEvents({
    required List<EventModel> events,
  }) {
    if (events.isEmpty) {
      return;
    }

    boxHome.put(
      StorageKey.eventHome,
      events
          .map(
            (event) => event.toJson(),
          )
          .toList(),
    );
  }

  void saveLocationFavorite({
    required List<String> listIdFavorite,
  }) {
    if (listIdFavorite.isEmpty) {
      return;
    }

    boxHome.put(
      '${StorageKey.locationFavorite}/${UserLocal().getUser().id}',
      listIdFavorite,
    );
  }

  // Clean
  void clear() {
    boxHome.clear();
  }
}
