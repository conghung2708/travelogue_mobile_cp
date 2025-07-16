import 'package:equatable/equatable.dart';
import 'package:travelogue_mobile/model/craft_village/craft_village_model.dart';
import 'package:travelogue_mobile/model/location_model.dart';
import 'package:travelogue_mobile/model/restaurant_model.dart';

class TripPlanState extends Equatable {
  final List<DateTime> days;
  final Map<DateTime, List<LocationModel>> selectedLocations;
  final Map<DateTime, List<RestaurantModel>> selectedRestaurants;
  final Map<DateTime, List<CraftVillageModel>> selectedVillages;
  final Set<DateTime> completedDays;
  final DateTime? currentDay;

  const TripPlanState({
    this.days = const [],
    this.selectedLocations = const {},
    this.selectedRestaurants = const {},
    this.selectedVillages = const {},
    this.completedDays = const {},
    this.currentDay,
  });

  TripPlanState copyWith({
    List<DateTime>? days,
    Map<DateTime, List<LocationModel>>? selectedLocations,
    Map<DateTime, List<RestaurantModel>>? selectedRestaurants,
    Map<DateTime, List<CraftVillageModel>>? selectedVillages,
    Set<DateTime>? completedDays,
    DateTime? currentDay,
  }) {
    return TripPlanState(
      days: days ?? this.days,
      selectedLocations: selectedLocations ?? this.selectedLocations,
      selectedRestaurants: selectedRestaurants ?? this.selectedRestaurants,
      selectedVillages: selectedVillages ?? this.selectedVillages,
      completedDays: completedDays ?? this.completedDays,
      currentDay: currentDay ?? this.currentDay,
    );
  }

  @override
  List<Object?> get props => [
        days,
        selectedLocations,
        selectedRestaurants,
        selectedVillages,
        completedDays,
        currentDay,
      ];
}
